import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/data/app_store.dart';
import '../../core/data/db_queries.dart';
import '../../core/data/permissions.dart';
import '../../core/l10n/l10n.dart';
import '../../core/l10n/labels.dart';
import '../../core/models/models.dart';
import '../../core/utils/format.dart';
import '../../shared/widgets/buttons.dart';
import '../../shared/widgets/cards.dart';
import '../../shared/widgets/feedback.dart';
import '../../shared/widgets/layout.dart';
import '../../shared/widgets/pills.dart';
import '../../shared/widgets/rows.dart';
import '../../shared/widgets/sheets.dart';
import '../../shared/widgets/timeline.dart';
import 'ops_actions.dart';

String sourceLabel(AppLocalizations t, EnquirySource s) => switch (s) {
      EnquirySource.sales => t.sourceSales,
      EnquirySource.customer => t.sourceCustomer,
      EnquirySource.backOffice => t.sourceBackOffice,
      EnquirySource.admin => t.sourceAdmin,
    };

/// Customer, requirement, answers, who referred it and the internal note.
class DetailsPart extends ConsumerWidget {
  const DetailsPart({super.key, required this.enquiry});

  final Enquiry enquiry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final me = ref.watch(currentUserProvider)!;
    final config = db.config;
    final e = enquiry;
    final customer = db.customerById(e.customerId);
    final category = db.categoryById(e.categoryId);
    final referrer = db.userById(e.salespersonId);
    final canCall = can(me.role, Perm.call, config);
    final answers = [
      for (final q in category?.questions ?? const <QualificationQuestion>[])
        if ((e.answers[q.id] ?? '').isNotEmpty) (q.label, e.answers[q.id]!),
    ];

    return PageScaffold(
      title: t.opsPartDetails,
      children: [
        SectionCard(
          title: t.labelCustomer,
          icon: Icons.person_outline,
          trailing: customer == null
              ? null
              : TextButton(
                  onPressed: () => context.push(Routes.customer(customer.id)),
                  child: Text(t.actionView),
                ),
          child: Column(
            children: [
              InfoRow(label: t.labelName, value: customer?.name ?? ''),
              InfoRow(label: t.labelMobile, value: Fmt.phone(customer?.phone ?? '')),
              if ((customer?.email ?? '').isNotEmpty)
                InfoRow(label: t.labelEmail, value: customer!.email!),
              InfoRow(
                label: t.labelAddress,
                value: [
                  if ((e.address ?? '').isNotEmpty) e.address!,
                  e.area,
                  e.city,
                  ?e.pincode,
                ].join(', '),
              ),
              InfoRow(
                label: t.referContactLabel,
                value: e.contactPreference == ContactPreference.callAtTime
                    ? '${contactPrefLabel(t, e.contactPreference)}: ${e.preferredTime ?? ''}'
                    : contactPrefLabel(t, e.contactPreference),
              ),
              if (canCall && customer != null) ...[
                Space.gapSm,
                _ContactButtons(enquiry: e, name: customer.name, phone: customer.phone),
              ],
            ],
          ),
        ),
        Space.gapMd,
        SectionCard(
          title: t.labelRequirement,
          icon: Icons.notes,
          child: Column(
            children: [
              InfoRow(label: t.labelProduct, value: db.enquiryTitle(e)),
              InfoRow(label: t.labelRequirement, value: e.requirement, maxLines: 10),
              if (e.potentialValue != null)
                InfoRow(label: t.labelEstimatedValue, value: Fmt.money(e.potentialValue!)),
              for (final (q, a) in answers) InfoRow(label: q, value: a),
            ],
          ),
        ),
        Space.gapMd,
        SectionCard(
          title: t.opsSource,
          icon: Icons.campaign_outlined,
          child: Column(
            children: [
              InfoRow(label: t.opsSourceLabel, value: sourceLabel(t, e.source)),
              if (referrer != null)
                InfoRow(
                  label: t.labelSalesperson,
                  value: '${referrer.name}, ${Fmt.phone(referrer.phone)}',
                ),
              InfoRow(label: t.labelBackOffice, value: db.userName(e.backOfficeId)),
              InfoRow(label: t.labelFranchise, value: db.franchiseById(e.franchiseId)?.name ?? ''),
              InfoRow(label: t.labelCreated, value: Fmt.dateTime(context, e.createdAt)),
              if (e.otpVerified) InfoRow(label: t.labelMobile, value: t.opsOtpVerified),
            ],
          ),
        ),
        if (can(me.role, Perm.seeInternalNotes, config)) ...[
          Space.gapMd,
          SectionCard(
            title: t.opsInternalNote,
            icon: Icons.lock_outline,
            trailing: me.role == UserRole.franchise
                ? null
                : TextButton(
                    onPressed: () async {
                      final note = await askText(
                        context,
                        title: t.opsInternalNote,
                        label: t.opsInternalNoteLabel,
                        confirmLabel: t.actionSave,
                        initial: e.internalNote,
                        required: false,
                        maxLines: 4,
                      );
                      if (note == null) return;
                      ref.read(dbProvider.notifier).saveInternalNote(e.id, note);
                      if (context.mounted) showToast(context, t.toastSaved);
                    },
                    child: Text(t.actionEdit),
                  ),
            child: Text(
              e.internalNote.isEmpty ? t.opsNoNote : e.internalNote,
              style: context.text.bodyMedium?.copyWith(
                  color: e.internalNote.isEmpty ? AppColors.textSecondary : AppColors.text),
            ),
          ),
          Space.gapSm,
          Text(t.opsInternalNoteHelp, style: context.text.bodySmall),
        ],
      ],
    );
  }
}

/// Call, WhatsApp and SMS through O2O Boss. Channels follow admin settings.
class _ContactButtons extends ConsumerWidget {
  const _ContactButtons({required this.enquiry, required this.name, required this.phone});

  final Enquiry enquiry;
  final String name;
  final String phone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final config = ref.watch(configProvider);
    return Wrap(
      spacing: Space.sm,
      runSpacing: Space.sm,
      children: [
        FilledButton.icon(
          onPressed: () async {
            final secs = await simulateCall(context, name: name, phone: Fmt.phone(phone));
            if (secs == null) return;
            ref.read(dbProvider.notifier)
                .logCall(enquiry.id, UserRole.customer, name, durationSec: secs);
            if (context.mounted) showToast(context, t.callLogged);
          },
          icon: const Icon(Icons.call_outlined, size: 18),
          label: Text(t.actionCall),
        ),
        if (config.whatsappEnabled)
          OutlinedButton.icon(
            onPressed: () => showToast(context, t.demoActionNote),
            icon: const Icon(Icons.chat_outlined, size: 18),
            label: Text(t.actionWhatsapp),
          ),
        if (config.smsEnabled)
          OutlinedButton.icon(
            onPressed: () => showToast(context, t.demoActionNote),
            icon: const Icon(Icons.sms_outlined, size: 18),
            label: Text(t.actionSms),
          ),
      ],
    );
  }
}

/// Verification result and every call logged for the enquiry.
class CallsPart extends ConsumerWidget {
  const CallsPart({super.key, required this.enquiry});

  final Enquiry enquiry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final me = ref.watch(currentUserProvider)!;
    final e = enquiry;
    final v = e.verification;
    final calls = db.callsFor(e.id);
    final canWork = can(me.role, Perm.verify, db.config);
    final needsVerify = e.status == EnquiryStatus.newEnquiry ||
        e.status == EnquiryStatus.verificationPending;
    return PageScaffold(
      title: t.opsPartCalls,
      children: [
        SectionCard(
          title: t.opsVerification,
          icon: Icons.verified_outlined,
          child: v == null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(t.opsNotVerifiedYet, style: context.text.bodyMedium),
                    if (canWork && needsVerify) ...[
                      Space.gapMd,
                      AppButton(t.nextVerifyButton,
                          onPressed: () => context.push(Routes.enquiryPart(e.id, 'verify'))),
                    ],
                  ],
                )
              : Column(
                  children: [
                    InfoRow(label: t.opsOutcome, value: outcomeLabel(t, v.outcome)),
                    InfoRow(label: t.opsVerifiedBy,
                        value: '${db.userName(v.byUserId)}, ${Fmt.dateTime(context, v.at)}'),
                    if (v.notes.isNotEmpty) InfoRow(label: t.labelNotes, value: v.notes),
                  ],
                ),
        ),
        SectionHeader(
          t.callLogHeading,
          action: canWork ? t.callLogTitle : null,
          onAction: () => logCallFlow(context, ref, e),
        ),
        if (calls.isEmpty)
          AppCard(child: EmptyState(compact: true, icon: Icons.call_outlined, title: t.callNone))
        else
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (var i = 0; i < calls.length; i++) ...[
                  if (i > 0) const Divider(indent: 66),
                  CallRow(call: calls[i]),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class CallRow extends ConsumerWidget {
  const CallRow({super.key, required this.call, this.showEnquiry = false});

  final CallRecord call;
  final bool showEnquiry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final c = call;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.xs),
      leading: IconTile(
        c.direction == CallDirection.outgoing ? Icons.call_made : Icons.call_received,
        tone: c.outcome != null && c.outcome!.rejects ? Tone.danger : Tone.info,
        size: 38,
      ),
      title: Text('${c.toName}, ${roleLabel(t, c.toRole)}', style: context.text.bodyLarge),
      subtitle: Text(
        [
          if (showEnquiry && c.enquiryId != null) c.enquiryId!,
          Fmt.dateTime(context, c.at),
          if (c.durationSec > 0) Fmt.duration(c.durationSec),
          if (c.outcome != null) outcomeLabel(t, c.outcome!),
          if (c.notes.isNotEmpty) c.notes,
          t.callBy(db.userName(c.byUserId)),
        ].join('\n'),
        style: context.text.bodySmall,
      ),
      trailing: c.recorded
          ? Tooltip(
              message: t.callRecordedShort,
              child: const Icon(Icons.graphic_eq, color: AppColors.textSecondary),
            )
          : null,
      isThreeLine: true,
      onTap: showEnquiry && c.enquiryId != null
          ? () => context.push(Routes.enquiry(c.enquiryId!))
          : null,
    );
  }
}

/// Every recorded action on the enquiry, newest first.
class ActivityPart extends ConsumerWidget {
  const ActivityPart({super.key, required this.enquiry});

  final Enquiry enquiry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final entries = db.activityFor(enquiry.id);
    return PageScaffold(
      title: t.opsPartActivity,
      children: [
        NoteCard(text: t.opsActivityNote, icon: Icons.shield_outlined),
        Space.gapLg,
        if (entries.isEmpty)
          EmptyState(icon: Icons.history, title: t.emptyTitle)
        else
          AppCard(
            child: Timeline(entries: [
              for (final a in entries)
                TimelineEntry(
                  title: auditText(t, a),
                  subtitle: [
                    a.userId == null ? t.auditBySystem : t.auditBy(db.userName(a.userId)),
                    if ((a.note ?? '').isNotEmpty && a.action != AuditAction.assigned) a.note!,
                  ].join('. '),
                  time: Fmt.dateTime(context, a.at),
                  tone: switch (a.action) {
                    AuditAction.quotationAccepted ||
                    AuditAction.paymentRecorded ||
                    AuditAction.commissionPaid =>
                      Tone.success,
                    AuditAction.quotationRejected || AuditAction.vendorRejected => Tone.danger,
                    AuditAction.statusChanged => Tone.info,
                    _ => Tone.neutral,
                  },
                ),
            ]),
          ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/data/app_store.dart';
import '../../core/data/db_queries.dart';
import '../../core/data/drafts.dart';
import '../../core/data/system_text.dart';
import '../../core/l10n/l10n.dart';
import '../../core/l10n/labels.dart';
import '../../core/models/models.dart';
import '../../core/utils/format.dart';
import '../../core/utils/validators.dart';
import '../../shared/widgets/buttons.dart';
import '../../shared/widgets/cards.dart';
import '../../shared/widgets/feedback.dart';
import '../../shared/widgets/inputs.dart';
import '../../shared/widgets/layout.dart';
import '../../shared/widgets/pills.dart';
import '../../shared/widgets/rows.dart';
import '../../shared/widgets/sheets.dart';
import '../../shared/widgets/tones.dart';
import '../common/system_screens.dart';

/// One quotation version. The same page for every role, with the actions
/// each one needs: back office reviews, the vendor edits or revises, and
/// the customer accepts, asks for changes or declines.
class QuotationScreen extends ConsumerStatefulWidget {
  const QuotationScreen({super.key, required this.id});

  final String id;

  @override
  ConsumerState<QuotationScreen> createState() => _QuotationScreenState();
}

class _QuotationScreenState extends ConsumerState<QuotationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.read(dbProvider.notifier).markQuotationViewed(widget.id);
    });
  }

  bool _allowed(DbState db, AppUser me, Quotation q) {
    final e = db.enquiryById(q.enquiryId);
    if (e == null || !db.canView(me, e)) return false;
    return switch (me.role) {
      UserRole.vendor => q.vendorId == me.vendorId,
      UserRole.customer => q.status.isWithCustomer,
      UserRole.sales => false,
      _ => q.status != QuotationStatus.draft,
    };
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final me = ref.watch(currentUserProvider);
    final q = db.quotationById(widget.id);
    if (me == null) return const SizedBox.shrink();
    if (q == null) return const NotFoundScreen();
    if (!_allowed(db, me, q)) return const NoAccessView();
    final e = db.enquiryById(q.enquiryId)!;
    final versions = db.versionsOf(q.number)
        .where((v) => v.id != q.id && (me.role != UserRole.customer || v.status.isWithCustomer))
        .toList();
    final isCustomer = me.role == UserRole.customer;

    return PageScaffold(
      title: t.quoteNumber(q.number, '${q.version}'),
      children: [
        _Header(quotation: q, enquiry: e),
        if (q.status == QuotationStatus.superseded) ...[
          Space.gapMd,
          NoteCard(tone: Tone.neutral, icon: Icons.history, text: t.quoteSupersededNote),
        ],
        if (q.status == QuotationStatus.revisionRequested && (q.revisionNote ?? '').isNotEmpty) ...[
          Space.gapMd,
          NoteCard(
            tone: Tone.warning,
            icon: Icons.edit_note,
            title: t.quoteRevisionAsked,
            text: q.revisionNote!,
          ),
        ],
        if (q.status == QuotationStatus.rejected && (q.responseNote ?? '').isNotEmpty) ...[
          Space.gapMd,
          NoteCard(
            tone: Tone.danger,
            icon: Icons.cancel_outlined,
            title: t.quoteDeclinedReason,
            text: reasonLabel(t, q.responseNote),
          ),
        ],
        if (q.status == QuotationStatus.accepted) ...[
          Space.gapMd,
          NoteCard(
            tone: Tone.success,
            icon: Icons.verified_outlined,
            title: t.quoteAcceptedTitle,
            text: q.signedName == null
                ? t.quoteAcceptedOn(Fmt.dateTime(context, q.respondedAt ?? q.createdAt))
                : t.quoteSignedBy(q.signedName!, Fmt.dateTime(context, q.respondedAt ?? q.createdAt)),
          ),
        ],
        DetailLabelInline(t.quoteItems),
        _Items(quotation: q),
        DetailLabelInline(t.quoteTerms),
        AppCard(
          child: Column(
            children: [
              InfoRow(icon: Icons.timer_outlined, label: t.quoteTimeline, value: t.quoteDays('${q.timelineDays}')),
              InfoRow(
                icon: Icons.event_available_outlined,
                label: t.quoteValidity,
                value: q.sentAt == null
                    ? t.quoteDays('${q.validityDays}')
                    : t.quoteValidUntil(Fmt.date(context, q.validUntil)),
              ),
              if (q.terms.isNotEmpty)
                InfoRow(icon: Icons.gavel_outlined, label: t.quoteTermsLabel, value: q.terms, maxLines: 10),
              if (q.notes.isNotEmpty)
                InfoRow(icon: Icons.notes, label: t.labelNotes, value: q.notes, maxLines: 10),
              for (final a in q.attachments)
                InfoRow(icon: Icons.attach_file, label: t.quoteAttachment, value: a),
            ],
          ),
        ),
        if (!isCustomer && q.adminCopySent) ...[
          Space.gapMd,
          Row(
            children: [
              const Icon(Icons.mark_email_read_outlined, size: 16, color: AppColors.textSecondary),
              Space.gapSm,
              Expanded(
                child: Text(t.quoteCopySent(db.config.adminCopyEmail), style: context.text.bodySmall),
              ),
            ],
          ),
        ],
        if (versions.isNotEmpty) ...[
          DetailLabelInline(t.quoteOtherVersions),
          NavGroup(rows: [
            for (final v in versions)
              NavRow(
                icon: Icons.history,
                tone: Tone.neutral,
                title: t.quoteNumber(v.number, '${v.version}'),
                subtitle: '${quotationLabel(t, v.status)}, ${Fmt.money(v.total)}',
                onTap: () => context.pushReplacement(Routes.quotation(v.id)),
              ),
          ]),
        ],
        const SizedBox(height: 80),
      ],
      bottomBar: _actions(context, me, q, e),
    );
  }

  Widget? _actions(BuildContext context, AppUser me, Quotation q, Enquiry e) {
    final t = context.t;
    final store = ref.read(dbProvider.notifier);
    final config = ref.read(configProvider);
    final closed = e.status.isEnded;
    if (closed) return null;
    switch (me.role) {
      case UserRole.backOffice:
      case UserRole.admin:
        if (q.status != QuotationStatus.submitted) return null;
        return StickyActions(
          note: t.quoteReviewNote,
          children: [
            AppButton.secondary(t.quoteAskChanges, onPressed: () async {
              final note = await askText(
                context,
                title: t.quoteAskChangesTitle,
                label: t.quoteAskChangesLabel,
                hint: t.quoteAskChangesHint,
                confirmLabel: t.quoteSendToVendor,
              );
              if (note == null) return;
              store.requestRevision(q.id, note);
              if (context.mounted) showToast(context, t.quoteChangesSent);
            }),
            AppButton(t.quoteApprove, icon: Icons.send_outlined, onPressed: () async {
              await simulateWork();
              store.approveQuotation(q.id);
              if (context.mounted) showToast(context, t.quoteApproved);
            }),
          ],
        );
      case UserRole.vendor:
        if (q.status == QuotationStatus.draft) {
          return StickyActions(children: [
            AppButton.secondary(t.actionEdit,
                onPressed: () => context.push(Routes.editQuotation(q.id))),
            AppButton(t.quoteSubmit, onPressed: () async {
              final ok = await confirmAction(context,
                  title: t.quoteSubmitTitle, body: t.quoteSubmitBody, confirmLabel: t.quoteSubmit);
              if (!ok) return;
              store.saveQuotation(QuotationDraft.fromQuotation(q), draftId: q.id, submit: true);
              if (context.mounted) showToast(context, t.quoteSubmittedToast);
            }),
          ]);
        }
        final canRevise = (q.status == QuotationStatus.revisionRequested ||
                (q.status == QuotationStatus.rejected &&
                    SystemText.decode(q.responseNote ?? '')?.$1 != SystemText.otherAccepted)) &&
            ref.read(dbProvider).versionsOf(q.number).first.id == q.id;
        if (!canRevise) return null;
        return StickyActions(children: [
          AppButton(t.quoteRevise, icon: Icons.edit_outlined,
              onPressed: () => context.push(Routes.reviseQuotation(q.id))),
        ]);
      case UserRole.customer:
        if (q.status != QuotationStatus.sent && q.status != QuotationStatus.viewed) return null;
        return StickyActions(
          note: t.quoteCustomerNote,
          children: [
            AppButton.secondary(t.quoteCustomerChanges, onPressed: () => _customerMore(context, q)),
            AppButton(t.quoteAccept, kind: ButtonKind.success, onPressed: () async {
              final signed = await _acceptSheet(context, q, config.eSignatureRequired);
              if (signed == null) return;
              await simulateWork(600);
              store.acceptQuotation(q.id, signedName: signed.isEmpty ? null : signed);
              if (context.mounted) showToast(context, t.quoteAcceptedToast);
            }),
          ],
        );
      default:
        return null;
    }
  }

  Future<void> _customerMore(BuildContext context, Quotation q) async {
    final t = context.t;
    final store = ref.read(dbProvider.notifier);
    final choice = await pickOption<String>(
      context,
      title: t.quoteCustomerChanges,
      options: [
        SelectOption('revise', t.quoteAskChanges, subtitle: t.quoteAskChangesSub, icon: Icons.edit_note),
        SelectOption('reject', t.quoteDecline, subtitle: t.quoteDeclineSub, icon: Icons.cancel_outlined),
      ],
    );
    if (!context.mounted || choice == null) return;
    if (choice == 'revise') {
      final note = await askText(
        context,
        title: t.quoteAskChangesTitle,
        label: t.quoteAskChangesLabelCustomer,
        hint: t.quoteAskChangesHint,
        confirmLabel: t.actionSend,
      );
      if (note == null) return;
      store.requestRevision(q.id, note);
      if (context.mounted) showToast(context, t.quoteChangesSentCustomer);
    } else {
      final reason = await askReason(
        context,
        title: t.quoteDecline,
        reasons: [t.quoteDeclinePrice, t.quoteDeclineElsewhere, t.quoteDeclineLater],
        confirmLabel: t.quoteDecline,
        destructive: true,
      );
      if (reason == null) return;
      store.rejectQuotation(q.id, reason);
      if (context.mounted) showToast(context, t.quoteDeclined, tone: Tone.warning);
    }
  }

  /// Returns the typed signature ('' when e-signature is off), or null.
  Future<String?> _acceptSheet(BuildContext context, Quotation q, bool eSign) {
    final t = context.t;
    final name = TextEditingController(text: '');
    final form = GlobalKey<FormState>();
    var agreed = false;
    var showError = false;
    return showAppSheet<String>(
      context,
      title: t.quoteAcceptTitle,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Form(
          key: form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ValueLine(t.labelVendor, ref.read(dbProvider).vendorName(q.vendorId)),
              ValueLine(t.labelTotal, Fmt.money(q.total), strong: true),
              Space.gapLg,
              if (eSign) ...[
                AppTextField(
                  label: t.quoteSignLabel,
                  controller: name,
                  required: true,
                  help: t.quoteSignHelp,
                  textCapitalization: TextCapitalization.words,
                  validator: (v) => Validators.name(t, v),
                ),
                Space.gapMd,
              ],
              CheckboxListTile(
                value: agreed,
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (v) => setSheet(() => agreed = v ?? false),
                title: Text(t.quoteAcceptAgree, style: ctx.text.bodyMedium),
                subtitle: showError && !agreed
                    ? Text(t.referConsentError,
                        style: ctx.text.bodySmall?.copyWith(color: AppColors.dangerText))
                    : null,
              ),
              Space.gapLg,
              AppButton(t.quoteAccept, kind: ButtonKind.success, onPressed: () {
                final ok = form.currentState!.validate();
                if (!agreed) setSheet(() => showError = true);
                if (!ok || !agreed) return;
                Navigator.pop(ctx, eSign ? name.text.trim() : '');
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends ConsumerWidget {
  const _Header({required this.quotation, required this.enquiry});

  final Quotation quotation;
  final Enquiry enquiry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final me = ref.watch(currentUserProvider)!;
    final q = quotation;
    final status = me.role == UserRole.customer && q.status == QuotationStatus.sent
        ? t.quoteNew
        : quotationLabel(t, q.status);
    return AppCard(
      padding: const EdgeInsets.all(Space.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  me.role == UserRole.vendor ? db.enquiryTitle(enquiry) : db.vendorName(q.vendorId),
                  style: context.text.titleMedium,
                ),
              ),
              StatusPill(status, tone: quotationTone(q.status)),
            ],
          ),
          const SizedBox(height: 2),
          Text('${enquiry.id}, ${Fmt.date(context, q.submittedAt ?? q.createdAt)}',
              style: context.text.bodySmall),
          Space.gapLg,
          Text(t.labelTotal, style: context.text.bodySmall),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(Fmt.money(q.total),
                style: context.text.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontFeatures: const [FontFeature.tabularFigures()])),
          ),
          Text(t.quoteInclTax(Fmt.percent(q.taxPercent)), style: context.text.bodySmall),
        ],
      ),
    );
  }
}

class _Items extends StatelessWidget {
  const _Items({required this.quotation});

  final Quotation quotation;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final q = quotation;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final item in q.items) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.description, style: context.text.bodyMedium),
                      Text(
                        t.quoteQtyLine(_qty(item.qty), Fmt.money(item.unitPrice)),
                        style: context.text.bodySmall,
                      ),
                    ],
                  ),
                ),
                Space.gapMd,
                Text(Fmt.money(item.total),
                    style: context.text.bodyMedium
                        ?.copyWith(fontFeatures: const [FontFeature.tabularFigures()])),
              ],
            ),
            Space.gapMd,
          ],
          const Divider(),
          Space.gapSm,
          ValueLine(t.quoteSubtotal, Fmt.money(q.subtotal)),
          if (q.discount > 0) ValueLine(t.quoteDiscount, '− ${Fmt.money(q.discount)}'),
          if (q.installation > 0) ValueLine(t.quoteInstallation, Fmt.money(q.installation)),
          if (q.delivery > 0) ValueLine(t.quoteDelivery, Fmt.money(q.delivery)),
          ValueLine(t.quoteTax(Fmt.percent(q.taxPercent)), Fmt.money(q.taxAmount)),
          const Divider(),
          ValueLine(t.labelTotal, Fmt.money(q.total), strong: true),
        ],
      ),
    );
  }

  static String _qty(double q) => q % 1 == 0 ? q.toStringAsFixed(0) : q.toStringAsFixed(1);
}

/// Section title used on the quotation page.
class DetailLabelInline extends StatelessWidget {
  const DetailLabelInline(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: Space.xl, bottom: Space.sm),
        child: Semantics(
          header: true,
          child: Text(text, style: context.text.titleSmall?.copyWith(color: AppColors.textSecondary)),
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
import '../../shared/widgets/cards.dart';
import '../../shared/widgets/feedback.dart';
import '../../shared/widgets/layout.dart';
import '../../shared/widgets/pills.dart';
import '../../shared/widgets/rows.dart';
import '../../shared/widgets/sheets.dart';
import '../../shared/widgets/tones.dart';

/// Commissions created for an enquiry. Admin moves each one along:
/// approved, payable, paid — or puts it on hold.
class CommissionPart extends ConsumerWidget {
  const CommissionPart({super.key, required this.enquiry});

  final Enquiry enquiry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final me = ref.watch(currentUserProvider)!;
    final list = db.commissionsFor(enquiry.id);
    final canApprove = can(me.role, Perm.approveCommission, db.config);
    return PageScaffold(
      title: t.opsPartCommission,
      children: [
        NoteCard(
          text: t.commissionRuleNote(triggerSentence(t, db.config.commissionTrigger)),
        ),
        Space.gapLg,
        if (list.isEmpty)
          EmptyState(icon: Icons.account_balance_wallet_outlined, title: t.commissionNone)
        else
          Gap(children: [
            for (final c in list) CommissionManageCard(commission: c, canApprove: canApprove),
          ]),
        if (!canApprove && list.isNotEmpty) ...[
          Space.gapLg,
          Text(t.commissionAdminOnly, style: context.text.bodySmall),
        ],
      ],
    );
  }
}

/// A commission with its next admin action.
class CommissionManageCard extends ConsumerWidget {
  const CommissionManageCard({
    super.key,
    required this.commission,
    required this.canApprove,
    this.showEnquiry = false,
  });

  final Commission commission;
  final bool canApprove;
  final bool showEnquiry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final store = ref.read(dbProvider.notifier);
    final c = commission;
    final beneficiary = db.userById(c.beneficiaryUserId);
    final nextLabel = switch (c.status) {
      CommissionStatus.pending => t.commissionApprove,
      CommissionStatus.approved => t.commissionMakePayable,
      CommissionStatus.payable => t.commissionMarkPaid,
      CommissionStatus.onHold => t.commissionRelease,
      _ => null,
    };

    Future<void> advance() async {
      String? reference;
      if (c.status == CommissionStatus.payable) {
        reference = await askText(
          context,
          title: t.commissionMarkPaid,
          label: t.commissionReference,
          hint: t.commissionReferenceHint,
          confirmLabel: t.commissionMarkPaid,
          maxLines: 1,
        );
        if (reference == null) return;
      }
      store.advanceCommission(c.id, reference: reference);
      if (context.mounted) showToast(context, t.toastUpdated);
    }

    Future<void> hold() async {
      final note = await askText(
        context,
        title: t.commissionHold,
        label: t.labelReason,
        confirmLabel: t.commissionHold,
      );
      if (note == null) return;
      store.holdCommission(c.id, note);
      if (context.mounted) showToast(context, t.toastUpdated, tone: Tone.warning);
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(beneficiary?.name ?? '', style: context.text.titleSmall),
                    Text(
                      showEnquiry
                          ? '${roleLabel(t, c.role)}, ${c.enquiryId}'
                          : roleLabel(t, c.role),
                      style: context.text.bodySmall,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(Fmt.money(c.amount), style: AppType.money(context)),
                  const SizedBox(height: 4),
                  StatusPill(commissionLabel(t, c.status), tone: commissionTone(c.status)),
                ],
              ),
            ],
          ),
          Space.gapSm,
          ValueLine(t.commissionBase, Fmt.money(c.businessValue)),
          ValueLine(t.commissionRate, Fmt.percent(c.percent)),
          if ((c.reference ?? '').isNotEmpty) ValueLine(t.commissionReference, c.reference!),
          if ((c.note ?? '').isNotEmpty) ValueLine(t.labelNotes, c.note!),
          if (beneficiary != null && c.status == CommissionStatus.payable)
            ValueLine(
              t.earningsPayoutTitle,
              (beneficiary.upiId ?? '').isNotEmpty
                  ? beneficiary.upiId!
                  : ((beneficiary.bankAccount ?? '').isNotEmpty ? beneficiary.bankAccount! : t.notSet),
            ),
          if (canApprove && nextLabel != null) ...[
            Space.gapMd,
            Row(
              children: [
                Expanded(child: FilledButton(onPressed: advance, child: Text(nextLabel))),
                if (c.status != CommissionStatus.onHold) ...[
                  Space.gapSm,
                  OutlinedButton(onPressed: hold, child: Text(t.commissionHold)),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

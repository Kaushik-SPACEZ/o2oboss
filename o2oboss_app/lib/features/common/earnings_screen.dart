import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/data/app_store.dart';
import '../../core/data/db_queries.dart';
import '../../core/l10n/l10n.dart';
import '../../core/l10n/labels.dart';
import '../../core/models/models.dart';
import '../../core/utils/format.dart';
import '../../shared/widgets/cards.dart';
import '../../shared/widgets/feedback.dart';
import '../../shared/widgets/inputs.dart';
import '../../shared/widgets/layout.dart';
import '../../shared/widgets/pills.dart';
import '../../shared/widgets/rows.dart';
import '../../shared/widgets/tones.dart';

/// The signed-in person's commissions: what is paid, what is on the way,
/// and where the money goes. Used by referral partners and franchise heads.
class EarningsScreen extends ConsumerStatefulWidget {
  const EarningsScreen({super.key});

  @override
  ConsumerState<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends ConsumerState<EarningsScreen> {
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final me = ref.watch(currentUserProvider);
    final db = ref.watch(dbProvider);
    if (me == null) return const SizedBox.shrink();
    final config = db.config;
    final all = db.commissionsOf(me.id)
        .where((c) => c.status != CommissionStatus.cancelled)
        .toList();
    double sum(bool Function(Commission c) test) =>
        all.where(test).fold(0, (s, c) => s + c.amount);
    bool isPending(Commission c) =>
        c.status == CommissionStatus.pending ||
        c.status == CommissionStatus.approved ||
        c.status == CommissionStatus.payable;
    final paid = sum((c) => c.status == CommissionStatus.paid);
    final pending = sum(isPending);
    final onHold = sum((c) => c.status == CommissionStatus.onHold);
    final shown = all.where((c) => switch (_filter) {
          'pending' => isPending(c) || c.status == CommissionStatus.onHold,
          'paid' => c.status == CommissionStatus.paid,
          _ => true,
        }).toList();
    final hasPayout = (me.upiId ?? '').isNotEmpty || (me.bankAccount ?? '').isNotEmpty;
    final percent = me.role == UserRole.franchise
        ? (db.franchiseById(me.franchiseId)?.sharePercent ?? config.franchiseSharePercent)
        : me.role == UserRole.backOffice
            ? config.backOfficeCommissionPercent
            : config.salesCommissionPercent;

    return PageScaffold(
      title: t.earningsTitle,
      onRefresh: () => simulateWork(600),
      children: [
        _Summary(paid: paid, pending: pending, onHold: onHold),
        Space.gapLg,
        AppCard(
          padding: EdgeInsets.zero,
          child: NavRow(
            icon: Icons.account_balance_outlined,
            tone: hasPayout ? Tone.success : Tone.warning,
            title: t.earningsPayoutTitle,
            subtitle: hasPayout
                ? ((me.upiId ?? '').isNotEmpty
                    ? t.earningsPayoutUpi(me.upiId!)
                    : t.earningsPayoutBank(_last4(me.bankAccount!)))
                : t.earningsPayoutMissing,
            onTap: () => context.push(Routes.editProfile),
          ),
        ),
        SectionHeader(t.earningsListTitle),
        ChoiceChips<String>(
          options: [
            SelectOption('all', t.labelAll),
            SelectOption('pending', t.earningsFilterPending),
            SelectOption('paid', t.earningsFilterPaid),
          ],
          selected: _filter,
          onSelected: (v) => setState(() => _filter = v),
        ),
        Space.gapMd,
        if (shown.isEmpty)
          AppCard(
            child: EmptyState(
              compact: true,
              icon: Icons.account_balance_wallet_outlined,
              title: t.earningsEmptyTitle,
              body: t.earningsEmptyBody,
            ),
          )
        else
          Gap(children: [for (final c in shown) CommissionCard(commission: c)]),
        Space.gapXl,
        NoteCard(
          icon: Icons.info_outline,
          text: t.earningsRule(Fmt.percent(percent),
              triggerSentence(t, config.commissionTrigger)),
        ),
      ],
    );
  }

  static String _last4(String s) => s.length <= 4 ? s : s.substring(s.length - 4);
}

class _Summary extends StatelessWidget {
  const _Summary({required this.paid, required this.pending, required this.onHold});

  final double paid;
  final double pending;
  final double onHold;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return AppCard(
      padding: const EdgeInsets.all(Space.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.earningsTotalPaid, style: context.text.bodySmall),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(Fmt.money(paid),
                style: context.text.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontFeatures: const [FontFeature.tabularFigures()])),
          ),
          Space.gapLg,
          const Divider(),
          Space.gapMd,
          Row(
            children: [
              Expanded(child: _Mini(label: t.earningsOnTheWay, value: pending, tone: Tone.warning)),
              if (onHold > 0)
                Expanded(child: _Mini(label: t.comOnHold, value: onHold, tone: Tone.danger)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Mini extends StatelessWidget {
  const _Mini({required this.label, required this.value, required this.tone});

  final String label;
  final double value;
  final Tone tone;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: tone.solid, shape: BoxShape.circle),
        ),
        Space.gapSm,
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: context.text.bodySmall),
              Text(Fmt.money(value), style: context.text.titleSmall),
            ],
          ),
        ),
      ],
    );
  }
}

/// One commission: which referral, how much and where it stands.
class CommissionCard extends ConsumerWidget {
  const CommissionCard({super.key, required this.commission, this.showPerson = false});

  final Commission commission;
  final bool showPerson;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final c = commission;
    final e = db.enquiryById(c.enquiryId);
    final when = c.paidAt ?? c.approvedAt ?? c.createdAt;
    return AppCard(
      onTap: e == null ? null : () => context.push(Routes.enquiry(e.id)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  showPerson
                      ? '${db.userName(c.beneficiaryUserId)}, ${roleLabel(t, c.role)}'
                      : (e == null ? c.enquiryId : db.enquiryTitle(e)),
                  style: context.text.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  t.earningsLineDetail(c.enquiryId, Fmt.percent(c.percent), Fmt.money(c.businessValue)),
                  style: context.text.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(Fmt.shortDate(context, when), style: context.text.labelSmall),
              ],
            ),
          ),
          Space.gapMd,
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(Fmt.money(c.amount),
                  style: context.text.titleMedium?.copyWith(
                      color: c.status == CommissionStatus.paid
                          ? AppColors.successText
                          : AppColors.text)),
              const SizedBox(height: 4),
              StatusPill(commissionLabel(t, c.status), tone: commissionTone(c.status)),
            ],
          ),
        ],
      ),
    );
  }
}

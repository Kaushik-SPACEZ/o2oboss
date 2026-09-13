import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/data/app_store.dart';
import '../../core/data/db_queries.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/utils/format.dart';
import '../../shared/navigation/home_header.dart';
import '../../shared/widgets/cards.dart';
import '../../shared/widgets/enquiry_card.dart';
import '../../shared/widgets/enquiry_list.dart';
import '../../shared/widgets/feedback.dart';
import '../../shared/widgets/kpi.dart';
import '../../shared/widgets/layout.dart';

/// Referral partner's Home: one big "Refer a customer" action, four numbers
/// and the latest referrals. Nothing else competes for attention.
class SalesHomeScreen extends ConsumerWidget {
  const SalesHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final me = ref.watch(currentUserProvider);
    final db = ref.watch(dbProvider);
    if (me == null) return const SizedBox.shrink();
    final mine = db.enquiriesFor(me);
    final inProgress = mine.where(salesInProgress).length;
    final won = mine.where((e) => e.status.isWon).length;
    final commissions = db.commissionsOf(me.id);
    final paid = commissions
        .where((c) => c.status == CommissionStatus.paid)
        .fold<double>(0, (s, c) => s + c.amount);
    final pending = commissions
        .where((c) => salesPendingCommission(c.status))
        .fold<double>(0, (s, c) => s + c.amount);

    void openList(String filter) {
      ref.read(listFilterProvider('sales').notifier).set(filter);
      context.go('/sales/enquiries');
    }

    return PageScaffold(
      showAppBar: false,
      onRefresh: () => simulateWork(600),
      children: [
        const HomeTopBar(),
        Greeting(summary: t.salesHomeSummary(inProgress)),
        PrimaryActionCard(
          icon: Icons.person_add_alt_1_outlined,
          title: t.salesReferTitle,
          body: t.salesReferBody,
          actionLabel: t.salesReferButton,
          onTap: () => context.push(Routes.refer()),
        ),
        Space.gapLg,
        StatStrip(items: [
          StatItem(
            label: t.salesKpiInProgress,
            value: '$inProgress',
            icon: Icons.autorenew,
            onTap: () => openList('active'),
          ),
          StatItem(
            label: t.salesKpiWon,
            value: '$won',
            icon: Icons.emoji_events_outlined,
            tone: Tone.purple,
            onTap: () => openList('won'),
          ),
          StatItem(
            label: t.salesKpiEarned,
            value: Fmt.moneyCompact(paid),
            icon: Icons.account_balance_wallet_outlined,
            tone: Tone.success,
            onTap: () => context.go('/sales/earnings'),
          ),
          StatItem(
            label: t.salesKpiPending,
            value: Fmt.moneyCompact(pending),
            icon: Icons.hourglass_bottom,
            tone: Tone.warning,
            onTap: () => context.go('/sales/earnings'),
          ),
        ]),
        SectionHeader(
          t.salesRecentTitle,
          action: mine.isEmpty ? null : t.actionSeeAll,
          onAction: () => openList('all'),
        ),
        if (mine.isEmpty)
          AppCard(
            child: EmptyState(
              compact: true,
              icon: Icons.campaign_outlined,
              title: t.salesEmptyTitle,
              body: t.salesEmptyBody,
            ),
          )
        else
          Gap(children: [
            for (final e in mine.take(3)) EnquiryCard(enquiry: e),
          ]),
      ],
    );
  }
}

/// Still moving: not ended and not yet won.
bool salesInProgress(Enquiry e) => !e.status.isEnded && !e.status.isWon;

bool salesPendingCommission(CommissionStatus s) =>
    s == CommissionStatus.pending ||
    s == CommissionStatus.approved ||
    s == CommissionStatus.payable;

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
import '../../shared/navigation/home_header.dart';
import '../../shared/widgets/cards.dart';
import '../../shared/widgets/enquiry_card.dart';
import '../../shared/widgets/enquiry_list.dart';
import '../../shared/widgets/feedback.dart';
import '../../shared/widgets/kpi.dart';
import '../../shared/widgets/layout.dart';
import '../../shared/widgets/pills.dart';
import '../../shared/widgets/rows.dart';

bool _open(Enquiry e) => !e.status.isEnded && !e.status.isClosed && !e.status.isWon;

double _valueOf(Enquiry e) => e.finalValue ?? e.potentialValue ?? 0;

bool _vendorWaiting(Vendor v) =>
    v.status == AccountStatus.pending || v.status == AccountStatus.underReview;

bool _payoutWaiting(Commission c) =>
    c.status == CommissionStatus.pending || c.status == CommissionStatus.payable;

/// Admin Home: approvals first, four numbers, shortcuts, latest enquiries.
class AdminHomeScreen extends ConsumerWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final me = ref.watch(currentUserProvider);
    final db = ref.watch(dbProvider);
    if (me == null) return const SizedBox.shrink();
    final now = DateTime.now();
    final open = db.enquiries.where(_open).length;
    final monthWon = db.enquiries
        .where((e) => e.status.isWon && e.updatedAt.year == now.year && e.updatedAt.month == now.month)
        .fold<double>(0, (s, e) => s + _valueOf(e));
    final vendorsWaiting = db.vendors.where(_vendorWaiting).length;
    final payouts = db.commissions.where(_payoutWaiting).length;

    final Widget primary;
    if (vendorsWaiting > 0) {
      primary = PrimaryActionCard(
        icon: Icons.how_to_reg_outlined,
        title: t.adVendorsTitle(vendorsWaiting),
        body: t.adVendorsBody,
        actionLabel: t.adVendorsButton,
        onTap: () => context.push('${Routes.vendors}?filter=pending'),
      );
    } else if (payouts > 0) {
      primary = PrimaryActionCard(
        icon: Icons.payments_outlined,
        title: t.adPayoutsTitle(payouts),
        body: t.adPayoutsBody,
        actionLabel: t.adPayoutsButton,
        onTap: () => context.push(Routes.commissions),
      );
    } else {
      primary = PrimaryActionCard(
        icon: Icons.person_add_alt_1_outlined,
        title: t.adAddUserTitle,
        body: t.adAddUserBody,
        actionLabel: t.adAddUserButton,
        onTap: () => context.push(Routes.adminNewUser),
      );
    }

    return PageScaffold(
      showAppBar: false,
      onRefresh: () => simulateWork(600),
      children: [
        const HomeTopBar(),
        Greeting(summary: t.adHomeSummary(vendorsWaiting + payouts)),
        primary,
        Space.gapLg,
        StatStrip(items: [
          StatItem(
            icon: Icons.assignment_outlined,
            value: '$open',
            label: t.adKpiOpen,
            onTap: () => context.go('/admin/enquiries'),
          ),
          StatItem(
            icon: Icons.emoji_events_outlined,
            value: Fmt.moneyCompact(monthWon),
            label: t.adKpiWonMonth,
            tone: Tone.success,
            onTap: () => context.go('/admin/business'),
          ),
          StatItem(
            icon: Icons.people_outline,
            value: '${db.users.length}',
            label: t.adKpiUsers,
            tone: Tone.purple,
            onTap: () => context.push(Routes.adminUsers),
          ),
          StatItem(
            icon: Icons.storefront_outlined,
            value: '${db.vendors.where((v) => v.isActive).length}',
            label: t.adKpiVendors,
            tone: Tone.warning,
            onTap: () => context.push(Routes.vendors),
          ),
        ]),
        SectionHeader(t.homeQuickActions),
        TileGrid(children: [
          QuickActionTile(
            icon: Icons.person_add_alt_1_outlined,
            label: t.adAddUserShort,
            onTap: () => context.push(Routes.adminNewUser),
          ),
          QuickActionTile(
            icon: Icons.tune,
            label: t.adSettings,
            tint: ActionTint.amber,
            onTap: () => context.push(Routes.adminSettings),
          ),
          QuickActionTile(
            icon: Icons.bar_chart,
            label: t.navReports,
            tint: ActionTint.purple,
            onTap: () => context.go('/admin/reports'),
          ),
          QuickActionTile(
            icon: Icons.history,
            label: t.adAudit,
            tint: ActionTint.green,
            onTap: () => context.push(Routes.adminAudit),
          ),
        ]),
        SectionHeader(t.frLatest, action: t.actionSeeAll, onAction: () {
          ref.read(listFilterProvider('admin').notifier).set('all');
          context.go('/admin/enquiries');
        }),
        Gap(children: [for (final e in db.enquiriesFor(me).take(3)) EnquiryCard(enquiry: e)]),
      ],
    );
  }
}

/// Admin "Business": the money in four numbers, then every work list.
class AdminBusinessScreen extends ConsumerWidget {
  const AdminBusinessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final won = db.enquiries.where((e) => e.status.isWon).fold<double>(0, (s, e) => s + _valueOf(e));
    final collected = db.payments.fold<double>(0, (s, p) => s + p.amount);
    final outstanding = db.projects.fold<double>(0, (s, p) {
      final due = p.finalValue - db.paidFor(p.id);
      return s + (due > 0 ? due : 0);
    });
    final commission = db.commissions
        .where((c) =>
            c.status == CommissionStatus.pending ||
            c.status == CommissionStatus.approved ||
            c.status == CommissionStatus.payable)
        .fold<double>(0, (s, c) => s + c.amount);
    final toReview = db.quotations.where((q) => q.status == QuotationStatus.submitted).length;

    return PageScaffold(
      title: t.navBusiness,
      children: [
        StatStrip(items: [
          StatItem(icon: Icons.emoji_events_outlined, value: Fmt.moneyCompact(won), label: t.adBizWon),
          StatItem(
            icon: Icons.account_balance_wallet_outlined,
            value: Fmt.moneyCompact(collected),
            label: t.adBizCollected,
            tone: Tone.success,
            onTap: () => context.push(Routes.payments),
          ),
          StatItem(
            icon: Icons.hourglass_bottom,
            value: Fmt.moneyCompact(outstanding),
            label: t.adBizOutstanding,
            tone: Tone.warning,
            onTap: () => context.push(Routes.payments),
          ),
          StatItem(
            icon: Icons.handshake_outlined,
            value: Fmt.moneyCompact(commission),
            label: t.adBizCommission,
            tone: Tone.purple,
            onTap: () => context.push(Routes.commissions),
          ),
        ]),
        NavGroup(title: t.adBizWork, rows: [
          NavRow(
            icon: Icons.request_quote_outlined,
            title: t.navQuotations,
            badge: toReview,
            onTap: () => context.push(Routes.quotations),
          ),
          NavRow(
            icon: Icons.construction_outlined,
            title: t.listProjects,
            onTap: () => context.push(Routes.projects),
          ),
          NavRow(
            icon: Icons.currency_rupee,
            title: t.listPayments,
            onTap: () => context.push(Routes.payments),
          ),
          NavRow(
            icon: Icons.handshake_outlined,
            title: t.earningsTitle,
            badge: db.commissions.where(_payoutWaiting).length,
            onTap: () => context.push(Routes.commissions),
          ),
          NavRow(
            icon: Icons.event_outlined,
            title: t.listVisits,
            onTap: () => context.push(Routes.appointments),
          ),
          NavRow(
            icon: Icons.call_outlined,
            title: t.listCalls,
            onTap: () => context.push(Routes.calls),
          ),
        ]),
        NavGroup(title: t.moreDirectory, rows: [
          NavRow(
            icon: Icons.people_outline,
            title: t.searchCustomers,
            onTap: () => context.push(Routes.customers),
          ),
          NavRow(
            icon: Icons.storefront_outlined,
            title: t.searchVendors,
            badge: db.vendors.where(_vendorWaiting).length,
            onTap: () => context.push(Routes.vendors),
          ),
        ]),
      ],
    );
  }
}

/// Plain bar lists anyone can read: numbers are always written next to
/// the bars, so nothing depends on judging lengths or colours.
class AdminReportsScreen extends ConsumerWidget {
  const AdminReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final open = db.enquiries.where((e) => !e.status.isEnded).toList();
    final stages = [
      for (final s in JourneyStep.values)
        (journeyLabel(t, s), open.where((e) => e.status.step == s).length),
      (t.adRepClosed, db.enquiries.where((e) => e.status.isEnded).length),
    ].where((x) => x.$2 > 0).toList();
    final services = [
      for (final c in db.categories)
        (c.name, db.enquiries.where((e) => e.categoryId == c.id).length),
    ].where((x) => x.$2 > 0).toList()
      ..sort((a, b) => b.$2.compareTo(a.$2));
    final now = DateTime.now();
    final months = [
      for (var i = 5; i >= 0; i--) DateTime(now.year, now.month - i),
    ];
    final loc = MaterialLocalizations.of(context);
    final wonByMonth = [
      for (final m in months)
        (
          loc.formatMonthYear(m),
          db.enquiries
              .where((e) =>
                  e.status.isWon && e.updatedAt.year == m.year && e.updatedAt.month == m.month)
              .fold<double>(0, (s, e) => s + _valueOf(e)),
        ),
    ];
    final vendors = [
      for (final v in db.vendors)
        (
          v.companyName,
          db.assignments
              .where((a) => a.vendorId == v.id && a.status == AssignmentStatus.accepted)
              .length,
        ),
    ].where((x) => x.$2 > 0).toList()
      ..sort((a, b) => b.$2.compareTo(a.$2));

    return PageScaffold(
      title: t.navReports,
      children: [
        SectionHeader(t.adRepStages, top: Space.sm),
        BarList(items: [for (final (l, n) in stages) (l, n, '$n')]),
        SectionHeader(t.adRepMonths),
        BarList(
          tone: Tone.success,
          items: [for (final (l, v) in wonByMonth) (l, v, Fmt.moneyCompact(v))],
        ),
        SectionHeader(t.adRepServices),
        BarList(tone: Tone.purple, items: [for (final (l, n) in services.take(8)) (l, n, '$n')]),
        SectionHeader(t.adRepVendors),
        BarList(tone: Tone.warning, items: [for (final (l, n) in vendors.take(5)) (l, n, '$n')]),
      ],
    );
  }
}

/// Labelled horizontal bars inside a card.
class BarList extends StatelessWidget {
  const BarList({super.key, required this.items, this.tone = Tone.info});

  /// Label, value, value as shown.
  final List<(String, num, String)> items;
  final Tone tone;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return AppCard(
        child: Text(context.t.adRepEmpty,
            style: context.text.bodyMedium?.copyWith(color: AppColors.textSecondary)),
      );
    }
    final max = items.fold<num>(0, (m, x) => x.$2 > m ? x.$2 : m);
    return AppCard(
      child: Gap(
        space: Space.md,
        children: [
          for (final (label, value, shown) in items)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(label, style: context.text.bodyMedium)),
                    Space.gapSm,
                    Text(shown,
                        style: context.text.titleSmall
                            ?.copyWith(fontFeatures: const [FontFeature.tabularFigures()])),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: Corners.pillAll,
                  child: LinearProgressIndicator(
                    value: max == 0 ? 0 : value / max,
                    minHeight: 8,
                    color: tone.solid,
                    backgroundColor: AppColors.track,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

/// Admin "More": people, setup and records, each one tap away.
class AdminMoreScreen extends ConsumerWidget {
  const AdminMoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final me = ref.watch(currentUserProvider);
    final db = ref.watch(dbProvider);
    if (me == null) return const SizedBox.shrink();
    return PageScaffold(
      title: t.navMore,
      children: [
        AppCard(
          padding: EdgeInsets.zero,
          child: NavRow(
            icon: Icons.person_outline,
            title: me.name,
            subtitle: roleLabel(t, me.role),
            trailing: InitialsAvatar(me.name, size: 32),
            onTap: () => context.push(Routes.profile),
          ),
        ),
        NavGroup(title: t.adMorePeople, rows: [
          NavRow(
            icon: Icons.people_outline,
            title: t.adUsers,
            subtitle: t.adUsersCount(db.users.length),
            onTap: () => context.push(Routes.adminUsers),
          ),
          NavRow(
            icon: Icons.person_add_alt_1_outlined,
            title: t.adAddUserShort,
            onTap: () => context.push(Routes.adminNewUser),
          ),
          NavRow(
            icon: Icons.how_to_reg_outlined,
            title: t.adVendorApprovals,
            badge: db.vendors.where(_vendorWaiting).length,
            onTap: () => context.push('${Routes.vendors}?filter=pending'),
          ),
          NavRow(
            icon: Icons.map_outlined,
            title: t.adFranchises,
            onTap: () => context.push(Routes.adminFranchises),
          ),
        ]),
        NavGroup(title: t.adMoreSetup, rows: [
          NavRow(
            icon: Icons.tune,
            title: t.adSettings,
            onTap: () => context.push(Routes.adminSettings),
          ),
          NavRow(
            icon: Icons.category_outlined,
            title: t.adCategories,
            onTap: () => context.push(Routes.adminCategories),
          ),
          NavRow(
            icon: Icons.inventory_2_outlined,
            title: t.adProducts,
            onTap: () => context.push(Routes.adminProducts),
          ),
          NavRow(
            icon: Icons.sell_outlined,
            title: t.adBrands,
            onTap: () => context.push(Routes.adminBrands),
          ),
          NavRow(
            icon: Icons.location_city_outlined,
            title: t.adLocations,
            onTap: () => context.push(Routes.adminLocations),
          ),
        ]),
        NavGroup(title: t.adMoreRecords, rows: [
          NavRow(
            icon: Icons.history,
            title: t.adAudit,
            onTap: () => context.push(Routes.adminAudit),
          ),
          NavRow(
            icon: Icons.admin_panel_settings_outlined,
            title: t.adRoles,
            onTap: () => context.push(Routes.adminRoles),
          ),
          NavRow(
            icon: Icons.help_outline,
            title: t.helpTitle,
            onTap: () => context.push(Routes.help),
          ),
        ]),
      ],
    );
  }
}

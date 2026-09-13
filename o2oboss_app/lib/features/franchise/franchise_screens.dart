import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/brand/brand_philosophy.dart';
import '../../core/data/app_store.dart';
import '../../core/data/db_queries.dart';
import '../../core/l10n/l10n.dart';
import '../../core/l10n/labels.dart';
import '../../core/models/models.dart';
import '../../core/utils/format.dart';
import '../../shared/navigation/home_header.dart';
import '../../shared/widgets/brand_widgets.dart';
import '../../shared/widgets/cards.dart';
import '../../shared/widgets/enquiry_card.dart';
import '../../shared/widgets/enquiry_list.dart';
import '../../shared/widgets/feedback.dart';
import '../../shared/widgets/kpi.dart';
import '../../shared/widgets/layout.dart';
import '../../shared/widgets/pills.dart';
import '../../shared/widgets/rows.dart';
import '../ops/lists.dart';

bool _open(Enquiry e) => !e.status.isEnded && !e.status.isClosed && !e.status.isWon;

/// Franchise head's Home: the territory at a glance, four numbers, anything
/// waiting on approval, and the latest enquiries.
class FranchiseHomeScreen extends ConsumerWidget {
  const FranchiseHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final me = ref.watch(currentUserProvider);
    final db = ref.watch(dbProvider);
    if (me == null) return const SizedBox.shrink();
    final f = db.franchiseById(me.franchiseId);
    final mine = db.enquiriesFor(me);
    final open = mine.where(_open).length;
    final won = mine.where((e) => e.status.isWon).toList();
    final now = DateTime.now();
    final monthValue = won
        .where((e) => e.updatedAt.year == now.year && e.updatedAt.month == now.month)
        .fold<double>(0, (s, e) => s + (e.finalValue ?? e.potentialValue ?? 0));
    final vendors = f == null ? const <Vendor>[] : db.vendorsInTerritory(f.id);
    final waiting = vendors
        .where((v) => v.status == AccountStatus.pending || v.status == AccountStatus.underReview)
        .length;
    final partners = f == null ? 0 : db.salesInTerritory(f.id).length;

    void openList(String key) {
      ref.read(listFilterProvider('franchise').notifier).set(key);
      context.go('/franchise/business');
    }

    return PageScaffold(
      showAppBar: false,
      onRefresh: () => simulateWork(600),
      children: [
        const HomeTopBar(),
        Greeting(summary: t.frHomeSummary(open)),
        InspirationCard(
          title: kFranchiseQuote,
          subtitle: kFranchiseQuoteBody,
          icon: Icons.business,
          gradient: [AppColors.primaryLight, AppColors.primaryLight.withValues(alpha: 0.5)],
        ),
        if (f == null)
          NoteCard(tone: Tone.warning, text: t.frNoTerritory)
        else
          PrimaryActionCard(
            icon: Icons.map_outlined,
            title: t.frHeroTitle(f.name),
            body: t.frHeroBody(Fmt.moneyCompact(monthValue), f.cities.join(', ')),
            actionLabel: t.frHeroButton,
            onTap: () => openList('all'),
          ),
        Space.gapLg,
        StatStrip(items: [
          StatItem(
            icon: Icons.assignment_outlined,
            value: '$open',
            label: t.frKpiActive,
            onTap: () => openList('all'),
          ),
          StatItem(
            icon: Icons.emoji_events_outlined,
            value: '${won.length}',
            label: t.frKpiWon,
            tone: Tone.success,
            onTap: () => openList('all'),
          ),
          StatItem(
            icon: Icons.storefront_outlined,
            value: '${vendors.where((v) => v.isActive).length}',
            label: t.frKpiVendors,
            tone: Tone.purple,
            onTap: () => context.push(Routes.vendors),
          ),
          StatItem(
            icon: Icons.people_outline,
            value: '$partners',
            label: t.frKpiPartners,
            tone: Tone.warning,
            onTap: () => context.go('/franchise/network'),
          ),
        ]),
        if (waiting > 0) ...[
          Space.gapMd,
          NoteCard(
            tone: Tone.warning,
            icon: Icons.hourglass_top,
            text: t.frPendingVendors(waiting),
            action: TextButton(
              onPressed: () => context.push('${Routes.vendors}?filter=pending'),
              child: Text(t.frSeeVendors),
            ),
          ),
        ],
        if (mine.isNotEmpty) ...[
          SectionHeader(t.frLatest, action: t.actionSeeAll, onAction: () => openList('all')),
          Gap(children: [for (final e in mine.take(3)) EnquiryCard(enquiry: e)]),
        ],
      ],
    );
  }
}

/// The people doing business in the territory: vendors and sales partners.
class FranchiseNetworkScreen extends ConsumerWidget {
  const FranchiseNetworkScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final me = ref.watch(currentUserProvider);
    final db = ref.watch(dbProvider);
    if (me == null) return const SizedBox.shrink();
    final f = db.franchiseById(me.franchiseId);
    final vendors = f == null ? const <Vendor>[] : db.vendorsInTerritory(f.id);
    final partners = f == null ? const <AppUser>[] : db.salesInTerritory(f.id);
    final waiting = vendors
        .where((v) => v.status == AccountStatus.pending || v.status == AccountStatus.underReview)
        .length;

    return PageScaffold(
      title: t.navNetwork,
      children: [
        StatStrip(items: [
          StatItem(
            icon: Icons.storefront_outlined,
            value: '${vendors.where((v) => v.isActive).length}',
            label: t.frKpiVendors,
            tone: Tone.purple,
            onTap: () => context.push(Routes.vendors),
          ),
          StatItem(
            icon: Icons.hourglass_top,
            value: '$waiting',
            label: t.frVendorsWaiting,
            tone: waiting > 0 ? Tone.warning : Tone.neutral,
            onTap: () => context.push('${Routes.vendors}?filter=pending'),
          ),
          StatItem(
            icon: Icons.people_outline,
            value: '${partners.length}',
            label: t.frKpiPartners,
            tone: Tone.success,
          ),
        ]),
        SectionHeader(
          t.frVendors,
          action: vendors.length > 3 ? t.actionSeeAll : null,
          onAction: () => context.push(Routes.vendors),
        ),
        if (vendors.isEmpty)
          AppCard(child: EmptyState(compact: true, icon: Icons.storefront_outlined, title: t.frNoVendors))
        else
          Gap(children: [for (final v in vendors.take(3)) VendorCard(vendor: v)]),
        SectionHeader(t.frPartners),
        if (partners.isEmpty)
          AppCard(child: EmptyState(compact: true, icon: Icons.people_outline, title: t.frNoPartners))
        else
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (var i = 0; i < partners.length; i++) ...[
                  if (i > 0) const Divider(indent: 66),
                  _PartnerRow(user: partners[i]),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _PartnerRow extends ConsumerWidget {
  const _PartnerRow({required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final u = user;
    final referrals = db.enquiries.where((e) => e.salespersonId == u.id).length;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.md),
      child: Row(
        children: [
          InitialsAvatar(u.name, size: 38),
          Space.gapMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(u.name, style: context.text.titleSmall),
                Text(
                  [if (u.salesType != null) salesTypeLabel(t, u.salesType!), u.city].join(', '),
                  style: context.text.bodySmall,
                ),
              ],
            ),
          ),
          Space.gapSm,
          StatusPill(t.frReferralsCount(referrals), tone: referrals > 0 ? Tone.info : Tone.neutral),
        ],
      ),
    );
  }
}

/// Franchise "More": the territory, work lists and account.
class FranchiseMoreScreen extends ConsumerWidget {
  const FranchiseMoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final me = ref.watch(currentUserProvider);
    final db = ref.watch(dbProvider);
    if (me == null) return const SizedBox.shrink();
    final f = db.franchiseById(me.franchiseId);
    return PageScaffold(
      title: t.navMore,
      children: [
        AppCard(
          padding: EdgeInsets.zero,
          child: NavRow(
            icon: Icons.person_outline,
            title: me.name,
            subtitle: t.moreProfileSubtitle,
            trailing: InitialsAvatar(me.name, size: 32),
            onTap: () => context.push(Routes.profile),
          ),
        ),
        SectionHeader(t.frTerritory, top: Space.xl),
        if (f == null)
          NoteCard(tone: Tone.warning, text: t.frNoTerritory)
        else
          AppCard(
            child: Column(
              children: [
                InfoRow(icon: Icons.map_outlined, label: t.frTerritoryName, value: f.name),
                InfoRow(icon: Icons.location_city_outlined, label: t.frCities, value: f.cities.join(', ')),
                InfoRow(
                  icon: Icons.percent,
                  label: t.frShare,
                  value: Fmt.percent(f.sharePercent ?? db.config.franchiseSharePercent),
                ),
              ],
            ),
          ),
        NavGroup(title: t.moreWork, rows: [
          NavRow(
            icon: Icons.event_outlined,
            title: t.listVisits,
            onTap: () => context.push(Routes.appointments),
          ),
          NavRow(
            icon: Icons.request_quote_outlined,
            title: t.navQuotations,
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
        ]),
        NavGroup(title: t.moreMine, rows: [
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/brand/brand_philosophy.dart';
import '../../core/data/app_store.dart';
import '../../core/data/db_queries.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/utils/format.dart';
import '../../shared/navigation/home_header.dart';
import '../../shared/widgets/brand_widgets.dart';
import '../../shared/widgets/cards.dart';
import '../../shared/widgets/enquiry_list.dart';
import '../../shared/widgets/feedback.dart';
import '../../shared/widgets/kpi.dart';
import '../../shared/widgets/layout.dart';
import '../visits/visit_widgets.dart';
import 'vendor_common.dart';

/// Vendor Home: new referrals first, then the four numbers that matter,
/// shortcuts, and the next visits. One main action at a time.
class VendorHomeScreen extends ConsumerWidget {
  const VendorHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final me = ref.watch(currentUserProvider);
    final db = ref.watch(dbProvider);
    if (me == null || me.vendorId == null) return const SizedBox.shrink();
    final vendorId = me.vendorId!;
    final vendor = db.vendorById(vendorId);
    final referrals = vendorReferrals(db, vendorId);
    final pending = [
      for (final (_, a) in referrals)
        if (a.status == AssignmentStatus.pending) a,
    ]..sort((a, b) => a.deadline.compareTo(b.deadline));
    final jobs = [
      for (final (e, a) in referrals)
        if (a.status == AssignmentStatus.accepted) e,
    ];
    final toQuote = jobs.where((e) => vendorNeedsQuote(db, e, vendorId)).toList();
    final openQuotes =
        db.quotations.where((q) => q.vendorId == vendorId && q.status.isOpen).length;
    final working = db.projects
        .where((p) =>
            p.vendorId == vendorId &&
            (p.status == ProjectStatus.notStarted ||
                p.status == ProjectStatus.inProgress ||
                p.status == ProjectStatus.onHold))
        .length;
    final now = DateTime.now();
    final visits = db.appointments
        .where((a) =>
            a.vendorId == vendorId &&
            a.status.isOpen &&
            a.at.isAfter(now.subtract(const Duration(hours: 3))))
        .toList()
      ..sort((a, b) => a.at.compareTo(b.at));

    void openList(String key) {
      ref.read(listFilterProvider('vendor').notifier).set(key);
      context.go('/vendor/referrals');
    }

    return PageScaffold(
      showAppBar: false,
      onRefresh: () => simulateWork(600),
      children: [
        const HomeTopBar(),
        Greeting(summary: t.vnHomeSummary(pending.length)),
        const InspirationCard(
          title: kVendorQuote,
          subtitle: kVendorQuoteBody,
          icon: Icons.verified,
          gradient: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
        ),
        if (vendor != null && !vendor.isActive) ...[
          NoteCard(
            tone: Tone.warning,
            icon: Icons.hourglass_top,
            title: t.vnPendingTitle,
            text: t.vnPendingBody,
          ),
          Space.gapMd,
        ],
        if (pending.isNotEmpty)
          PrimaryActionCard(
            icon: Icons.inbox_outlined,
            title: t.vnNewTitle(pending.length),
            body: t.vnNewBody(Fmt.dateTime(context, pending.first.deadline)),
            actionLabel: t.vnNewButton,
            onTap: () => context.push(Routes.enquiry(pending.first.enquiryId)),
          )
        else if (toQuote.isNotEmpty)
          PrimaryActionCard(
            icon: Icons.request_quote_outlined,
            title: t.vnQuoteTitle,
            body: t.vnQuoteBody(db.enquiryTitle(toQuote.first)),
            actionLabel: t.vnQuoteButton,
            onTap: () => context.push(Routes.newQuotation(toQuote.first.id, vendorId)),
          )
        else
          NoteCard(
            tone: Tone.success,
            icon: Icons.check_circle_outline,
            title: t.vnAllClearTitle,
            text: t.vnAllClearBody,
          ),
        Space.gapLg,
        StatStrip(items: [
          StatItem(
            icon: Icons.inbox_outlined,
            value: '${pending.length}',
            label: t.vnKpiNew,
            tone: pending.isEmpty ? Tone.neutral : Tone.warning,
            onTap: () => openList('new'),
          ),
          StatItem(
            icon: Icons.work_outline,
            value: '${jobs.where(vendorJobActive).length}',
            label: t.vnKpiActive,
            onTap: () => openList('active'),
          ),
          StatItem(
            icon: Icons.request_quote_outlined,
            value: '$openQuotes',
            label: t.vnKpiQuotes,
            tone: Tone.purple,
            onTap: () => context.go('/vendor/quotations'),
          ),
          StatItem(
            icon: Icons.construction_outlined,
            value: '$working',
            label: t.vnKpiProjects,
            tone: Tone.success,
            onTap: () => context.push(Routes.projects),
          ),
        ]),
        SectionHeader(t.homeQuickActions),
        TileGrid(children: [
          QuickActionTile(
            icon: Icons.event_outlined,
            label: t.listVisits,
            tint: ActionTint.purple,
            onTap: () => context.push(Routes.appointments),
          ),
          QuickActionTile(
            icon: Icons.construction_outlined,
            label: t.listProjects,
            tint: ActionTint.amber,
            onTap: () => context.push(Routes.projects),
          ),
          QuickActionTile(
            icon: Icons.currency_rupee,
            label: t.listPayments,
            tint: ActionTint.green,
            onTap: () => context.push(Routes.payments),
          ),
          QuickActionTile(
            icon: Icons.storefront_outlined,
            label: t.vnBusinessProfile,
            onTap: () => context.push(Routes.vendorCompany),
          ),
        ]),
        if (visits.isNotEmpty) ...[
          SectionHeader(
            t.vnUpcomingVisits,
            action: visits.length > 2 ? t.actionSeeAll : null,
            onAction: () => context.push(Routes.appointments),
          ),
          Gap(children: [
            for (final a in visits.take(2)) VisitCard(appointment: a, showEnquiry: true),
          ]),
        ],
      ],
    );
  }
}

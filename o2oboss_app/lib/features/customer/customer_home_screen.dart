import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/routes.dart';
import '../../core/brand/brand_philosophy.dart';
import '../../core/data/app_store.dart';
import '../../core/data/db_queries.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../shared/navigation/home_header.dart';
import '../../shared/widgets/brand_widgets.dart';
import '../../shared/widgets/cards.dart';
import '../../shared/widgets/enquiry_card.dart';
import '../../shared/widgets/feedback.dart';
import '../../shared/widgets/layout.dart';

/// Customer Home: the one thing that needs them (a quotation, a visit to
/// confirm, or posting a new need), their requirements, and four shortcuts.
class CustomerHomeScreen extends ConsumerWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final me = ref.watch(currentUserProvider);
    final db = ref.watch(dbProvider);
    if (me == null) return const SizedBox.shrink();
    final mine = db.enquiriesFor(me);
    final ids = {for (final e in mine) e.id};
    final active = mine.where((e) => !e.status.isEnded && !e.status.isClosed).toList();
    final waiting = db.quotations
        .where((q) =>
            ids.contains(q.enquiryId) &&
            (q.status == QuotationStatus.sent || q.status == QuotationStatus.viewed))
        .toList();
    final toConfirm = db.appointments
        .where((a) =>
            ids.contains(a.enquiryId) &&
            a.status == AppointmentStatus.completed &&
            !a.customerConfirmed)
        .toList();

    final Widget primary;
    var posting = false;
    if (waiting.isNotEmpty) {
      final q = waiting.first;
      primary = PrimaryActionCard(
        icon: Icons.request_quote_outlined,
        title: t.cuQuoteReadyTitle,
        body: t.cuQuoteReadyBody(db.vendorName(q.vendorId), db.enquiryTitle(db.enquiryById(q.enquiryId)!)),
        actionLabel: t.cuQuoteReadyButton,
        onTap: () => context.push(Routes.quotation(q.id)),
      );
    } else if (toConfirm.isNotEmpty) {
      final a = toConfirm.first;
      primary = PrimaryActionCard(
        icon: Icons.event_available_outlined,
        title: t.cuVisitCheckTitle,
        body: t.cuVisitCheckBody(db.vendorName(a.vendorId), db.enquiryTitle(db.enquiryById(a.enquiryId)!)),
        actionLabel: t.cuVisitCheckButton,
        onTap: () => context.push(Routes.enquiry(a.enquiryId)),
      );
    } else {
      posting = true;
      primary = PrimaryActionCard(
        icon: Icons.add_task,
        title: t.cuPostTitle,
        body: t.cuPostBody,
        actionLabel: t.cuPostButton,
        onTap: () => context.push(Routes.refer()),
      );
    }

    return PageScaffold(
      showAppBar: false,
      onRefresh: () => simulateWork(600),
      children: [
        const HomeTopBar(showSearch: false),
        Greeting(summary: t.cuHomeSummary(active.length)),
        const InspirationCard(
          title: kCustomerQuote,
          subtitle: kCustomerQuoteBody,
          icon: Icons.storefront,
          gradient: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
        ),
        primary,
        if (active.isNotEmpty) ...[
          SectionHeader(
            t.cuYourRequirements,
            action: mine.length > 2 ? t.actionSeeAll : null,
            onAction: () => context.go('/customer/requirement'),
          ),
          Gap(children: [for (final e in active.take(2)) EnquiryCard(enquiry: e)]),
        ],
        SectionHeader(t.homeQuickActions),
        TileGrid(children: [
          if (!posting)
            QuickActionTile(
              icon: Icons.add,
              label: t.cuNewRequirement,
              subtitle: t.qaSubNewRequirement,
              onTap: () => context.push(Routes.refer()),
            ),
          QuickActionTile(
            icon: Icons.request_quote_outlined,
            label: t.navQuotations,
            subtitle: t.qaSubQuotations,
            tint: ActionTint.purple,
            count: waiting.length,
            onTap: () => context.go('/customer/quotations'),
          ),
          QuickActionTile(
            icon: Icons.inventory_2_outlined,
            label: t.navOrders,
            subtitle: t.qaSubTrack,
            tint: ActionTint.amber,
            onTap: () => context.push(Routes.projects),
          ),
          QuickActionTile(
            icon: Icons.chat_bubble_outline,
            label: t.cuMessages,
            subtitle: t.qaSubMessages,
            tint: ActionTint.pink,
            onTap: () => context.push('/chats'),
          ),
          if (posting)
            QuickActionTile(
              icon: Icons.help_outline,
              label: t.helpTitle,
              subtitle: t.qaSubHelp,
              tint: ActionTint.green,
              onTap: () => context.push(Routes.help),
            ),
        ]),
      ],
    );
  }
}

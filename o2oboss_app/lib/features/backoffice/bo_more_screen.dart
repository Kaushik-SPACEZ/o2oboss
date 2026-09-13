import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/routes.dart';
import '../../core/data/app_store.dart';
import '../../core/data/db_queries.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../shared/widgets/layout.dart';
import '../../shared/widgets/pills.dart';
import '../../shared/widgets/rows.dart';

/// Back office "More": the less frequent lists, grouped, plus the account.
class BoMoreScreen extends ConsumerWidget {
  const BoMoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final me = ref.watch(currentUserProvider);
    final db = ref.watch(dbProvider);
    if (me == null) return const SizedBox.shrink();
    final ids = db.enquiriesFor(me).map((e) => e.id).toSet();
    final toConfirm = db.appointments
        .where((a) => ids.contains(a.enquiryId) && a.status == AppointmentStatus.pendingConfirmation)
        .length;
    final toReview = db.quotations
        .where((q) => ids.contains(q.enquiryId) && q.status == QuotationStatus.submitted)
        .length;
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
        NavGroup(title: t.moreWork, rows: [
          NavRow(
            icon: Icons.event_outlined,
            title: t.listVisits,
            badge: toConfirm,
            onTap: () => context.push(Routes.appointments),
          ),
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
            icon: Icons.call_outlined,
            title: t.listCalls,
            onTap: () => context.push(Routes.calls),
          ),
          NavRow(
            icon: Icons.chat_bubble_outline,
            title: t.navChat,
            onTap: () => context.push('/chats'),
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
            onTap: () => context.push(Routes.vendors),
          ),
        ]),
        NavGroup(title: t.moreMine, rows: [
          NavRow(
            icon: Icons.account_balance_wallet_outlined,
            title: t.earningsTitle,
            onTap: () => context.push(Routes.commissions),
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/routes.dart';
import '../../core/data/app_store.dart';
import '../../core/data/db_queries.dart';
import '../../core/l10n/l10n.dart';
import '../../core/l10n/labels.dart';
import '../../core/models/models.dart';
import '../../shared/widgets/layout.dart';
import '../../shared/widgets/pills.dart';
import '../../shared/widgets/rows.dart';
import '../../shared/widgets/tones.dart';

/// Vendor "More": the business profile in four short pages, the less
/// frequent work lists, and the personal account.
class VendorMoreScreen extends ConsumerWidget {
  const VendorMoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final me = ref.watch(currentUserProvider);
    final db = ref.watch(dbProvider);
    if (me == null) return const SizedBox.shrink();
    final vendor = db.vendorById(me.vendorId);
    final toConfirm = db.appointments
        .where((a) => a.vendorId == me.vendorId && a.status == AppointmentStatus.proposed)
        .length;
    return PageScaffold(
      title: t.navMore,
      children: [
        AppCard(
          padding: EdgeInsets.zero,
          child: NavRow(
            icon: Icons.storefront_outlined,
            title: vendor?.companyName ?? me.name,
            subtitle: vendor == null ? null : me.name,
            trailing: vendor == null
                ? null
                : StatusPill(accountStatusLabel(t, vendor.status), tone: accountTone(vendor.status)),
            onTap: () => context.push(Routes.vendorCompany),
          ),
        ),
        NavGroup(title: t.vnMoreBusiness, rows: [
          NavRow(
            icon: Icons.storefront_outlined,
            title: t.vnBusinessProfile,
            onTap: () => context.push(Routes.vendorCompany),
          ),
          NavRow(
            icon: Icons.category_outlined,
            title: t.vnCatalog,
            subtitle: t.vnCatalogSubtitle,
            onTap: () => context.push(Routes.vendorCatalog),
          ),
          NavRow(
            icon: Icons.map_outlined,
            title: t.vnAreas,
            subtitle: t.vnAreasSubtitle,
            onTap: () => context.push(Routes.vendorAreas),
          ),
          NavRow(
            icon: Icons.description_outlined,
            title: t.vendorDocuments,
            subtitle: t.vnDocumentsSubtitle,
            onTap: () => context.push(Routes.vendorDocuments),
          ),
        ]),
        NavGroup(title: t.moreWork, rows: [
          NavRow(
            icon: Icons.event_outlined,
            title: t.listVisits,
            badge: toConfirm,
            onTap: () => context.push(Routes.appointments),
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
            icon: Icons.person_outline,
            title: t.navProfile,
            subtitle: t.moreProfileSubtitle,
            onTap: () => context.push(Routes.profile),
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

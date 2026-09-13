import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/routes.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/data/app_store.dart';
import '../../core/data/db_queries.dart';
import '../../core/l10n/l10n.dart';
import '../../core/l10n/labels.dart';
import '../../core/models/models.dart';
import '../../core/utils/format.dart';
import '../../shared/widgets/feedback.dart';
import '../../shared/widgets/inputs.dart';
import '../../shared/widgets/layout.dart';
import '../../shared/widgets/rows.dart';
import '../../shared/widgets/tones.dart';

/// One search box for everything the person is allowed to see: enquiries,
/// and for operations roles also customers and vendors.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final me = ref.watch(currentUserProvider);
    final db = ref.watch(dbProvider);
    if (me == null) return const SizedBox.shrink();
    final q = _q.toLowerCase();
    final digits = _q.replaceAll(RegExp(r'\D'), '');
    bool hit(String? s) => s != null && s.toLowerCase().contains(q);
    bool phoneHit(String? p) => digits.length >= 3 && (p ?? '').contains(digits);
    final ops = me.role == UserRole.backOffice ||
        me.role == UserRole.admin ||
        me.role == UserRole.franchise;
    final showCustomerDetails = me.role != UserRole.vendor;

    final enquiries = _q.length < 2
        ? const <Enquiry>[]
        : db.enquiriesFor(me).where((e) {
            final c = db.customerById(e.customerId);
            return hit(e.id) ||
                hit(db.enquiryTitle(e)) ||
                hit(e.area) ||
                (showCustomerDetails && (hit(c?.name) || phoneHit(c?.phone)));
          }).take(20).toList();
    final vendors = !ops || _q.length < 2
        ? const <Vendor>[]
        : db.vendors
            .where((v) =>
                (me.role != UserRole.franchise || v.franchiseId == me.franchiseId) &&
                (hit(v.companyName) || hit(v.contactPerson) || phoneHit(v.phone)))
            .take(10)
            .toList();
    final customers = !ops || _q.length < 2
        ? const <Customer>[]
        : db.customers
            .where((c) =>
                (me.role != UserRole.franchise ||
                    db.franchiseForCity(c.city)?.id == me.franchiseId) &&
                (hit(c.name) || phoneHit(c.phone)))
            .take(10)
            .toList();
    final nothing = enquiries.isEmpty && vendors.isEmpty && customers.isEmpty;

    return PageScaffold(
      title: t.actionSearch,
      children: [
        SearchBox(
          autofocus: true,
          hint: ops ? t.searchHintOps : t.searchHint,
          onChanged: (v) => setState(() => _q = v.trim()),
        ),
        if (_q.length < 2)
          EmptyState(icon: Icons.search, title: t.searchStartTitle, body: t.searchStartBody)
        else if (nothing)
          EmptyState(icon: Icons.search_off, title: t.emptyNoResults, body: t.emptyNoResultsBody)
        else ...[
          if (enquiries.isNotEmpty)
            NavGroup(title: t.navEnquiries, rows: [
              for (final e in enquiries)
                NavRow(
                  icon: categoryIcon(db.categoryById(e.categoryId)?.icon ?? ''),
                  title: db.enquiryTitle(e),
                  subtitle: showCustomerDetails
                      ? '${e.id}, ${db.customerName(e.customerId)}'
                      : '${e.id}, ${e.area}',
                  trailing: Text(statusLabelFor(t, me.role, e.status),
                      style: Theme.of(context).textTheme.labelSmall),
                  onTap: () => context.push(Routes.enquiry(e.id)),
                ),
            ]),
          if (customers.isNotEmpty)
            NavGroup(title: t.searchCustomers, rows: [
              for (final c in customers)
                NavRow(
                  icon: Icons.person_outline,
                  title: c.name,
                  subtitle: '${Fmt.phone(c.phone)}, ${c.city}',
                  onTap: () => context.push(Routes.customer(c.id)),
                ),
            ]),
          if (vendors.isNotEmpty)
            NavGroup(title: t.searchVendors, rows: [
              for (final v in vendors)
                NavRow(
                  icon: Icons.storefront_outlined,
                  title: v.companyName,
                  subtitle: '${v.contactPerson}, ${v.city}',
                  trailing: Text(accountStatusLabel(t, v.status),
                      style: Theme.of(context).textTheme.labelSmall),
                  onTap: () => context.push(Routes.vendor(v.id)),
                ),
            ]),
          Space.gapXl,
        ],
      ],
    );
  }
}

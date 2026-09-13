import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/routes.dart';
import '../../core/data/app_store.dart';
import '../../core/data/permissions.dart';
import '../../core/l10n/l10n.dart';
import '../../shared/widgets/enquiry_list.dart';
import '../../shared/widgets/layout.dart';
import 'bo_filters.dart';

/// Enquiry list for back office, franchise and admin, filtered by work queue.
class OpsEnquiriesScreen extends ConsumerWidget {
  const OpsEnquiriesScreen({super.key, required this.listKey});

  final String listKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final me = ref.watch(currentUserProvider);
    final config = ref.watch(configProvider);
    final canCreate = me != null && can(me.role, Perm.createEnquiry, config);
    return PageScaffold(
      title: t.navEnquiries,
      fab: canCreate
          ? FloatingActionButton.extended(
              onPressed: () => context.push(Routes.refer()),
              icon: const Icon(Icons.add),
              label: Text(t.boNewEnquiryShort),
            )
          : null,
      body: EnquiryListBody(listKey: listKey, filters: opsListFilters(t)),
    );
  }
}

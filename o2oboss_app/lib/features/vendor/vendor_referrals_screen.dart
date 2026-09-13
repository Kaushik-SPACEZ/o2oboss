import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/app_store.dart';
import '../../core/data/db_queries.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../shared/widgets/enquiry_list.dart';
import '../../shared/widgets/feedback.dart';
import '../../shared/widgets/layout.dart';
import 'vendor_common.dart';

/// Every referral O2O Boss sent this vendor, with simple filters.
class VendorReferralsScreen extends ConsumerWidget {
  const VendorReferralsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final vendorId = ref.watch(currentUserProvider)?.vendorId ?? '';
    AssignmentStatus? statusOf(Enquiry e) => db.assignmentFor(e.id, vendorId)?.status;
    bool accepted(Enquiry e) => statusOf(e) == AssignmentStatus.accepted;

    return PageScaffold(
      title: t.navReferrals,
      body: EnquiryListBody(
        listKey: 'vendor',
        source: (db, me) => [for (final (e, _) in vendorReferrals(db, me.vendorId ?? '')) e],
        filters: [
          EnquiryFilter('all', t.labelAll, (_) => true),
          EnquiryFilter('new', t.vnFilterNew, (e) => statusOf(e) == AssignmentStatus.pending),
          EnquiryFilter('active', t.vnFilterActive, (e) => accepted(e) && vendorJobActive(e)),
          EnquiryFilter('won', t.vnFilterWon, (e) => accepted(e) && e.status.isWon),
          EnquiryFilter(
            'closed',
            t.vnFilterClosed,
            (e) =>
                statusOf(e) == AssignmentStatus.rejected ||
                statusOf(e) == AssignmentStatus.expired ||
                e.status.isEnded,
          ),
        ],
        empty: EmptyState(
          icon: Icons.inbox_outlined,
          title: t.vnEmptyTitle,
          body: t.vnEmptyBody,
        ),
      ),
    );
  }
}

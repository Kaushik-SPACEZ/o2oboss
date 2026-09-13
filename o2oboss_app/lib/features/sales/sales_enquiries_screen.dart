import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/routes.dart';
import '../../core/l10n/l10n.dart';
import '../../shared/widgets/enquiry_list.dart';
import '../../shared/widgets/feedback.dart';
import '../../shared/widgets/layout.dart';
import 'sales_home_screen.dart';

/// All of a referral partner's referrals with four simple filters.
class SalesEnquiriesScreen extends StatelessWidget {
  const SalesEnquiriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return PageScaffold(
      title: t.salesEnquiriesTitle,
      body: EnquiryListBody(
        listKey: 'sales',
        filters: [
          EnquiryFilter('all', t.labelAll, (_) => true),
          EnquiryFilter('active', t.salesFilterActive, salesInProgress),
          EnquiryFilter('won', t.salesFilterWon, (e) => e.status.isWon),
          EnquiryFilter('closed', t.salesFilterClosed, (e) => e.status.isEnded),
        ],
        empty: EmptyState(
          icon: Icons.campaign_outlined,
          title: t.salesEmptyTitle,
          body: t.salesEmptyBody,
          actionLabel: t.salesReferButton,
          onAction: () => context.push(Routes.refer()),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/routes.dart';
import '../../core/l10n/l10n.dart';
import '../../shared/widgets/buttons.dart';
import '../../shared/widgets/enquiry_list.dart';
import '../../shared/widgets/feedback.dart';
import '../../shared/widgets/layout.dart';

/// Everything the customer has asked for, and one button to ask again.
class CustomerRequirementsScreen extends StatelessWidget {
  const CustomerRequirementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    void post() => context.push(Routes.refer());
    return PageScaffold(
      title: t.navRequirement,
      fab: AddFab(label: t.cuNewRequirement, onPressed: post),
      body: EnquiryListBody(
        listKey: 'customer',
        filters: [
          EnquiryFilter('all', t.labelAll, (_) => true),
          EnquiryFilter('active', t.cuFilterActive, (e) => !e.status.isEnded && !e.status.isWon),
          EnquiryFilter('done', t.cuFilterDone, (e) => e.status.isWon),
          EnquiryFilter('closed', t.cuFilterClosed, (e) => e.status.isEnded),
        ],
        empty: EmptyState(
          icon: Icons.assignment_outlined,
          title: t.cuEmptyTitle,
          body: t.cuEmptyBody,
          actionLabel: t.cuNewRequirement,
          onAction: post,
        ),
      ),
    );
  }
}

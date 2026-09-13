import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/app_store.dart';
import '../../core/data/db_queries.dart';
import '../../core/models/models.dart';
import '../common/system_screens.dart';
import '../customer/customer_enquiry_view.dart';
import '../ops/ops_enquiry_view.dart';
import '../sales/sales_enquiry_view.dart';
import '../vendor/vendor_enquiry_view.dart';

/// One address for an enquiry, shown differently to each role: referral
/// partners and customers get a plain progress view, vendors a referral
/// card, and back office, franchise and admin the full work view.
class EnquiryDetailScreen extends ConsumerWidget {
  const EnquiryDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(dbProvider);
    final me = ref.watch(currentUserProvider);
    final e = db.enquiryById(id);
    if (me == null) return const SizedBox.shrink();
    if (e == null) return const NotFoundScreen();
    if (!db.canView(me, e)) return const NoAccessView();
    return switch (me.role) {
      UserRole.sales => SalesEnquiryView(enquiry: e),
      UserRole.backOffice || UserRole.admin || UserRole.franchise => OpsEnquiryView(enquiry: e),
      UserRole.vendor => VendorEnquiryView(enquiry: e),
      UserRole.customer => CustomerEnquiryView(enquiry: e),
    };
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/app_store.dart';
import '../../core/data/db_queries.dart';
import '../../core/models/models.dart';
import '../chat/chat_screens.dart';
import '../common/system_screens.dart';
import 'commission_part.dart';
import 'info_parts.dart';
import 'qualify_screen.dart';
import 'quotes_part.dart';
import 'vendors_part.dart';
import 'verify_screen.dart';
import 'visits_part.dart';

/// Sub-pages of an enquiry (`/enquiry/:id/:part`). Work parts are for back
/// office and admin; franchise heads can open them read-only.
class EnquiryPartScreen extends ConsumerWidget {
  const EnquiryPartScreen({super.key, required this.id, required this.part});

  final String id;
  final String part;

  static const _opsRoles = {UserRole.backOffice, UserRole.admin, UserRole.franchise};

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(dbProvider);
    final me = ref.watch(currentUserProvider);
    final e = db.enquiryById(id);
    if (me == null) return const SizedBox.shrink();
    if (e == null) return const NotFoundScreen();
    if (!db.canView(me, e)) return const NoAccessView();
    if (part == 'chat') return ChatThreadsScreen(enquiry: e);
    if (!_opsRoles.contains(me.role)) return const NoAccessView();
    return switch (part) {
      'details' => DetailsPart(enquiry: e),
      'calls' => CallsPart(enquiry: e),
      'verify' => VerifyScreen(enquiry: e),
      'qualify' => QualifyScreen(enquiry: e),
      'vendors' => VendorsPart(enquiry: e),
      'visits' => VisitsPart(enquiry: e),
      'quotations' => QuotesPart(enquiry: e),
      'commission' => CommissionPart(enquiry: e),
      'activity' => ActivityPart(enquiry: e),
      _ => const NotFoundScreen(),
    };
  }
}

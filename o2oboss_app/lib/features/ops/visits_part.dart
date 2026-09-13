import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_spacing.dart';
import '../../core/data/app_store.dart';
import '../../core/data/db_queries.dart';
import '../../core/data/permissions.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../shared/widgets/buttons.dart';
import '../../shared/widgets/cards.dart';
import '../../shared/widgets/feedback.dart';
import '../../shared/widgets/layout.dart';
import '../visits/visit_widgets.dart';

/// Site visits for one enquiry: book, confirm vendor proposals, reschedule,
/// cancel, and mark done or no-show.
class VisitsPart extends ConsumerWidget {
  const VisitsPart({super.key, required this.enquiry});

  final Enquiry enquiry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final me = ref.watch(currentUserProvider)!;
    final e = db.enquiryById(enquiry.id) ?? enquiry;
    final canBook = can(me.role, Perm.manageAppointments, db.config) &&
        !e.status.isClosed &&
        db.activeAssignmentsFor(e.id).any((a) => a.status == AssignmentStatus.accepted);
    final notIntroduced = e.status == EnquiryStatus.vendorAccepted;
    final accepted = db.activeAssignmentsFor(e.id)
        .where((a) => a.status == AssignmentStatus.accepted)
        .toList();

    return PageScaffold(
      title: t.opsPartVisits,
      children: [
        if (canBook && notIntroduced && accepted.isNotEmpty) ...[
          NoteCard(
            icon: Icons.handshake_outlined,
            text: t.visitIntroduceFirst(db.vendorName(accepted.first.vendorId)),
            action: AppButton.secondary(
              t.vendorsIntroduce,
              expand: false,
              onPressed: () {
                ref.read(dbProvider.notifier).introduceVendor(e.id, accepted.first.vendorId);
                showToast(context, t.vendorsIntroduced);
              },
            ),
          ),
          Space.gapLg,
        ],
        VisitsList(enquiry: e),
        const SizedBox(height: 80),
      ],
      bottomBar: canBook
          ? StickyActions(children: [
              AppButton(t.visitBookTitle,
                  icon: Icons.event_available_outlined,
                  onPressed: () => bookVisitFlow(context, ref, e)),
            ])
          : null,
    );
  }
}

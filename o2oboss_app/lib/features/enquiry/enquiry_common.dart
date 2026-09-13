import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/data/app_store.dart';
import '../../core/data/db_queries.dart';
import '../../core/l10n/l10n.dart';
import '../../core/l10n/labels.dart';
import '../../core/models/models.dart';
import '../../core/utils/format.dart';
import '../../shared/widgets/cards.dart';
import '../../shared/widgets/journey.dart';
import '../../shared/widgets/layout.dart';
import '../../shared/widgets/pills.dart';
import '../../shared/widgets/tones.dart';

/// Top of every enquiry page: what it is, its ID and where it stands.
class EnquiryHeader extends ConsumerWidget {
  const EnquiryHeader({super.key, required this.enquiry, this.simple = false, this.statusOverride});

  final Enquiry enquiry;

  /// Plain status wording for referral partners and customers.
  final bool simple;

  /// Replaces the enquiry status, e.g. "New referral" for a vendor.
  final (String, Tone)? statusOverride;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final e = enquiry;
    final category = db.categoryById(e.categoryId);
    return SoftHeroCard(
      padding: const EdgeInsets.all(Space.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlowIcon(categoryIcon(category?.icon ?? ''), size: 52),
          Space.gapMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(db.enquiryTitle(e), style: context.text.titleLarge),
                const SizedBox(height: 2),
                Text(t.detailCreatedOn(e.id, Fmt.date(context, e.createdAt)),
                    style: context.text.bodySmall),
                Space.gapSm,
                Wrap(
                  spacing: Space.sm,
                  runSpacing: Space.xs,
                  children: [
                    StatusPill(
                      statusOverride?.$1 ??
                          (simple ? simpleStatusLabel(t, e.status) : statusLabel(t, e.status)),
                      tone: statusOverride?.$2 ?? statusTone(e.status),
                    ),
                    if (!simple && e.priority.index >= EnquiryPriority.high.index)
                      StatusPill(priorityLabel(t, e.priority),
                          tone: priorityTone(e.priority), icon: Icons.flag_outlined),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// When each simple journey step was completed, taken from the activity log.
Map<JourneyStep, DateTime> journeyDates(DbState db, Enquiry e) {
  final dates = <JourneyStep, DateTime>{JourneyStep.submitted: e.createdAt};
  final entries = db.activityFor(e.id).reversed; // oldest first
  for (final a in entries) {
    if (a.action != AuditAction.statusChanged) continue;
    final s = enumByNameOrNullPublic(EnquiryStatus.values, a.newValue ?? '');
    if (s == null || s.isEnded) continue;
    for (final j in JourneyStep.values) {
      if (j.index < s.step.index) dates.putIfAbsent(j, () => a.at);
    }
    if (s == EnquiryStatus.commissionSettled) {
      for (final j in JourneyStep.values) {
        dates.putIfAbsent(j, () => a.at);
      }
    }
  }
  return dates;
}

/// The simple journey with dates on finished steps and a plain sentence on
/// the current one. Used by referral partners and customers.
class SimpleJourneyCard extends ConsumerWidget {
  const SimpleJourneyCard({super.key, required this.enquiry, this.forCustomer = false});

  final Enquiry enquiry;
  final bool forCustomer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final e = enquiry;
    final dates = journeyDates(db, e);
    final marks = journeyMarks(e.status, simpleJourneySteps);
    final steps = <JourneyStepData>[];
    for (var i = 0; i < simpleJourneySteps.length; i++) {
      final step = simpleJourneySteps[i];
      final mark = marks[i];
      String? detail;
      if (mark == StepMark.done && dates[step] != null) {
        detail = Fmt.date(context, dates[step]!);
      } else if (mark == StepMark.current) {
        detail = currentStepDetail(context, db, e, forCustomer: forCustomer);
      } else if (mark == StepMark.failed) {
        detail = reasonLabel(t, e.status == EnquiryStatus.rejected ? e.rejectReason : e.lossReason);
      }
      steps.add(JourneyStepData(
        label: mark == StepMark.failed ? simpleStatusLabel(t, e.status) : journeyLabel(t, step),
        mark: mark,
        detail: detail,
      ));
    }
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.detailProgress, style: context.text.titleSmall),
          Space.gapLg,
          JourneyRail(steps: steps),
        ],
      ),
    );
  }
}

/// One plain sentence about what is happening now.
String currentStepDetail(BuildContext context, DbState db, Enquiry e, {bool forCustomer = false}) {
  final t = context.t;
  final apt = db.nextAppointment(e.id);
  final project = db.projectFor(e.id);
  return switch (e.status.step) {
    JourneyStep.submitted || JourneyStep.verified =>
      forCustomer ? t.jdVerifyingCustomer : t.jdVerifying,
    JourneyStep.qualified || JourneyStep.vendor => t.jdVendor,
    JourneyStep.visit => apt != null
        ? t.jdVisitOn(Fmt.dateTime(context, apt.at))
        : (forCustomer ? t.jdVisitCustomer : t.jdVisit),
    JourneyStep.quotation => db.currentQuotations(e.id).any((q) => q.status.isWithCustomer)
        ? (forCustomer ? t.jdQuoteReadyCustomer : t.jdQuoteReady)
        : t.jdQuotePreparing,
    JourneyStep.won || JourneyStep.project => project == null
        ? t.jdWon
        : t.jdWork('${project.doneCount}', '${project.milestones.length}'),
    JourneyStep.payment => t.jdPayment,
    JourneyStep.commission => t.jdCommission,
  };
}

/// Muted section title used inside detail pages.
class DetailLabel extends StatelessWidget {
  const DetailLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: Space.xl, bottom: Space.sm),
        child: Semantics(
          header: true,
          child: Text(text,
              style: context.text.titleSmall?.copyWith(color: AppColors.textSecondary)),
        ),
      );
}

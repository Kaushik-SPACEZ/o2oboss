import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/l10n/l10n.dart';
import '../../core/l10n/labels.dart';
import '../../core/models/models.dart';

/// The referral's path from submission to payment. This is the app's one
/// signature element: the same journey appears, compact or full, everywhere
/// an enquiry is shown, so every role reads progress the same way.

enum StepMark { done, current, failed, upcoming }

class JourneyStepData {
  const JourneyStepData({
    required this.label,
    required this.mark,
    this.detail,
    this.action,
    this.onTap,
  });

  final String label;
  final StepMark mark;
  final String? detail;

  /// Optional button shown under the current step.
  final Widget? action;
  final VoidCallback? onTap;
}

/// Steps shown to referral partners and customers.
const simpleJourneySteps = [
  JourneyStep.submitted,
  JourneyStep.verified,
  JourneyStep.vendor,
  JourneyStep.visit,
  JourneyStep.quotation,
  JourneyStep.won,
  JourneyStep.project,
  JourneyStep.payment,
];

/// Marks each step of [steps] for an enquiry in [status].
List<StepMark> journeyMarks(EnquiryStatus status, List<JourneyStep> steps) {
  if (status == EnquiryStatus.commissionSettled) {
    return [for (final _ in steps) StepMark.done];
  }
  final currentFull = status.step.index;
  // The first listed step at or after the one being worked on is "current".
  final currentIndex = steps.indexWhere((s) => s.index >= currentFull);
  return [
    for (var i = 0; i < steps.length; i++)
      if (i == 0 || (currentIndex == -1) || i < currentIndex)
        StepMark.done
      else if (i == currentIndex)
        (status.isEnded ? StepMark.failed : StepMark.current)
      else
        StepMark.upcoming,
  ];
}

List<JourneyStepData> simpleJourney(AppLocalizations t, EnquiryStatus status) {
  final marks = journeyMarks(status, simpleJourneySteps);
  return [
    for (var i = 0; i < simpleJourneySteps.length; i++)
      JourneyStepData(
        label: marks[i] == StepMark.failed
            ? simpleStatusLabel(t, status)
            : journeyLabel(t, simpleJourneySteps[i]),
        mark: marks[i],
      ),
  ];
}

/// Thin segmented bar for cards: how far along the journey an enquiry is.
class JourneyBar extends StatelessWidget {
  const JourneyBar({super.key, required this.status});

  final EnquiryStatus status;

  @override
  Widget build(BuildContext context) {
    final marks = journeyMarks(status, simpleJourneySteps);
    final done = marks.where((m) => m == StepMark.done).length;
    return Semantics(
      label: '${journeyLabel(context.t, status.step)} $done / ${marks.length}',
      child: Row(
        children: [
          for (var i = 0; i < marks.length; i++) ...[
            if (i > 0) const SizedBox(width: 3),
            Expanded(
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: switch (marks[i]) {
                    StepMark.done => AppColors.primary,
                    StepMark.current => AppColors.blueLight,
                    StepMark.failed => AppColors.danger,
                    StepMark.upcoming => AppColors.track,
                  },
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Vertical journey with a node per step and a connecting line.
class JourneyRail extends StatelessWidget {
  const JourneyRail({super.key, required this.steps});

  final List<JourneyStepData> steps;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < steps.length; i++)
          _RailRow(step: steps[i], isFirst: i == 0, isLast: i == steps.length - 1,
              nextMark: i + 1 < steps.length ? steps[i + 1].mark : null),
      ],
    );
  }
}

class _RailRow extends StatelessWidget {
  const _RailRow({
    required this.step,
    required this.isFirst,
    required this.isLast,
    required this.nextMark,
  });

  final JourneyStepData step;
  final bool isFirst;
  final bool isLast;
  final StepMark? nextMark;

  @override
  Widget build(BuildContext context) {
    final lineDone = step.mark == StepMark.done &&
        (nextMark == StepMark.done || nextMark == StepMark.current || nextMark == StepMark.failed);
    final labelStyle = switch (step.mark) {
      StepMark.current => context.text.titleSmall?.copyWith(color: AppColors.primaryDark),
      StepMark.failed => context.text.titleSmall?.copyWith(color: AppColors.dangerText),
      StepMark.done => context.text.bodyLarge,
      StepMark.upcoming => context.text.bodyLarge?.copyWith(color: AppColors.textSecondary),
    };
    final content = Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : Space.lg, top: 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(step.label, style: labelStyle),
          if (step.detail != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(step.detail!, style: context.text.bodySmall),
            ),
          if (step.action != null)
            Padding(padding: const EdgeInsets.only(top: Space.sm), child: step.action!),
        ],
      ),
    );
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 28,
            child: Column(
              children: [
                _Node(mark: step.mark),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      color: lineDone ? AppColors.primary : AppColors.borderStrong,
                    ),
                  ),
              ],
            ),
          ),
          Space.gapMd,
          Expanded(
            child: step.onTap == null
                ? content
                : InkWell(onTap: step.onTap, borderRadius: Corners.smAll, child: content),
          ),
        ],
      ),
    );
  }
}

class _Node extends StatelessWidget {
  const _Node({required this.mark});

  final StepMark mark;

  @override
  Widget build(BuildContext context) {
    const size = 24.0;
    return switch (mark) {
      StepMark.done => Container(
          width: size,
          height: size,
          decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
          child: const Icon(Icons.check, size: 15, color: Colors.white),
        ),
      StepMark.current => Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 2.5),
          ),
          child: Center(
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
            ),
          ),
        ),
      StepMark.failed => Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(color: AppColors.danger, shape: BoxShape.circle),
          child: const Icon(Icons.close, size: 15, color: Colors.white),
        ),
      StepMark.upcoming => Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.borderStrong, width: 2),
          ),
        ),
    };
  }
}

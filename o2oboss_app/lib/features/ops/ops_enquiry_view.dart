import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/data/app_store.dart';
import '../../core/data/db_queries.dart';
import '../../core/data/permissions.dart';
import '../../core/l10n/l10n.dart';
import '../../core/l10n/labels.dart';
import '../../core/models/models.dart';
import '../../core/utils/format.dart';
import '../../shared/widgets/buttons.dart';
import '../../shared/widgets/feedback.dart';
import '../../shared/widgets/inputs.dart';
import '../../shared/widgets/journey.dart';
import '../../shared/widgets/layout.dart';
import '../../shared/widgets/rows.dart';
import '../../shared/widgets/sheets.dart';
import '../enquiry/enquiry_common.dart';
import 'ops_actions.dart';

/// The work view of an enquiry for back office, franchise and admin.
/// One "next step" card says what to do now; everything else sits behind
/// short rows that open their own page, so this screen never gets crowded.
class OpsEnquiryView extends ConsumerWidget {
  const OpsEnquiryView({super.key, required this.enquiry});

  final Enquiry enquiry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final me = ref.watch(currentUserProvider)!;
    final e = enquiry;
    final config = db.config;
    final canWork = can(me.role, Perm.verify, config);
    final status = e.status;
    final assignments = db.assignmentsFor(e.id)
        .where((a) => a.status != AssignmentStatus.withdrawn)
        .toList();
    final accepted = assignments.where((a) => a.status == AssignmentStatus.accepted).length;
    final pendingVendors = assignments.where((a) => a.status == AssignmentStatus.pending).length;
    final apts = db.appointmentsFor(e.id);
    final quotes = db.currentQuotations(e.id);
    final project = db.projectFor(e.id);
    final commissions = db.commissionsFor(e.id);
    final unread = db.threadsFor(e.id).fold<int>(0, (s, th) => s + db.unreadInThread(me.id, e.id, th));
    final reached = status.isEnded
        ? (db.quotationsFor(e.id).isNotEmpty ? JourneyStep.quotation : JourneyStep.vendor)
        : status.step;
    bool atLeast(JourneyStep s) => reached.index >= s.index;

    return PageScaffold(
      title: e.id,
      actions: [
        if (canWork || me.role == UserRole.admin) OpsMenu(enquiry: e),
      ],
      children: [
        EnquiryHeader(enquiry: e),
        Space.gapMd,
        _StageStrip(status: status),
        Space.gapMd,
        if (canWork || status.isEnded) NextStepCard(enquiry: e),
        NavGroup(title: t.opsSections, rows: [
          NavRow(
            icon: Icons.person_outline,
            title: t.opsPartDetails,
            subtitle: '${db.customerName(e.customerId)}, ${e.area}',
            onTap: () => context.push(Routes.enquiryPart(e.id, 'details')),
          ),
          NavRow(
            icon: Icons.call_outlined,
            title: t.opsPartCalls,
            subtitle: e.verification == null
                ? t.opsNotVerifiedYet
                : outcomeLabel(t, e.verification!.outcome),
            badge: 0,
            onTap: () => context.push(Routes.enquiryPart(e.id, 'calls')),
          ),
          if (atLeast(JourneyStep.qualified))
            NavRow(
              icon: Icons.fact_check_outlined,
              title: t.opsPartQualify,
              subtitle: status.isQualified || e.status.index > EnquiryStatus.qualified.index
                  ? t.opsAnswers(e.answers.length)
                  : t.opsNotQualifiedYet,
              onTap: () => context.push(Routes.enquiryPart(e.id, 'qualify')),
            ),
          if (atLeast(JourneyStep.vendor))
            NavRow(
              icon: Icons.storefront_outlined,
              title: t.opsPartVendors,
              subtitle: assignments.isEmpty
                  ? t.opsNoVendorsYet
                  : t.opsVendorsSummary('$accepted', '$pendingVendors'),
              onTap: () => context.push(Routes.enquiryPart(e.id, 'vendors')),
            ),
          NavRow(
            icon: Icons.chat_bubble_outline,
            title: t.navChat,
            subtitle: t.opsChatSubtitle,
            badge: unread,
            onTap: () => context.push(Routes.enquiryPart(e.id, 'chat')),
          ),
          if (atLeast(JourneyStep.visit) || apts.isNotEmpty)
            NavRow(
              icon: Icons.event_outlined,
              title: t.opsPartVisits,
              subtitle: apts.isEmpty
                  ? t.opsNoVisitsYet
                  : '${appointmentLabel(t, apts.first.status)}, ${Fmt.dateTime(context, apts.first.at)}',
              onTap: () => context.push(Routes.enquiryPart(e.id, 'visits')),
            ),
          if (atLeast(JourneyStep.quotation) || quotes.isNotEmpty)
            NavRow(
              icon: Icons.request_quote_outlined,
              title: t.navQuotations,
              subtitle: quotes.isEmpty
                  ? t.opsNoQuotesYet
                  : '${quotes.first.number} v${quotes.first.version}, ${quotationLabel(t, quotes.first.status)}',
              onTap: () => context.push(Routes.enquiryPart(e.id, 'quotations')),
            ),
          if (project != null)
            NavRow(
              icon: Icons.construction_outlined,
              title: t.opsPartProject,
              subtitle: '${projectStatusLabel(t, project.status)}, '
                  '${paymentStatusLabel(t, db.paymentStatusOf(project, DateTime.now()))}',
              onTap: () => context.push(Routes.project(project.id)),
            ),
          if (commissions.isNotEmpty)
            NavRow(
              icon: Icons.account_balance_wallet_outlined,
              title: t.opsPartCommission,
              subtitle: t.opsCommissionSummary(
                  Fmt.money(commissions.fold<double>(0, (s, c) => s + c.amount))),
              onTap: () => context.push(Routes.enquiryPart(e.id, 'commission')),
            ),
          NavRow(
            icon: Icons.history,
            title: t.opsPartActivity,
            subtitle: t.opsActivitySubtitle(Fmt.relative(context, e.updatedAt)),
            onTap: () => context.push(Routes.enquiryPart(e.id, 'activity')),
          ),
        ]),
      ],
    );
  }
}

/// Thin journey bar with the current stage written under it.
class _StageStrip extends StatelessWidget {
  const _StageStrip({required this.status});

  final EnquiryStatus status;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final marks = journeyMarks(status, simpleJourneySteps);
    final done = marks.where((m) => m == StepMark.done).length;
    return AppCard(
      padding: const EdgeInsets.fromLTRB(Space.lg, Space.md, Space.lg, Space.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(t.opsStageOf(journeyLabel(t, status.step), '$done', '${marks.length}'),
                    style: context.text.bodySmall),
              ),
            ],
          ),
          Space.gapSm,
          JourneyBar(status: status),
        ],
      ),
    );
  }
}

/// What to do now, with one button. The heart of the ops enquiry page.
class NextStepCard extends ConsumerWidget {
  const NextStepCard({super.key, required this.enquiry});

  final Enquiry enquiry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final me = ref.watch(currentUserProvider)!;
    final store = ref.read(dbProvider.notifier);
    final e = enquiry;
    final canWork = can(me.role, Perm.verify, db.config);
    VoidCallback part(String p) => () => context.push(Routes.enquiryPart(e.id, p));
    final apt = db.nextAppointment(e.id);
    final toReview = db.currentQuotations(e.id)
        .where((q) => q.status == QuotationStatus.submitted)
        .firstOrNull;
    final project = db.projectFor(e.id);
    final pendingAssign = db.activeAssignmentsFor(e.id)
        .where((a) => a.status == AssignmentStatus.pending)
        .firstOrNull;

    final (String title, String body, String? label, VoidCallback? onTap) = switch (e.status) {
      EnquiryStatus.newEnquiry || EnquiryStatus.verificationPending => (
          t.nextVerifyTitle,
          t.nextVerifyBody(db.customerName(e.customerId)),
          t.nextVerifyButton,
          part('verify'),
        ),
      EnquiryStatus.verified || EnquiryStatus.qualificationPending => (
          t.nextQualifyTitle,
          t.nextQualifyBody,
          t.nextQualifyButton,
          part('qualify'),
        ),
      EnquiryStatus.qualified || EnquiryStatus.vendorMatching => (
          t.nextAssignTitle,
          t.nextAssignBody,
          t.nextAssignButton,
          part('vendors'),
        ),
      EnquiryStatus.vendorAssigned => (
          t.nextWaitVendorTitle,
          pendingAssign == null
              ? t.nextWaitVendorBodyPlain
              : t.nextWaitVendorBody(
                  db.vendorName(pendingAssign.vendorId), Fmt.timeLeft(context, pendingAssign.deadline)),
          t.opsPartVendors,
          part('vendors'),
        ),
      EnquiryStatus.vendorAccepted || EnquiryStatus.customerContact => (
          t.nextVisitTitle,
          t.nextVisitBody,
          t.nextVisitButton,
          part('visits'),
        ),
      EnquiryStatus.appointmentScheduled => (
          t.nextVisitDoneTitle,
          apt == null ? t.nextVisitDoneBodyPlain : t.nextVisitDoneBody(Fmt.dateTime(context, apt.at)),
          t.opsPartVisits,
          part('visits'),
        ),
      EnquiryStatus.appointmentCompleted || EnquiryStatus.quotationPending => (
          t.nextWaitQuoteTitle,
          t.nextWaitQuoteBody,
          t.nextMessageVendor,
          part('chat'),
        ),
      EnquiryStatus.quotationSubmitted || EnquiryStatus.negotiation => toReview != null
          ? (
              t.nextReviewTitle,
              t.nextReviewBody(toReview.number, db.vendorName(toReview.vendorId)),
              t.nextReviewButton,
              () => context.push(Routes.quotation(toReview.id)),
            )
          : (
              t.nextCustomerDecidesTitle,
              t.nextCustomerDecidesBody,
              t.navQuotations,
              part('quotations'),
            ),
      EnquiryStatus.won => (
          t.nextProjectTitle,
          t.nextProjectBody,
          t.nextProjectButton,
          () => createProjectFlow(context, ref, e),
        ),
      EnquiryStatus.projectCreated || EnquiryStatus.projectInProgress => (
          t.nextWorkTitle,
          project == null ? '' : t.nextWorkBody('${project.doneCount}', '${project.milestones.length}'),
          t.opsPartProject,
          project == null ? null : () => context.push(Routes.project(project.id)),
        ),
      EnquiryStatus.projectCompleted || EnquiryStatus.paymentPending => (
          t.nextPaymentTitle,
          project == null
              ? ''
              : t.nextPaymentBody(Fmt.money(project.finalValue - db.paidFor(project.id))),
          t.nextPaymentButton,
          project == null ? null : () => context.push(Routes.project(project.id)),
        ),
      EnquiryStatus.paymentCollected || EnquiryStatus.commissionCalculated => (
          t.nextCommissionTitle,
          t.nextCommissionBody,
          t.opsPartCommission,
          part('commission'),
        ),
      EnquiryStatus.commissionSettled => (t.nextDoneTitle, t.nextDoneBody, null, null),
      EnquiryStatus.rejected || EnquiryStatus.lost => (
          simpleStatusLabel(t, e.status),
          reasonLabel(t, e.status == EnquiryStatus.rejected ? e.rejectReason : e.lossReason),
          can(me.role, Perm.reopenEnquiry, db.config) ? t.opsReopen : null,
          () async {
            final ok = await confirmAction(context,
                title: t.opsReopenTitle, body: t.opsReopenBody, confirmLabel: t.opsReopen);
            if (!ok) return;
            store.reopenEnquiry(e.id);
            if (context.mounted) showToast(context, t.opsReopened);
          },
        ),
    };
    final ended = e.status.isEnded;
    return Container(
      margin: const EdgeInsets.only(bottom: Space.xs),
      padding: const EdgeInsets.all(Space.lg),
      decoration: BoxDecoration(
        color: ended ? AppColors.dangerLight : AppColors.primaryLight,
        borderRadius: Corners.lgAll,
        border: Border.all(color: ended ? AppColors.dangerLight : AppColors.blueLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(ended ? t.opsClosed : t.opsNextStep,
              style: context.text.labelMedium?.copyWith(
                  color: ended ? AppColors.dangerText : AppColors.primaryDark,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(title, style: context.text.titleMedium),
          if (body.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(body, style: context.text.bodyMedium?.copyWith(color: AppColors.neutralText)),
          ],
          if (label != null && onTap != null && (canWork || ended)) ...[
            Space.gapMd,
            AppButton(label, onPressed: onTap),
          ],
        ],
      ),
    );
  }
}

/// Less frequent actions, kept out of the way in the app bar menu.
class OpsMenu extends ConsumerWidget {
  const OpsMenu({super.key, required this.enquiry});

  final Enquiry enquiry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final me = ref.watch(currentUserProvider)!;
    final db = ref.watch(dbProvider);
    final store = ref.read(dbProvider.notifier);
    final e = enquiry;
    final isAdmin = me.role == UserRole.admin;
    return PopupMenuButton<String>(
      tooltip: t.opsMoreActions,
      icon: const Icon(Icons.more_vert),
      onSelected: (v) async {
        switch (v) {
          case 'priority':
            final p = await pickOption<EnquiryPriority>(
              context,
              title: t.labelPriority,
              selected: e.priority,
              options: [
                for (final p in EnquiryPriority.values) SelectOption(p, priorityLabel(t, p)),
              ],
            );
            if (p != null) {
              store.setPriority(e.id, p);
              if (context.mounted) showToast(context, t.toastUpdated);
            }
          case 'note':
            final note = await askText(
              context,
              title: t.opsInternalNote,
              label: t.opsInternalNoteLabel,
              confirmLabel: t.actionSave,
              initial: e.internalNote,
              required: false,
              maxLines: 4,
            );
            if (note != null) {
              store.saveInternalNote(e.id, note);
              if (context.mounted) showToast(context, t.toastSaved);
            }
          case 'reassign':
            final bos = db.usersWithRole(UserRole.backOffice);
            final picked = await pickOption<String>(
              context,
              title: t.opsReassign,
              selected: e.backOfficeId,
              options: [for (final u in bos) SelectOption(u.id, u.name, subtitle: u.city)],
            );
            if (picked != null) {
              store.assignBackOffice(e.id, picked);
              if (context.mounted) showToast(context, t.opsReassigned(db.userName(picked)));
            }
          case 'lost':
            final reason = await askReason(
              context,
              title: t.opsMarkLost,
              subtitle: t.opsMarkLostBody,
              reasons: [t.lostReasonPrice, t.lostReasonOther, t.lostReasonDelay, t.lostReasonNoNeed],
              confirmLabel: t.opsMarkLost,
              destructive: true,
            );
            if (reason != null) {
              store.markLost(e.id, reason);
              if (context.mounted) showToast(context, t.opsMarkedLost, tone: Tone.warning);
            }
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem(value: 'priority', child: Text(t.opsChangePriority)),
        PopupMenuItem(value: 'note', child: Text(t.opsInternalNote)),
        if (isAdmin) PopupMenuItem(value: 'reassign', child: Text(t.opsReassign)),
        if (!e.status.isClosed && !e.status.isWon)
          PopupMenuItem(value: 'lost', child: Text(t.opsMarkLost)),
      ],
    );
  }
}

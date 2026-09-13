import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/data/app_store.dart';
import '../../core/data/db_queries.dart';
import '../../core/l10n/l10n.dart';
import '../../core/l10n/labels.dart';
import '../../core/models/models.dart';
import '../../core/utils/format.dart';
import '../../shared/widgets/buttons.dart';
import '../../shared/widgets/cards.dart';
import '../../shared/widgets/feedback.dart';
import '../../shared/widgets/inputs.dart';
import '../../shared/widgets/layout.dart';
import '../../shared/widgets/rows.dart';
import '../../shared/widgets/sheets.dart';
import '../common/system_screens.dart';
import '../enquiry/enquiry_common.dart';
import '../ops/lists.dart';
import '../quotation/quotation_card.dart';
import '../visits/visit_widgets.dart';

/// A referral as the vendor sees it: the job and area (never the customer's
/// number), what to do next, then visits, quotations, work and chat.
class VendorEnquiryView extends ConsumerWidget {
  const VendorEnquiryView({super.key, required this.enquiry});

  final Enquiry enquiry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final me = ref.watch(currentUserProvider)!;
    final e = enquiry;
    final vendorId = me.vendorId;
    final a = vendorId == null ? null : db.assignmentFor(e.id, vendorId);
    if (vendorId == null || a == null) return const NoAccessView();

    final pending = a.status == AssignmentStatus.pending;
    final accepted = a.status == AssignmentStatus.accepted;
    final quotes = db.currentQuotations(e.id, vendorId: vendorId);
    final visits = db.appointmentsFor(e.id).where((x) => x.vendorId == vendorId).toList();
    final project = db.projectFor(e.id);
    final myProject = project?.vendorId == vendorId ? project : null;
    final next = accepted ? _nextStep(context, ref, db, e, vendorId) : null;
    final canQuote = accepted && !e.status.isEnded && quotes.isEmpty;

    return PageScaffold(
      title: t.vnReferralTitle,
      bottomBar: pending
          ? StickyActions(
              note: t.vnReplyBy(Fmt.dateTime(context, a.deadline)),
              children: [
                AppButton.secondary(t.vnDecline, onPressed: () => _decline(context, ref, a)),
                AppButton(t.vnAccept, onPressed: () => _accept(context, ref, a)),
              ],
            )
          : null,
      children: [
        EnquiryHeader(
          enquiry: e,
          statusOverride: pending ? (t.vnStatusNew, Tone.warning) : null,
        ),
        Space.gapMd,
        if (pending)
          NoteCard(icon: Icons.lock_outline, text: t.vnPrivacyNote)
        else if (a.status == AssignmentStatus.rejected)
          NoteCard(
            tone: Tone.neutral,
            icon: Icons.do_not_disturb_on_outlined,
            title: t.vnDeclinedTitle,
            text: t.vnDeclinedBody(reasonLabel(t, a.rejectReason)),
          )
        else if (a.status == AssignmentStatus.expired)
          NoteCard(
            tone: Tone.neutral,
            icon: Icons.timer_off_outlined,
            title: t.vnExpiredTitle,
            text: t.vnExpiredBody,
          )
        else if (e.status.isEnded)
          NoteCard(
            tone: Tone.neutral,
            icon: Icons.info_outline,
            title: t.vnClosedTitle,
            text: t.vnClosedBody,
          )
        else if (next != null)
          _NextStepCard(step: next),
        DetailLabel(t.labelRequirement),
        AppCard(
          child: Column(
            children: [
              InfoRow(icon: Icons.category_outlined, label: t.labelProduct, value: db.enquiryTitle(e)),
              InfoRow(icon: Icons.notes, label: t.labelRequirement, value: e.requirement, maxLines: 8),
              InfoRow(icon: Icons.place_outlined, label: t.labelLocation, value: '${e.area}, ${e.city}'),
              InfoRow(
                icon: Icons.person_outline,
                label: t.labelCustomer,
                value: accepted
                    ? db.customerName(e.customerId).split(' ').first
                    : t.vnCustomerHidden,
              ),
            ],
          ),
        ),
        if (!pending && a.respondedAt != null && accepted) ...[
          DetailLabel(t.vnYourReply),
          AppCard(
            child: Column(
              children: [
                if (a.expectedPrice != null)
                  InfoRow(
                    icon: Icons.currency_rupee,
                    label: t.vnExpectedPrice,
                    value: Fmt.money(a.expectedPrice!),
                  ),
                if (a.expectedDays != null)
                  InfoRow(
                    icon: Icons.timer_outlined,
                    label: t.vnExpectedDays,
                    value: t.vendorsExpectedDays('${a.expectedDays}'),
                  ),
                InfoRow(
                  icon: Icons.schedule,
                  label: t.vnReplyStatus,
                  value: '${assignmentLabel(t, a.status)}, ${Fmt.date(context, a.respondedAt!)}',
                ),
              ],
            ),
          ),
        ],
        if (accepted) ...[
          SectionHeader(
            t.listVisits,
            top: Space.xl,
            action: !e.status.isEnded && visits.every((v) => !v.status.isOpen) ? t.vnProposeVisit : null,
            onAction: () => bookVisitFlow(context, ref, e, vendorId: vendorId),
          ),
          if (visits.isEmpty)
            _Empty(icon: Icons.event_outlined, text: t.vnNoVisits)
          else
            Gap(children: [for (final v in visits) VisitCard(appointment: v)]),
          SectionHeader(
            t.navQuotations,
            top: Space.xl,
            action: canQuote ? t.vnNewQuote : null,
            onAction: () => context.push(Routes.newQuotation(e.id, vendorId)),
          ),
          if (quotes.isEmpty)
            _Empty(icon: Icons.request_quote_outlined, text: t.vnNoQuotes)
          else
            Gap(children: [for (final q in quotes) QuotationCard(quotation: q)]),
          if (myProject != null) ...[
            DetailLabel(t.listProjects),
            ProjectCard(project: myProject),
          ],
          Space.gapXl,
          AppCard(
            padding: EdgeInsets.zero,
            child: NavRow(
              icon: Icons.chat_bubble_outline,
              title: t.vnChatWithO2O,
              subtitle: t.vnChatHelp,
              badge: db.unreadInThread(me.id, e.id, vendorId),
              onTap: () => context.push(Routes.chat(e.id, vendorId)),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _accept(BuildContext context, WidgetRef ref, VendorAssignment a) async {
    final t = context.t;
    final config = ref.read(dbProvider).config;
    final result = await showAppSheet<({double? price, int? days, String note})>(
      context,
      title: t.vnAcceptTitle,
      subtitle: config.vendorResponseAsksPrice || config.vendorResponseAsksTime
          ? t.vnAcceptSubtitle
          : null,
      builder: (_) => _AcceptForm(
        askPrice: config.vendorResponseAsksPrice,
        askDays: config.vendorResponseAsksTime,
      ),
    );
    if (result == null) return;
    await simulateWork();
    ref.read(dbProvider.notifier).respondToReferral(
          a.id,
          accept: true,
          expectedPrice: result.price,
          expectedDays: result.days,
          note: result.note,
        );
    if (context.mounted) showToast(context, t.vnAcceptedToast);
  }

  Future<void> _decline(BuildContext context, WidgetRef ref, VendorAssignment a) async {
    final t = context.t;
    final reason = await askReason(
      context,
      title: t.vnDeclineTitle,
      reasons: [t.vnDeclineBusy, t.vnDeclineArea, t.vnDeclineProduct, t.vnDeclineBudget],
      confirmLabel: t.vnDecline,
      destructive: true,
    );
    if (reason == null) return;
    await simulateWork();
    ref.read(dbProvider.notifier).respondToReferral(a.id, accept: false, reason: reason);
    if (context.mounted) showToast(context, t.vnDeclinedToast, tone: Tone.warning);
  }
}

typedef _Step = ({String title, String body, String? action, VoidCallback? onTap});

/// What the vendor should do now on an accepted referral.
_Step? _nextStep(BuildContext context, WidgetRef ref, DbState db, Enquiry e, String vendorId) {
  final t = context.t;
  if (e.status.isEnded) return null;
  final project = db.projectFor(e.id);
  if (project != null && project.vendorId == vendorId) {
    if (project.status == ProjectStatus.completed || project.status == ProjectStatus.cancelled) {
      return null;
    }
    return (
      title: t.vnNextWorkTitle,
      body: t.vnNextWorkBody,
      action: t.vnOpenProject,
      onTap: () => context.push(Routes.project(project.id)),
    );
  }
  final q = db.currentQuotations(e.id, vendorId: vendorId).firstOrNull;
  if (q != null) {
    return switch (q.status) {
      QuotationStatus.draft => (
          title: t.vnNextDraftTitle,
          body: t.vnNextDraftBody,
          action: t.vnOpenDraft,
          onTap: () => context.push(Routes.editQuotation(q.id)),
        ),
      QuotationStatus.submitted => (
          title: t.vnNextCheckTitle,
          body: t.vnNextCheckBody,
          action: null,
          onTap: null,
        ),
      QuotationStatus.revisionRequested => (
          title: t.vnNextChangesTitle,
          body: t.vnNextChangesBody,
          action: t.vnRevise,
          onTap: () => context.push(Routes.reviseQuotation(q.id)),
        ),
      QuotationStatus.sent || QuotationStatus.viewed => (
          title: t.vnNextCustomerTitle,
          body: t.vnNextCustomerBody,
          action: null,
          onTap: null,
        ),
      _ => null,
    };
  }
  final mine = db.appointmentsFor(e.id).where((a) => a.vendorId == vendorId).toList();
  final open = mine.where((a) => a.status.isOpen).firstOrNull;
  if (open != null) {
    return (
      title: t.vnNextVisitSetTitle,
      body: t.vnNextVisitSetBody(Fmt.dateTime(context, open.at), open.location),
      action: null,
      onTap: null,
    );
  }
  if (mine.any((a) => a.status == AppointmentStatus.completed) ||
      e.status == EnquiryStatus.quotationPending) {
    return (
      title: t.vnNextQuoteTitle,
      body: t.vnNextQuoteBody,
      action: t.vnNewQuote,
      onTap: () => context.push(Routes.newQuotation(e.id, vendorId)),
    );
  }
  return (
    title: t.vnNextVisitTitle,
    body: t.vnNextVisitBody,
    action: t.vnProposeVisit,
    onTap: () => bookVisitFlow(context, ref, e, vendorId: vendorId),
  );
}

class _NextStepCard extends StatelessWidget {
  const _NextStepCard({required this.step});

  final _Step step;

  @override
  Widget build(BuildContext context) {
    return SoftHeroCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.t.vnNextLabel,
              style: context.text.labelMedium?.copyWith(color: AppColors.primaryDark)),
          const SizedBox(height: 4),
          Text(step.title, style: context.text.titleLarge),
          const SizedBox(height: 4),
          Text(step.body, style: context.text.bodyMedium?.copyWith(color: AppColors.textSecondary)),
          if (step.action != null) ...[
            Space.gapLg,
            AppButton(step.action!, onPressed: step.onTap, expand: false),
          ],
        ],
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Icon(icon, color: AppColors.textMuted),
          Space.gapMd,
          Expanded(child: Text(text, style: context.text.bodyMedium?.copyWith(color: AppColors.textSecondary))),
        ],
      ),
    );
  }
}

class _AcceptForm extends StatefulWidget {
  const _AcceptForm({required this.askPrice, required this.askDays});

  final bool askPrice;
  final bool askDays;

  @override
  State<_AcceptForm> createState() => _AcceptFormState();
}

class _AcceptFormState extends State<_AcceptForm> {
  final _price = TextEditingController();
  final _days = TextEditingController();
  final _note = TextEditingController();
  final _form = GlobalKey<FormState>();

  @override
  void dispose() {
    _price.dispose();
    _days.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.askPrice) ...[
            AmountField(controller: _price, label: t.vnExpectedPrice),
            Space.gapLg,
          ],
          if (widget.askDays) ...[
            AppTextField(
              label: t.vnExpectedDays,
              controller: _days,
              required: true,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) => (int.tryParse(v ?? '') ?? 0) <= 0 ? t.validationRequired : null,
            ),
            Space.gapLg,
          ],
          AppTextField(label: t.vnNoteLabel, controller: _note, optional: true, maxLines: 3),
          Space.gapXl,
          AppButton(t.vnAccept, onPressed: () {
            if (!_form.currentState!.validate()) return;
            Navigator.pop(context, (
              price: double.tryParse(_price.text.replaceAll(RegExp(r'[^0-9.]'), '')),
              days: int.tryParse(_days.text),
              note: _note.text.trim(),
            ));
          }),
        ],
      ),
    );
  }
}

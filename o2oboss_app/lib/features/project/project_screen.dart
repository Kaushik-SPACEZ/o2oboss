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
import '../../shared/widgets/cards.dart';
import '../../shared/widgets/feedback.dart';
import '../../shared/widgets/inputs.dart';
import '../../shared/widgets/layout.dart';
import '../../shared/widgets/pills.dart';
import '../../shared/widgets/rows.dart';
import '../../shared/widgets/sheets.dart';
import '../../shared/widgets/tones.dart';
import '../common/system_screens.dart';

/// The work after an order is won: a checklist of steps, the payments
/// received, and — for the customer — a place to rate the work.
class ProjectScreen extends ConsumerWidget {
  const ProjectScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final me = ref.watch(currentUserProvider);
    final p = db.projectById(id);
    if (me == null) return const SizedBox.shrink();
    if (p == null) return const NotFoundScreen();
    final e = db.enquiryById(p.enquiryId);
    if (e == null || !db.canView(me, e) || me.role == UserRole.sales) return const NoAccessView();
    if (me.role == UserRole.vendor && p.vendorId != me.vendorId) return const NoAccessView();
    final config = db.config;
    final canUpdate = (can(me.role, Perm.manageProject, config) ||
            can(me.role, Perm.updateProject, config)) &&
        p.status != ProjectStatus.cancelled;
    final isOps = can(me.role, Perm.manageProject, config);

    return PageScaffold(
      title: p.id,
      actions: [
        if (isOps && p.status != ProjectStatus.completed && p.status != ProjectStatus.cancelled)
          _ProjectMenu(project: p),
      ],
      children: [
        _Summary(project: p, enquiry: e),
        if (p.status == ProjectStatus.onHold && (p.holdReason ?? '').isNotEmpty) ...[
          Space.gapMd,
          NoteCard(tone: Tone.warning, icon: Icons.pause_circle_outline, text: t.projectOnHoldNote(p.holdReason!)),
        ],
        SectionHeader(t.projectSteps),
        _Milestones(project: p, editable: canUpdate),
        if (config.paymentTrackingEnabled) ...[
          SectionHeader(t.projectPayments),
          _Payments(project: p, canRecord: can(me.role, Perm.recordPayment, config)),
        ],
        if (me.role == UserRole.customer && config.feedbackEnabled && p.status == ProjectStatus.completed) ...[
          SectionHeader(t.feedbackTitle),
          _Feedback(project: p),
        ],
        Space.gapXl,
        Center(
          child: TextButton(
            onPressed: () => context.push(Routes.enquiry(e.id)),
            child: Text(t.projectOpenEnquiry(e.id)),
          ),
        ),
      ],
    );
  }
}

class _Summary extends ConsumerWidget {
  const _Summary({required this.project, required this.enquiry});

  final Project project;
  final Enquiry enquiry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final me = ref.watch(currentUserProvider)!;
    final p = project;
    return AppCard(
      padding: const EdgeInsets.all(Space.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(db.enquiryTitle(enquiry), style: context.text.titleMedium)),
              StatusPill(projectStatusLabel(t, p.status), tone: projectTone(p.status)),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            me.role == UserRole.vendor
                ? '${enquiry.area}, ${enquiry.city}'
                : db.vendorName(p.vendorId),
            style: context.text.bodySmall,
          ),
          Space.gapLg,
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: Corners.pillAll,
                  child: LinearProgressIndicator(value: p.progress, minHeight: 10),
                ),
              ),
              Space.gapMd,
              Text('${(p.progress * 100).round()}%', style: context.text.titleSmall),
            ],
          ),
          Space.gapSm,
          Text(t.jdWork('${p.doneCount}', '${p.milestones.length}'), style: context.text.bodySmall),
          Space.gapLg,
          ValueLine(t.labelFinalValue, Fmt.money(p.finalValue), strong: true),
          ValueLine(t.projectStart, Fmt.date(context, p.startDate)),
          ValueLine(
            p.actualCompletion != null ? t.projectCompletedOn : t.projectExpectedEnd,
            Fmt.date(context, p.actualCompletion ?? p.expectedCompletion),
          ),
        ],
      ),
    );
  }
}

class _Milestones extends ConsumerWidget {
  const _Milestones({required this.project, required this.editable});

  final Project project;
  final bool editable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final store = ref.read(dbProvider.notifier);
    final p = project;
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < p.milestones.length; i++) ...[
            if (i > 0) const Divider(indent: 56),
            CheckboxListTile(
              value: p.milestones[i].done,
              controlAffinity: ListTileControlAffinity.leading,
              // Final payment is ticked automatically when paid in full.
              onChanged: !editable || p.milestones[i].key == MilestoneKey.finalPayment
                  ? null
                  : (v) async {
                      final m = p.milestones[i];
                      if (m.key == MilestoneKey.projectCompleted && v == true) {
                        final ok = await confirmAction(context,
                            title: t.projectCompleteTitle,
                            body: t.projectCompleteBody,
                            confirmLabel: t.projectCompleteConfirm);
                        if (!ok) return;
                      }
                      store.toggleMilestone(p.id, m.key, v ?? false);
                      if (context.mounted) showToast(context, t.toastUpdated);
                    },
              title: Text(milestoneLabel(t, p.milestones[i].key), style: context.text.bodyLarge),
              subtitle: p.milestones[i].doneAt == null
                  ? null
                  : Text(Fmt.date(context, p.milestones[i].doneAt!), style: context.text.bodySmall),
            ),
          ],
        ],
      ),
    );
  }
}

class _Payments extends ConsumerWidget {
  const _Payments({required this.project, required this.canRecord});

  final Project project;
  final bool canRecord;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final p = project;
    final paid = db.paidFor(p.id);
    final balance = (p.finalValue - paid).clamp(0, double.infinity).toDouble();
    final status = db.paymentStatusOf(p, DateTime.now());
    final list = db.paymentsFor(p.id);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(t.projectPaidOf(Fmt.money(paid), Fmt.money(p.finalValue)),
                    style: context.text.titleSmall),
              ),
              StatusPill(paymentStatusLabel(t, status), tone: paymentTone(status)),
            ],
          ),
          Space.gapSm,
          ClipRRect(
            borderRadius: Corners.pillAll,
            child: LinearProgressIndicator(
              value: p.finalValue <= 0 ? 0 : (paid / p.finalValue).clamp(0, 1),
              minHeight: 8,
              color: AppColors.success,
              backgroundColor: AppColors.track,
            ),
          ),
          if (balance > 0) ...[
            Space.gapSm,
            Text(
              p.paymentDueDate == null
                  ? t.projectBalance(Fmt.money(balance))
                  : t.projectBalanceDue(Fmt.money(balance), Fmt.date(context, p.paymentDueDate!)),
              style: context.text.bodySmall?.copyWith(
                  color: status == PaymentStatus.overdue ? AppColors.dangerText : null),
            ),
          ],
          if (list.isNotEmpty) ...[
            Space.gapMd,
            const Divider(),
            for (final r in list)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: Space.sm),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: AppColors.success, size: 20),
                    Space.gapMd,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${methodLabel(t, r.method)}, ${Fmt.date(context, r.at)}',
                              style: context.text.bodyMedium),
                          if (r.reference.isNotEmpty)
                            Text(r.reference, style: context.text.bodySmall),
                        ],
                      ),
                    ),
                    Text(Fmt.money(r.amount), style: AppType.money(context)),
                  ],
                ),
              ),
          ],
          if (canRecord && balance > 0) ...[
            Space.gapMd,
            AppButton(t.paymentRecord, icon: Icons.add, onPressed: () => recordPaymentFlow(context, ref, p, balance)),
          ],
          if (db.config.onlinePaymentEnabled && balance > 0 &&
              ref.read(currentUserProvider)?.role == UserRole.customer) ...[
            Space.gapMd,
            AppButton(t.paymentPayOnline, icon: Icons.payment,
                onPressed: () => showToast(context, t.demoActionNote)),
          ],
        ],
      ),
    );
  }
}

/// Records a payment against a project (back office or vendor).
Future<void> recordPaymentFlow(BuildContext context, WidgetRef ref, Project p, double balance) async {
  final t = context.t;
  final result = await showAppSheet<({double amount, PaymentMethod method, String reference, DateTime at})>(
    context,
    title: t.paymentRecord,
    builder: (_) => _PaymentForm(balance: balance),
  );
  if (result == null) return;
  await simulateWork();
  ref.read(dbProvider.notifier).recordPayment(
        p.id,
        amount: result.amount,
        method: result.method,
        reference: result.reference,
        at: result.at,
      );
  if (context.mounted) showToast(context, t.paymentRecorded(Fmt.money(result.amount)));
}

class _PaymentForm extends StatefulWidget {
  const _PaymentForm({required this.balance});

  final double balance;

  @override
  State<_PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends State<_PaymentForm> {
  final _form = GlobalKey<FormState>();
  late final _amount = TextEditingController(text: widget.balance.toStringAsFixed(0));
  final _reference = TextEditingController();
  PaymentMethod _method = PaymentMethod.upi;
  DateTime _at = DateTime.now();
  bool _proof = false;

  @override
  void dispose() {
    _amount.dispose();
    _reference.dispose();
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
          AmountField(
            controller: _amount,
            label: t.labelAmount,
            help: t.projectBalance(Fmt.money(widget.balance)),
          ),
          Space.gapLg,
          ChoiceChips<PaymentMethod>(
            label: t.paymentMethod,
            options: [for (final m in PaymentMethod.values) SelectOption(m, methodLabel(t, m))],
            selected: _method,
            onSelected: (v) => setState(() => _method = v),
          ),
          Space.gapLg,
          AppTextField(
            label: t.paymentReference,
            controller: _reference,
            optional: true,
            hint: t.paymentReferenceHint,
          ),
          Space.gapLg,
          DateTimeField(
            label: t.labelDate,
            value: _at,
            withTime: false,
            lastDate: DateTime.now(),
            onChanged: (v) => setState(() => _at = v),
          ),
          Space.gapLg,
          OutlinedButton.icon(
            onPressed: () => setState(() => _proof = true),
            icon: Icon(_proof ? Icons.check_circle : Icons.upload_file),
            label: Text(_proof ? t.paymentProofAdded : t.paymentAddProof),
          ),
          Space.gapXl,
          AppButton(t.actionSave, onPressed: () {
            if (!_form.currentState!.validate()) return;
            Navigator.pop(context, (
              amount: double.parse(_amount.text.trim()),
              method: _method,
              reference: _reference.text.trim(),
              at: _at,
            ));
          }),
        ],
      ),
    );
  }
}

class _ProjectMenu extends ConsumerWidget {
  const _ProjectMenu({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final store = ref.read(dbProvider.notifier);
    final p = project;
    return PopupMenuButton<String>(
      tooltip: t.opsMoreActions,
      onSelected: (v) async {
        if (v == 'hold') {
          final reason = await askText(context,
              title: t.projectHold, label: t.labelReason, confirmLabel: t.projectHold);
          if (reason == null) return;
          store.setProjectStatus(p.id, ProjectStatus.onHold, reason: reason);
        } else if (v == 'resume') {
          store.setProjectStatus(p.id, ProjectStatus.inProgress);
        } else if (v == 'cancel') {
          final reason = await askReason(
            context,
            title: t.projectCancel,
            subtitle: t.projectCancelBody,
            reasons: [t.projectCancelCustomer, t.projectCancelVendor],
            confirmLabel: t.projectCancel,
            destructive: true,
          );
          if (reason == null) return;
          store.setProjectStatus(p.id, ProjectStatus.cancelled, reason: reason);
        }
        if (context.mounted) showToast(context, t.toastUpdated);
      },
      itemBuilder: (_) => [
        if (p.status == ProjectStatus.onHold)
          PopupMenuItem(value: 'resume', child: Text(t.projectResume))
        else
          PopupMenuItem(value: 'hold', child: Text(t.projectHold)),
        PopupMenuItem(value: 'cancel', child: Text(t.projectCancel)),
      ],
    );
  }
}

class _Feedback extends ConsumerStatefulWidget {
  const _Feedback({required this.project});

  final Project project;

  @override
  ConsumerState<_Feedback> createState() => _FeedbackState();
}

class _FeedbackState extends ConsumerState<_Feedback> {
  int _rating = 0;
  final _review = TextEditingController();

  @override
  void dispose() {
    _review.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final scale = db.config.feedbackScale;
    final given = db.feedback.where((f) => f.enquiryId == widget.project.enquiryId).firstOrNull;
    if (given != null) {
      return AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Stars(value: given.rating, max: scale),
            if (given.review.isNotEmpty) ...[Space.gapSm, Text(given.review)],
            Space.gapSm,
            Text(t.feedbackThanks, style: context.text.bodySmall),
          ],
        ),
      );
    }
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(t.feedbackAsk(db.vendorName(widget.project.vendorId)), style: context.text.bodyMedium),
          Space.gapMd,
          _Stars(value: _rating, max: scale, onChanged: (v) => setState(() => _rating = v)),
          Space.gapMd,
          AppTextField(label: t.feedbackReview, controller: _review, optional: true, maxLines: 3),
          Space.gapLg,
          AppButton(t.feedbackSend, onPressed: _rating == 0
              ? null
              : () {
                  ref.read(dbProvider.notifier)
                      .submitFeedback(widget.project.enquiryId, _rating, _review.text.trim());
                  showToast(context, t.feedbackThanks);
                }),
        ],
      ),
    );
  }
}

class _Stars extends StatelessWidget {
  const _Stars({required this.value, required this.max, this.onChanged});

  final int value;
  final int max;
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$value / $max',
      child: Row(
        children: [
          for (var i = 1; i <= max; i++)
            IconButton(
              visualDensity: VisualDensity.compact,
              tooltip: '$i / $max',
              onPressed: onChanged == null ? null : () => onChanged!(i),
              icon: Icon(i <= value ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: i <= value ? AppColors.warning : AppColors.textMuted, size: 32),
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
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
import '../../shared/widgets/feedback.dart';
import '../../shared/widgets/inputs.dart';
import '../../shared/widgets/layout.dart';
import '../../shared/widgets/pills.dart';
import '../../shared/widgets/sheets.dart';

/// Calls and checks back office promised to make, grouped by when.
class FollowUpsScreen extends ConsumerStatefulWidget {
  const FollowUpsScreen({super.key});

  @override
  ConsumerState<FollowUpsScreen> createState() => _FollowUpsScreenState();
}

class _FollowUpsScreenState extends ConsumerState<FollowUpsScreen> {
  String _tab = 'today';

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final me = ref.watch(currentUserProvider);
    final db = ref.watch(dbProvider);
    if (me == null) return const SizedBox.shrink();
    final now = DateTime.now();
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final all = db.followUpsOf(me.id);
    final open = all.where((f) => !f.done).toList();
    final overdue = open.where((f) => f.dueAt.isBefore(now)).toList();
    final today = open.where((f) => !f.dueAt.isBefore(now) && !f.dueAt.isAfter(endOfDay)).toList();
    final later = open.where((f) => f.dueAt.isAfter(endOfDay)).toList();
    final done = all.where((f) => f.done).toList()
      ..sort((a, b) => (b.doneAt ?? b.dueAt).compareTo(a.doneAt ?? a.dueAt));
    final shown = switch (_tab) {
      'overdue' => overdue,
      'later' => later,
      'done' => done.take(30).toList(),
      _ => [...overdue, ...today],
    };

    return PageScaffold(
      title: t.navFollowUps,
      fab: AddFab(label: t.fuAdd, onPressed: () => addFollowUpFlow(context, ref)),
      body: ListView(
        padding: EdgeInsets.fromLTRB(0, Space.sm, 0, 120),
        children: [
          FilterChipsRow<String>(
            items: [
              ('today', t.fuTabToday, overdue.length + today.length),
              ('overdue', t.overdue, overdue.length),
              ('later', t.upcoming, later.length),
              ('done', t.completed, null),
            ],
            selected: _tab,
            onSelected: (v) => setState(() => _tab = v),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Space.page(context)),
            child: shown.isEmpty
                ? EmptyState(
                    icon: Icons.event_available_outlined,
                    title: _tab == 'done' ? t.emptyTitle : t.fuEmptyTitle,
                    body: _tab == 'done' ? null : t.fuEmptyBody,
                  )
                : Gap(children: [for (final f in shown) FollowUpCard(followUp: f)]),
          ),
        ],
      ),
    );
  }
}

class FollowUpCard extends ConsumerWidget {
  const FollowUpCard({super.key, required this.followUp});

  final FollowUp followUp;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final store = ref.read(dbProvider.notifier);
    final f = followUp;
    final e = db.enquiryById(f.enquiryId);
    final late = !f.done && f.dueAt.isBefore(DateTime.now());
    final icon = switch (f.type) {
      FollowUpType.customerCall => Icons.phone_outlined,
      FollowUpType.vendorCall => Icons.storefront_outlined,
      FollowUpType.appointment => Icons.event_outlined,
      FollowUpType.quotation => Icons.request_quote_outlined,
      FollowUpType.project => Icons.construction_outlined,
      FollowUpType.payment => Icons.currency_rupee,
    };
    return AppCard(
      onTap: e == null ? null : () => context.push(Routes.enquiry(e.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconTile(icon, tone: late ? Tone.danger : Tone.info, size: 38),
              Space.gapMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(followUpLabel(t, f.type), style: context.text.titleSmall),
                    if (e != null)
                      Text('${e.id}, ${db.customerName(e.customerId)}',
                          style: context.text.bodySmall),
                    if (f.notes.isNotEmpty) Text(f.notes, style: context.text.bodySmall),
                    if (f.done && (f.outcome ?? '').isNotEmpty)
                      Text(t.fuOutcome(f.outcome!), style: context.text.bodySmall),
                    const SizedBox(height: 2),
                    Text(
                      f.done
                          ? t.fuDoneOn(Fmt.dateTime(context, f.doneAt ?? f.dueAt))
                          : Fmt.dateTime(context, f.dueAt),
                      style: context.text.labelSmall?.copyWith(
                          color: late ? AppColors.dangerText : null,
                          fontWeight: late ? FontWeight.w700 : null),
                    ),
                  ],
                ),
              ),
              if (late) StatusPill(t.overdue, tone: Tone.danger),
            ],
          ),
          if (!f.done) ...[
            Space.gapMd,
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final at = await pickDateTime(context, initial: f.dueAt, first: DateTime.now());
                      if (at == null) return;
                      store.rescheduleFollowUp(f.id, at);
                      if (context.mounted) showToast(context, t.fuRescheduled);
                    },
                    child: Text(t.actionReschedule),
                  ),
                ),
                Space.gapSm,
                Expanded(
                  child: FilledButton(
                    onPressed: () => completeFollowUpFlow(context, ref, f),
                    child: Text(t.actionMarkDone),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Closes a follow-up, optionally scheduling the next one.
Future<void> completeFollowUpFlow(BuildContext context, WidgetRef ref, FollowUp f) async {
  final t = context.t;
  final result = await showAppSheet<({String outcome, DateTime? next})>(
    context,
    title: t.fuCompleteTitle,
    builder: (_) => const _CompleteForm(),
  );
  if (result == null) return;
  ref.read(dbProvider.notifier).completeFollowUp(f.id, outcome: result.outcome, nextAt: result.next);
  if (context.mounted) showToast(context, result.next == null ? t.fuDone : t.fuDoneNext);
}

class _CompleteForm extends StatefulWidget {
  const _CompleteForm();

  @override
  State<_CompleteForm> createState() => _CompleteFormState();
}

class _CompleteFormState extends State<_CompleteForm> {
  final _outcome = TextEditingController();
  bool _again = false;
  DateTime? _next;

  @override
  void dispose() {
    _outcome.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(label: t.fuWhatHappened, controller: _outcome, maxLines: 3, optional: true),
        Space.gapMd,
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: _again,
          onChanged: (v) => setState(() => _again = v),
          title: Text(t.fuScheduleNext),
        ),
        if (_again)
          DateTimeField(
            label: t.fuNextWhen,
            value: _next,
            firstDate: DateTime.now(),
            onChanged: (v) => setState(() => _next = v),
          ),
        Space.gapLg,
        AppButton(t.actionMarkDone, onPressed: () {
          Navigator.pop(context, (outcome: _outcome.text.trim(), next: _again ? _next : null));
        }),
      ],
    );
  }
}

/// Adds a follow-up for one of the person's enquiries.
Future<void> addFollowUpFlow(BuildContext context, WidgetRef ref, {String? enquiryId}) async {
  final t = context.t;
  final db = ref.read(dbProvider);
  final me = ref.read(currentUserProvider)!;
  final enquiries = db.enquiriesFor(me).where((e) => !e.status.isClosed).toList();
  final result = await showAppSheet<({String? enquiry, FollowUpType type, DateTime at, String notes})>(
    context,
    title: t.fuAdd,
    builder: (_) => _AddForm(
      enquiries: {for (final e in enquiries) e.id: '${e.id}, ${db.customerName(e.customerId)}'},
      initial: enquiryId,
    ),
  );
  if (result == null) return;
  ref.read(dbProvider.notifier).addFollowUp(
      enquiryId: result.enquiry, type: result.type, dueAt: result.at, notes: result.notes);
  if (context.mounted) showToast(context, t.fuAdded);
}

class _AddForm extends StatefulWidget {
  const _AddForm({required this.enquiries, this.initial});

  final Map<String, String> enquiries;
  final String? initial;

  @override
  State<_AddForm> createState() => _AddFormState();
}

class _AddFormState extends State<_AddForm> {
  late String? _enquiry = widget.initial;
  FollowUpType _type = FollowUpType.customerCall;
  DateTime? _at;
  final _notes = TextEditingController();
  bool _error = false;

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SelectField<String>(
          label: t.labelEnquiryId,
          optional: true,
          value: _enquiry,
          options: [for (final e in widget.enquiries.entries) SelectOption(e.key, e.value)],
          onChanged: (v) => setState(() => _enquiry = v),
        ),
        Space.gapLg,
        ChoiceChips<FollowUpType>(
          label: t.fuType,
          options: [for (final f in FollowUpType.values) SelectOption(f, followUpLabel(t, f))],
          selected: _type,
          onSelected: (v) => setState(() => _type = v),
        ),
        Space.gapLg,
        DateTimeField(
          label: t.fuNextWhen,
          value: _at,
          required: true,
          firstDate: DateTime.now(),
          onChanged: (v) => setState(() => _at = v),
        ),
        if (_error && _at == null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(t.validationRequired,
                style: context.text.bodySmall?.copyWith(color: AppColors.dangerText)),
          ),
        Space.gapLg,
        AppTextField(label: t.labelNotes, controller: _notes, optional: true, maxLines: 2),
        Space.gapLg,
        AppButton(t.actionAdd, onPressed: () {
          if (_at == null) {
            setState(() => _error = true);
            return;
          }
          Navigator.pop(context, (enquiry: _enquiry, type: _type, at: _at!, notes: _notes.text.trim()));
        }),
      ],
    );
  }
}

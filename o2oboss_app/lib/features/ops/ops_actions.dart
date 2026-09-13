import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/routes.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/data/app_store.dart';
import '../../core/data/db_queries.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/utils/format.dart';
import '../../shared/widgets/buttons.dart';
import '../../shared/widgets/cards.dart';
import '../../shared/widgets/feedback.dart';
import '../../shared/widgets/inputs.dart';
import '../../shared/widgets/rows.dart';
import '../../shared/widgets/sheets.dart';

/// Simulated phone call through the O2O Boss number. Returns the call
/// length in seconds, or null if it never connected.
Future<int?> simulateCall(BuildContext context, {required String name, required String phone}) {
  return showModalBottomSheet<int>(
    context: context,
    isDismissible: false,
    enableDrag: false,
    useSafeArea: true,
    builder: (_) => _CallSheet(name: name, phone: phone),
  );
}

class _CallSheet extends ConsumerStatefulWidget {
  const _CallSheet({required this.name, required this.phone});

  final String name;
  final String phone;

  @override
  ConsumerState<_CallSheet> createState() => _CallSheetState();
}

class _CallSheetState extends ConsumerState<_CallSheet> {
  int _secs = 0;
  bool _connected = false;
  late final Stream<int> _ticks =
      Stream.periodic(const Duration(seconds: 1), (i) => i + 1);

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final recording = ref.watch(configProvider.select((c) => c.callRecordingEnabled));
    return StreamBuilder<int>(
      stream: _ticks,
      builder: (context, snap) {
        final tick = snap.data ?? 0;
        _connected = tick >= 2;
        _secs = _connected ? tick - 2 : 0;
        return Padding(
          padding: const EdgeInsets.fromLTRB(Space.xl, Space.xl, Space.xl, Space.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InitialsAvatarLarge(name: widget.name),
              Space.gapLg,
              Text(widget.name, style: Theme.of(context).textTheme.titleLarge),
              Text(widget.phone, style: Theme.of(context).textTheme.bodySmall),
              Space.gapMd,
              Text(_connected ? Fmt.duration(_secs) : t.callConnecting,
                  style: Theme.of(context).textTheme.titleMedium),
              if (recording) ...[
                Space.gapSm,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.fiber_manual_record, size: 14, color: Colors.red),
                    const SizedBox(width: 6),
                    Text(t.callRecorded, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ],
              Space.gapXl,
              AppButton.danger(
                t.callEnd,
                icon: Icons.call_end,
                onPressed: () => Navigator.pop(context, _connected ? _secs.clamp(1, 99999) : null),
              ),
              Space.gapSm,
              Text(t.demoActionNote, style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
        );
      },
    );
  }
}

/// Large initials circle for call screens.
class InitialsAvatarLarge extends StatelessWidget {
  const InitialsAvatarLarge({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final parts = name.trim().split(RegExp(r'\s+'));
    final initials = parts.isEmpty || parts.first.isEmpty
        ? '?'
        : (parts.first[0] + (parts.length > 1 ? parts.last[0] : '')).toUpperCase();
    return Container(
      width: 80,
      height: 80,
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: Color(0xFFDBEAFE), shape: BoxShape.circle),
      child: Text(initials,
          style: const TextStyle(
              fontSize: 28, fontWeight: FontWeight.w700, color: Color(0xFF1D4ED8))),
    );
  }
}

/// Logs a call made outside the app (e.g. from a personal phone).
Future<void> logCallFlow(BuildContext context, WidgetRef ref, Enquiry e) async {
  final t = context.t;
  final db = ref.read(dbProvider);
  final targets = <SelectOption<(UserRole, String)>>[
    SelectOption((UserRole.customer, db.customerName(e.customerId)),
        '${db.customerName(e.customerId)}, ${t.roleCustomer}'),
    for (final a in db.activeAssignmentsFor(e.id))
      SelectOption((UserRole.vendor, db.vendorName(a.vendorId)),
          '${db.vendorName(a.vendorId)}, ${t.roleVendor}'),
  ];
  final result = await showAppSheet<({(UserRole, String) to, int minutes, String notes})>(
    context,
    title: t.callLogTitle,
    builder: (_) => _LogCallForm(targets: targets),
  );
  if (result == null) return;
  ref.read(dbProvider.notifier).logCall(e.id, result.to.$1, result.to.$2,
      durationSec: result.minutes * 60, notes: result.notes);
  if (context.mounted) showToast(context, t.callLogged);
}

class _LogCallForm extends StatefulWidget {
  const _LogCallForm({required this.targets});

  final List<SelectOption<(UserRole, String)>> targets;

  @override
  State<_LogCallForm> createState() => _LogCallFormState();
}

class _LogCallFormState extends State<_LogCallForm> {
  late (UserRole, String) _to = widget.targets.first.value;
  int _minutes = 2;
  final _notes = TextEditingController();

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
        SelectField<(UserRole, String)>(
          label: t.callWith,
          value: _to,
          options: widget.targets,
          onChanged: (v) => setState(() => _to = v),
        ),
        Space.gapLg,
        ChoiceChips<int>(
          label: t.callLength,
          options: [
            for (final m in [1, 2, 5, 10, 15]) SelectOption(m, t.callMinutes(m)),
          ],
          selected: _minutes,
          onSelected: (v) => setState(() => _minutes = v),
        ),
        Space.gapLg,
        AppTextField(label: t.labelNotes, controller: _notes, maxLines: 3, optional: true),
        Space.gapLg,
        AppButton(t.actionSave,
            onPressed: () =>
                Navigator.pop(context, (to: _to, minutes: _minutes, notes: _notes.text.trim()))),
      ],
    );
  }
}

/// Creates the project for a won enquiry after asking for the key dates.
Future<void> createProjectFlow(BuildContext context, WidgetRef ref, Enquiry e) async {
  final t = context.t;
  final db = ref.read(dbProvider);
  final q = db.acceptedQuotation(e.id);
  final now = DateTime.now();
  final result = await showAppSheet<({DateTime start, DateTime end, DateTime due})>(
    context,
    title: t.projectCreateTitle,
    subtitle: t.projectCreateSubtitle,
    builder: (_) => _ProjectDates(
      value: q?.total ?? e.finalValue ?? e.potentialValue ?? 0,
      vendor: db.vendorName(q?.vendorId),
      start: now,
      end: now.add(Duration(days: q?.timelineDays ?? 7)),
    ),
  );
  if (result == null || !context.mounted) return;
  await simulateWork();
  final id = ref.read(dbProvider.notifier).createProject(
        e.id,
        startDate: result.start,
        expectedCompletion: result.end,
        paymentDueDate: result.due,
      );
  if (!context.mounted) return;
  showToast(context, t.projectCreated(id));
  context.push(Routes.project(id));
}

class _ProjectDates extends StatefulWidget {
  const _ProjectDates({
    required this.value,
    required this.vendor,
    required this.start,
    required this.end,
  });

  final double value;
  final String vendor;
  final DateTime start;
  final DateTime end;

  @override
  State<_ProjectDates> createState() => _ProjectDatesState();
}

class _ProjectDatesState extends State<_ProjectDates> {
  late DateTime _start = widget.start;
  late DateTime _end = widget.end;
  late DateTime _due = widget.end.add(const Duration(days: 3));

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ValueLine(t.labelVendor, widget.vendor),
        ValueLine(t.labelFinalValue, Fmt.money(widget.value), strong: true),
        Space.gapLg,
        DateTimeField(
          label: t.projectStart,
          value: _start,
          withTime: false,
          onChanged: (v) => setState(() => _start = v),
        ),
        Space.gapLg,
        DateTimeField(
          label: t.projectExpectedEnd,
          value: _end,
          withTime: false,
          onChanged: (v) => setState(() => _end = v),
        ),
        Space.gapLg,
        DateTimeField(
          label: t.projectPaymentDue,
          value: _due,
          withTime: false,
          onChanged: (v) => setState(() => _due = v),
        ),
        Space.gapLg,
        NoteCard(text: t.projectCreateNote),
        Space.gapLg,
        AppButton(
          t.nextProjectButton,
          onPressed: () => Navigator.pop(context, (start: _start, end: _end, due: _due)),
        ),
      ],
    );
  }
}

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
import '../../shared/widgets/tones.dart';

/// Books (back office) or proposes (vendor) a site visit.
Future<void> bookVisitFlow(BuildContext context, WidgetRef ref, Enquiry e,
    {String? vendorId}) async {
  final t = context.t;
  final db = ref.read(dbProvider);
  final me = ref.read(currentUserProvider)!;
  final byVendor = me.role == UserRole.vendor;
  final vendors = vendorId != null
      ? [vendorId]
      : db.activeAssignmentsFor(e.id)
          .where((a) => a.status == AssignmentStatus.accepted)
          .map((a) => a.vendorId)
          .toList();
  if (vendors.isEmpty) {
    showToast(context, t.visitNeedVendor, tone: Tone.warning);
    return;
  }
  final address = [if ((e.address ?? '').isNotEmpty) e.address!, e.area, e.city].join(', ');
  final result = await showAppSheet<({String vendor, DateTime at, String location, String purpose})>(
    context,
    title: byVendor ? t.visitProposeTitle : t.visitBookTitle,
    subtitle: byVendor ? t.visitProposeSubtitle : null,
    builder: (_) => _VisitForm(
      vendors: {for (final v in vendors) v: db.vendorName(v)},
      location: byVendor ? '${e.area}, ${e.city}' : address,
    ),
  );
  if (result == null) return;
  await simulateWork();
  ref.read(dbProvider.notifier).proposeAppointment(
        enquiryId: e.id,
        vendorId: result.vendor,
        at: result.at,
        location: result.location,
        purpose: result.purpose,
      );
  if (context.mounted) showToast(context, byVendor ? t.visitProposed : t.visitBooked);
}

class _VisitForm extends StatefulWidget {
  const _VisitForm({required this.vendors, required this.location});

  final Map<String, String> vendors;
  final String location;

  @override
  State<_VisitForm> createState() => _VisitFormState();
}

class _VisitFormState extends State<_VisitForm> {
  late String _vendor = widget.vendors.keys.first;
  DateTime? _at;
  late final _location = TextEditingController(text: widget.location);
  final _purpose = TextEditingController();
  final _form = GlobalKey<FormState>();

  @override
  void dispose() {
    _location.dispose();
    _purpose.dispose();
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
          if (widget.vendors.length > 1) ...[
            SelectField<String>(
              label: t.labelVendor,
              value: _vendor,
              options: [for (final v in widget.vendors.entries) SelectOption(v.key, v.value)],
              onChanged: (v) => setState(() => _vendor = v),
            ),
            Space.gapLg,
          ],
          DateTimeField(
            label: t.visitWhen,
            value: _at,
            required: true,
            firstDate: DateTime.now(),
            onChanged: (v) => setState(() => _at = v),
          ),
          Space.gapLg,
          AppTextField(
            label: t.labelLocation,
            controller: _location,
            required: true,
            validator: (v) => (v ?? '').trim().isEmpty ? t.validationRequired : null,
          ),
          Space.gapLg,
          AppTextField(
            label: t.visitPurpose,
            controller: _purpose,
            optional: true,
            hint: t.visitPurposeHint,
          ),
          Space.gapXl,
          AppButton(t.actionConfirm, onPressed: () {
            if (!_form.currentState!.validate()) return;
            Navigator.pop(context, (
              vendor: _vendor,
              at: _at!,
              location: _location.text.trim(),
              purpose: _purpose.text.trim(),
            ));
          }),
        ],
      ),
    );
  }
}

/// One visit with the actions the viewer may take on it.
class VisitCard extends ConsumerWidget {
  const VisitCard({super.key, required this.appointment, this.showEnquiry = false});

  final Appointment appointment;
  final bool showEnquiry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final me = ref.watch(currentUserProvider)!;
    final store = ref.read(dbProvider.notifier);
    final a = appointment;
    final e = db.enquiryById(a.enquiryId);
    final ops = me.role == UserRole.backOffice || me.role == UserRole.admin;
    final isVendor = me.role == UserRole.vendor;
    final isCustomer = me.role == UserRole.customer;
    final past = a.at.isBefore(DateTime.now());

    Future<void> reschedule() async {
      final at = await pickDateTime(context, initial: a.at, first: DateTime.now());
      if (at == null) return;
      store.rescheduleAppointment(a.id, at);
      if (context.mounted) showToast(context, t.visitRescheduled);
    }

    Future<void> cancel() async {
      final reason = await askReason(
        context,
        title: t.visitCancelTitle,
        reasons: [t.visitCancelCustomer, t.visitCancelVendor, t.visitCancelWeather],
        confirmLabel: t.visitCancel,
        destructive: true,
      );
      if (reason == null) return;
      store.cancelAppointment(a.id, reason);
      if (context.mounted) showToast(context, t.visitCancelled, tone: Tone.warning);
    }

    final actions = <Widget>[
      if (ops && a.status == AppointmentStatus.pendingConfirmation)
        FilledButton(
          onPressed: () {
            store.confirmAppointment(a.id);
            showToast(context, t.visitConfirmed);
          },
          child: Text(t.visitConfirm),
        ),
      if ((ops || isVendor) && a.status.isOpen && (past || a.status == AppointmentStatus.confirmed))
        FilledButton.tonal(
          onPressed: () async {
            final ok = await confirmAction(context,
                title: t.visitDoneTitle, body: t.visitDoneBody, confirmLabel: t.visitMarkDone);
            if (!ok) return;
            store.completeAppointment(a.id);
            if (context.mounted) showToast(context, t.visitDone);
          },
          child: Text(t.visitMarkDone),
        ),
      if ((ops || isVendor) && a.status.isOpen)
        TextButton(onPressed: reschedule, child: Text(t.actionReschedule)),
      if (ops && a.status.isOpen)
        TextButton(onPressed: cancel, child: Text(t.visitCancel)),
      if (ops && a.status.isOpen && past)
        TextButton(
          onPressed: () {
            store.markNoShow(a.id);
            showToast(context, t.visitNoShowSaved, tone: Tone.warning);
          },
          child: Text(t.visitNoShow),
        ),
      if (isCustomer && a.status == AppointmentStatus.completed && !a.customerConfirmed)
        FilledButton(
          onPressed: () {
            store.customerConfirmVisit(a.id);
            showToast(context, t.visitThanks);
          },
          child: Text(t.visitCustomerConfirm),
        ),
    ];

    return AppCard(
      onTap: showEnquiry && e != null ? () => context.push(Routes.enquiry(e.id)) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DateBadge(date: a.at),
              Space.gapMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Fmt.time(context, a.at), style: context.text.titleSmall),
                    Text(
                      showEnquiry && e != null
                          ? '${db.enquiryTitle(e)}, ${e.id}'
                          : (isVendor ? a.location : db.vendorName(a.vendorId)),
                      style: context.text.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (!isVendor || showEnquiry)
                      Text(a.location, style: context.text.bodySmall, maxLines: 2),
                    if (a.purpose.isNotEmpty) Text(a.purpose, style: context.text.bodySmall),
                    if (a.status == AppointmentStatus.cancelled && a.notes.isNotEmpty)
                      Text(t.visitCancelReason(a.notes), style: context.text.bodySmall),
                    if (a.customerConfirmed)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: StatusPill(t.visitCustomerConfirmed,
                            tone: Tone.success, icon: Icons.verified_outlined),
                      ),
                  ],
                ),
              ),
              Space.gapSm,
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 130),
                child: StatusPill(appointmentLabel(t, a.status), tone: appointmentTone(a.status)),
              ),
            ],
          ),
          if (actions.isNotEmpty) ...[
            Space.gapMd,
            Wrap(spacing: Space.sm, runSpacing: Space.sm, children: actions),
          ],
        ],
      ),
    );
  }
}

class _DateBadge extends StatelessWidget {
  const _DateBadge({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: const BoxDecoration(
        color: Color(0xFFEFF6FF),
        borderRadius: Corners.mdAll,
      ),
      child: Column(
        children: [
          Text(Fmt.weekday(context, date),
              style: context.text.labelSmall?.copyWith(color: const Color(0xFF1D4ED8))),
          Text('${date.day}',
              style: context.text.titleLarge?.copyWith(
                  color: const Color(0xFF1D4ED8), fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

/// All visits of one enquiry, with booking for back office.
class VisitsList extends ConsumerWidget {
  const VisitsList({super.key, required this.enquiry});

  final Enquiry enquiry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final apts = db.appointmentsFor(enquiry.id);
    if (apts.isEmpty) {
      return AppCard(
        child: EmptyState(compact: true, icon: Icons.event_outlined, title: t.opsNoVisitsYet),
      );
    }
    return Gap(children: [for (final a in apts) VisitCard(appointment: a)]);
  }
}

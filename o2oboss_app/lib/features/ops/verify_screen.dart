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
import '../../shared/widgets/cards.dart';
import '../../shared/widgets/feedback.dart';
import '../../shared/widgets/inputs.dart';
import '../../shared/widgets/layout.dart';
import 'ops_actions.dart';

/// Step 1 of back-office work: call the customer and record what happened.
/// Genuine moves on to qualification; call-back schedules a follow-up;
/// anything else closes the enquiry with that reason.
class VerifyScreen extends ConsumerStatefulWidget {
  const VerifyScreen({super.key, required this.enquiry});

  final Enquiry enquiry;

  @override
  ConsumerState<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends ConsumerState<VerifyScreen> {
  CallOutcome? _outcome;
  int _duration = 0;
  DateTime? _callbackAt;
  bool _recordingConsent = false;
  bool _showErrors = false;
  final _notes = TextEditingController();

  @override
  void initState() {
    super.initState();
    final e = widget.enquiry;
    if (e.status == EnquiryStatus.newEnquiry) {
      // Opening the page means someone is picking it up.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) ref.read(dbProvider.notifier).startVerification(e.id);
      });
    }
  }

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  Future<void> _call(Customer c) async {
    final secs = await simulateCall(context, name: c.name, phone: Fmt.phone(c.phone));
    if (secs == null || !mounted) return;
    setState(() => _duration = secs);
  }

  Future<void> _save() async {
    final t = context.t;
    final config = ref.read(configProvider);
    final needsConsent = config.callRecordingEnabled &&
        config.callRecordingConsentRequired &&
        _duration > 0;
    final needsCallback = _outcome == CallOutcome.callBackLater;
    if (_outcome == null || (needsConsent && !_recordingConsent) ||
        (needsCallback && _callbackAt == null)) {
      setState(() => _showErrors = true);
      showToast(context, t.validationFixErrors, tone: Tone.danger);
      return;
    }
    final outcome = _outcome!;
    if (outcome.rejects) {
      final ok = await confirmAction(
        context,
        title: t.verifyRejectTitle,
        body: t.verifyRejectBody(outcomeLabel(t, outcome)),
        confirmLabel: t.verifyRejectConfirm,
        destructive: true,
      );
      if (!ok) return;
    }
    await simulateWork();
    final e = widget.enquiry;
    final store = ref.read(dbProvider.notifier);
    if (needsConsent) store.recordConsent(ConsentAction.callRecording, enquiryId: e.id);
    store.recordVerification(
      e.id,
      outcome,
      notes: _notes.text.trim(),
      durationSec: _duration,
      callbackAt: _callbackAt,
    );
    if (!mounted) return;
    if (outcome == CallOutcome.genuine) {
      showToast(context, t.verifyDoneGenuine);
      context.pushReplacement(Routes.enquiryPart(e.id, 'qualify'));
    } else {
      showToast(
        context,
        outcome.rejects ? t.verifyDoneRejected : t.verifyDoneLater,
        tone: outcome.rejects ? Tone.warning : Tone.info,
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final config = db.config;
    final e = db.enquiryById(widget.enquiry.id) ?? widget.enquiry;
    final customer = db.customerById(e.customerId);
    final referrer = db.userById(e.salespersonId);
    final dupes = ref
        .read(dbProvider.notifier)
        .findDuplicates(customer?.phone ?? '')
        .where((x) => x.id != e.id)
        .toList();
    final outcomes = [
      CallOutcome.genuine,
      CallOutcome.callBackLater,
      CallOutcome.noAnswer,
      CallOutcome.notInterested,
      CallOutcome.wrongRequirement,
      CallOutcome.wrongNumber,
      CallOutcome.duplicate,
      CallOutcome.notGenuine,
    ];

    return PageScaffold(
      title: t.verifyTitle,
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(customer?.name ?? '', style: context.text.titleLarge),
              Text(Fmt.phone(customer?.phone ?? ''), style: context.text.bodyMedium),
              Space.gapSm,
              Text(db.enquiryTitle(e), style: context.text.titleSmall),
              Text(e.requirement, style: context.text.bodySmall),
              if (e.contactPreference != ContactPreference.callAnytime) ...[
                Space.gapSm,
                Text(
                  e.contactPreference == ContactPreference.callAtTime
                      ? '${contactPrefLabel(t, e.contactPreference)}: ${e.preferredTime ?? ''}'
                      : contactPrefLabel(t, e.contactPreference),
                  style: context.text.bodySmall,
                ),
              ],
              if (referrer != null) ...[
                Space.gapSm,
                Text(t.verifyReferredBy(referrer.name), style: context.text.bodySmall),
              ],
              Space.gapLg,
              if (config.callingEnabled && customer != null)
                AppButton(
                  _duration > 0 ? t.verifyCallAgain : t.verifyCallButton,
                  icon: Icons.call,
                  kind: ButtonKind.success,
                  onPressed: () => _call(customer),
                ),
              if (_duration > 0) ...[
                Space.gapSm,
                Text(t.verifyCallLength(Fmt.duration(_duration)),
                    style: context.text.bodySmall, textAlign: TextAlign.center),
              ],
            ],
          ),
        ),
        if (dupes.isNotEmpty) ...[
          Space.gapMd,
          NoteCard(
            tone: Tone.warning,
            icon: Icons.content_copy,
            text: t.verifyDuplicateNote(dupes.map((d) => d.id).join(', ')),
          ),
        ],
        SectionHeader(t.verifyWhatHappened),
        ChoiceChips<CallOutcome>(
          options: [for (final o in outcomes) SelectOption(o, outcomeLabel(t, o))],
          selected: _outcome,
          onSelected: (v) => setState(() => _outcome = v),
        ),
        if (_showErrors && _outcome == null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(t.validationChooseOne,
                style: context.text.bodySmall?.copyWith(color: Tone.danger.foreground)),
          ),
        if (_outcome == CallOutcome.callBackLater || _outcome == CallOutcome.noAnswer) ...[
          Space.gapLg,
          DateTimeField(
            label: t.verifyCallbackAt,
            value: _callbackAt,
            required: _outcome == CallOutcome.callBackLater,
            firstDate: DateTime.now(),
            onChanged: (v) => setState(() => _callbackAt = v),
          ),
          if (_showErrors && _outcome == CallOutcome.callBackLater && _callbackAt == null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(t.validationRequired,
                  style: context.text.bodySmall?.copyWith(color: Tone.danger.foreground)),
            ),
        ],
        Space.gapLg,
        AppTextField(
          label: t.labelNotes,
          controller: _notes,
          optional: true,
          maxLines: 3,
          hint: t.verifyNotesHint,
        ),
        if (config.callRecordingEnabled && config.callRecordingConsentRequired && _duration > 0) ...[
          Space.gapLg,
          AppCard(
            padding: EdgeInsets.zero,
            child: CheckboxListTile(
              value: _recordingConsent,
              onChanged: (v) => setState(() => _recordingConsent = v ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(t.verifyRecordingConsent, style: context.text.bodyMedium),
              subtitle: _showErrors && !_recordingConsent
                  ? Text(t.referConsentError,
                      style: context.text.bodySmall?.copyWith(color: Tone.danger.foreground))
                  : null,
            ),
          ),
        ],
        Space.gapLg,
        if (_outcome != null)
          NoteCard(
            tone: _outcome == CallOutcome.genuine
                ? Tone.success
                : (_outcome!.rejects ? Tone.danger : Tone.info),
            text: _outcome == CallOutcome.genuine
                ? t.verifyExplainGenuine
                : (_outcome!.rejects ? t.verifyExplainReject : t.verifyExplainLater),
          ),
        const SizedBox(height: 80),
      ],
      bottomBar: StickyActions(children: [
        AppButton(t.verifySave, onPressed: _save),
      ]),
    );
  }
}

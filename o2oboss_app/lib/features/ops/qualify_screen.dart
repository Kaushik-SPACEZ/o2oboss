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

/// Step 2: the category's questions, so vendors get a clear, complete brief.
/// "Save for later" keeps partial answers; "Mark as qualified" needs every
/// required answer and releases the enquiry for vendor matching.
class QualifyScreen extends ConsumerStatefulWidget {
  const QualifyScreen({super.key, required this.enquiry});

  final Enquiry enquiry;

  @override
  ConsumerState<QualifyScreen> createState() => _QualifyScreenState();
}

class _QualifyScreenState extends ConsumerState<QualifyScreen> {
  final _form = GlobalKey<FormState>();
  late final Map<String, String> _answers = {...widget.enquiry.answers};
  late final Map<String, TextEditingController> _text = {};
  late String? _productId = widget.enquiry.productId;
  late String? _brandId = widget.enquiry.brandId;
  late EnquiryPriority _priority = widget.enquiry.priority;
  late final _value = TextEditingController(
      text: widget.enquiry.potentialValue?.round().toString() ?? '');

  @override
  void dispose() {
    for (final c in _text.values) {
      c.dispose();
    }
    _value.dispose();
    super.dispose();
  }

  TextEditingController _controller(String id) =>
      _text.putIfAbsent(id, () => TextEditingController(text: _answers[id] ?? ''));

  Map<String, String> _collect() => {
        ..._answers,
        for (final e in _text.entries) e.key: e.value.text.trim(),
      };

  Future<void> _save({required bool complete}) async {
    final t = context.t;
    if (complete && !_form.currentState!.validate()) {
      showToast(context, t.validationFixErrors, tone: Tone.danger);
      return;
    }
    await simulateWork();
    final value = double.tryParse(_value.text.trim());
    ref.read(dbProvider.notifier).saveQualification(
          widget.enquiry.id,
          _collect(),
          complete: complete,
          potentialValue: value,
          priority: _priority,
          brandId: _brandId,
          productId: _productId,
        );
    if (!mounted) return;
    showToast(context, complete ? t.qualifyDone : t.toastSaved);
    if (complete) {
      context.pushReplacement(Routes.enquiryPart(widget.enquiry.id, 'vendors'));
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final me = ref.watch(currentUserProvider)!;
    final e = db.enquiryById(widget.enquiry.id) ?? widget.enquiry;
    final category = db.categoryById(e.categoryId);
    final questions = category?.questions ?? const <QualificationQuestion>[];
    final products = db.products.where((p) => p.active && p.categoryId == e.categoryId).toList();
    final brands = db.brands.where((b) => b.active && b.categoryIds.contains(e.categoryId)).toList();
    final readOnly = !can(me.role, Perm.qualify, db.config) ||
        e.status.index > EnquiryStatus.vendorMatching.index;

    return PageScaffold(
      title: t.qualifyTitle,
      children: [
        Text(t.qualifySubtitle(category?.name ?? ''),
            style: context.text.bodyMedium),
        Space.gapLg,
        if (readOnly && e.status.isQualified)
          Padding(
            padding: const EdgeInsets.only(bottom: Space.lg),
            child: NoteCard(tone: Tone.success, icon: Icons.check_circle_outline, text: t.qualifyLocked),
          ),
        Form(
          key: _form,
          child: AbsorbPointer(
            absorbing: readOnly,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (products.isNotEmpty) ...[
                  SelectField<String>(
                    label: t.labelProduct,
                    value: _productId,
                    options: [for (final p in products) SelectOption(p.id, p.name)],
                    onChanged: (v) => setState(() => _productId = v),
                  ),
                  Space.gapLg,
                ],
                if (brands.isNotEmpty) ...[
                  SelectField<String>(
                    label: t.labelBrand,
                    value: _brandId ?? '',
                    options: [
                      SelectOption('', t.labelAnyBrand),
                      for (final b in brands) SelectOption(b.id, b.name),
                    ],
                    onChanged: (v) => setState(() => _brandId = v.isEmpty ? null : v),
                  ),
                  Space.gapLg,
                ],
                for (final q in questions) ...[
                  _question(context, q),
                  Space.gapLg,
                ],
                AmountField(
                  controller: _value,
                  label: t.labelEstimatedValue,
                  required: false,
                  help: t.qualifyValueHelp,
                ),
                Space.gapLg,
                ChoiceChips<EnquiryPriority>(
                  label: t.labelPriority,
                  options: [
                    for (final p in EnquiryPriority.values) SelectOption(p, priorityLabel(t, p)),
                  ],
                  selected: _priority,
                  onSelected: (v) => setState(() => _priority = v),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 80),
      ],
      bottomBar: readOnly
          ? null
          : StickyActions(children: [
              AppButton.secondary(t.qualifySaveLater, onPressed: () => _save(complete: false)),
              AppButton(t.qualifyComplete, onPressed: () => _save(complete: true)),
            ]),
    );
  }

  Widget _question(BuildContext context, QualificationQuestion q) {
    final t = context.t;
    String? requiredCheck(String? v) =>
        q.required && (v ?? '').trim().isEmpty ? t.validationRequired : null;
    switch (q.type) {
      case QuestionType.choice:
        return _ChoiceQuestion(
          label: q.label,
          required: q.required,
          options: q.options,
          value: _answers[q.id],
          onChanged: (v) => setState(() => _answers[q.id] = v),
        );
      case QuestionType.yesNo:
        return _ChoiceQuestion(
          label: q.label,
          required: q.required,
          options: const ['Yes', 'No'],
          labels: [t.questionYes, t.questionNo],
          value: _answers[q.id],
          onChanged: (v) => setState(() => _answers[q.id] = v),
        );
      case QuestionType.date:
        final current = DateTime.tryParse(_answers[q.id] ?? '');
        return DateTimeField(
          label: q.label,
          value: current,
          withTime: false,
          required: q.required,
          onChanged: (v) => setState(() => _answers[q.id] =
              '${v.year}-${v.month.toString().padLeft(2, '0')}-${v.day.toString().padLeft(2, '0')}'),
        );
      case QuestionType.number:
        return AppTextField(
          label: q.label,
          controller: _controller(q.id),
          required: q.required,
          optional: !q.required,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
          validator: requiredCheck,
        );
      case QuestionType.text:
        return AppTextField(
          label: q.label,
          controller: _controller(q.id),
          required: q.required,
          optional: !q.required,
          validator: requiredCheck,
        );
    }
  }
}

class _ChoiceQuestion extends StatelessWidget {
  const _ChoiceQuestion({
    required this.label,
    required this.required,
    required this.options,
    required this.value,
    required this.onChanged,
    this.labels,
  });

  final String label;
  final bool required;
  final List<String> options;
  final List<String>? labels;
  final String? value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return ChoiceChips<String>(
      label: label,
      required: required,
      options: [
        for (var i = 0; i < options.length; i++)
          SelectOption(options[i], labels?[i] ?? options[i]),
      ],
      selected: value,
      onSelected: onChanged,
    );
  }
}

/// Qualification answers as read-only lines, for vendors and summaries.
List<(String, String)> answerLines(DbState db, Enquiry e) {
  final category = db.categoryById(e.categoryId);
  return [
    for (final q in category?.questions ?? const <QualificationQuestion>[])
      if ((e.answers[q.id] ?? '').isNotEmpty)
        (q.label, q.type == QuestionType.number && q.id == 'budget'
            ? Fmt.money(double.tryParse(e.answers[q.id]!) ?? 0)
            : e.answers[q.id]!),
  ];
}

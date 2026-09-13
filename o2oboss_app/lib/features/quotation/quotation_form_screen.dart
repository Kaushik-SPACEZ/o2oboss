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
import '../../core/data/drafts.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../core/utils/format.dart';
import '../../shared/widgets/buttons.dart';
import '../../shared/widgets/cards.dart';
import '../../shared/widgets/feedback.dart';
import '../../shared/widgets/inputs.dart';
import '../../shared/widgets/layout.dart';
import '../common/system_screens.dart';

enum QuotationFormMode { create, edit, revise }

/// Vendor's quotation form: items, charges, tax and terms, with the total
/// always visible at the bottom. Save as draft or submit for review.
class QuotationFormScreen extends ConsumerStatefulWidget {
  const QuotationFormScreen({
    super.key,
    required this.mode,
    this.enquiryId,
    this.vendorId,
    this.quotationId,
  });

  final QuotationFormMode mode;
  final String? enquiryId;
  final String? vendorId;
  final String? quotationId;

  @override
  ConsumerState<QuotationFormScreen> createState() => _QuotationFormScreenState();
}

class _Line {
  _Line({String description = '', double qty = 1, double price = 0})
      : description = TextEditingController(text: description),
        qty = TextEditingController(text: qty % 1 == 0 ? qty.toStringAsFixed(0) : '$qty'),
        price = TextEditingController(text: price == 0 ? '' : price.toStringAsFixed(0));

  final TextEditingController description;
  final TextEditingController qty;
  final TextEditingController price;

  double get total =>
      (double.tryParse(qty.text) ?? 0) * (double.tryParse(price.text) ?? 0);

  void dispose() {
    description.dispose();
    qty.dispose();
    price.dispose();
  }
}

class _QuotationFormScreenState extends ConsumerState<QuotationFormScreen> {
  final _form = GlobalKey<FormState>();
  late final QuotationDraft _d;
  final List<_Line> _lines = [];
  late final _discount = TextEditingController();
  late final _installation = TextEditingController();
  late final _delivery = TextEditingController();
  late final _terms = TextEditingController();
  late final _notes = TextEditingController();
  int _timeline = 7;
  int _validity = 15;
  double _tax = 18;
  bool _dirty = false;
  Quotation? _source;

  @override
  void initState() {
    super.initState();
    final db = ref.read(dbProvider);
    _source = db.quotationById(widget.quotationId);
    final src = _source;
    if (src != null) {
      _d = QuotationDraft.fromQuotation(src);
    } else {
      final e = db.enquiryById(widget.enquiryId);
      _d = QuotationDraft(
        enquiryId: widget.enquiryId ?? '',
        vendorId: widget.vendorId ?? ref.read(currentUserProvider)?.vendorId ?? '',
        terms: '50% advance, balance on completion. 1 year warranty on workmanship.',
        items: e == null
            ? []
            : [QuotationItem(description: db.enquiryTitle(e), unitPrice: 0)],
      );
    }
    for (final i in _d.items) {
      _lines.add(_Line(description: i.description, qty: i.qty, price: i.unitPrice));
    }
    if (_lines.isEmpty) _lines.add(_Line());
    _discount.text = _d.discount == 0 ? '' : _d.discount.toStringAsFixed(0);
    _installation.text = _d.installation == 0 ? '' : _d.installation.toStringAsFixed(0);
    _delivery.text = _d.delivery == 0 ? '' : _d.delivery.toStringAsFixed(0);
    _terms.text = _d.terms;
    _notes.text = _d.notes;
    _timeline = _d.timelineDays;
    _validity = _d.validityDays;
    _tax = _d.taxPercent;
  }

  @override
  void dispose() {
    for (final l in _lines) {
      l.dispose();
    }
    for (final c in [_discount, _installation, _delivery, _terms, _notes]) {
      c.dispose();
    }
    super.dispose();
  }

  double _num(TextEditingController c) => double.tryParse(c.text.trim()) ?? 0;

  QuotationDraft _collect() => _d
    ..items = [
      for (final l in _lines)
        if (l.description.text.trim().isNotEmpty)
          QuotationItem(
            description: l.description.text.trim(),
            qty: double.tryParse(l.qty.text) ?? 1,
            unitPrice: double.tryParse(l.price.text) ?? 0,
          ),
    ]
    ..discount = _num(_discount)
    ..installation = _num(_installation)
    ..delivery = _num(_delivery)
    ..taxPercent = _tax
    ..timelineDays = _timeline
    ..validityDays = _validity
    ..terms = _terms.text.trim()
    ..notes = _notes.text.trim();

  Future<void> _save({required bool submit}) async {
    final t = context.t;
    if (!_form.currentState!.validate()) {
      showToast(context, t.validationFixErrors, tone: Tone.danger);
      return;
    }
    final d = _collect();
    if (d.items.isEmpty || d.total <= 0) {
      showToast(context, t.quoteFormNeedItem, tone: Tone.danger);
      return;
    }
    if (submit) {
      final ok = await confirmAction(context,
          title: t.quoteSubmitTitle, body: t.quoteSubmitBody, confirmLabel: t.quoteSubmit);
      if (!ok) return;
    }
    await simulateWork(600);
    final store = ref.read(dbProvider.notifier);
    final id = switch (widget.mode) {
      QuotationFormMode.edit => store.saveQuotation(d, draftId: _source!.id, submit: submit),
      QuotationFormMode.revise => store.saveQuotation(d, revisesId: _source!.id, submit: submit),
      QuotationFormMode.create => store.saveQuotation(d, submit: submit),
    };
    if (!mounted) return;
    _dirty = false;
    showToast(context, submit ? t.quoteSubmittedToast : t.quoteDraftSaved);
    context.pushReplacement(Routes.quotation(id));
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final me = ref.watch(currentUserProvider);
    final e = db.enquiryById(_d.enquiryId);
    if (me == null) return const SizedBox.shrink();
    if (e == null || me.role != UserRole.vendor || _d.vendorId != me.vendorId) {
      return const NoAccessView();
    }
    final draft = _collect();
    final title = switch (widget.mode) {
      QuotationFormMode.create => t.quoteFormNew,
      QuotationFormMode.edit => t.quoteFormEdit,
      QuotationFormMode.revise => t.quoteFormRevise('${(_source?.version ?? 1) + 1}'),
    };

    return PopScope(
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await confirmDiscard(context) && context.mounted) {
          setState(() => _dirty = false);
          context.pop();
        }
      },
      child: Form(
        key: _form,
        onChanged: () => setState(() => _dirty = true),
        child: PageScaffold(
          title: title,
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(db.enquiryTitle(e), style: context.text.titleSmall),
                  Text('${e.id}, ${e.area}, ${e.city}', style: context.text.bodySmall),
                  if (widget.mode == QuotationFormMode.revise &&
                      (_source?.revisionNote ?? '').isNotEmpty) ...[
                    Space.gapMd,
                    NoteCard(
                      tone: Tone.warning,
                      icon: Icons.edit_note,
                      title: t.quoteRevisionAsked,
                      text: _source!.revisionNote!,
                    ),
                  ],
                ],
              ),
            ),
            SectionHeader(t.quoteItems),
            for (var i = 0; i < _lines.length; i++) ...[
              _LineEditor(
                key: ObjectKey(_lines[i]),
                line: _lines[i],
                index: i + 1,
                onRemove: _lines.length == 1
                    ? null
                    : () => setState(() {
                          _lines.removeAt(i).dispose();
                          _dirty = true;
                        }),
              ),
              Space.gapMd,
            ],
            AppButton.secondary(t.quoteFormAddItem,
                icon: Icons.add, onPressed: () => setState(() => _lines.add(_Line()))),
            SectionHeader(t.quoteFormCharges),
            AmountField(controller: _installation, label: t.quoteInstallation, required: false, allowZero: true),
            Space.gapLg,
            AmountField(controller: _delivery, label: t.quoteDelivery, required: false, allowZero: true),
            Space.gapLg,
            AmountField(controller: _discount, label: t.quoteDiscount, required: false, allowZero: true),
            Space.gapLg,
            ChoiceChips<double>(
              label: t.quoteFormTax,
              options: [for (final p in [0.0, 5.0, 12.0, 18.0, 28.0]) SelectOption(p, Fmt.percent(p))],
              selected: _tax,
              onSelected: (v) => setState(() {
                _tax = v;
                _dirty = true;
              }),
            ),
            SectionHeader(t.quoteTerms),
            ChoiceChips<int>(
              label: t.quoteTimeline,
              options: [for (final d in [3, 7, 15, 30, 45]) SelectOption(d, t.quoteDays('$d'))],
              selected: _timeline,
              onSelected: (v) => setState(() {
                _timeline = v;
                _dirty = true;
              }),
            ),
            Space.gapLg,
            ChoiceChips<int>(
              label: t.quoteValidity,
              options: [for (final d in [7, 15, 30]) SelectOption(d, t.quoteDays('$d'))],
              selected: _validity,
              onSelected: (v) => setState(() {
                _validity = v;
                _dirty = true;
              }),
            ),
            Space.gapLg,
            AppTextField(label: t.quoteTermsLabel, controller: _terms, maxLines: 4, optional: true),
            Space.gapLg,
            AppTextField(label: t.labelNotes, controller: _notes, maxLines: 3, optional: true),
            Space.gapLg,
            FieldLabel(t.quoteAttachment, optional: true),
            Wrap(
              spacing: Space.sm,
              runSpacing: Space.sm,
              children: [
                for (final a in _d.attachments)
                  InputChip(
                    label: Text(a),
                    avatar: const Icon(Icons.attach_file, size: 18),
                    onDeleted: () => setState(() {
                      _d.attachments.remove(a);
                      _dirty = true;
                    }),
                  ),
                ActionChip(
                  avatar: const Icon(Icons.add, size: 18),
                  label: Text(t.quoteFormAttach),
                  onPressed: () => setState(() {
                    _d.attachments.add('brochure_${_d.attachments.length + 1}.pdf');
                    _dirty = true;
                  }),
                ),
              ],
            ),
            Space.gapXl,
            NoteCard(icon: Icons.fact_check_outlined, text: t.quoteFormReviewNote),
            const SizedBox(height: 120),
          ],
          bottomBar: _TotalBar(
            total: draft.total,
            subtotal: draft.subtotal,
            tax: draft.taxAmount,
            onDraft: () => _save(submit: false),
            onSubmit: () => _save(submit: true),
          ),
        ),
      ),
    );
  }
}

class _LineEditor extends StatelessWidget {
  const _LineEditor({super.key, required this.line, required this.index, this.onRemove});

  final _Line line;
  final int index;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return AppCard(
      padding: const EdgeInsets.fromLTRB(Space.lg, Space.sm, Space.sm, Space.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text(t.quoteFormItem('$index'), style: context.text.labelLarge)),
              if (onRemove != null)
                IconButton(
                  tooltip: t.actionRemove,
                  icon: const Icon(Icons.delete_outline, color: AppColors.dangerText),
                  onPressed: onRemove,
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(end: Space.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  label: t.quoteFormDescription,
                  controller: line.description,
                  required: true,
                  textCapitalization: TextCapitalization.sentences,
                  validator: (v) => (v ?? '').trim().isEmpty ? t.validationRequired : null,
                ),
                Space.gapMd,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 90,
                      child: AppTextField(
                        label: t.quoteFormQty,
                        controller: line.qty,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                        validator: (v) =>
                            (double.tryParse(v ?? '') ?? 0) <= 0 ? t.validationNumber : null,
                      ),
                    ),
                    Space.gapMd,
                    Expanded(
                      child: AmountField(controller: line.price, label: t.quoteFormUnitPrice),
                    ),
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

class _TotalBar extends StatelessWidget {
  const _TotalBar({
    required this.total,
    required this.subtotal,
    required this.tax,
    required this.onDraft,
    required this.onSubmit,
  });

  final double total;
  final double subtotal;
  final double tax;
  final Future<void> Function() onDraft;
  final Future<void> Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: ContentWidth(
          fillHeight: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(Space.page(context), Space.md, Space.page(context), Space.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(t.quoteFormTotalLine(Fmt.money(subtotal), Fmt.money(tax)),
                          style: context.text.bodySmall),
                    ),
                    Text(Fmt.money(total),
                        style: context.text.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontFeatures: const [FontFeature.tabularFigures()])),
                  ],
                ),
                Space.gapMd,
                Row(
                  children: [
                    Expanded(child: AppButton.secondary(t.quoteSaveDraft, onPressed: onDraft)),
                    Space.gapMd,
                    Expanded(child: AppButton(t.quoteSubmit, onPressed: onSubmit)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

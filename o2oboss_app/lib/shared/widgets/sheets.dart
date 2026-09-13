import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/l10n/l10n.dart';
import 'buttons.dart';
import 'inputs.dart';
import 'layout.dart';

/// Bottom sheet with a title, for short tasks and choices (spec 03 §17).
/// It slides up and back down, and keeps clear of the keyboard.
Future<T?> showAppSheet<T>(
  BuildContext context, {
  required String title,
  required WidgetBuilder builder,
  String? subtitle,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (ctx) => SheetFrame(title: title, subtitle: subtitle, child: builder(ctx)),
  );
}

class SheetFrame extends StatelessWidget {
  const SheetFrame({super.key, required this.title, required this.child, this.subtitle});

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: ContentWidth(
        fillHeight: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(Space.xl, 0, Space.sm, Space.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Semantics(
                          header: true,
                          child: Text(title, style: context.text.titleLarge),
                        ),
                        if (subtitle != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(subtitle!, style: context.text.bodySmall),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: context.t.actionClose,
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(Space.xl, 0, Space.xl, Space.xl),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A single-choice list in a sheet. Returns the chosen value.
Future<T?> pickOption<T>(
  BuildContext context, {
  required String title,
  required List<SelectOption<T>> options,
  T? selected,
  String? subtitle,
}) {
  return showAppSheet<T>(
    context,
    title: title,
    subtitle: subtitle,
    builder: (ctx) => Column(
      children: [
        for (final o in options)
          OptionTile(
            label: o.label,
            subtitle: o.subtitle,
            icon: o.icon,
            selected: o.value == selected,
            onTap: () => Navigator.pop(ctx, o.value),
          ),
      ],
    ),
  );
}

/// Radio-style row. Built by hand so the whole row is one large target.
class OptionTile extends StatelessWidget {
  const OptionTile({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.subtitle,
    this.icon,
    this.multi = false,
  });

  final String label;
  final String? subtitle;
  final IconData? icon;
  final bool selected;
  final bool multi;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      inMutuallyExclusiveGroup: !multi,
      child: InkWell(
        borderRadius: Corners.mdAll,
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 52),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: Space.sm, horizontal: Space.xs),
            child: Row(
              children: [
                Icon(
                  multi
                      ? (selected ? Icons.check_box : Icons.check_box_outline_blank)
                      : (selected ? Icons.radio_button_checked : Icons.radio_button_off),
                  color: selected ? AppColors.primary : AppColors.textSecondary,
                ),
                Space.gapMd,
                if (icon != null) ...[
                  Icon(icon, size: Sizes.icon, color: AppColors.textSecondary),
                  Space.gapMd,
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label, style: context.text.bodyLarge),
                      if (subtitle != null)
                        Text(subtitle!, style: context.text.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Asks for a reason from a short list, with an "Other" free-text option.
/// Returns null if dismissed.
Future<String?> askReason(
  BuildContext context, {
  required String title,
  required List<String> reasons,
  required String confirmLabel,
  String? subtitle,
  bool destructive = false,
}) {
  return showAppSheet<String>(
    context,
    title: title,
    subtitle: subtitle,
    builder: (_) => _ReasonPicker(
      reasons: reasons,
      confirmLabel: confirmLabel,
      destructive: destructive,
    ),
  );
}

class _ReasonPicker extends StatefulWidget {
  const _ReasonPicker({
    required this.reasons,
    required this.confirmLabel,
    required this.destructive,
  });

  final List<String> reasons;
  final String confirmLabel;
  final bool destructive;

  @override
  State<_ReasonPicker> createState() => _ReasonPickerState();
}

class _ReasonPickerState extends State<_ReasonPicker> {
  String? _choice;
  final _other = TextEditingController();
  bool _showError = false;

  @override
  void dispose() {
    _other.dispose();
    super.dispose();
  }

  String? get _value {
    if (_choice == null) return null;
    if (_choice == '__other') {
      final s = _other.text.trim();
      return s.isEmpty ? null : s;
    }
    return _choice;
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final r in widget.reasons)
          OptionTile(
            label: r,
            selected: _choice == r,
            onTap: () => setState(() => _choice = r),
          ),
        OptionTile(
          label: t.labelOther,
          selected: _choice == '__other',
          onTap: () => setState(() => _choice = '__other'),
        ),
        if (_choice == '__other') ...[
          Space.gapSm,
          AppTextField(
            label: t.labelReason,
            controller: _other,
            maxLines: 3,
            autofocus: true,
            onChanged: (_) => setState(() {}),
          ),
        ],
        if (_showError && _value == null)
          Padding(
            padding: const EdgeInsets.only(top: Space.sm),
            child: Text(t.validationReason,
                style: context.text.bodySmall?.copyWith(color: AppColors.dangerText)),
          ),
        Space.gapLg,
        AppButton(
          widget.confirmLabel,
          kind: widget.destructive ? ButtonKind.danger : ButtonKind.primary,
          onPressed: () {
            final v = _value;
            if (v == null) {
              setState(() => _showError = true);
              return;
            }
            Navigator.pop(context, v);
          },
        ),
      ],
    );
  }
}

/// Asks for a single piece of text. Returns null if dismissed.
Future<String?> askText(
  BuildContext context, {
  required String title,
  required String label,
  required String confirmLabel,
  String? initial,
  String? hint,
  String? subtitle,
  int maxLines = 3,
  bool required = true,
}) {
  final controller = TextEditingController(text: initial);
  final formKey = GlobalKey<FormState>();
  return showAppSheet<String>(
    context,
    title: title,
    subtitle: subtitle,
    builder: (ctx) => Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            label: label,
            controller: controller,
            hint: hint,
            maxLines: maxLines,
            required: required,
            autofocus: true,
            validator: required ? (v) => (v ?? '').trim().isEmpty ? ctx.t.validationRequired : null : null,
          ),
          Space.gapLg,
          AppButton(confirmLabel, onPressed: () {
            if (!formKey.currentState!.validate()) return;
            Navigator.pop(ctx, controller.text.trim());
          }),
        ],
      ),
    ),
  ).whenComplete(() {
    // Let the closing animation finish before releasing the field.
    Future<void>.delayed(const Duration(seconds: 1), controller.dispose);
  });
}

/// Date picker followed by a time picker.
Future<DateTime?> pickDateTime(
  BuildContext context, {
  DateTime? initial,
  bool withTime = true,
  DateTime? first,
  DateTime? last,
}) async {
  final now = DateTime.now();
  final start = initial ?? now.add(const Duration(days: 1));
  final date = await showDatePicker(
    context: context,
    initialDate: start,
    firstDate: first ?? now.subtract(const Duration(days: 365)),
    lastDate: last ?? now.add(const Duration(days: 365)),
  );
  if (date == null || !context.mounted) return null;
  if (!withTime) return DateTime(date.year, date.month, date.day);
  final time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(initial ?? DateTime(now.year, now.month, now.day, 11)),
  );
  if (time == null) return null;
  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}

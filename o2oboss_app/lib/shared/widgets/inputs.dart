import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/l10n/l10n.dart';
import '../../core/utils/format.dart';
import '../../core/utils/validators.dart';
import 'sheets.dart';

/// Label shown above every field. Labels stay visible — placeholders are
/// never used as labels (spec 04 §12).
class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key, this.required = false, this.optional = false});

  final String text;
  final bool required;
  final bool optional;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text.rich(
        TextSpan(children: [
          TextSpan(text: text),
          if (required)
            const TextSpan(text: ' *', style: TextStyle(color: AppColors.dangerText)),
          if (optional)
            TextSpan(
              text: '  ${context.t.labelOptional}',
              style: context.text.bodySmall,
            ),
        ]),
        style: context.text.labelLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.initialValue,
    this.hint,
    this.help,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
    this.minLines,
    this.required = false,
    this.optional = false,
    this.obscure = false,
    this.prefixIcon,
    this.prefixText,
    this.suffix,
    this.enabled = true,
    this.readOnly = false,
    this.onTap,
    this.inputFormatters,
    this.autofillHints,
    this.maxLength,
    this.textCapitalization = TextCapitalization.none,
    this.onSubmitted,
    this.autofocus = false,
  });

  final String label;
  final TextEditingController? controller;
  final String? initialValue;
  final String? hint;
  final String? help;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final int? maxLines;
  final int? minLines;
  final bool required;
  final bool optional;
  final bool obscure;
  final IconData? prefixIcon;
  final String? prefixText;
  final Widget? suffix;
  final bool enabled;
  final bool readOnly;
  final VoidCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;
  final int? maxLength;
  final TextCapitalization textCapitalization;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(label, required: required, optional: optional),
        TextFormField(
          controller: controller,
          initialValue: controller == null ? initialValue : null,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          validator: validator,
          onChanged: onChanged,
          maxLines: obscure ? 1 : maxLines,
          minLines: minLines,
          obscureText: obscure,
          enabled: enabled,
          readOnly: readOnly,
          onTap: onTap,
          inputFormatters: inputFormatters,
          autofillHints: autofillHints,
          maxLength: maxLength,
          textCapitalization: textCapitalization,
          onFieldSubmitted: onSubmitted,
          autofocus: autofocus,
          autovalidateMode: AutovalidateMode.onUnfocus,
          style: context.text.bodyLarge,
          decoration: InputDecoration(
            hintText: hint,
            helperText: help,
            counterText: '',
            prefixIcon: prefixIcon == null ? null : Icon(prefixIcon, size: Sizes.icon),
            prefixText: prefixText,
            suffixIcon: suffix,
          ),
        ),
      ],
    );
  }
}

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.help,
    this.textInputAction,
    this.onSubmitted,
    this.autofillHints = const [AutofillHints.password],
  });

  final String label;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final String? help;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final Iterable<String> autofillHints;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _hidden = true;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: widget.label,
      controller: widget.controller,
      obscure: _hidden,
      validator: widget.validator,
      help: widget.help,
      required: true,
      textInputAction: widget.textInputAction,
      onSubmitted: widget.onSubmitted,
      autofillHints: widget.autofillHints,
      prefixIcon: Icons.lock_outline,
      suffix: IconButton(
        tooltip: _hidden ? context.t.authShowPassword : context.t.authHidePassword,
        icon: Icon(_hidden ? Icons.visibility_outlined : Icons.visibility_off_outlined),
        onPressed: () => setState(() => _hidden = !_hidden),
      ),
    );
  }
}

/// Indian mobile number field: +91 prefix, digits only, 10 digits.
class PhoneField extends StatelessWidget {
  const PhoneField({
    super.key,
    required this.controller,
    this.label,
    this.required = true,
    this.textInputAction,
    this.help,
    this.validator,
  });

  final TextEditingController controller;
  final String? label;
  final bool required;
  final TextInputAction? textInputAction;
  final String? help;

  /// Replaces the standard check, e.g. to also reject numbers already in use.
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: label ?? context.t.labelMobile,
      controller: controller,
      required: required,
      help: help,
      keyboardType: TextInputType.phone,
      textInputAction: textInputAction,
      prefixIcon: Icons.phone_outlined,
      prefixText: '+91 ',
      maxLength: 10,
      autofillHints: const [AutofillHints.telephoneNumberNational],
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: validator ??
          (v) => required || (v ?? '').isNotEmpty ? Validators.phone(context.t, v) : null,
    );
  }
}

/// Rupee amount field.
class AmountField extends StatelessWidget {
  const AmountField({
    super.key,
    required this.controller,
    required this.label,
    this.required = true,
    this.help,
    this.allowZero = false,
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final bool required;
  final String? help;
  final bool allowZero;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: label,
      controller: controller,
      required: required,
      optional: !required,
      help: help,
      onChanged: onChanged,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      prefixText: '₹ ',
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
      validator: (v) {
        if (!required && (v ?? '').isEmpty) return null;
        return Validators.amount(context.t, v, allowZero: allowZero);
      },
    );
  }
}

class SelectOption<T> {
  const SelectOption(this.value, this.label, {this.subtitle, this.icon});

  final T value;
  final String label;
  final String? subtitle;
  final IconData? icon;
}

/// Looks like a text field; opens a bottom sheet list to choose one value.
class SelectField<T> extends StatelessWidget {
  const SelectField({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.hint,
    this.required = false,
    this.optional = false,
    this.icon,
    this.sheetTitle,
    this.enabled = true,
  });

  final String label;
  final T? value;
  final List<SelectOption<T>> options;
  final ValueChanged<T> onChanged;
  final String? hint;
  final bool required;
  final bool optional;
  final IconData? icon;
  final String? sheetTitle;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final current = options.where((o) => o.value == value).firstOrNull;
    return FormField<T>(
      initialValue: value,
      validator: (_) => required && value == null ? context.t.validationChooseOne : null,
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FieldLabel(label, required: required, optional: optional),
            InkWell(
              borderRadius: Corners.mdAll,
              onTap: !enabled
                  ? null
                  : () async {
                      final picked = await pickOption<T>(
                        context,
                        title: sheetTitle ?? label,
                        options: options,
                        selected: value,
                      );
                      if (picked != null) {
                        field.didChange(picked);
                        onChanged(picked);
                      }
                    },
              child: InputDecorator(
                isEmpty: current == null,
                decoration: InputDecoration(
                  hintText: hint ?? context.t.labelChoose,
                  errorText: field.errorText,
                  enabled: enabled,
                  prefixIcon: icon == null ? null : Icon(icon, size: Sizes.icon),
                  suffixIcon: const Icon(Icons.expand_more),
                ),
                child: current == null
                    ? null
                    : Text(current.label,
                        style: context.text.bodyLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// A wrap of choice chips for one choice from a short list.
class ChoiceChips<T> extends StatelessWidget {
  const ChoiceChips({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
    this.label,
    this.required = false,
  });

  final List<SelectOption<T>> options;
  final T? selected;
  final ValueChanged<T> onSelected;
  final String? label;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      initialValue: selected,
      validator: (_) => required && selected == null ? context.t.validationChooseOne : null,
      builder: (field) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null) FieldLabel(label!, required: required),
          Wrap(
            spacing: Space.sm,
            runSpacing: Space.sm,
            children: [
              for (final o in options)
                ChoiceChip(
                  label: Text(o.label),
                  avatar: o.icon == null
                      ? null
                      : Icon(o.icon,
                          size: 18,
                          color: o.value == selected ? Colors.white : AppColors.textSecondary),
                  selected: o.value == selected,
                  labelStyle: context.text.labelMedium?.copyWith(
                    color: o.value == selected ? Colors.white : AppColors.text,
                  ),
                  onSelected: (_) {
                    field.didChange(o.value);
                    onSelected(o.value);
                  },
                ),
            ],
          ),
          if (field.errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(field.errorText!,
                  style: context.text.bodySmall?.copyWith(color: AppColors.dangerText)),
            ),
        ],
      ),
    );
  }
}

/// Chips allowing several choices.
class MultiChips<T> extends StatelessWidget {
  const MultiChips({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.label,
    this.required = false,
  });

  final List<SelectOption<T>> options;
  final Set<T> selected;
  final ValueChanged<Set<T>> onChanged;
  final String? label;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return FormField<Set<T>>(
      initialValue: selected,
      validator: (_) => required && selected.isEmpty ? context.t.validationChooseOne : null,
      builder: (field) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null) FieldLabel(label!, required: required),
          Wrap(
            spacing: Space.sm,
            runSpacing: Space.sm,
            children: [
              for (final o in options)
                FilterChip(
                  label: Text(o.label),
                  selected: selected.contains(o.value),
                  showCheckmark: true,
                  checkmarkColor: Colors.white,
                  labelStyle: context.text.labelMedium?.copyWith(
                    color: selected.contains(o.value) ? Colors.white : AppColors.text,
                  ),
                  onSelected: (on) {
                    final next = {...selected};
                    on ? next.add(o.value) : next.remove(o.value);
                    field.didChange(next);
                    onChanged(next);
                  },
                ),
            ],
          ),
          if (field.errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(field.errorText!,
                  style: context.text.bodySmall?.copyWith(color: AppColors.dangerText)),
            ),
        ],
      ),
    );
  }
}

/// Field that opens the date (and optionally time) picker.
class DateTimeField extends StatelessWidget {
  const DateTimeField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.withTime = true,
    this.required = false,
    this.firstDate,
    this.lastDate,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final bool withTime;
  final bool required;
  final DateTime? firstDate;
  final DateTime? lastDate;

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      initialValue: value,
      validator: (_) => required && value == null ? context.t.validationRequired : null,
      builder: (field) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FieldLabel(label, required: required),
          InkWell(
            borderRadius: Corners.mdAll,
            onTap: () async {
              final picked = await pickDateTime(
                context,
                initial: value,
                withTime: withTime,
                first: firstDate,
                last: lastDate,
              );
              if (picked != null) {
                field.didChange(picked);
                onChanged(picked);
              }
            },
            child: InputDecorator(
              isEmpty: value == null,
              decoration: InputDecoration(
                hintText: context.t.labelChoose,
                errorText: field.errorText,
                prefixIcon: const Icon(Icons.event_outlined, size: Sizes.icon),
              ),
              child: value == null
                  ? null
                  : Text(
                      withTime ? Fmt.dateTime(context, value!) : Fmt.date(context, value!),
                      style: context.text.bodyLarge,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Rounded search box with a clear button.
class SearchBox extends StatefulWidget {
  const SearchBox({
    super.key,
    required this.onChanged,
    this.hint,
    this.initial = '',
    this.autofocus = false,
  });

  final ValueChanged<String> onChanged;
  final String? hint;
  final String initial;
  final bool autofocus;

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  late final _c = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _c,
      autofocus: widget.autofocus,
      onChanged: (v) {
        setState(() {});
        widget.onChanged(v);
      },
      textInputAction: TextInputAction.search,
      style: context.text.bodyLarge,
      decoration: InputDecoration(
        hintText: widget.hint ?? context.t.labelSearchHint,
        filled: true,
        fillColor: AppColors.surface,
        prefixIcon: const Icon(Icons.search, size: Sizes.icon),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        suffixIcon: _c.text.isEmpty
            ? null
            : IconButton(
                tooltip: context.t.actionClearFilters,
                icon: const Icon(Icons.close, size: Sizes.icon),
                onPressed: () {
                  _c.clear();
                  setState(() {});
                  widget.onChanged('');
                },
              ),
      ),
    );
  }
}

/// A horizontally scrolling row of filter chips with optional counts.
class FilterChipsRow<T> extends StatelessWidget {
  const FilterChipsRow({
    super.key,
    required this.items,
    required this.selected,
    required this.onSelected,
  });

  final List<(T, String, int?)> items;
  final T selected;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final pad = Space.page(context);
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: pad),
        itemCount: items.length,
        separatorBuilder: (_, _) => Space.gapSm,
        itemBuilder: (context, i) {
          final (value, label, count) = items[i];
          final on = value == selected;
          return Center(
            child: ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(label),
                  if (count != null) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: on ? Colors.white.withValues(alpha: 0.22) : AppColors.track,
                        borderRadius: Corners.pillAll,
                      ),
                      child: Text(
                        '$count',
                        style: context.text.labelSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: on ? Colors.white : AppColors.neutralText,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              selected: on,
              labelStyle: context.text.labelMedium?.copyWith(
                color: on ? Colors.white : AppColors.text,
              ),
              onSelected: (_) => onSelected(value),
            ),
          );
        },
      ),
    );
  }
}

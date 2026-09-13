import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';

/// Tappable chips for picking several items. Selected chips are filled and
/// carry a tick, so the choice never depends on colour alone.
class CheckChips extends StatelessWidget {
  const CheckChips({
    super.key,
    required this.options,
    required this.selected,
    required this.onToggle,
  });

  /// Value and label of each chip.
  final List<(String, String)> options;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: Space.sm,
      runSpacing: Space.sm,
      children: [
        for (final (id, label) in options)
          FilterChip(
            label: Text(label),
            selected: selected.contains(id),
            showCheckmark: true,
            checkmarkColor: Colors.white,
            labelStyle: context.text.labelMedium
                ?.copyWith(color: selected.contains(id) ? Colors.white : AppColors.text),
            onSelected: (_) => onToggle(id),
          ),
      ],
    );
  }
}

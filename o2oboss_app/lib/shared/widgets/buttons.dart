import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';

/// Button kinds - primary uses ORANGE for main actions
enum ButtonKind { primary, secondary, danger, success, text }

/// The one button used for actions. Shows a spinner while its async action
/// runs and ignores extra taps, so nothing is submitted twice.
class AppButton extends StatefulWidget {
  const AppButton(
    this.label, {
    super.key,
    required this.onPressed,
    this.icon,
    this.kind = ButtonKind.primary,
    this.expand = true,
  });

  const AppButton.secondary(
    this.label, {
    super.key,
    required this.onPressed,
    this.icon,
    this.expand = true,
  }) : kind = ButtonKind.secondary;

  const AppButton.danger(
    this.label, {
    super.key,
    required this.onPressed,
    this.icon,
    this.expand = true,
  }) : kind = ButtonKind.danger;

  final String label;
  final FutureOr<void> Function()? onPressed;
  final IconData? icon;
  final ButtonKind kind;
  final bool expand;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _busy = false;

  Future<void> _tap() async {
    if (_busy || widget.onPressed == null) return;
    HapticFeedback.lightImpact(); // Premium haptic feedback
    final result = widget.onPressed!();
    if (result is Future) {
      setState(() => _busy = true);
      try {
        await result;
      } finally {
        if (mounted) setState(() => _busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    final light = widget.kind == ButtonKind.primary ||
        widget.kind == ButtonKind.danger ||
        widget.kind == ButtonKind.success;
    final content = _busy
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              color: light ? Colors.white : AppColors.primary,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: 20),
                const SizedBox(width: Space.sm),
              ],
              Flexible(
                child: Text(widget.label, maxLines: 2, textAlign: TextAlign.center),
              ),
            ],
          );
    final onPressed = enabled ? _tap : null;
    // Primary buttons use ORANGE (accent color) for important actions
    final Widget button = switch (widget.kind) {
      ButtonKind.primary => FilledButton(
          style: FilledButton.styleFrom(backgroundColor: AppColors.accent),
          onPressed: onPressed,
          child: content,
        ),
      ButtonKind.danger => FilledButton(
          style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
          onPressed: onPressed,
          child: content,
        ),
      ButtonKind.success => FilledButton(
          style: FilledButton.styleFrom(backgroundColor: AppColors.success),
          onPressed: onPressed,
          child: content,
        ),
      ButtonKind.secondary => OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: BorderSide(color: AppColors.primary),
          ),
          onPressed: onPressed,
          child: content,
        ),
      ButtonKind.text => TextButton(onPressed: onPressed, child: content),
    };
    return Semantics(
      button: true,
      enabled: enabled && !_busy,
      child: widget.expand ? SizedBox(width: double.infinity, child: button) : button,
    );
  }
}

/// Clean quick action card - simple flat design, no gradients or heavy shadows
class QuickAction extends StatelessWidget {
  const QuickAction({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.badge = 0,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final int badge;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: Corners.lgAll,
        side: BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Badge(
                isLabelVisible: badge > 0,
                label: Text('$badge'),
                child: Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: Corners.mdAll,
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 22),
                ),
              ),
              Space.gapSm,
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Round "+" button for adding something to a list. The label becomes the
/// tooltip and what screen readers announce, so the button itself stays
/// small and never grows with a long translation.
/// Clean FAB button - uses orange accent for important add actions
class AddFab extends StatelessWidget {
  const AddFab({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      tooltip: label,
      backgroundColor: AppColors.accent,
      elevation: 2,
      onPressed: () {
        HapticFeedback.mediumImpact();
        onPressed();
      },
      child: const Icon(Icons.add, size: 28, color: Colors.white),
    );
  }
}



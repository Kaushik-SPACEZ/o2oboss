import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';

enum ButtonKind { primary, secondary, danger, success, text, premium }

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
    final Widget button = switch (widget.kind) {
      ButtonKind.primary => FilledButton(onPressed: onPressed, child: content),
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
      ButtonKind.secondary => OutlinedButton(onPressed: onPressed, child: content),
      ButtonKind.text => TextButton(onPressed: onPressed, child: content),
      ButtonKind.premium => _PremiumGradientButton(onPressed: onPressed, child: content),
    };
    return Semantics(
      button: true,
      enabled: enabled && !_busy,
      child: widget.expand ? SizedBox(width: double.infinity, child: button) : button,
    );
  }
}

/// Square-ish quick action: icon on a tinted tile with a short label below - Premium with shadows
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: Corners.lgAll,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 1)),
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Material(
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
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primaryLight, AppColors.primary.withOpacity(0.15)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: Corners.mdAll,
                      boxShadow: [
                        BoxShadow(color: AppColors.primary.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2)),
                      ],
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
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Round "+" button for adding something to a list. The label becomes the
/// tooltip and what screen readers announce, so the button itself stays
/// small and never grows with a long translation.
class AddFab extends StatelessWidget {
  const AddFab({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: FloatingActionButton(
        heroTag: null,
        tooltip: label,
        backgroundColor: Colors.transparent,
        elevation: 0,
        onPressed: () {
          HapticFeedback.mediumImpact();
          onPressed();
        },
        child: const Icon(Icons.add, size: 28, color: Colors.white),
      ),
    );
  }
}

/// Premium gradient button internal widget
class _PremiumGradientButton extends StatelessWidget {
  const _PremiumGradientButton({required this.onPressed, required this.child});
  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Sizes.buttonHeight,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: Corners.mdAll,
        boxShadow: [
          BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: Corners.mdAll,
          splashColor: Colors.white.withOpacity(0.2),
          child: Center(
            child: DefaultTextStyle(
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
              child: IconTheme(data: const IconThemeData(color: Colors.white, size: 20), child: child),
            ),
          ),
        ),
      ),
    );
  }
}

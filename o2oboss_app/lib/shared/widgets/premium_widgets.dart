import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';

/// O2O Boss brand colors - Simple, clean, no excessive effects
/// Design: 70% White/neutrals, 20% Blue (structure), 10% Orange (actions)
abstract final class BrandColors {
  // Primary brand colors from theme spec
  static const orange = Color(0xFFF15E21); // Primary action color
  static const orangeHover = Color(0xFFD94F16);
  static const royalBlue = Color(0xFF2A4D9F); // Structure color
  static const deepBlue = Color(0xFF16369D);
}

/// Simple card - clean white with subtle border
/// No glassmorphism, no heavy shadows - just clean and readable
class SimpleCard extends StatelessWidget {
  const SimpleCard({super.key, required this.child, this.padding, this.margin, this.color});
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(Space.md),
      decoration: BoxDecoration(
        color: color ?? AppColors.surface,
        borderRadius: Corners.mdAll,
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}

// Keep GlassCard as alias for backward compatibility but make it simple
class GlassCard extends SimpleCard {
  const GlassCard({super.key, required super.child, super.padding, super.margin, double blur = 10, double opacity = 0.1});
}

/// Shimmer loading effect
class ShimmerLoading extends StatefulWidget {
  const ShimmerLoading({super.key, this.width, this.height = 16, this.borderRadius});
  final double? width;
  final double height;
  final BorderRadius? borderRadius;

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this)..repeat();
    _animation = Tween<double>(begin: -2, end: 2).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? Corners.smAll,
            gradient: LinearGradient(
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value, 0),
              colors: const [Color(0xFFEEEEEE), Color(0xFFF5F5F5), Color(0xFFEEEEEE)],
            ),
          ),
        );
      },
    );
  }
}

/// Shimmer card placeholder
class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key, this.height = 100});
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(Space.md),
      decoration: BoxDecoration(color: Colors.white, borderRadius: Corners.mdAll, border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const ShimmerLoading(width: 36, height: 36, borderRadius: BorderRadius.all(Radius.circular(18))),
          const SizedBox(width: Space.sm),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
            ShimmerLoading(width: 100, height: 12),
            SizedBox(height: 6),
            ShimmerLoading(width: 70, height: 10),
          ])),
        ]),
        const Spacer(),
        const ShimmerLoading(height: 10),
        const SizedBox(height: 6),
        const ShimmerLoading(width: 150, height: 10),
      ]),
    );
  }
}

/// Clean card with tappable support - no heavy shadows
class PremiumCard extends StatelessWidget {
  const PremiumCard({super.key, required this.child, this.padding, this.margin, this.onTap, this.gradient, this.showGoldAccent = false});
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final VoidCallback? onTap;
  final Gradient? gradient; // Ignored - kept for backward compat
  final bool showGoldAccent; // Ignored - kept for backward compat

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(vertical: Space.xs),
      child: Material(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: Corners.mdAll,
          side: BorderSide(color: AppColors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap != null ? () { HapticFeedback.selectionClick(); onTap?.call(); } : null,
          borderRadius: Corners.mdAll,
          child: Padding(
            padding: padding ?? const EdgeInsets.all(Space.md),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Clean solid button - uses ORANGE for primary actions
class PremiumButton extends StatelessWidget {
  const PremiumButton({super.key, required this.onPressed, required this.child, this.width, this.height = 44, this.isLoading = false});
  final VoidCallback? onPressed;
  final Widget child;
  final double? width;
  final double height;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.accent, // Orange for actions
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: Corners.mdAll),
        ),
        onPressed: isLoading ? null : () { HapticFeedback.lightImpact(); onPressed?.call(); },
        child: isLoading
            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
            : child,
      ),
    );
  }
}

/// Simple styled text - no gradients
class GradientText extends StatelessWidget {
  const GradientText(this.text, {super.key, this.style, this.gradient});
  final String text;
  final TextStyle? style;
  final Gradient? gradient; // Ignored for simplicity

  @override
  Widget build(BuildContext context) {
    return Text(
      text, 
      style: (style ?? const TextStyle()).copyWith(
        color: AppColors.primary, // Royal blue for emphasis
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

/// Simple badge - clean with light background
class PremiumBadge extends StatelessWidget {
  const PremiumBadge({super.key, required this.label, this.icon, this.isGold = false});
  final String label;
  final IconData? icon;
  final bool isGold; // Ignored - all badges use brand colors

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: Corners.pillAll,
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (icon != null) ...[Icon(icon, size: 12, color: AppColors.primary), const SizedBox(width: 4)],
        Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primaryDark)),
      ]),
    );
  }
}

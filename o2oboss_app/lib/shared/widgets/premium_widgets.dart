import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';

/// Premium color constants
abstract final class PremiumColors {
  static const gold = Color(0xFFD4AF37);
  static const goldLight = Color(0xFFF5E6C8);
  static const goldDark = Color(0xFFB8960C);
  static const premiumBlueStart = Color(0xFF2563EB);
  static const premiumBlueEnd = Color(0xFF1E40AF);
}

/// Glass morphism card with frosted glass effect
class GlassCard extends StatelessWidget {
  const GlassCard({super.key, required this.child, this.padding, this.margin, this.blur = 10, this.opacity = 0.1});
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double blur;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: Corners.mdAll,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding ?? const EdgeInsets.all(Space.md),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(opacity),
              borderRadius: Corners.mdAll,
              border: Border.all(color: Colors.white.withOpacity(0.2)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
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

/// Premium card with layered shadows
class PremiumCard extends StatelessWidget {
  const PremiumCard({super.key, required this.child, this.padding, this.margin, this.onTap, this.gradient, this.showGoldAccent = false});
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final VoidCallback? onTap;
  final Gradient? gradient;
  final bool showGoldAccent;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(vertical: Space.xs),
      decoration: BoxDecoration(
        borderRadius: Corners.mdAll,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 1)),
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap != null ? () { HapticFeedback.selectionClick(); onTap?.call(); } : null,
          borderRadius: Corners.mdAll,
          child: Container(
            padding: padding ?? const EdgeInsets.all(Space.md),
            decoration: BoxDecoration(
              gradient: gradient,
              color: gradient == null ? AppColors.surface : null,
              borderRadius: Corners.mdAll,
              border: showGoldAccent ? Border.all(color: PremiumColors.gold.withOpacity(0.3)) : Border.all(color: AppColors.border),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Premium gradient button
class PremiumButton extends StatelessWidget {
  const PremiumButton({super.key, required this.onPressed, required this.child, this.width, this.height = 44, this.isLoading = false});
  final VoidCallback? onPressed;
  final Widget child;
  final double? width;
  final double height;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [PremiumColors.premiumBlueStart, PremiumColors.premiumBlueEnd]),
        borderRadius: Corners.mdAll,
        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : () { HapticFeedback.lightImpact(); onPressed?.call(); },
          borderRadius: Corners.mdAll,
          child: Center(
            child: isLoading
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : DefaultTextStyle(style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13), child: child),
          ),
        ),
      ),
    );
  }
}

/// Gradient text
class GradientText extends StatelessWidget {
  const GradientText(this.text, {super.key, this.style, this.gradient});
  final String text;
  final TextStyle? style;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => (gradient ?? const LinearGradient(colors: [PremiumColors.premiumBlueStart, PremiumColors.premiumBlueEnd])).createShader(bounds),
      child: Text(text, style: (style ?? const TextStyle()).copyWith(color: Colors.white)),
    );
  }
}

/// Premium badge
class PremiumBadge extends StatelessWidget {
  const PremiumBadge({super.key, required this.label, this.icon, this.isGold = false});
  final String label;
  final IconData? icon;
  final bool isGold;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: isGold ? const LinearGradient(colors: [PremiumColors.goldLight, PremiumColors.gold]) : LinearGradient(colors: [AppColors.primaryLight, AppColors.primary.withOpacity(0.2)]),
        borderRadius: Corners.pillAll,
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (icon != null) ...[Icon(icon, size: 10, color: isGold ? PremiumColors.goldDark : AppColors.primaryDark), const SizedBox(width: 3)],
        Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: isGold ? PremiumColors.goldDark : AppColors.primaryDark)),
      ]),
    );
  }
}

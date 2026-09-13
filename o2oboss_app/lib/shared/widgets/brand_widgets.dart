import 'dart:ui';
import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/brand/brand_philosophy.dart';

/// Animated tagline banner for login/auth screens - Premium glass effect
class TaglineBanner extends StatelessWidget {
  const TaglineBanner({super.key, this.compact = false});
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: Corners.mdAll,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: EdgeInsets.all(compact ? Space.sm : Space.md),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryLight.withOpacity(0.8), AppColors.primaryLight.withOpacity(0.4)],
              begin: Alignment.topLeft, end: Alignment.bottomRight,
            ),
            borderRadius: Corners.mdAll,
            border: Border.all(color: Colors.white.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(color: AppColors.primary.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            children: [
              Text(kTaglinePrimary,
                textAlign: TextAlign.center,
                style: context.text.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold, color: AppColors.primaryDark, letterSpacing: 0.3,
                )),
              SizedBox(height: compact ? 2 : Space.xs),
              Text(kTaglineSecondary,
                textAlign: TextAlign.center,
                style: context.text.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic, color: AppColors.textSecondary, height: 1.3,
                )),
            ],
          ),
        ),
      ),
    );
  }
}

/// Inspirational quote card for home screens (role-specific) - Premium with layered shadows
class InspirationCard extends StatelessWidget {
  const InspirationCard({super.key, required this.title, required this.subtitle, this.icon, this.gradient});
  final String title;
  final String subtitle;
  final IconData? icon;
  final List<Color>? gradient;

  @override
  Widget build(BuildContext context) {
    final colors = gradient ?? [AppColors.primary.withOpacity(0.1), AppColors.primaryLight];
    return Container(
      margin: const EdgeInsets.symmetric(vertical: Space.xs),
      decoration: BoxDecoration(
        borderRadius: Corners.mdAll,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 1)),
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: ClipRRect(
        borderRadius: Corners.mdAll,
        child: Container(
          padding: const EdgeInsets.all(Space.md),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: Corners.mdAll,
            border: Border.all(color: Colors.white.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(Space.xs),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.15), blurRadius: 6, offset: const Offset(0, 2))],
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 18),
                ),
                Space.gapSm,
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: context.text.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: AppColors.primaryDark, fontSize: 14)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: context.text.bodySmall?.copyWith(fontStyle: FontStyle.italic, color: AppColors.textSecondary, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Abundance motto banner for signup screens
class AbundanceBanner extends StatelessWidget {
  const AbundanceBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Space.md, horizontal: Space.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryLight, AppColors.primaryLight.withValues(alpha: 0.5)],
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
        ),
        borderRadius: Corners.mdAll,
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(kMottoAbundance, textAlign: TextAlign.center,
            style: context.text.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryDark, fontSize: 16)),
          const SizedBox(height: 2),
          Text(kMottoAbundanceSub, textAlign: TextAlign.center,
            style: context.text.bodySmall?.copyWith(fontStyle: FontStyle.italic, color: AppColors.primary, fontSize: 12)),
        ],
      ),
    );
  }
}

/// Culture code banner
class CultureCodeBanner extends StatelessWidget {
  const CultureCodeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Space.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [const Color(0xFFE8F5E9), const Color(0xFFC8E6C9)]),
        borderRadius: Corners.mdAll,
      ),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.groups, color: Color(0xFF2E7D32), size: 16),
          Space.gapXs,
          Text(kCultureCodeTitle, style: context.text.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF2E7D32), fontSize: 13)),
        ]),
        Space.gapSm,
        Text(kCultureCodeRespect, textAlign: TextAlign.center,
          style: context.text.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: const Color(0xFF1B5E20), fontSize: 12)),
        const SizedBox(height: 2),
        Text(kCultureCodeBeliefs, textAlign: TextAlign.center,
          style: context.text.bodySmall?.copyWith(fontStyle: FontStyle.italic, color: const Color(0xFF388E3C), fontSize: 11)),
      ]),
    );
  }
}

/// CARING values expandable card for profile screens
class CaringValuesCard extends StatefulWidget {
  const CaringValuesCard({super.key});
  @override
  State<CaringValuesCard> createState() => _CaringValuesCardState();
}

class _CaringValuesCardState extends State<CaringValuesCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: Space.sm),
      decoration: BoxDecoration(
        color: AppColors.surface, borderRadius: Corners.mdAll,
        border: Border.all(color: AppColors.washBorder),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 2)],
      ),
      child: Column(children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          borderRadius: Corners.mdAll,
          child: Padding(
            padding: const EdgeInsets.all(Space.md),
            child: Row(children: [
              Container(
                padding: const EdgeInsets.all(Space.xs),
                decoration: BoxDecoration(color: AppColors.successLight, borderRadius: Corners.smAll),
                child: const Icon(Icons.favorite, color: AppColors.success, size: 18),
              ),
              Space.gapSm,
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(kCoreValuesTitle, style: context.text.bodyMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 13)),
                Text('Tap to explore our values', style: context.text.bodySmall?.copyWith(color: AppColors.textSecondary, fontSize: 11)),
              ])),
              Icon(_expanded ? Icons.expand_less : Icons.expand_more, color: AppColors.textSecondary, size: 18),
            ]),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: _buildValues(context),
          crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 250),
        ),
      ]),
    );
  }

  Widget _buildValues(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Space.md, 0, Space.md, Space.md),
      child: Column(children: [
        const Divider(height: 1), Space.gapXs,
        for (final v in kCaringValues)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: 20, height: 20, alignment: Alignment.center,
                decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                child: Text(v.letter, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
              ),
              Space.gapSm,
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(v.word, style: context.text.bodySmall?.copyWith(fontWeight: FontWeight.w600, fontSize: 12)),
                Text('— ${v.meaning}', style: context.text.bodySmall?.copyWith(fontStyle: FontStyle.italic, color: AppColors.textSecondary, fontSize: 10)),
              ])),
            ]),
          ),
      ]),
    );
  }
}

/// Vision section for About page
class VisionSection extends StatelessWidget {
  const VisionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Space.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [const Color(0xFFE3F2FD), const Color(0xFFBBDEFB)]),
        borderRadius: Corners.mdAll,
      ),
      child: Column(children: [
        const Icon(Icons.visibility, color: Color(0xFF1565C0), size: 28),
        Space.gapSm,
        Text(kVisionTitle, style: context.text.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1565C0), fontSize: 14)),
        Space.gapSm,
        Text(kVisionText, textAlign: TextAlign.center, style: context.text.bodySmall?.copyWith(fontStyle: FontStyle.italic, height: 1.4, fontSize: 12)),
      ]),
    );
  }
}

/// Philosophy card with Sanskrit
class PhilosophyCard extends StatelessWidget {
  const PhilosophyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Space.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [const Color(0xFFFCE4EC), const Color(0xFFF8BBD9)]),
        borderRadius: Corners.mdAll,
      ),
      child: Column(children: [
        Text(kPhilosophySanskrit, style: context.text.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFFC2185B), fontSize: 14)),
        const SizedBox(height: 4),
        Text(kPhilosophyText, textAlign: TextAlign.center, style: context.text.bodySmall?.copyWith(fontStyle: FontStyle.italic, color: const Color(0xFF880E4F), fontSize: 12)),
      ]),
    );
  }
}

/// INDIA acronym display
class IndiaAcronymCard extends StatelessWidget {
  const IndiaAcronymCard({super.key, this.expanded = false});
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Space.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.primaryLight, AppColors.primaryLight.withValues(alpha: 0.5)]),
        borderRadius: Corners.mdAll,
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          for (final c in kIndiaAcronym.split(''))
            Container(
              width: 28, height: 28, margin: const EdgeInsets.symmetric(horizontal: 2),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: Corners.smAll,
              ),
              child: Text(c, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
            ),
        ]),
        Space.gapSm,
        Text(kIndiaFull, textAlign: TextAlign.center, style: context.text.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: AppColors.primaryDark, fontSize: 12)),
        if (expanded) ...[
          Space.gapSm, const Divider(height: 1), Space.gapXs,
          for (final p in kIndiaPoints.take(5))
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(Icons.check_circle, color: AppColors.primary, size: 14),
                Space.gapXs,
                Expanded(child: Text(p, style: context.text.bodySmall?.copyWith(fontSize: 11))),
              ]),
            ),
        ],
      ]),
    );
  }
}

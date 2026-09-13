import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/brand/brand_philosophy.dart';

/// Animated tagline banner for login/auth screens
class TaglineBanner extends StatelessWidget {
  const TaglineBanner({super.key, this.compact = false});
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(compact ? Space.md : Space.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryLight.withOpacity(0.6), AppColors.primaryLight.withOpacity(0.2)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: Corners.lgAll,
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(kTaglinePrimary,
            textAlign: TextAlign.center,
            style: context.text.titleLarge?.copyWith(
              fontWeight: FontWeight.bold, color: AppColors.primaryDark, letterSpacing: 0.5,
            )),
          SizedBox(height: compact ? Space.xs : Space.sm),
          Text(kTaglineSecondary,
            textAlign: TextAlign.center,
            style: context.text.bodyMedium?.copyWith(
              fontStyle: FontStyle.italic, color: AppColors.textSecondary, height: 1.4,
            )),
        ],
      ),
    );
  }
}

/// Inspirational quote card for home screens (role-specific)
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
      margin: const EdgeInsets.symmetric(vertical: Space.sm),
      padding: const EdgeInsets.all(Space.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: Corners.lgAll,
        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(Space.sm),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.8), shape: BoxShape.circle),
              child: Icon(icon, color: AppColors.primary, size: 24),
            ),
            Space.gapMd,
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.text.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                Space.gapXs,
                Text(subtitle, style: context.text.bodySmall?.copyWith(fontStyle: FontStyle.italic, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
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
      padding: const EdgeInsets.symmetric(vertical: Space.lg, horizontal: Space.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryLight, AppColors.primaryLight.withValues(alpha: 0.5)],
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
        ),
        borderRadius: Corners.lgAll,
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(kMottoAbundance, textAlign: TextAlign.center,
            style: context.text.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
          Space.gapXs,
          Text(kMottoAbundanceSub, textAlign: TextAlign.center,
            style: context.text.titleMedium?.copyWith(fontStyle: FontStyle.italic, color: AppColors.primary)),
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
      padding: const EdgeInsets.all(Space.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [const Color(0xFFE8F5E9), const Color(0xFFC8E6C9)]),
        borderRadius: Corners.lgAll,
      ),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.groups, color: Color(0xFF2E7D32), size: 20),
          Space.gapSm,
          Text(kCultureCodeTitle, style: context.text.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF2E7D32))),
        ]),
        Space.gapMd,
        Text(kCultureCodeRespect, textAlign: TextAlign.center,
          style: context.text.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: const Color(0xFF1B5E20))),
        Space.gapSm,
        Text(kCultureCodeBeliefs, textAlign: TextAlign.center,
          style: context.text.bodySmall?.copyWith(fontStyle: FontStyle.italic, color: const Color(0xFF388E3C))),
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
      margin: const EdgeInsets.symmetric(vertical: Space.md),
      decoration: BoxDecoration(
        color: AppColors.surface, borderRadius: Corners.lgAll,
        border: Border.all(color: AppColors.washBorder),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
      ),
      child: Column(children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          borderRadius: Corners.lgAll,
          child: Padding(
            padding: const EdgeInsets.all(Space.lg),
            child: Row(children: [
              Container(
                padding: const EdgeInsets.all(Space.sm),
                decoration: BoxDecoration(color: AppColors.successLight, borderRadius: Corners.mdAll),
                child: const Icon(Icons.favorite, color: AppColors.success, size: 24),
              ),
              Space.gapMd,
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(kCoreValuesTitle, style: context.text.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                Text('Tap to explore our values', style: context.text.bodySmall?.copyWith(color: AppColors.textSecondary)),
              ])),
              Icon(_expanded ? Icons.expand_less : Icons.expand_more, color: AppColors.textSecondary),
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
      padding: const EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, Space.lg),
      child: Column(children: [
        const Divider(), Space.gapSm,
        for (final v in kCaringValues)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Space.xs),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: 28, height: 28, alignment: Alignment.center,
                decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                child: Text(v.letter, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              ),
              Space.gapMd,
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(v.word, style: context.text.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                Text('— ${v.meaning}', style: context.text.bodySmall?.copyWith(fontStyle: FontStyle.italic, color: AppColors.textSecondary)),
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
      padding: const EdgeInsets.all(Space.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [const Color(0xFFE3F2FD), const Color(0xFFBBDEFB)]),
        borderRadius: Corners.lgAll,
      ),
      child: Column(children: [
        const Icon(Icons.visibility, color: Color(0xFF1565C0), size: 40),
        Space.gapMd,
        Text(kVisionTitle, style: context.text.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1565C0))),
        Space.gapMd,
        Text(kVisionText, textAlign: TextAlign.center, style: context.text.bodyLarge?.copyWith(fontStyle: FontStyle.italic, height: 1.5)),
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
      padding: const EdgeInsets.all(Space.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [const Color(0xFFFCE4EC), const Color(0xFFF8BBD9)]),
        borderRadius: Corners.lgAll,
      ),
      child: Column(children: [
        Text(kPhilosophySanskrit, style: context.text.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFFC2185B))),
        Space.gapSm,
        Text(kPhilosophyText, textAlign: TextAlign.center, style: context.text.titleMedium?.copyWith(fontStyle: FontStyle.italic, color: const Color(0xFF880E4F))),
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
      padding: const EdgeInsets.all(Space.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.primaryLight, AppColors.primaryLight.withValues(alpha: 0.5)]),
        borderRadius: Corners.lgAll,
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          for (final c in kIndiaAcronym.split(''))
            Container(
              width: 36, height: 36, margin: const EdgeInsets.symmetric(horizontal: 2),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: Corners.smAll,
              ),
              child: Text(c, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
            ),
        ]),
        Space.gapMd,
        Text(kIndiaFull, textAlign: TextAlign.center, style: context.text.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: AppColors.primaryDark)),
        if (expanded) ...[
          Space.gapMd, const Divider(), Space.gapSm,
          for (final p in kIndiaPoints.take(5))
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Space.xs),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(Icons.check_circle, color: AppColors.primary, size: 18),
                Space.gapSm,
                Expanded(child: Text(p, style: context.text.bodySmall)),
              ]),
            ),
        ],
      ]),
    );
  }
}

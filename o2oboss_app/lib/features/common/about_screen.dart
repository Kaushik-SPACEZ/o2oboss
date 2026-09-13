import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/brand/brand_philosophy.dart';
import '../../shared/widgets/brand_widgets.dart';
import '../../shared/widgets/layout.dart';
import '../../shared/widgets/pills.dart';

/// About O2O Boss - Full company philosophy and values
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'About O2O Boss',
      children: [
        // Brand Mark and Tagline
        Center(child: BrandMark(size: 48)),
        Space.gapLg,
        const TaglineBanner(),
        Space.gapXxl,
        
        // Vision Section
        const VisionSection(),
        Space.gapXl,
        
        // Philosophy
        const PhilosophyCard(),
        Space.gapXl,
        
        // Work Philosophy
        _buildSection(context, kWorkPhilosophyTitle, kWorkPhilosophyText, Icons.work, const Color(0xFF7B1FA2)),
        Space.gapXl,
        
        // INDIA Acronym
        const IndiaAcronymCard(expanded: true),
        Space.gapXl,
        
        // Objectives
        _buildObjectives(context),
        Space.gapXl,
        
        // Vocal for Local Quote
        _buildQuote(context, kVocalForLocalQuote),
        Space.gapXl,
        
        // CARING Values
        const CaringValuesCard(),
        Space.gapXl,
        
        // Culture Code
        const CultureCodeBanner(),
        Space.gapXxl,
        
        // Footer
        Center(
          child: Column(children: [
            Text('© 2024 O2O Boss', style: context.text.bodySmall?.copyWith(color: AppColors.textSecondary)),
            Space.gapXs,
            Text(kQpsRights, style: context.text.labelSmall?.copyWith(color: AppColors.primary)),
          ]),
        ),
      ],
    );
  }

  Widget _buildSection(BuildContext context, String title, String body, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(Space.lg),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: Corners.lgAll,
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(children: [
        Icon(icon, color: color, size: 32),
        Space.gapMd,
        Text(title, style: context.text.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: color)),
        Space.gapSm,
        Text(body, textAlign: TextAlign.center, style: context.text.bodyLarge?.copyWith(fontStyle: FontStyle.italic)),
      ]),
    );
  }

  Widget _buildObjectives(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Space.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [const Color(0xFFE8F5E9), const Color(0xFFC8E6C9)]),
        borderRadius: Corners.lgAll,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.flag, color: Color(0xFF2E7D32)),
          Space.gapSm,
          Text(kObjectivesTitle, style: context.text.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF2E7D32))),
        ]),
        Space.gapMd,
        for (final obj in kObjectives)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Space.xs),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 18),
              Space.gapSm,
              Expanded(child: Text(obj, style: context.text.bodyMedium)),
            ]),
          ),
      ]),
    );
  }

  Widget _buildQuote(BuildContext context, String quote) {
    return Container(
      padding: const EdgeInsets.all(Space.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [const Color(0xFFFF9800).withOpacity(0.15), const Color(0xFFFFB74D).withOpacity(0.15)]),
        borderRadius: Corners.lgAll,
        border: Border.all(color: const Color(0xFFFF9800).withOpacity(0.4)),
      ),
      child: Column(children: [
        const Icon(Icons.format_quote, color: Color(0xFFFF9800), size: 32),
        Space.gapSm,
        Text(quote, textAlign: TextAlign.center, style: context.text.titleMedium?.copyWith(fontStyle: FontStyle.italic, fontWeight: FontWeight.w600, color: const Color(0xFFE65100))),
      ]),
    );
  }
}

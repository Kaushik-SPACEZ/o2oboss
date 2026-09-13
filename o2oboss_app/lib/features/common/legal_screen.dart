import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/data/app_store.dart';
import '../../core/l10n/l10n.dart';
import '../../shared/widgets/cards.dart';
import '../../shared/widgets/layout.dart';

/// Terms of use and privacy policy. Placeholder wording for the prototype;
/// the real text comes from O2O Boss's legal team.
class LegalScreen extends ConsumerWidget {
  const LegalScreen({super.key, required this.doc});

  final String doc;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final version = ref.watch(configProvider.select((c) => c.termsVersion));
    final privacy = doc == 'privacy';
    final sections = privacy
        ? [
            (t.privacy1Title, t.privacy1Body),
            (t.privacy2Title, t.privacy2Body),
            (t.privacy3Title, t.privacy3Body),
            (t.privacy4Title, t.privacy4Body),
          ]
        : [
            (t.terms1Title, t.terms1Body),
            (t.terms2Title, t.terms2Body),
            (t.terms3Title, t.terms3Body),
            (t.terms4Title, t.terms4Body),
          ];
    return PageScaffold(
      title: privacy ? t.legalPrivacy : t.legalTerms,
      children: [
        Text(t.legalVersion(version),
            style: context.text.bodySmall?.copyWith(color: AppColors.textSecondary)),
        Space.gapLg,
        NoteCard(icon: Icons.science_outlined, tone: Tone.warning, text: t.legalDemoNote),
        for (final (title, body) in sections) ...[
          Space.gapXl,
          Text(title, style: context.text.titleSmall),
          Space.gapSm,
          Text(body, style: context.text.bodyMedium),
        ],
      ],
    );
  }
}

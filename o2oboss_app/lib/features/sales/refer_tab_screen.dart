import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/data/app_store.dart';
import '../../core/l10n/l10n.dart';
import '../../core/l10n/labels.dart';
import '../../core/models/models.dart';
import '../../core/utils/format.dart';
import '../../shared/widgets/buttons.dart';
import '../../shared/widgets/cards.dart';
import '../../shared/widgets/layout.dart';
import '../../shared/widgets/tones.dart';

/// The Refer tab: pick what the customer needs to start a referral. The same
/// grid is used by customers to post a new requirement.
class ReferTabScreen extends ConsumerWidget {
  const ReferTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final config = ref.watch(configProvider);
    return PageScaffold(
      title: t.referTabTitle,
      children: [
        Text(t.referTabSubtitle,
            style: context.text.bodyMedium?.copyWith(color: AppColors.textSecondary)),
        Space.gapLg,
        const CategoryGrid(),
        Space.gapLg,
        AppButton.secondary(
          t.referNotSure,
          icon: Icons.edit_note,
          onPressed: () => context.push(Routes.refer()),
        ),
        SectionHeader(t.referHowTitle),
        AppCard(
          child: StepsList(steps: [
            (t.referHow1Title, t.referHow1Body),
            (t.referHow2Title, t.referHow2Body),
            (t.referHow3Title, t.referHow3Body),
          ]),
        ),
        Space.gapLg,
        NoteCard(
          icon: Icons.verified_user_outlined,
          text: t.referRulesBody(
            Fmt.percent(config.salesCommissionPercent),
            triggerSentence(t, config.commissionTrigger),
            '${config.referralProtectionDays}',
          ),
        ),
      ],
    );
  }
}

/// Category tiles. Tapping one starts the referral form with it chosen.
class CategoryGrid extends ConsumerWidget {
  const CategoryGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories =
        ref.watch(dbProvider.select((db) => db.categories.where((c) => c.active).toList()));
    return ResponsiveGrid(
      minItemWidth: 100,
      spacing: Space.sm,
      children: [
        for (final c in categories) _CategoryTile(category: c),
      ],
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category});

  final ServiceCategory category;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => context.push(Routes.refer(category: category.id)),
      padding: const EdgeInsets.symmetric(horizontal: Space.sm, vertical: Space.lg),
      child: Column(
        children: [
          Icon(categoryIcon(category.icon), color: AppColors.primary, size: 28),
          Space.gapSm,
          Text(
            category.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.text.labelMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

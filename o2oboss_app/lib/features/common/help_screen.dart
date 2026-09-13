import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/data/app_store.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../shared/widgets/buttons.dart';
import '../../shared/widgets/feedback.dart';
import '../../shared/widgets/layout.dart';

/// Short answers for the person's role and a way to reach support.
class HelpScreen extends ConsumerWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final role = ref.watch(currentUserProvider)?.role;
    final faqs = <(String, String)>[
      ...switch (role) {
        UserRole.sales => [
            (t.faqSales1Q, t.faqSales1A),
            (t.faqSales2Q, t.faqSales2A),
            (t.faqSales3Q, t.faqSales3A),
          ],
        UserRole.vendor => [
            (t.faqVendor1Q, t.faqVendor1A),
            (t.faqVendor2Q, t.faqVendor2A),
            (t.faqVendor3Q, t.faqVendor3A),
          ],
        UserRole.customer => [
            (t.faqCustomer1Q, t.faqCustomer1A),
            (t.faqCustomer2Q, t.faqCustomer2A),
            (t.faqCustomer3Q, t.faqCustomer3A),
          ],
        UserRole.backOffice || UserRole.franchise || UserRole.admin => [
            (t.faqOps1Q, t.faqOps1A),
            (t.faqOps2Q, t.faqOps2A),
          ],
        null => [(t.faqLogin1Q, t.faqLogin1A)],
      },
      (t.faqLanguageQ, t.faqLanguageA),
    ];
    return PageScaffold(
      title: t.helpTitle,
      children: [
        SectionHeader(t.helpFaqTitle, top: Space.sm),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (var i = 0; i < faqs.length; i++) ...[
                if (i > 0) const Divider(height: 1),
                ExpansionTile(
                  shape: const Border(),
                  collapsedShape: const Border(),
                  title: Text(faqs[i].$1, style: context.text.bodyLarge),
                  childrenPadding:
                      const EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, Space.lg),
                  expandedAlignment: AlignmentDirectional.centerStart,
                  children: [Text(faqs[i].$2, style: context.text.bodyMedium)],
                ),
              ],
            ],
          ),
        ),
        SectionHeader(t.helpContactTitle),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(t.helpContactBody, style: context.text.bodyMedium),
              Space.gapLg,
              AppButton(t.helpCall, icon: Icons.call_outlined,
                  onPressed: () => showToast(context, t.demoActionNote)),
              Space.gapMd,
              AppButton.secondary(t.helpEmail, icon: Icons.email_outlined,
                  onPressed: () => showToast(context, t.demoActionNote)),
            ],
          ),
        ),
      ],
    );
  }
}

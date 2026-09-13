import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/l10n/l10n.dart';
import '../../core/l10n/languages.dart';
import '../../core/l10n/locale_controller.dart';
import '../../shared/widgets/buttons.dart';
import '../../shared/widgets/feedback.dart';
import '../../shared/widgets/layout.dart';
import '../../shared/widgets/pills.dart';

/// First-launch language picker, also used from Settings. Languages are
/// listed by their own names, not flags (ux-designer: endonyms).
class LanguageScreen extends ConsumerStatefulWidget {
  const LanguageScreen({super.key, this.fromSettings = false});

  final bool fromSettings;

  @override
  ConsumerState<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends ConsumerState<LanguageScreen> {
  late String _selected =
      (ref.read(localeProvider) ?? deviceLocale()).languageCode;

  @override
  Widget build(BuildContext context) {
    // Preview the heading and button in the language being picked.
    final preview = lookupAppLocalizations(Locale(_selected));
    final pad = Space.page(context);
    return Scaffold(
      appBar: widget.fromSettings ? AppBar(title: Text(context.t.settingsLanguage)) : null,
      body: SafeArea(
        child: ContentWidth(
          child: ListView(
            padding: EdgeInsets.fromLTRB(pad, Space.xl, pad, Space.xxl),
            children: [
              if (!widget.fromSettings) ...[
                const BrandMark(size: 36),
                Space.gapXxl,
                Text(preview.langTitle, style: context.text.headlineSmall),
                if (_selected != 'en')
                  Text('Choose your language',
                      style: context.text.bodyMedium?.copyWith(color: AppColors.textSecondary)),
                Space.gapXs,
                Text(preview.langSubtitle, style: context.text.bodySmall),
                Space.gapXl,
              ],
              ResponsiveGrid(
                minItemWidth: 140,
                children: [
                  for (final lang in appLanguages)
                    _LanguageTile(
                      language: lang,
                      selected: lang.code == _selected,
                      onTap: () => setState(() => _selected = lang.code),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: StickyActions(
        children: [
          AppButton(preview.langContinue, onPressed: () async {
            await ref.read(localeProvider.notifier).choose(_selected);
            if (widget.fromSettings) {
              if (context.mounted) {
                showToast(context, lookupAppLocalizations(Locale(_selected)).toastSaved);
                context.pop();
              }
            } else {
              if (context.mounted) context.go('/login');
            }
          }),
        ],
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({required this.language, required this.selected, required this.onTap});

  final AppLanguage language;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      label: '${language.endonym}, ${language.englishName}',
      excludeSemantics: true,
      child: AppCard(
        onTap: onTap,
        color: selected ? AppColors.primaryLight : null,
        borderColor: selected ? AppColors.primary : null,
        padding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.md),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language.endonym,
                    style: context.text.titleMedium,
                    textDirection: language.rtl ? TextDirection.rtl : TextDirection.ltr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(language.englishName, style: context.text.bodySmall),
                ],
              ),
            ),
            Icon(
              selected ? Icons.check_circle : Icons.circle_outlined,
              color: selected ? AppColors.primary : AppColors.borderStrong,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../app/theme/theme_controller.dart';
import '../../core/data/app_store.dart';
import '../../core/data/db_queries.dart';
import '../../core/l10n/l10n.dart';
import '../../core/l10n/labels.dart';
import '../../core/l10n/languages.dart';
import '../../core/models/models.dart';
import '../../core/utils/format.dart';
import '../../shared/widgets/brand_widgets.dart';
import '../../shared/widgets/feedback.dart';
import '../../shared/widgets/layout.dart';
import '../../shared/widgets/pills.dart';
import '../../shared/widgets/rows.dart';
import '../../shared/widgets/sheets.dart';

/// The person's own account: details, password, language, colours,
/// notifications, help and sign out. The same page for all six roles;
/// customers also find their orders here.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final me = ref.watch(currentUserProvider);
    final db = ref.watch(dbProvider);
    if (me == null) return const SizedBox.shrink();
    final language = languageFor(Localizations.localeOf(context).languageCode);
    final roleText = me.role == UserRole.sales && me.salesType != null
        ? salesTypeLabel(t, me.salesType!)
        : roleLabel(t, me.role);
    final company = me.vendorId == null ? null : db.vendorName(me.vendorId);
    final territory = db.franchiseById(me.franchiseId)?.name;
    final themeId = ref.watch(themeProvider);
    final isCustomer = me.role == UserRole.customer;
    final orders = isCustomer
        ? db.projects.where((p) => db.enquiryById(p.enquiryId)?.customerId == me.customerId).length
        : 0;

    return PageScaffold(
      title: t.profileTitle,
      children: [
        AppCard(
          padding: const EdgeInsets.all(Space.xl),
          child: Row(
            children: [
              InitialsAvatar(me.name, size: Sizes.avatarLg),
              Space.gapLg,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(me.name, style: context.text.titleLarge),
                    const SizedBox(height: 2),
                    Text(company ?? roleText,
                        style: context.text.bodyMedium?.copyWith(color: AppColors.textSecondary)),
                    if (territory != null && me.role != UserRole.customer)
                      Text(territory, style: context.text.bodySmall),
                    Space.gapSm,
                    StatusPill(t.profileUserId(me.loginId), icon: Icons.badge_outlined),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (isCustomer)
          NavGroup(rows: [
            NavRow(
              icon: Icons.inventory_2_outlined,
              title: t.navOrders,
              subtitle: t.cuOrdersCount(orders),
              onTap: () => context.push(Routes.projects),
            ),
          ]),
        NavGroup(title: t.profileAccount, rows: [
          NavRow(
            icon: Icons.edit_outlined,
            title: t.profileEdit,
            subtitle: Fmt.phone(me.phone),
            onTap: () => context.push(Routes.editProfile),
          ),
          NavRow(
            icon: Icons.lock_outline,
            title: t.profileChangePassword,
            onTap: () => context.push(Routes.changePassword),
          ),
        ]),
        NavGroup(title: t.profilePreferences, rows: [
          NavRow(
            icon: Icons.translate,
            title: t.settingsLanguage,
            subtitle: language?.endonym,
            onTap: () => context.push(Routes.language),
          ),
          NavRow(
            icon: Icons.palette_outlined,
            title: t.settingsTheme,
            subtitle: themeName(t, themeId),
            onTap: () => _pickTheme(context, ref),
          ),
          NavRow(
            icon: Icons.notifications_none,
            title: t.profileNotifications,
            onTap: () => context.push(Routes.notificationSettings),
          ),
        ]),
        NavGroup(title: t.profileSupport, rows: [
          NavRow(
            icon: Icons.help_outline,
            title: t.helpTitle,
            onTap: () => context.push(Routes.help),
          ),
          NavRow(
            icon: Icons.info_outline,
            title: 'About O2O Boss',
            subtitle: 'Vision, Values & Philosophy',
            onTap: () => context.push(Routes.about),
          ),
          NavRow(
            icon: Icons.description_outlined,
            title: t.legalTerms,
            onTap: () => context.push(Routes.legal('terms')),
          ),
          NavRow(
            icon: Icons.privacy_tip_outlined,
            title: t.legalPrivacy,
            onTap: () => context.push(Routes.legal('privacy')),
          ),
        ]),
        NavGroup(title: t.profileDemo, rows: [
          NavRow(
            icon: Icons.restart_alt,
            tone: Tone.warning,
            title: t.profileResetDemo,
            subtitle: t.profileResetDemoBody,
            onTap: () async {
              final ok = await confirmAction(
                context,
                title: t.profileResetDemoTitle,
                body: t.profileResetDemoConfirm,
                confirmLabel: t.profileResetDemo,
                destructive: true,
              );
              if (!ok) return;
              ref.read(dbProvider.notifier).resetDemo();
              if (context.mounted) showToast(context, t.profileResetDemoDone);
            },
          ),
        ]),
        Space.gapXl,
        AppCard(
          padding: EdgeInsets.zero,
          child: NavRow(
            icon: Icons.logout,
            title: t.actionLogout,
            destructive: true,
            onTap: () async {
              final ok = await confirmAction(
                context,
                title: t.logoutTitle,
                body: t.logoutBody,
                confirmLabel: t.actionLogout,
              );
              if (ok) ref.read(sessionProvider.notifier).signOut();
            },
          ),
        ),
        const CaringValuesCard(),
        const CultureCodeBanner(),
        Space.gapXl,
        Center(child: Text(t.profileVersion('1.0'), style: context.text.labelSmall)),
      ],
    );
  }
}

String themeName(AppLocalizations t, AppThemeId id) => switch (id) {
      AppThemeId.classic => t.themeClassic,
      AppThemeId.brand => t.themeBrand,
    };

Future<void> _pickTheme(BuildContext context, WidgetRef ref) async {
  final t = context.t;
  final current = ref.read(themeProvider);
  final picked = await showAppSheet<AppThemeId>(
    context,
    title: t.settingsTheme,
    builder: (ctx) => Column(
      children: [
        for (final id in AppThemeId.values)
          _ThemeOption(id: id, selected: id == current, onTap: () => Navigator.pop(ctx, id)),
      ],
    ),
  );
  if (picked == null || picked == current) return;
  ref.read(themeProvider.notifier).choose(picked);
  if (context.mounted) showToast(context, t.toastSaved);
}

/// A theme choice with a small preview of its two main colours.
class _ThemeOption extends StatelessWidget {
  const _ThemeOption({required this.id, required this.selected, required this.onTap});

  final AppThemeId id;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final palette = AppPalette.of(id);
    Widget dot(Color c) => Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: c,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.surface, width: 2),
          ),
        );
    return Semantics(
      selected: selected,
      inMutuallyExclusiveGroup: true,
      child: InkWell(
        borderRadius: Corners.mdAll,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Space.md, horizontal: Space.xs),
          child: Row(
            children: [
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: selected ? AppColors.primary : AppColors.textSecondary,
              ),
              Space.gapMd,
              ExcludeSemantics(
                child: SizedBox(
                  width: 44,
                  height: 26,
                  child: Stack(children: [
                    dot(palette.primary),
                    Positioned(left: 18, child: dot(palette.primaryDark)),
                  ]),
                ),
              ),
              Space.gapMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(themeName(t, id), style: context.text.bodyLarge),
                    Text(
                      id == AppThemeId.classic ? t.themeClassicBody : t.themeBrandBody,
                      style: context.text.bodySmall,
                    ),
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/data/app_store.dart';
import '../core/l10n/l10n.dart';
import '../core/l10n/locale_controller.dart';
import 'router/app_router.dart';
import 'theme/app_colors.dart';
import 'theme/app_theme.dart';
import 'theme/theme_controller.dart';

class O2OBossApp extends ConsumerWidget {
  const O2OBossApp({super.key});

  static final _themes = <AppThemeId, ThemeData>{};

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeProvider) ?? deviceLocale();
    final company = ref.watch(configProvider.select((c) => c.companyName));
    final themeId = ref.watch(themeProvider);
    return MaterialApp.router(
      title: company,
      debugShowCheckedModeBanner: false,
      scrollBehavior: const _NoScrollbars(),
      theme: _themes.putIfAbsent(themeId, buildAppTheme),
      routerConfig: router,
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationDelegates,
      builder: (context, child) {
        // Honour large text settings, but cap them so layouts stay usable.
        final mq = MediaQuery.of(context);
        return MediaQuery(
          data: mq.copyWith(
            textScaler: mq.textScaler.clamp(minScaleFactor: 1, maxScaleFactor: 1.6),
          ),
          child: child!,
        );
      },
    );
  }
}

/// Pages still scroll with touch, mouse wheel, trackpad and keyboard, but
/// without the scrollbar line Flutter adds on desktop browsers.
class _NoScrollbars extends MaterialScrollBehavior {
  const _NoScrollbars();

  @override
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) => child;
}


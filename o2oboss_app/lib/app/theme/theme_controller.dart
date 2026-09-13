import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/app_store.dart';
import 'app_colors.dart';

final themeProvider = NotifierProvider<ThemeController, AppThemeId>(ThemeController.new);

/// The colour theme chosen on this device. Saved like the language choice.
class ThemeController extends Notifier<AppThemeId> {
  @override
  AppThemeId build() {
    final saved = ref.read(storageProvider).themeId;
    final id = AppThemeId.values.where((t) => t.name == saved).firstOrNull ?? AppThemeId.classic;
    AppColors.use(id);
    return id;
  }

  void choose(AppThemeId id) {
    if (id == state) return;
    AppColors.use(id);
    state = id;
    unawaited(ref.read(storageProvider).setThemeId(id.name));
    _rebuildEverything();
  }

  /// Screens read colours straight from [AppColors], so after a switch every
  /// widget is rebuilt once, including const ones Flutter would skip.
  static void _rebuildEverything() {
    void mark(Element e) {
      e.markNeedsBuild();
      e.visitChildren(mark);
    }

    WidgetsBinding.instance.rootElement?.visitChildren(mark);
  }
}

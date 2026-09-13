import 'dart:async';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/app_store.dart';
import 'languages.dart';

/// The chosen app language, or null until the person picks one on first launch.
final localeProvider = NotifierProvider<LocaleController, Locale?>(LocaleController.new);

class LocaleController extends Notifier<Locale?> {
  @override
  Locale? build() {
    final storage = ref.read(storageProvider);
    if (!storage.languageChosen) return null;
    return Locale(storage.localeCode ?? 'en');
  }

  Future<void> choose(String code) async {
    state = Locale(code);
    final storage = ref.read(storageProvider);
    await storage.setLocaleCode(code);
    await storage.setLanguageChosen();
  }
}

/// The device language if the app supports it, otherwise English. Used to
/// show the language picker in a familiar language before anything is chosen.
Locale deviceLocale() {
  final code = PlatformDispatcher.instance.locale.languageCode;
  return languageFor(code) == null ? const Locale('en') : Locale(code);
}

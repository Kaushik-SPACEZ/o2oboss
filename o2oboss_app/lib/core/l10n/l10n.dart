import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

import '../../l10n/gen/app_localizations.dart';
import 'languages.dart';

export '../../l10n/gen/app_localizations.dart';

extension L10nContext on BuildContext {
  /// Translated strings for the current language.
  AppLocalizations get t => AppLocalizations.of(this);
}

final List<Locale> supportedLocales = [
  for (final l in appLanguages) Locale(l.code),
];

/// App strings plus Flutter's own widget strings. Languages Flutter doesn't
/// cover (Bodo, Santali…) borrow the closest supported language for things
/// like date pickers, and keep right-to-left layout for Kashmiri and Sindhi.
const List<LocalizationsDelegate<dynamic>> localizationDelegates = [
  AppLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
  _Fallback<MaterialLocalizations>(GlobalMaterialLocalizations.delegate),
  _Fallback<WidgetsLocalizations>(GlobalWidgetsLocalizations.delegate),
  _Fallback<CupertinoLocalizations>(GlobalCupertinoLocalizations.delegate),
];

class _Fallback<T> extends LocalizationsDelegate<T> {
  const _Fallback(this.inner);

  final LocalizationsDelegate<T> inner;

  static Locale? _fallbackFor(Locale locale) {
    final f = languageFor(locale.languageCode)?.fallback;
    return f == null ? null : Locale(f);
  }

  @override
  bool isSupported(Locale locale) =>
      !inner.isSupported(locale) && _fallbackFor(locale) != null;

  @override
  Future<T> load(Locale locale) => inner.load(_fallbackFor(locale)!);

  @override
  bool shouldReload(covariant LocalizationsDelegate<T> old) => false;
}

/// Locale code to use with `intl` date formatting for the current language.
String intlLocaleOf(BuildContext context) {
  final code = Localizations.localeOf(context).languageCode;
  // Indian English date order: 12 Sep 2026.
  if (code == 'en') return 'en_IN';
  if (DateFormat.localeExists(code)) return code;
  final f = languageFor(code)?.fallback;
  if (f != null && DateFormat.localeExists(f)) return f;
  return 'en';
}

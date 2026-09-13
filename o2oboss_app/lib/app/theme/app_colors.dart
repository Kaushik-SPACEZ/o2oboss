import 'package:flutter/material.dart';

/// The two colour themes a person can pick in Profile → Preferences.
enum AppThemeId { classic, brand }

/// The colours that change with the theme. Everything else (text, status
/// colours, borders) stays the same so meaning never depends on the theme.
class AppPalette {
  const AppPalette({
    required this.primary,
    required this.primaryDark,
    required this.primaryLight,
    required this.primarySoft,
    required this.infoText,
    required this.wash,
    required this.washSoft,
    required this.washBorder,
    required this.brandText,
    required this.sceneWindow,
    required this.sceneLight,
    required this.sceneMid,
    required this.sceneDark,
  });

  /// Buttons, links, active icons. Keeps 4.5:1 against white.
  final Color primary;

  /// Selected tab labels and text on light tints.
  final Color primaryDark;
  final Color primaryLight;
  final Color primarySoft;
  final Color infoText;
  final Color wash;
  final Color washSoft;
  final Color washBorder;

  /// The "Boss" half of the logo.
  final Color brandText;

  /// The small city drawing beside the Home greeting, back to front.
  final Color sceneWindow;
  final Color sceneLight;
  final Color sceneMid;
  final Color sceneDark;

  /// Blue, from the CRM mobile design specification.
  static const classic = AppPalette(
    primary: Color(0xFF2563EB),
    primaryDark: Color(0xFF1D4ED8),
    primaryLight: Color(0xFFEFF6FF),
    primarySoft: Color(0xFFDBEAFE),
    infoText: Color(0xFF1D4ED8),
    wash: Color(0xFFE1E7FF),
    washSoft: Color(0xFFEEF2FF),
    washBorder: Color(0xFFDCE3FB),
    brandText: Color(0xFF111827),
    sceneWindow: Color(0xFFE8EBFD),
    sceneLight: Color(0xFFD5DBFA),
    sceneMid: Color(0xFFB8C1F5),
    sceneDark: Color(0xFF8F9BEA),
  );

  /// Orange, navy and white from the o2oboss.com website. The website's
  /// orange (#E8612C) is too light for white button text, so buttons use a
  /// deeper shade of it; navy carries labels, as it does on the logo.
  static const brand = AppPalette(
    primary: Color(0xFFC94A12),
    primaryDark: Color(0xFF2B3990),
    primaryLight: Color(0xFFFFF3EC),
    primarySoft: Color(0xFFFFE3D3),
    infoText: Color(0xFF2B3990),
    wash: Color(0xFFFFE6D6),
    washSoft: Color(0xFFFFF1E8),
    washBorder: Color(0xFFFBD9C4),
    brandText: Color(0xFF2B3990),
    sceneWindow: Color(0xFFFFF1E8),
    sceneLight: Color(0xFFFFDCC7),
    sceneMid: Color(0xFFFDBF9C),
    sceneDark: Color(0xFFEE9A6C),
  );

  static AppPalette of(AppThemeId id) => switch (id) {
        AppThemeId.classic => classic,
        AppThemeId.brand => brand,
      };
}

/// Colour tokens from the CRM mobile design specification.
abstract final class AppColors {
  static AppPalette _palette = AppPalette.classic;

  /// Switches the theme colours. The theme controller calls this and then
  /// rebuilds the app, so screens pick up the new values.
  static void use(AppThemeId id) => _palette = AppPalette.of(id);

  static Color get primary => _palette.primary;
  static Color get primaryDark => _palette.primaryDark;
  static Color get primaryLight => _palette.primaryLight;
  static Color get blueLight => _palette.primarySoft;
  static Color get brandText => _palette.brandText;
  static Color get sceneWindow => _palette.sceneWindow;
  static Color get sceneLight => _palette.sceneLight;
  static Color get sceneMid => _palette.sceneMid;
  static Color get sceneDark => _palette.sceneDark;

  static const text = Color(0xFF111827);
  static const textSecondary = Color(0xFF6B7280);

  /// Placeholders and disabled content only — too light for meaningful text.
  static const textMuted = Color(0xFF9CA3AF);

  static const background = Color(0xFFF8FAFC);

  /// Soft wash at the top of every page, fading into [background]. Also the
  /// start of the hero card gradient.
  static Color get wash => _palette.wash;
  static Color get washSoft => _palette.washSoft;
  static Color get washBorder => _palette.washBorder;
  static const pink = Color(0xFFDB2777);
  static const amber = Color(0xFFD97706);
  static const surface = Color(0xFFFFFFFF);
  static const input = Color(0xFFF9FAFB);
  static const border = Color(0xFFEEF2F7);
  static const borderStrong = Color(0xFFE5E7EB);
  static const track = Color(0xFFF1F5F9);

  static const success = Color(0xFF16A34A);
  static const successLight = Color(0xFFDCFCE7);
  static const warning = Color(0xFFF59E0B);
  static const warningLight = Color(0xFFFEF3C7);
  static const danger = Color(0xFFDC2626);
  static const dangerLight = Color(0xFFFEE2E2);
  static const purple = Color(0xFF7C3AED);
  static const purpleLight = Color(0xFFF3E8FF);

  // Darker text shades for use on the light status backgrounds, so pill
  // labels keep at least 4.5:1 contrast.
  static const successText = Color(0xFF15803D);
  static const warningText = Color(0xFFB45309);
  static const dangerText = Color(0xFFB91C1C);
  static const purpleText = Color(0xFF6D28D9);
  static Color get infoText => _palette.infoText;
  static const neutralText = Color(0xFF374151);
}

/// Semantic tone for chips, badges and icons. Always paired with text.
enum Tone { neutral, info, success, warning, danger, purple }

extension ToneColors on Tone {
  Color get background => switch (this) {
        Tone.neutral => AppColors.track,
        Tone.info => AppColors.blueLight,
        Tone.success => AppColors.successLight,
        Tone.warning => AppColors.warningLight,
        Tone.danger => AppColors.dangerLight,
        Tone.purple => AppColors.purpleLight,
      };

  Color get foreground => switch (this) {
        Tone.neutral => AppColors.neutralText,
        Tone.info => AppColors.infoText,
        Tone.success => AppColors.successText,
        Tone.warning => AppColors.warningText,
        Tone.danger => AppColors.dangerText,
        Tone.purple => AppColors.purpleText,
      };

  /// Stronger colour for icons and progress marks.
  Color get solid => switch (this) {
        Tone.neutral => AppColors.textSecondary,
        Tone.info => AppColors.primary,
        Tone.success => AppColors.success,
        Tone.warning => AppColors.warning,
        Tone.danger => AppColors.danger,
        Tone.purple => AppColors.purple,
      };
}

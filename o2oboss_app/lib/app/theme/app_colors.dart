import 'package:flutter/material.dart';

/// The two colour themes a person can pick in Profile → Preferences.
enum AppThemeId { classic, brand }

/// The colours that change with the theme. Everything else (text, status
/// colours, borders) stays the same so meaning never depends on the theme.
/// 
/// Design principle: Simple to understand. Fast to use. Modern to look at.
/// Color balance: 70% White/neutrals, 20% Blue (structure), 10% Orange (actions)
class AppPalette {
  const AppPalette({
    required this.primary,
    required this.primaryDark,
    required this.primaryLight,
    required this.primarySoft,
    required this.accent,
    required this.accentHover,
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

  /// Structure color - Royal Blue for headers, navigation, containers.
  final Color primary;

  /// Darker shade of primary for selected states.
  final Color primaryDark;
  final Color primaryLight;
  final Color primarySoft;
  
  /// Action color - Orange for important CTAs and primary buttons.
  final Color accent;
  final Color accentHover;
  
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

  /// O2O Boss brand theme - Orange + Royal Blue
  /// Orange (#F15E21) for actions, Royal Blue (#2A4D9F) for structure
  static const classic = AppPalette(
    // Royal Blue - structure color
    primary: Color(0xFF2A4D9F),
    primaryDark: Color(0xFF16369D),
    primaryLight: Color(0xFFEFF6FF),
    primarySoft: Color(0xFFDBEAFE),
    // Orange - action color
    accent: Color(0xFFF15E21),
    accentHover: Color(0xFFD94F16),
    infoText: Color(0xFF2A4D9F),
    wash: Color(0xFFE1E7FF),
    washSoft: Color(0xFFEEF2FF),
    washBorder: Color(0xFFDCE3FB),
    brandText: Color(0xFF17213A),
    sceneWindow: Color(0xFFE8EBFD),
    sceneLight: Color(0xFFD5DBFA),
    sceneMid: Color(0xFFB8C1F5),
    sceneDark: Color(0xFF8F9BEA),
  );

  /// Brand theme variant - same colors, different emphasis
  static const brand = AppPalette(
    // Orange primary for brand-heavy screens
    primary: Color(0xFFF15E21),
    primaryDark: Color(0xFFD94F16),
    primaryLight: Color(0xFFFFF3EC),
    primarySoft: Color(0xFFFFE3D3),
    accent: Color(0xFF2A4D9F),
    accentHover: Color(0xFF16369D),
    infoText: Color(0xFF2A4D9F),
    wash: Color(0xFFFFE6D6),
    washSoft: Color(0xFFFFF1E8),
    washBorder: Color(0xFFFBD9C4),
    brandText: Color(0xFF2A4D9F),
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
  
  /// Orange accent color - use for PRIMARY ACTIONS ONLY
  static Color get accent => _palette.accent;
  static Color get accentHover => _palette.accentHover;
  static Color get accentLight => const Color(0xFFFFF3EC);
  
  static Color get brandText => _palette.brandText;
  static Color get sceneWindow => _palette.sceneWindow;
  static Color get sceneLight => _palette.sceneLight;
  static Color get sceneMid => _palette.sceneMid;
  static Color get sceneDark => _palette.sceneDark;

  /// Primary text - dark and readable
  static const text = Color(0xFF17213A);
  static const textSecondary = Color(0xFF475467);

  /// Placeholders and disabled content only — too light for meaningful text.
  static const textMuted = Color(0xFF667085);
  
  /// Disabled state
  static const disabled = Color(0xFF98A2B3);

  /// App background - subtle off-white, not pure white
  static const background = Color(0xFFF8FAFC);
  
  /// Soft surface for subtle sections
  static const softSurface = Color(0xFFF1F3F5);

  /// Soft wash at the top of every page, fading into [background]. Also the
  /// start of the hero card gradient.
  static Color get wash => _palette.wash;
  static Color get washSoft => _palette.washSoft;
  static Color get washBorder => _palette.washBorder;
  static const pink = Color(0xFFDB2777);
  static const amber = Color(0xFFD97706);
  static const surface = Color(0xFFFFFFFF);
  static const input = Color(0xFFF9FAFB);
  static const border = Color(0xFFE4E7EC);
  static const borderStrong = Color(0xFFE4E7EC);
  static const track = Color(0xFFF1F5F9);

  /// Semantic colors from theme spec
  static const success = Color(0xFF168A52);
  static const successLight = Color(0xFFDCFCE7);
  static const warning = Color(0xFFD99000);
  static const warningLight = Color(0xFFFEF3C7);
  static const danger = Color(0xFFC62828);
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

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Central type scale. Sizes follow the CRM spec, nudged up slightly for body
/// text because many users are not regular smartphone readers.
abstract final class AppType {
  /// Tests turn this off so no font is fetched from the network.
  static bool useGoogleFonts = true;

  static TextTheme textTheme() {
    const base = TextTheme(
      // Greeting / hero numbers.
      displaySmall: TextStyle(
          fontSize: 28, fontWeight: FontWeight.w700, height: 1.2,
          letterSpacing: -0.4, color: AppColors.text),
      // Page title.
      headlineSmall: TextStyle(
          fontSize: 22, fontWeight: FontWeight.w700, height: 1.25,
          letterSpacing: -0.2, color: AppColors.text),
      titleLarge: TextStyle(
          fontSize: 19, fontWeight: FontWeight.w700, height: 1.3,
          color: AppColors.text),
      // Section heading.
      titleMedium: TextStyle(
          fontSize: 17, fontWeight: FontWeight.w700, height: 1.3,
          color: AppColors.text),
      // Card title.
      titleSmall: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w600, height: 1.35,
          color: AppColors.text),
      bodyLarge: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w400, height: 1.45,
          color: AppColors.text),
      bodyMedium: TextStyle(
          fontSize: 15, fontWeight: FontWeight.w400, height: 1.45,
          color: AppColors.text),
      // Supporting text.
      bodySmall: TextStyle(
          fontSize: 13, fontWeight: FontWeight.w400, height: 1.4,
          color: AppColors.textSecondary),
      // Buttons.
      labelLarge: TextStyle(
          fontSize: 15, fontWeight: FontWeight.w600, height: 1.2,
          color: AppColors.text),
      labelMedium: TextStyle(
          fontSize: 13, fontWeight: FontWeight.w600, height: 1.25,
          color: AppColors.text),
      // Captions and pills.
      labelSmall: TextStyle(
          fontSize: 12, fontWeight: FontWeight.w500, height: 1.3,
          color: AppColors.textSecondary),
    );
    return useGoogleFonts ? GoogleFonts.interTextTheme(base) : base;
  }

  /// Large KPI figures. Tabular digits keep columns of numbers aligned.
  static TextStyle kpi(BuildContext context) =>
      Theme.of(context).textTheme.displaySmall!.copyWith(
            fontSize: 26,
            fontFeatures: const [FontFeature.tabularFigures()],
          );

  /// Changes a style's weight. Google Fonts loads one file per weight, so a
  /// plain copyWith keeps the old file; this fetches the matching one.
  static TextStyle weight(TextStyle style, FontWeight weight) {
    final s = style.copyWith(fontWeight: weight);
    return useGoogleFonts ? GoogleFonts.inter(textStyle: s) : s;
  }

  static TextStyle money(BuildContext context) =>
      Theme.of(context).textTheme.titleSmall!.copyWith(
            fontFeatures: const [FontFeature.tabularFigures()],
          );
}

extension TextThemeContext on BuildContext {
  TextTheme get text => Theme.of(this).textTheme;
}

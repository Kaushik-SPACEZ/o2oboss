import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// One central light theme. Components pick up these styles automatically,
/// so screens never set colours or sizes of their own.
ThemeData buildAppTheme() {
  final text = AppType.textTheme();

  final scheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: Colors.white,
    primaryContainer: AppColors.primaryLight,
    onPrimaryContainer: AppColors.primaryDark,
    secondary: AppColors.primaryDark,
    onSecondary: Colors.white,
    secondaryContainer: AppColors.blueLight,
    onSecondaryContainer: AppColors.primaryDark,
    tertiary: AppColors.purple,
    onTertiary: Colors.white,
    error: AppColors.danger,
    onError: Colors.white,
    errorContainer: AppColors.dangerLight,
    onErrorContainer: AppColors.dangerText,
    surface: AppColors.surface,
    onSurface: AppColors.text,
    onSurfaceVariant: AppColors.textSecondary,
    surfaceContainerLowest: Colors.white,
    surfaceContainerLow: AppColors.background,
    surfaceContainer: AppColors.background,
    surfaceContainerHigh: AppColors.input,
    surfaceContainerHighest: AppColors.track,
    outline: AppColors.borderStrong,
    outlineVariant: AppColors.border,
    shadow: Color(0x140F172A),
    scrim: Color(0x66000000),
    inverseSurface: AppColors.text,
    onInverseSurface: Colors.white,
    inversePrimary: AppColors.blueLight,
    surfaceTint: Colors.transparent,
  );

  const inputBorder = OutlineInputBorder(
    borderRadius: Corners.mdAll,
    borderSide: BorderSide(color: AppColors.borderStrong),
  );

  bool selected(Set<WidgetState> s) => s.contains(WidgetState.selected);

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    textTheme: text,
    scaffoldBackgroundColor: AppColors.background,
    canvasColor: AppColors.background,
    dividerColor: AppColors.border,
    visualDensity: VisualDensity.standard,
    materialTapTargetSize: MaterialTapTargetSize.padded,
    appBarTheme: AppBarThemeData(
      // Transparent so the page wash shows behind the title.
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.text,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: text.titleLarge,
      toolbarHeight: 56,
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shadowColor: Colors.black.withOpacity(0.08),
      shape: const RoundedRectangleBorder(
        borderRadius: Corners.lgAll,
        side: BorderSide(color: AppColors.border),
      ),
    ),
    // Premium page transitions
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
      },
    ),
    inputDecorationTheme: InputDecorationThemeData(
      filled: true,
      fillColor: AppColors.surface,
      isDense: false,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: inputBorder,
      enabledBorder: inputBorder,
      focusedBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: AppColors.primary, width: 1.6)),
      errorBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.danger)),
      focusedErrorBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.danger, width: 1.6)),
      disabledBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.border)),
      hintStyle: text.bodyMedium?.copyWith(color: AppColors.textMuted),
      helperStyle: text.bodySmall,
      errorStyle: text.bodySmall?.copyWith(color: AppColors.dangerText),
      prefixIconColor: AppColors.textSecondary,
      suffixIconColor: AppColors.textSecondary,
      errorMaxLines: 3,
      helperMaxLines: 3,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(64, Sizes.buttonHeight),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        shape: const RoundedRectangleBorder(borderRadius: Corners.mdAll),
        textStyle: text.labelLarge,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        disabledBackgroundColor: AppColors.track,
        disabledForegroundColor: AppColors.textMuted,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(64, Sizes.buttonHeight),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        shape: const RoundedRectangleBorder(borderRadius: Corners.mdAll),
        side: const BorderSide(color: AppColors.borderStrong),
        foregroundColor: AppColors.text,
        backgroundColor: AppColors.surface,
        textStyle: text.labelLarge,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(48, 44),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        foregroundColor: AppColors.primary,
        textStyle: text.labelLarge,
        shape: const RoundedRectangleBorder(borderRadius: Corners.smAll),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        minimumSize: const Size(Sizes.touch, Sizes.touch),
        foregroundColor: AppColors.text,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 2,
      highlightElevation: 4,
      shape: const RoundedRectangleBorder(borderRadius: Corners.lgAll),
      extendedTextStyle: text.labelLarge,
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 68,
      elevation: 0,
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      // Active tab reads by colour, filled icon and bold label, no pill.
      indicatorColor: Colors.transparent,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (s) => text.labelSmall!.copyWith(
          fontSize: 12,
          fontWeight: selected(s) ? FontWeight.w700 : FontWeight.w500,
          color: selected(s) ? AppColors.primaryDark : AppColors.textSecondary,
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (s) => IconThemeData(
          size: 24,
          color: selected(s) ? AppColors.primary : AppColors.textSecondary,
        ),
      ),
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: AppColors.surface,
      indicatorColor: AppColors.primaryLight,
      labelType: NavigationRailLabelType.all,
      selectedIconTheme: IconThemeData(color: AppColors.primary),
      unselectedIconTheme: const IconThemeData(color: AppColors.textSecondary),
      selectedLabelTextStyle: text.labelMedium?.copyWith(color: AppColors.primaryDark),
      unselectedLabelTextStyle:
          text.labelMedium?.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w500),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surface,
      selectedColor: AppColors.primary,
      disabledColor: AppColors.track,
      labelStyle: text.labelMedium,
      secondaryLabelStyle: text.labelMedium?.copyWith(color: Colors.white),
      side: const BorderSide(color: AppColors.borderStrong),
      shape: const StadiumBorder(),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      showCheckmark: false,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.surface,
      modalBackgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      showDragHandle: true,
      dragHandleColor: AppColors.borderStrong,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(Corners.xl)),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(borderRadius: Corners.xlAll),
      titleTextStyle: text.titleLarge,
      contentTextStyle: text.bodyMedium?.copyWith(color: AppColors.textSecondary),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.text,
      contentTextStyle: text.bodyMedium?.copyWith(color: Colors.white),
      actionTextColor: AppColors.blueLight,
      shape: const RoundedRectangleBorder(borderRadius: Corners.mdAll),
      insetPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
    ),
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: Space.lg),
      minVerticalPadding: 10,
      minLeadingWidth: 24,
      iconColor: AppColors.textSecondary,
      titleTextStyle: text.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
      subtitleTextStyle: text.bodySmall,
    ),
    dividerTheme: const DividerThemeData(color: AppColors.border, thickness: 1, space: 1),
    tabBarTheme: TabBarThemeData(
      labelColor: AppColors.primaryDark,
      unselectedLabelColor: AppColors.textSecondary,
      indicatorColor: AppColors.primary,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: text.labelLarge,
      unselectedLabelStyle: text.labelLarge?.copyWith(fontWeight: FontWeight.w500),
      dividerColor: AppColors.border,
      tabAlignment: TabAlignment.start,
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: SegmentedButton.styleFrom(
        selectedBackgroundColor: AppColors.primaryLight,
        selectedForegroundColor: AppColors.primaryDark,
        foregroundColor: AppColors.textSecondary,
        backgroundColor: AppColors.surface,
        side: const BorderSide(color: AppColors.borderStrong),
        textStyle: text.labelMedium,
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(Colors.white),
      trackColor: WidgetStateProperty.resolveWith(
          (s) => selected(s) ? AppColors.primary : AppColors.borderStrong),
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith(
          (s) => selected(s) ? AppColors.primary : Colors.transparent),
      side: const BorderSide(color: AppColors.textSecondary, width: 1.5),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith(
          (s) => selected(s) ? AppColors.primary : AppColors.textSecondary),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColors.primary,
      linearTrackColor: AppColors.track,
    ),
    badgeTheme: const BadgeThemeData(
      backgroundColor: AppColors.danger,
      textColor: Colors.white,
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(borderRadius: Corners.mdAll),
      textStyle: text.bodyMedium,
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      headerBackgroundColor: AppColors.primary,
      headerForegroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: Corners.xlAll),
    ),
    timePickerTheme: const TimePickerThemeData(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: Corners.xlAll),
    ),
    expansionTileTheme: const ExpansionTileThemeData(
      shape: Border(),
      collapsedShape: Border(),
      tilePadding: EdgeInsets.symmetric(horizontal: Space.lg),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: const BoxDecoration(color: AppColors.text, borderRadius: Corners.smAll),
      textStyle: text.labelSmall?.copyWith(color: Colors.white),
    ),
  );
}

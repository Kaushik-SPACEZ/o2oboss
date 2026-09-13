import 'package:flutter/widgets.dart';

/// Motion tokens from the navigation & page-transition standard (doc 05).
/// Durations reduced for snappier feel while maintaining smoothness.
abstract final class Motion {
  static const micro = Duration(milliseconds: 100);
  static const simple = Duration(milliseconds: 150);
  static const page = Duration(milliseconds: 200);
  static const sheet = Duration(milliseconds: 220);
  static const complex = Duration(milliseconds: 280);

  /// Entering content.
  static const enter = Curves.easeOutCubic;

  /// Exiting content.
  static const exit = Curves.easeInCubic;

  /// Related state changes.
  static const change = Curves.easeInOutCubic;

  /// True when the user asked the platform to reduce motion.
  static bool reduced(BuildContext context) =>
      MediaQuery.maybeDisableAnimationsOf(context) ?? false;

  static Duration of(BuildContext context, Duration d) =>
      reduced(context) ? Duration.zero : d;
}

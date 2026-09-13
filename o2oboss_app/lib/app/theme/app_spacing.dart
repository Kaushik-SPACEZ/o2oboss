import 'package:flutter/widgets.dart';

/// 4px-based spacing scale (spec: 4 → 8 → 12 → 16 → 20 → 24 → 32 → 40 → 48).
abstract final class Space {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const xxl = 24.0;
  static const xxxl = 32.0;
  static const huge = 40.0;
  static const giant = 48.0;

  /// Horizontal page padding. Drops to 12 on very small phones.
  static double page(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 360 ? md : lg;

  static const gapXs = SizedBox(height: xs, width: xs);
  static const gapSm = SizedBox(height: sm, width: sm);
  static const gapMd = SizedBox(height: md, width: md);
  static const gapLg = SizedBox(height: lg, width: lg);
  static const gapXl = SizedBox(height: xl, width: xl);
  static const gapXxl = SizedBox(height: xxl, width: xxl);
  static const gapXxxl = SizedBox(height: xxxl, width: xxxl);
}

/// Radius scale — smaller parts get smaller corners so hierarchy stays visible.
abstract final class Corners {
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const pill = 999.0;

  static const smAll = BorderRadius.all(Radius.circular(sm));
  static const mdAll = BorderRadius.all(Radius.circular(md));
  static const lgAll = BorderRadius.all(Radius.circular(lg));
  static const xlAll = BorderRadius.all(Radius.circular(xl));
  static const pillAll = BorderRadius.all(Radius.circular(pill));
}

abstract final class Sizes {
  /// Minimum touch target (Android 48dp; spec minimum 44).
  static const touch = 48.0;
  static const buttonHeight = 48.0;
  static const inputHeight = 48.0;
  static const iconSm = 16.0;
  static const icon = 20.0;
  static const iconLg = 24.0;
  static const avatarSm = 32.0;
  static const avatar = 40.0;
  static const avatarLg = 64.0;

  /// Content column width on tablets/desktop so the phone layout doesn't stretch.
  static const contentMax = 640.0;

  /// Width at which the bottom bar becomes a side navigation rail.
  static const railBreakpoint = 900.0;
}

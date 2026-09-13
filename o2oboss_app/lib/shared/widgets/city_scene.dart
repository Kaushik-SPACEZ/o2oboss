import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// Small city skyline beside the Home greeting, in soft tints of the theme
/// colour. Decorative only, so screen readers skip it.
class CityScene extends StatelessWidget {
  const CityScene({super.key, this.width = 136});

  final double width;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: CustomPaint(
        size: Size(width, width * 106 / 136),
        painter: _CityPainter(
          window: AppColors.sceneWindow,
          light: AppColors.sceneLight,
          mid: AppColors.sceneMid,
          dark: AppColors.sceneDark,
          cloud: AppColors.surface,
        ),
      ),
    );
  }
}

class _CityPainter extends CustomPainter {
  _CityPainter({
    required this.window,
    required this.light,
    required this.mid,
    required this.dark,
    required this.cloud,
  });

  final Color window;
  final Color light;
  final Color mid;
  final Color dark;
  final Color cloud;

  static const _ground = 100.0;

  @override
  void paint(Canvas canvas, Size size) {
    // Drawn on a 136 × 106 grid, then scaled to the requested size.
    canvas.save();
    canvas.scale(size.width / 136);
    final p = Paint()..isAntiAlias = true;

    void cloudAt(double x, double y, double k) {
      p.color = cloud.withValues(alpha: 0.95);
      canvas.drawCircle(Offset(x, y), 7 * k, p);
      canvas.drawCircle(Offset(x + 8 * k, y - 4 * k), 9 * k, p);
      canvas.drawCircle(Offset(x + 18 * k, y), 7 * k, p);
      canvas.drawRRect(
          RRect.fromLTRBR(x - 7 * k, y, x + 25 * k, y + 7 * k, Radius.circular(3.5 * k)), p);
    }

    void building(double left, double top, double width, Color color,
        {int cols = 2, double roof = 0}) {
      final body = Path()
        ..moveTo(left, top + roof)
        ..lineTo(left + width, top)
        ..lineTo(left + width, _ground)
        ..lineTo(left, _ground)
        ..close();
      canvas.drawPath(body, p..color = color);
      p.color = window;
      const ww = 4.0, wh = 5.0, gy = 4.0;
      final gx = cols > 1 ? (width - 8 - cols * ww) / (cols - 1) : 0.0;
      for (var y = top + roof + 6; y + wh <= _ground - 6; y += wh + gy) {
        for (var c = 0; c < cols; c++) {
          final x = cols > 1 ? left + 4 + c * (ww + gx) : left + (width - ww) / 2;
          canvas.drawRRect(RRect.fromLTRBR(x, y, x + ww, y + wh, const Radius.circular(1)), p);
        }
      }
    }

    void tree(double x, double k) {
      canvas.drawRRect(
          RRect.fromLTRBR(x - 1.2, _ground - 12 * k, x + 1.2, _ground, const Radius.circular(1)),
          p..color = dark);
      canvas.drawOval(
          Rect.fromCenter(center: Offset(x, _ground - 16 * k), width: 14 * k, height: 18 * k),
          p..color = dark.withValues(alpha: 0.85));
    }

    cloudAt(12, 22, 0.8);
    cloudAt(100, 12, 0.7);
    // Back to front, so nearer buildings overlap the ones behind.
    building(18, 46, 22, light);
    building(88, 36, 24, light);
    building(32, 26, 26, mid, cols: 3);
    building(102, 56, 26, mid, cols: 3);
    building(58, 12, 28, dark, cols: 3, roof: 8);
    tree(10, 1);
    tree(129, 0.85);
    canvas.drawRRect(RRect.fromLTRBR(0, _ground, 136, _ground + 3, const Radius.circular(1.5)),
        p..color = light);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_CityPainter old) =>
      old.window != window || old.light != light || old.mid != mid || old.dark != dark;
}

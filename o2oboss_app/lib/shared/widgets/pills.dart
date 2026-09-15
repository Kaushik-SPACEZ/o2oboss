import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';

/// Small rounded status label. Colour is paired with text so meaning never
/// depends on colour alone.
class StatusPill extends StatelessWidget {
  const StatusPill(this.label, {super.key, this.tone = Tone.neutral, this.icon});

  final String label;
  final Tone tone;
  final IconData? icon;

  /// Long labels (common in translations) are shortened with an ellipsis
  /// instead of pushing the row wider than the screen.
  static const maxWidth = 170.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: maxWidth),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: tone.background, borderRadius: Corners.pillAll),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: tone.foreground),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.text.labelSmall?.copyWith(
                color: tone.foreground,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Rounded-square icon on a tinted background, used as a leading visual.
class IconTile extends StatelessWidget {
  const IconTile(this.icon, {super.key, this.tone = Tone.info, this.size = 40});

  final IconData icon;
  final Tone tone;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: tone.background,
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: size * 0.52, color: tone.foreground),
    );
  }
}

/// Circle with a person's initials.
class InitialsAvatar extends StatelessWidget {
  const InitialsAvatar(this.name, {super.key, this.size = Sizes.avatar});

  final String name;
  final double size;

  static const _tones = [Tone.info, Tone.purple, Tone.success, Tone.warning, Tone.neutral];

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    final first = parts.first.characters.first;
    final last = parts.length > 1 ? parts.last.characters.first : '';
    return (first + last).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final tone = _tones[name.hashCode.abs() % _tones.length];
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: tone.background, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: Text(
          _initials,
          style: TextStyle(
            fontSize: size * 0.36,
            fontWeight: FontWeight.w700,
            color: tone.foreground,
          ),
        ),
      ),
    );
  }
}

/// Count bubble for "3 new" style indicators.
class CountBadge extends StatelessWidget {
  const CountBadge(this.count, {super.key, this.tone = Tone.danger});

  final int count;
  final Tone tone;

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();
    return Container(
      constraints: const BoxConstraints(minWidth: 22),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(color: tone.solid, borderRadius: Corners.pillAll),
      child: Text(
        count > 99 ? '99+' : '$count',
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );
  }
}

/// The O2O Boss logo image.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 30, this.showName = true, this.light = false});

  final double size;
  final bool showName;
  final bool light;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/o2o_logo.png',
      height: size,
      fit: BoxFit.contain,
    );
  }
}

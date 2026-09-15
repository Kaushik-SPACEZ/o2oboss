import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import 'layout.dart';

/// Clean hero card - simple light background with border
/// No gradients, clean and professional
class SoftHeroCard extends StatelessWidget {
  const SoftHeroCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(Space.xl),
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryLight.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: Corners.xlAll,
        side: BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(onTap: onTap, child: Padding(padding: padding, child: child)),
    );
  }
}

/// Clean icon container - simple circle with light background
class GlowIcon extends StatelessWidget {
  const GlowIcon(this.icon, {super.key, this.size = 56, this.color});

  final IconData icon;
  final double size;

  /// Defaults to the theme's primary colour.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? AppColors.primary;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: size * 0.5),
    );
  }
}

/// The look of a filled ORANGE pill button for primary actions
/// Orange is the CTA color, used sparingly for important actions
class PillButtonLabel extends StatelessWidget {
  const PillButtonLabel(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Space.xl, vertical: 11),
        decoration: BoxDecoration(color: AppColors.accent, borderRadius: Corners.pillAll),
        child: Text(
          label,
          style: context.text.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

/// The one dominant action on a Home screen: a soft hero card with a short
/// explanation and a single blue button. Use at most one per screen.
class PrimaryActionCard extends StatelessWidget {
  const PrimaryActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String body;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: SoftHeroCard(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: context.text.titleLarge),
                      const SizedBox(height: 6),
                      Text(body,
                          style: context.text.bodyMedium?.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                Space.gapMd,
                GlowIcon(icon),
              ],
            ),
            Space.gapLg,
            PillButtonLabel(actionLabel),
          ],
        ),
      ),
    );
  }
}

/// Round solid button for a direct contact action (call, WhatsApp). The
/// label is read out and shown as a tooltip.
class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  /// Defaults to the theme's primary colour.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: Tooltip(
        message: label,
        child: Material(
          color: color ?? AppColors.primary,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: SizedBox(
              width: Sizes.touch,
              height: Sizes.touch,
              child: Icon(icon, color: Colors.white, size: 22),
            ),
          ),
        ),
      ),
    );
  }
}

/// Colours for quick action icon squares. Each pairs with a text label.
enum ActionTint {
  blue,
  green,
  pink,
  purple,
  amber;

  Color get color => switch (this) {
        blue => AppColors.primary,
        green => AppColors.success,
        pink => AppColors.pink,
        purple => AppColors.purple,
        amber => AppColors.amber,
      };
}

/// A shortcut tile: a solid coloured icon square, a bold label with a short
/// explanation under it, and a chevron, on a pale wash of the same colour.
/// Lay out four in a [TileGrid] for a calm two-by-two block.
class QuickActionTile extends StatelessWidget {
  const QuickActionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.subtitle,
    this.tint = ActionTint.blue,
    this.count = 0,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;
  final ActionTint tint;

  /// Waiting items, shown as a small badge on the icon.
  final int count;

  static const double _icon = 42;

  /// Width the tile spends on everything except its text: padding, icon,
  /// the gap after it and the chevron. [TileGrid] uses it to pick columns.
  static const double chrome = Space.md + _icon + 10 + 18 + Space.xs;

  static TextStyle titleStyle(BuildContext context) =>
      AppType.weight(context.text.titleSmall!, FontWeight.w700);

  @override
  Widget build(BuildContext context) {
    final color = tint.color;
    return Semantics(
      button: true,
      label: [label, ?subtitle, if (count > 0) '$count'].join(', '),
      excludeSemantics: true,
      child: Material(
        color: Color.alphaBlend(color.withValues(alpha: 0.07), AppColors.surface),
        shape: RoundedRectangleBorder(
          borderRadius: Corners.lgAll,
          side: BorderSide(color: color.withValues(alpha: 0.14)),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(Space.md, Space.md, Space.xs, Space.md),
            child: Row(
              children: [
                Badge(
                  isLabelVisible: count > 0,
                  label: Text('$count'),
                  child: Container(
                    width: _icon,
                    height: _icon,
                    decoration: BoxDecoration(color: color, borderRadius: Corners.mdAll),
                    child: Icon(icon, color: Colors.white, size: 22),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(label,
                          style: titleStyle(context),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(subtitle!,
                            style: context.text.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, size: 18, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Quick action tiles in a grid: four across on wide screens, two on
/// phones, one when a label would otherwise break mid-word (long
/// translations or large text).
class TileGrid extends StatefulWidget {
  const TileGrid({super.key, required this.children, this.minItemWidth = 160});

  final List<Widget> children;

  /// Minimum width for children that are not [QuickActionTile]s.
  final double minItemWidth;

  @override
  State<TileGrid> createState() => _TileGridState();
}

class _TileGridState extends State<TileGrid> {
  // Web fonts arrive after the first frame and are wider than the stand-in
  // font, so measure again once they load.
  void _fontsChanged() => setState(() {});

  @override
  void initState() {
    super.initState();
    PaintingBinding.instance.systemFonts.addListener(_fontsChanged);
  }

  @override
  void dispose() {
    PaintingBinding.instance.systemFonts.removeListener(_fontsChanged);
    super.dispose();
  }

  List<Widget> get children => widget.children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final perRow = _columns(context, c.maxWidth);
      final rows = <Widget>[];
      for (var i = 0; i < children.length; i += perRow) {
        final slice = children.sublist(i, (i + perRow).clamp(0, children.length));
        rows.add(IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var j = 0; j < perRow; j++) ...[
                if (j > 0) Space.gapMd,
                Expanded(child: j < slice.length ? slice[j] : const SizedBox.shrink()),
              ],
            ],
          ),
        ));
      }
      return Gap(children: rows);
    });
  }

  /// The most columns in which every word of every tile's title and
  /// subtitle still fits on one line.
  int _columns(BuildContext context, double width) {
    final tiles = children.whereType<QuickActionTile>().toList();
    final scaler = MediaQuery.textScalerOf(context);
    final direction = Directionality.of(context);
    final titleStyle = QuickActionTile.titleStyle(context);
    final subtitleStyle = context.text.bodySmall;
    bool fits(int n) {
      final column = (width - Space.md * (n - 1)) / n;
      if (tiles.length < children.length) return column >= widget.minItemWidth * scaler.scale(1);
      // A few pixels spare for rounding and glyph overhang.
      final room = column - QuickActionTile.chrome - 4;
      for (final tile in tiles) {
        for (final (text, style) in [(tile.label, titleStyle), (tile.subtitle ?? '', subtitleStyle)]) {
          for (final word in text.split(RegExp(r'\s+')).where((w) => w.isNotEmpty)) {
            final painter = TextPainter(
              text: TextSpan(text: word, style: style),
              textDirection: direction,
              textScaler: scaler,
              maxLines: 1,
            )..layout();
            final tooWide = painter.width > room;
            painter.dispose();
            if (tooWide) return false;
          }
        }
      }
      return true;
    }

    for (final n in [if (width >= 560) 4, 2]) {
      if (n <= children.length && fits(n)) return n;
    }
    return 1;
  }
}

/// A calm highlighted box for "what happens next" and similar guidance.
class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.text,
    this.icon = Icons.info_outline,
    this.tone = Tone.info,
    this.title,
    this.action,
  });

  final String text;
  final String? title;
  final IconData icon;
  final Tone tone;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Space.lg),
      decoration: BoxDecoration(color: tone.background, borderRadius: Corners.lgAll),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: tone.foreground),
          Space.gapMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) ...[
                  Text(title!, style: context.text.titleSmall?.copyWith(color: tone.foreground)),
                  const SizedBox(height: 2),
                ],
                Text(text, style: context.text.bodyMedium?.copyWith(color: tone.foreground)),
                if (action != null) ...[Space.gapSm, action!],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Numbered steps for short explanations that really are a sequence.
class StepsList extends StatelessWidget {
  const StepsList({super.key, required this.steps});

  final List<(String, String)> steps;

  @override
  Widget build(BuildContext context) {
    return Gap(
      space: Space.lg,
      children: [
        for (var i = 0; i < steps.length; i++)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: Text('${i + 1}',
                    style: context.text.labelLarge?.copyWith(
                        color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
              ),
              Space.gapMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(steps[i].$1, style: context.text.titleSmall),
                    const SizedBox(height: 2),
                    Text(steps[i].$2, style: context.text.bodySmall),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }
}

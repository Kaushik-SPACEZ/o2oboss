import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import 'layout.dart';
import 'pills.dart';

/// Pale blue-lavender card with a soft gradient. Holds the one thing a page
/// wants attention on: the Home action, the next task, an enquiry's header.
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
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: Corners.xlAll,
        side: BorderSide(color: AppColors.washBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
            colors: [AppColors.washSoft, AppColors.surface],
          ),
        ),
        child: InkWell(onTap: onTap, child: Padding(padding: padding, child: child)),
      ),
    );
  }
}

/// Round white badge with a soft blue glow, standing in for an illustration.
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
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.22), blurRadius: 18, offset: const Offset(0, 6)),
        ],
      ),
      child: Icon(icon, color: color, size: size * 0.5),
    );
  }
}

/// The look of a filled blue pill button, for cards that are tappable as a
/// whole (so the card, not this label, carries the tap and semantics).
class PillButtonLabel extends StatelessWidget {
  const PillButtonLabel(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Space.xl, vertical: 11),
        decoration: BoxDecoration(color: AppColors.primary, borderRadius: Corners.pillAll),
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

/// A shortcut tile: coloured icon square above a short label. Lay out four
/// in a [TileGrid] for a calm two-by-two block.
class QuickActionTile extends StatelessWidget {
  const QuickActionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.tint = ActionTint.blue,
    this.count = 0,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final ActionTint tint;

  /// Waiting items, shown as a small badge.
  final int count;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: count > 0 ? '$label, $count' : label,
      excludeSemantics: true,
      child: AppCard(
        onTap: onTap,
        padding: const EdgeInsets.all(Space.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: tint.color, borderRadius: Corners.mdAll),
                  child: Icon(icon, color: Colors.white, size: 22),
                ),
                const Spacer(),
                CountBadge(count, tone: Tone.info),
              ],
            ),
            Space.gapMd,
            Text(label, style: context.text.titleSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

/// Two tiles per row; one per row on very narrow screens or large text.
class TileGrid extends StatelessWidget {
  const TileGrid({super.key, required this.children, this.minItemWidth = 150});

  final List<Widget> children;
  final double minItemWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final scale = MediaQuery.textScalerOf(context).scale(1);
      final perRow = c.maxWidth >= 560 ? 4 : (c.maxWidth / (minItemWidth * scale)).floor().clamp(1, 2);
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

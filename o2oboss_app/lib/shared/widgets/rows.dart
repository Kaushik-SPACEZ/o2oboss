import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import 'layout.dart';
import 'pills.dart';

/// Label above value, with an optional leading icon. For read-only details.
class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.trailing,
    this.maxLines = 4,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Widget? trailing;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Space.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(icon, size: Sizes.icon, color: AppColors.textSecondary),
            ),
            Space.gapMd,
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: context.text.bodySmall),
                const SizedBox(height: 2),
                Text(
                  value.isEmpty ? '—' : value,
                  style: context.text.bodyMedium,
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (trailing != null) ...[Space.gapSm, trailing!],
        ],
      ),
    );
  }
}

/// A tappable menu row: icon, title, optional subtitle, badge and chevron.
class NavRow extends StatelessWidget {
  const NavRow({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.badge = 0,
    this.tone = Tone.info,
    this.trailing,
    this.destructive = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final int badge;
  final Tone tone;
  final Widget? trailing;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final color = destructive ? AppColors.dangerText : AppColors.text;
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 60),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.md),
          child: Row(
            children: [
              IconTile(icon, tone: destructive ? Tone.danger : tone, size: 38),
              Space.gapMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title,
                        style: context.text.bodyLarge
                            ?.copyWith(fontWeight: FontWeight.w500, color: color)),
                    if (subtitle != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(subtitle!, style: context.text.bodySmall),
                      ),
                  ],
                ),
              ),
              if (badge > 0) ...[Space.gapSm, CountBadge(badge)],
              if (trailing != null) ...[Space.gapSm, trailing!],
              if (onTap != null && trailing == null)
                const Padding(
                  padding: EdgeInsetsDirectional.only(start: Space.xs),
                  child: Icon(Icons.chevron_right, color: AppColors.textMuted),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A titled group of [NavRow]s inside one card.
class NavGroup extends StatelessWidget {
  const NavGroup({super.key, this.title, required this.rows});

  final String? title;
  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (title != null) SectionHeader(title!, top: Space.xl),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (var i = 0; i < rows.length; i++) ...[
                if (i > 0) const Divider(indent: 66),
                rows[i],
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// A card with a heading row and content — the building block of detail pages.
class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
    this.icon,
  });

  final String title;
  final Widget child;
  final Widget? trailing;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: Sizes.icon, color: AppColors.primary),
                Space.gapSm,
              ],
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(title, style: context.text.titleSmall),
                ),
              ),
              ?trailing,
            ],
          ),
          Space.gapSm,
          child,
        ],
      ),
    );
  }
}

/// Two-column "label ....... value" line for totals and summaries.
class ValueLine extends StatelessWidget {
  const ValueLine(this.label, this.value, {super.key, this.strong = false, this.valueColor});

  final String label;
  final String value;
  final bool strong;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final style = strong ? context.text.titleSmall : context.text.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style: strong
                    ? style
                    : context.text.bodyMedium?.copyWith(color: AppColors.textSecondary)),
          ),
          Space.gapMd,
          Text(value,
              style: style?.copyWith(
                color: valueColor,
                fontFeatures: const [FontFeature.tabularFigures()],
              )),
        ],
      ),
    );
  }
}

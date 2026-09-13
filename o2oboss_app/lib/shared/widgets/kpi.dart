import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import 'layout.dart';
import 'pills.dart';

/// One headline number with its label. Tapping opens the related list.
class KpiTile extends StatelessWidget {
  const KpiTile({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.tone = Tone.info,
    this.caption,
    this.onTap,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Tone tone;
  final String? caption;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onTap != null,
      label: '$label: $value',
      excludeSemantics: true,
      child: AppCard(
        onTap: onTap,
        padding: const EdgeInsets.fromLTRB(Space.lg, Space.md, Space.md, Space.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(label,
                      style: context.text.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ),
                if (icon != null) Icon(icon, size: 18, color: tone.solid),
              ],
            ),
            Space.gapXs,
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: Text(value, style: AppType.kpi(context)),
            ),
            if (caption != null)
              Text(caption!,
                  style: context.text.labelSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

/// One number in a [StatStrip].
class StatItem {
  const StatItem({
    required this.icon,
    required this.value,
    required this.label,
    this.tone = Tone.info,
    this.onTap,
  });

  final IconData icon;
  final String value;
  final String label;
  final Tone tone;
  final VoidCallback? onTap;
}

/// Up to four headline numbers side by side in one white card: tinted icon,
/// number, short label. Falls back to two per row when space is tight.
class StatStrip extends StatelessWidget {
  const StatStrip({super.key, required this.items});

  final List<StatItem> items;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: Space.md, horizontal: Space.xs),
      child: LayoutBuilder(builder: (context, c) {
        final scale = MediaQuery.textScalerOf(context).scale(1);
        final perRow = c.maxWidth / items.length >= 78 * scale ? items.length : 2;
        final rows = <Widget>[];
        for (var i = 0; i < items.length; i += perRow) {
          final slice = items.sublist(i, (i + perRow).clamp(0, items.length));
          rows.add(Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var j = 0; j < perRow; j++)
                Expanded(child: j < slice.length ? _StatCell(item: slice[j]) : const SizedBox()),
            ],
          ));
        }
        return Gap(space: Space.sm, children: rows);
      }),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({required this.item});

  final StatItem item;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: item.onTap != null,
      label: '${item.label}: ${item.value}',
      excludeSemantics: true,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: Corners.mdAll,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.xs, vertical: Space.sm),
          child: Column(
            children: [
              IconTile(item.icon, tone: item.tone, size: 36),
              Space.gapSm,
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(item.value,
                    style: context.text.titleLarge
                        ?.copyWith(fontFeatures: const [FontFeature.tabularFigures()])),
              ),
              const SizedBox(height: 2),
              Text(item.label,
                  style: context.text.labelSmall,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}

/// A row in a "work queue" list: label, count and chevron. Used where a role
/// has many queues (back office, admin) so they read as a calm list rather
/// than a wall of cards.
class QueueRow extends StatelessWidget {
  const QueueRow({
    super.key,
    required this.icon,
    required this.label,
    required this.count,
    this.onTap,
    this.urgent = false,
  });

  final IconData icon;
  final String label;
  final int count;
  final VoidCallback? onTap;
  final bool urgent;

  @override
  Widget build(BuildContext context) {
    final active = count > 0;
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 56),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.sm),
          child: Row(
            children: [
              Icon(icon,
                  size: Sizes.icon,
                  color: urgent && active ? AppColors.danger : AppColors.textSecondary),
              Space.gapMd,
              Expanded(child: Text(label, style: context.text.bodyLarge)),
              Text(
                '$count',
                style: context.text.titleSmall?.copyWith(
                  color: !active
                      ? AppColors.textMuted
                      : urgent
                          ? AppColors.dangerText
                          : AppColors.text,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
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

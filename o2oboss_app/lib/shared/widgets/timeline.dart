import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';

class TimelineEntry {
  const TimelineEntry({
    required this.title,
    required this.time,
    this.subtitle,
    this.tone = Tone.neutral,
  });

  final String title;
  final String time;
  final String? subtitle;
  final Tone tone;
}

/// Chronological activity list with small dots on a line.
class Timeline extends StatelessWidget {
  const Timeline({super.key, required this.entries});

  final List<TimelineEntry> entries;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < entries.length; i++)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 20,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: entries[i].tone == Tone.neutral
                              ? AppColors.textMuted
                              : entries[i].tone.solid,
                          shape: BoxShape.circle,
                        ),
                      ),
                      if (i < entries.length - 1)
                        Expanded(
                          child: Container(
                            width: 2,
                            margin: const EdgeInsets.symmetric(vertical: 3),
                            color: AppColors.border,
                          ),
                        ),
                    ],
                  ),
                ),
                Space.gapMd,
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: i < entries.length - 1 ? Space.lg : 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(entries[i].title, style: context.text.bodyMedium),
                        if (entries[i].subtitle != null)
                          Text(entries[i].subtitle!, style: context.text.bodySmall),
                        Text(entries[i].time, style: context.text.labelSmall),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

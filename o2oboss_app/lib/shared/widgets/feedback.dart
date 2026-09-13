import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_motion.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/l10n/l10n.dart';

/// Short, auto-dismissing confirmation (spec 01 §2). Never the only signal
/// for a failure.
void showToast(BuildContext context, String message,
    {Tone tone = Tone.success, String? actionLabel, VoidCallback? onAction}) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      duration: const Duration(seconds: 4),
      content: Row(
        children: [
          Icon(
            switch (tone) {
              Tone.danger => Icons.error_outline,
              Tone.warning => Icons.warning_amber_outlined,
              Tone.info || Tone.neutral || Tone.purple => Icons.info_outline,
              Tone.success => Icons.check_circle_outline,
            },
            color: switch (tone) {
              Tone.danger => const Color(0xFFFCA5A5),
              Tone.warning => const Color(0xFFFCD34D),
              Tone.success => const Color(0xFF86EFAC),
              _ => AppColors.blueLight,
            },
            size: 20,
          ),
          Space.gapMd,
          Expanded(child: Text(message)),
        ],
      ),
      action: actionLabel == null
          ? null
          : SnackBarAction(label: actionLabel, onPressed: onAction ?? () {}),
    ));
}

/// A brief "working" pause so actions feel real and double taps are blocked.
/// Reduced from 450ms to 150ms for better responsiveness while still preventing
/// accidental double-taps.
Future<void> simulateWork([int ms = 150]) =>
    Future<void>.delayed(Duration(milliseconds: ms));

/// Confirmation dialog for consequential actions (spec 01 §6). Buttons say
/// exactly what will happen; never "Yes"/"No".
Future<bool> confirmAction(
  BuildContext context, {
  required String title,
  String? body,
  required String confirmLabel,
  String? cancelLabel,
  bool destructive = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: body == null ? null : Text(body),
      actionsPadding: const EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, Space.lg),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(cancelLabel ?? ctx.t.actionCancel),
        ),
        FilledButton(
          style: destructive
              ? FilledButton.styleFrom(backgroundColor: AppColors.danger)
              : null,
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}

/// Asks before leaving a form with unsaved changes (spec 03 §25).
Future<bool> confirmDiscard(BuildContext context) => confirmAction(
      context,
      title: context.t.discardTitle,
      body: context.t.discardBody,
      confirmLabel: context.t.actionDiscard,
      cancelLabel: context.t.actionKeepEditing,
      destructive: true,
    );

/// Centered message for empty lists, first use and "no results".
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    this.body,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
    this.compact = false,
  });

  final String title;
  final String? body;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: compact ? Space.xl : Space.huge, horizontal: Space.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: compact ? 48 : 64,
            height: compact ? 48 : 64,
            decoration: const BoxDecoration(color: AppColors.track, shape: BoxShape.circle),
            child: Icon(icon, size: compact ? 24 : 30, color: AppColors.textSecondary),
          ),
          Space.gapLg,
          Text(title, style: context.text.titleSmall, textAlign: TextAlign.center),
          if (body != null) ...[
            Space.gapXs,
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: Text(body!,
                  style: context.text.bodySmall, textAlign: TextAlign.center),
            ),
          ],
          if (actionLabel != null) ...[
            Space.gapLg,
            FilledButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}

/// Grey placeholder block with a gentle pulse (static when motion is reduced).
class SkeletonBox extends StatefulWidget {
  const SkeletonBox({super.key, this.width, this.height = 14, this.radius = 6});

  final double? width;
  final double height;
  final double radius;

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 900));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (Motion.reduced(context)) {
      _c.stop();
    } else if (!_c.isAnimating) {
      _c.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween(begin: 0.55, end: 1.0).animate(_c),
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: AppColors.track,
          borderRadius: BorderRadius.circular(widget.radius),
        ),
      ),
    );
  }
}

/// Card-shaped skeleton rows shown while a list "loads".
class SkeletonList extends StatelessWidget {
  const SkeletonList({super.key, this.count = 5});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: context.t.loading,
      child: Column(
        children: [
          for (var i = 0; i < count; i++)
            Container(
              margin: const EdgeInsets.only(bottom: Space.md),
              padding: const EdgeInsets.all(Space.lg),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: Corners.lgAll,
                border: Border.all(color: AppColors.border),
              ),
              child: const Row(
                children: [
                  SkeletonBox(width: 40, height: 40, radius: 12),
                  Space.gapMd,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonBox(width: 160),
                        Space.gapSm,
                        SkeletonBox(width: 110, height: 12),
                      ],
                    ),
                  ),
                  SkeletonBox(width: 64, height: 20, radius: 10),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Shows [placeholder] briefly the first time a screen opens, then fades to
/// [child]. Mimics real loading so the loading state is part of the demo.
/// Delay reduced from 350ms to 100ms for snappier feel.
class DelayedReveal extends StatefulWidget {
  const DelayedReveal({
    super.key,
    required this.child,
    this.placeholder = const SkeletonList(),
    this.delay = const Duration(milliseconds: 100),
  });

  final Widget child;
  final Widget placeholder;
  final Duration delay;

  @override
  State<DelayedReveal> createState() => _DelayedRevealState();
}

class _DelayedRevealState extends State<DelayedReveal> {
  bool _ready = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.delay, () {
      if (mounted) setState(() => _ready = true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Motion.of(context, Motion.simple),
      child: _ready
          ? KeyedSubtree(key: const ValueKey('content'), child: widget.child)
          : KeyedSubtree(key: const ValueKey('loading'), child: widget.placeholder),
    );
  }
}

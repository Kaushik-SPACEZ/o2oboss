import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../shared/widgets/layout.dart';
import '../theme/app_motion.dart';

/// Modern page transitions with smooth animations.

/// Horizontal slide with parallax effect (for detail pages).
CustomTransitionPage<void> pushPage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: PushedPage(child: child),
    transitionDuration: Motion.page,
    reverseTransitionDuration: Motion.page,
    transitionsBuilder: (context, animation, secondary, child) {
      if (Motion.reduced(context)) {
        return FadeTransition(opacity: animation, child: child);
      }
      final rtl = Directionality.of(context) == TextDirection.rtl;
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return SlideTransition(
        position: Tween(
          begin: Offset(rtl ? -1 : 1, 0), 
          end: Offset.zero,
        ).animate(curved),
        child: FadeTransition(
          opacity: Tween(begin: 0.5, end: 1.0).animate(curved),
          child: DecoratedBox(
            decoration: BoxDecoration(
              boxShadow: [
BoxShadow(
                  color: const Color(0x1F000000),
                  blurRadius: 16,
                  offset: Offset(rtl ? 6 : -6, 0),
                ),
              ],
            ),
            child: child,
          ),
        ),
      );
    },
  );
}

/// Fade with subtle scale for context changes (login, etc).
CustomTransitionPage<void> fadePage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: Motion.simple,
    reverseTransitionDuration: Motion.simple,
    transitionsBuilder: (context, animation, _, child) {
      final curved = CurvedAnimation(
        parent: animation, 
        curve: Curves.easeOutCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween(begin: 0.96, end: 1.0).animate(curved),
          child: child,
        ),
      );
    },
  );
}

/// Fast tab switching with instant display and smooth animations.
/// All tabs stay in memory (maintainState) for instant back-navigation.
class FadeBranchContainer extends StatefulWidget {
  const FadeBranchContainer({super.key, required this.index, required this.children});

  final int index;
  final List<Widget> children;

  @override
  State<FadeBranchContainer> createState() => _FadeBranchContainerState();
}

class _FadeBranchContainerState extends State<FadeBranchContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();
    _previousIndex = widget.index;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
    )..value = 1.0;
  }

  @override
  void didUpdateWidget(FadeBranchContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) {
      _previousIndex = oldWidget.index;
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => Stack(
        children: [
          for (var i = 0; i < widget.children.length; i++)
            _buildTab(i),
        ],
      ),
    );
  }

  Widget _buildTab(int i) {
    final isActive = i == widget.index;
    final wasPrevious = i == _previousIndex && _previousIndex != widget.index;
    final shouldShow = isActive || wasPrevious;

    return Positioned.fill(
      child: Visibility(
        visible: shouldShow,
        maintainState: true,
        child: ExcludeSemantics(
          excluding: !isActive,
          child: IgnorePointer(
            ignoring: !isActive,
            child: Opacity(
              opacity: isActive ? _controller.value : (1.0 - _controller.value),
              child: widget.children[i],
            ),
          ),
        ),
      ),
    );
  }
}

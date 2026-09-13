import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';

/// Keeps content at a comfortable phone-like width on tablets and desktop,
/// instead of stretching a mobile layout across the screen.
class ContentWidth extends StatelessWidget {
  const ContentWidth({
    super.key,
    required this.child,
    this.max = Sizes.contentMax,
    this.fillHeight = true,
  });

  final Widget child;
  final double max;

  /// False inside bars and other slots that should size to their content.
  final bool fillHeight;

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.topCenter,
        heightFactor: fillHeight ? null : 1,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: max),
          child: child,
        ),
      );
}

/// Marks a full-screen page opened on top of the tabs. When such a page is
/// opened straight from a link there is nothing to go back to, so its app
/// bar offers a way home instead.
class PushedPage extends InheritedWidget {
  const PushedPage({super.key, required super.child});

  static bool of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<PushedPage>() != null;

  @override
  bool updateShouldNotify(PushedPage oldWidget) => false;
}

/// Standard page: app bar, scrolling content with page padding, and an
/// optional sticky action bar at the bottom for the main action.
class PageScaffold extends StatelessWidget {
  const PageScaffold({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.children,
    this.body,
    this.bottomBar,
    this.fab,
    this.onRefresh,
    this.appBarBottom,
    this.showAppBar = true,
    this.padBottom = true,
    this.backgroundColor,
  }) : assert(children != null || body != null);

  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;

  /// Content placed in a padded, scrolling column.
  final List<Widget>? children;

  /// Custom body when [children] is not enough (lists, chat…).
  final Widget? body;
  final Widget? bottomBar;
  final Widget? fab;
  final Future<void> Function()? onRefresh;
  final PreferredSizeWidget? appBarBottom;
  final bool showAppBar;
  final bool padBottom;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final pad = Space.page(context);
    Widget content = body ??
        ListView(
          padding: EdgeInsetsDirectional.fromSTEB(
              pad, Space.sm, pad, padBottom ? Space.xxxl + Space.lg : Space.lg),
          children: children!,
        );
    if (onRefresh != null) {
      content = RefreshIndicator(onRefresh: onRefresh!, child: content);
    }
    final orphan = PushedPage.of(context) && !Navigator.of(context).canPop();
    final washed = backgroundColor == null;
    final scaffold = Scaffold(
      backgroundColor: washed ? Colors.transparent : backgroundColor,
      appBar: showAppBar
          ? AppBar(
              leading: orphan
                  ? IconButton(
                      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                      icon: const BackButtonIcon(),
                      onPressed: () => GoRouter.of(context).go('/'),
                    )
                  : null,
              title: titleWidget ?? (title == null ? null : Text(title!)),
              actions: [...?actions, const SizedBox(width: Space.xs)],
              bottom: appBarBottom,
            )
          : null,
      body: SafeArea(top: !showAppBar, bottom: false, child: ContentWidth(child: content)),
      floatingActionButton: fab,
      bottomNavigationBar: bottomBar,
    );
    return washed ? DecoratedBox(decoration: pageWash, child: scaffold) : scaffold;
  }
}

/// Soft blue-lavender light from the top corner that fades into the page
/// background within the first third of the screen.
BoxDecoration get pageWash => BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment(0.9, -1),
    end: Alignment(-0.5, -0.3),
    colors: [AppColors.wash, AppColors.background],
  ),
);

/// Sticky bar holding the screen's main action(s), above the system inset.
class StickyActions extends StatelessWidget {
  const StickyActions({super.key, required this.children, this.note});

  final List<Widget> children;

  /// Small line of help text above the buttons.
  final String? note;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: ContentWidth(
          fillHeight: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                Space.page(context), Space.md, Space.page(context), Space.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (note != null) ...[
                  Text(note!, style: context.text.bodySmall, textAlign: TextAlign.center),
                  Space.gapSm,
                ],
                Row(
                  children: [
                    for (var i = 0; i < children.length; i++) ...[
                      if (i > 0) Space.gapMd,
                      Expanded(child: children[i]),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Heading for a group of content, with an optional link on the end.
class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key, this.action, this.onAction, this.top = Space.xxl});

  final String title;
  final String? action;
  final VoidCallback? onAction;
  final double top;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: top, bottom: Space.sm),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              header: true,
              child: Text(title, style: context.text.titleMedium),
            ),
          ),
          if (action != null)
            TextButton(onPressed: onAction, child: Text(action!)),
        ],
      ),
    );
  }
}

/// White card with the standard border. Tappable when [onTap] is set.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(Space.lg),
    this.color,
    this.borderColor,
    this.radius = Corners.lgAll,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final Color? borderColor;
  final BorderRadius radius;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color ?? AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: borderColor ?? AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

/// Vertical list with even spacing between items.
class Gap extends StatelessWidget {
  const Gap({super.key, required this.children, this.space = Space.md});

  final List<Widget> children;
  final double space;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) SizedBox(height: space),
            children[i],
          ],
        ],
      );
}

/// Lays children in a grid that falls back to one column on narrow phones.
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    super.key,
    required this.children,
    this.minItemWidth = 150,
    this.spacing = Space.md,
  });

  final List<Widget> children;
  final double minItemWidth;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final columns = (c.maxWidth / (minItemWidth + spacing)).floor().clamp(1, 4);
      final width = (c.maxWidth - spacing * (columns - 1)) / columns;
      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: [for (final w in children) SizedBox(width: width, child: w)],
      );
    });
  }
}

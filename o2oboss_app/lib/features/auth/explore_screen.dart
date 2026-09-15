import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_motion.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/l10n/l10n.dart';
import '../../core/l10n/labels.dart';
import '../../core/models/models.dart';
import '../../shared/widgets/city_scene.dart';
import '../../shared/widgets/layout.dart';
import '../../shared/widgets/pills.dart';

/// The big reasons people come to O2O Boss, in their words.
enum Goal { earn, grow, start, buy }

extension GoalText on Goal {
  String title(AppLocalizations t) => switch (this) {
        Goal.earn => t.goalEarn,
        Goal.grow => t.goalGrow,
        Goal.start => t.goalStart,
        Goal.buy => t.goalBuy,
      };

  String body(AppLocalizations t) => switch (this) {
        Goal.earn => t.goalEarnBody,
        Goal.grow => t.goalGrowBody,
        Goal.start => t.goalStartBody,
        Goal.buy => t.goalBuyBody,
      };

  IconData get icon => switch (this) {
        Goal.earn => Icons.payments_outlined,
        Goal.grow => Icons.trending_up_rounded,
        Goal.start => Icons.rocket_launch_outlined,
        Goal.buy => Icons.shopping_bag_outlined,
      };

  Color get accent => switch (this) {
        Goal.earn => const Color(0xFF15803D),
        Goal.grow => AppColors.primary,
        Goal.start => const Color(0xFF7C3AED),
        Goal.buy => const Color(0xFFB45309),
      };
}

String occupationBody(AppLocalizations t, Occupation o) => switch (o) {
      Occupation.student => t.occStudentBody,
      Occupation.employed => t.occEmployedBody,
      Occupation.selfEmployed => t.occSelfEmployedBody,
      Occupation.homemaker => t.occHomemakerBody,
      Occupation.retired => t.occRetiredBody,
      Occupation.other => t.occOtherBody,
    };

IconData occupationIcon(Occupation o) => switch (o) {
      Occupation.student => Icons.school_outlined,
      Occupation.employed => Icons.work_outline,
      Occupation.selfEmployed => Icons.handyman_outlined,
      Occupation.homemaker => Icons.home_outlined,
      Occupation.retired => Icons.elderly,
      Occupation.other => Icons.more_horiz,
    };

/// Opens from the O2O Boss logo. Four big choices; "Earning" asks one more
/// question (student, employed…) and every choice lands in the right sign-up.
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  bool _earning = false;

  void _pick(Goal g) {
    switch (g) {
      case Goal.earn:
        setState(() => _earning = true);
      case Goal.grow:
        context.push(Routes.signupAs(UserRole.vendor));
      case Goal.start:
        context.push(Routes.signupFranchise);
      case Goal.buy:
        context.push(Routes.signupAs(UserRole.customer));
    }
  }

  void _back() {
    if (_earning) {
      setState(() => _earning = false);
    } else if (context.canPop()) {
      context.pop();
    } else {
      context.go(Routes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pad = Space.page(context);
    return PopScope(
      canPop: !_earning,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _back();
      },
      child: Scaffold(
        body: SafeArea(
          child: ContentWidth(
            max: 560,
            child: AnimatedSwitcher(
              duration: Motion.reduced(context) ? Duration.zero : const Duration(milliseconds: 260),
              child: ListView(
                key: ValueKey(_earning),
                padding: EdgeInsets.fromLTRB(pad, Space.sm, pad, Space.xxl),
                children: _earning ? _occupations(context) : _goals(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) => Row(
        children: [
          IconButton(
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            onPressed: _back,
            icon: const BackButtonIcon(),
          ),
          Space.gapXs,
          const BrandMark(size: 30),
        ],
      );

  List<Widget> _goals(BuildContext context) {
    final t = context.t;
    final reduced = Motion.reduced(context);
    return [
      _topBar(context),
      Space.gapLg,
      const _Hero(),
      Space.gapXl,
      for (final (i, g) in Goal.values.indexed) ...[
        _entrance(
          i,
          reduced,
          _ChoiceCard(
            icon: g.icon,
            accent: g.accent,
            title: g.title(t),
            body: g.body(t),
            onTap: () => _pick(g),
          ),
        ),
        Space.gapMd,
      ],
      Space.gapLg,
      Center(
        child: TextButton(
          onPressed: () => context.go(Routes.login),
          child: Text(t.exHaveAccount),
        ),
      ),
    ];
  }

  /// The four choices rise in one after another, once, when the page opens.
  Widget _entrance(int i, bool reduced, Widget child) => reduced
      ? child
      : child
          .animate()
          .fadeIn(delay: (70 * i).ms, duration: 300.ms)
          .slideY(begin: 0.12, end: 0, curve: Curves.easeOutCubic);

  List<Widget> _occupations(BuildContext context) {
    final t = context.t;
    return [
      _topBar(context),
      Space.gapLg,
      Row(
        children: [
          _GoalBadge(goal: Goal.earn),
        ],
      ),
      Space.gapMd,
      Semantics(
        header: true,
        child: Text(t.exWhoTitle, style: AppType.weight(context.text.headlineSmall!, FontWeight.w800)),
      ),
      Space.gapXs,
      Text(t.exWhoSubtitle,
          style: context.text.bodyMedium?.copyWith(color: AppColors.textSecondary)),
      Space.gapXl,
      for (final o in Occupation.values) ...[
        _ChoiceCard(
          icon: occupationIcon(o),
          accent: Goal.earn.accent,
          title: occupationLabel(t, o),
          body: occupationBody(t, o),
          onTap: () => context.push(Routes.signupAs(UserRole.sales, occupation: o)),
        ),
        Space.gapMd,
      ],
    ];
  }
}

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final roomy = MediaQuery.sizeOf(context).width >= 340 &&
        MediaQuery.textScalerOf(context).scale(1) <= 1.3;
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(Space.xl, Space.xl, Space.md, Space.xl),
      decoration: BoxDecoration(
        borderRadius: Corners.xlAll,
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          // One hue, deepening: stays clean in both colour themes.
          colors: [AppColors.primary, Color.lerp(AppColors.primary, Colors.black, 0.22)!],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    t.exTitle,
                    style: AppType.weight(context.text.headlineSmall!, FontWeight.w800)
                        .copyWith(color: Colors.white, height: 1.2),
                  ),
                ),
                Space.gapSm,
                Text(
                  t.exSubtitle,
                  style: context.text.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.92)),
                ),
              ],
            ),
          ),
          if (roomy) ...[Space.gapSm, const CityScene(width: 112)],
        ],
      ),
    );
  }
}

class _GoalBadge extends StatelessWidget {
  const _GoalBadge({required this.goal});

  final Goal goal;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: goal.accent.withValues(alpha: 0.12),
        borderRadius: Corners.pillAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(goal.icon, size: 16, color: goal.accent),
          const SizedBox(width: 6),
          Text(goal.title(context.t),
              style: context.text.labelMedium?.copyWith(color: goal.accent, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

/// A big, easy tap target: coloured icon, a title and one line of help.
class _ChoiceCard extends StatelessWidget {
  const _ChoiceCard({
    required this.icon,
    required this.accent,
    required this.title,
    required this.body,
    required this.onTap,
  });

  final IconData icon;
  final Color accent;
  final String title;
  final String body;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: Corners.mdAll,
            ),
            child: Icon(icon, size: 30, color: accent),
          ),
          Space.gapLg,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppType.weight(context.text.titleMedium!, FontWeight.w800)),
                const SizedBox(height: 2),
                Text(body, style: context.text.bodyMedium?.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          Space.gapSm,
          const Icon(Icons.chevron_right, color: AppColors.textMuted),
        ],
      ),
    );
  }
}

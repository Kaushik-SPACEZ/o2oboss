import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_motion.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/data/app_store.dart';
import '../../core/data/db_queries.dart';
import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../widgets/pills.dart';
import 'role_tabs.dart';

/// Frame around a role's five tabs: a bottom bar on phones, a side rail on
/// wide screens (tablet/desktop web), so the layout adapts instead of
/// stretching.
class RoleShell extends ConsumerWidget {
  const RoleShell({super.key, required this.role, required this.shell});

  final UserRole role;
  final StatefulNavigationShell shell;

  void _go(int index) => shell.goBranch(index, initialLocation: index == shell.currentIndex);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final tabs = tabsFor(role);
    final badges = _badges(ref, tabs);
    final wide = MediaQuery.sizeOf(context).width >= Sizes.railBreakpoint;

    Widget icon(RoleTab tab, int i, {required bool active}) {
      final base = Icon(active ? tab.activeIcon : tab.icon);
      final count = badges[i];
      return count > 0
          ? Badge(label: Text(count > 99 ? '99+' : '$count'), child: base)
          : base;
    }

    if (wide) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                selectedIndex: shell.currentIndex,
                onDestinationSelected: _go,
                extended: MediaQuery.sizeOf(context).width >= 1200,
                minExtendedWidth: 220,
                leading: const Padding(
                  padding: EdgeInsets.symmetric(vertical: Space.lg),
                  child: BrandMark(size: 34, showName: false),
                ),
                destinations: [
                  for (var i = 0; i < tabs.length; i++)
                    NavigationRailDestination(
                      icon: icon(tabs[i], i, active: false),
                      selectedIcon: icon(tabs[i], i, active: true),
                      label: Text(tabs[i].label(t)),
                    ),
                ],
              ),
            ),
            const VerticalDivider(width: 1, color: AppColors.border),
            Expanded(child: shell),
          ],
        ),
      );
    }

    return Scaffold(
      body: shell,
      bottomNavigationBar: _BottomTabs(
        tabs: tabs,
        badges: badges,
        current: shell.currentIndex,
        onTap: _go,
      ),
    );
  }

  /// Small counts on tabs that hold waiting work.
  List<int> _badges(WidgetRef ref, List<RoleTab> tabs) {
    final db = ref.watch(dbProvider);
    final me = ref.watch(currentUserProvider);
    if (me == null) return List.filled(tabs.length, 0);
    final now = DateTime.now();
    int badgeFor(String path) {
      switch (path) {
        case '/bo/tasks':
          return db.tasksOf(me.id).where((x) => !x.done && x.dueAt.isBefore(now.add(const Duration(hours: 24)))).length;
        case '/bo/followups':
          return db.followUpsOf(me.id).where((f) => !f.done && f.dueAt.isBefore(now)).length;
        case '/vendor/referrals':
          return db.assignments
              .where((a) => a.vendorId == me.vendorId && a.status == AssignmentStatus.pending)
              .length;
        case '/vendor/chat':
          var n = 0;
          for (final a in db.assignments.where((a) => a.vendorId == me.vendorId)) {
            n += db.unreadInThread(me.id, a.enquiryId, a.vendorId);
          }
          return n;
        case '/customer/quotations':
          return db.quotations.where((q) {
            final e = db.enquiryById(q.enquiryId);
            return e?.customerId == me.customerId && q.status == QuotationStatus.sent;
          }).length;
        default:
          return 0;
      }
    }

    return [for (final tab in tabs) badgeFor(tab.path)];
  }
}

/// Bottom bar: outlined icons, and for the open tab a filled icon, a bold
/// label and a short underline, so the current tab never relies on colour
/// alone. Long translated labels shrink to fit instead of wrapping.
class _BottomTabs extends StatelessWidget {
  const _BottomTabs({
    required this.tabs,
    required this.badges,
    required this.current,
    required this.onTap,
  });

  final List<RoleTab> tabs;
  final List<int> badges;
  final int current;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < tabs.length; i++)
              Expanded(
                child: _TabItem(
                  tab: tabs[i],
                  label: tabs[i].label(t),
                  badge: badges[i],
                  active: i == current,
                  onTap: () => onTap(i),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.tab,
    required this.label,
    required this.badge,
    required this.active,
    required this.onTap,
  });

  final RoleTab tab;
  final String label;
  final int badge;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final icon = Icon(
      active ? tab.activeIcon : tab.icon,
      size: 24,
      color: active ? AppColors.primary : AppColors.textSecondary,
    );
    return Semantics(
      button: true,
      selected: active,
      label: badge > 0 ? '$label, $badge' : label,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(2, 10, 2, 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                badge > 0
                    ? Badge(label: Text(badge > 99 ? '99+' : '$badge'), child: icon)
                    : icon,
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    maxLines: 1,
                    style: context.text.labelSmall?.copyWith(
                      fontSize: 12,
                      fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                      color: active ? AppColors.primaryDark : AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                AnimatedContainer(
                  duration: MediaQuery.disableAnimationsOf(context) ? Duration.zero : Motion.micro,
                  curve: Motion.enter,
                  width: active ? 22 : 0,
                  height: 3,
                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: Corners.pillAll),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


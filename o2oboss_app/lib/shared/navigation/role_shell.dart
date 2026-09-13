import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
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
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: NavigationBar(
          selectedIndex: shell.currentIndex,
          onDestinationSelected: _go,
          destinations: [
            for (var i = 0; i < tabs.length; i++)
              NavigationDestination(
                icon: icon(tabs[i], i, active: false),
                selectedIcon: icon(tabs[i], i, active: true),
                label: tabs[i].label(t),
                tooltip: '',
              ),
          ],
        ),
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

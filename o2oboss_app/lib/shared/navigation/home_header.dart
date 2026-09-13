import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/data/app_store.dart';
import '../../core/data/db_queries.dart';
import '../../core/l10n/l10n.dart';
import '../widgets/pills.dart';

/// Top of every role's Home: brand on the start side; search, notifications
/// and the person's avatar on the end.
class HomeTopBar extends ConsumerWidget {
  const HomeTopBar({super.key, this.showSearch = true});

  final bool showSearch;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final me = ref.watch(currentUserProvider);
    if (me == null) return const SizedBox.shrink();
    return SizedBox(
      height: 56,
      child: Row(
        children: [
          const BrandMark(),
          const Spacer(),
          if (showSearch)
            IconButton(
              tooltip: context.t.actionSearch,
              icon: const Icon(Icons.search),
              onPressed: () => context.push(Routes.search),
            ),
          const NotificationBell(),
          const SizedBox(width: Space.xs),
          Semantics(
            button: true,
            label: context.t.navProfile,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => Routes.profileFor(me.role) == Routes.profile
                  ? context.push(Routes.profile)
                  : context.go(Routes.profileFor(me.role)),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: InitialsAvatar(me.name, size: 34),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationBell extends ConsumerWidget {
  const NotificationBell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final me = ref.watch(currentUserProvider);
    final count = me == null ? 0 : ref.watch(dbProvider).unreadNotifications(me.id);
    return IconButton(
      tooltip: context.t.navNotifications,
      onPressed: () => context.push(Routes.notifications),
      icon: Badge(
        isLabelVisible: count > 0,
        label: Text('$count'),
        child: const Icon(Icons.notifications_none),
      ),
    );
  }
}

/// "Good morning, Arun" with a one-line summary under it.
class Greeting extends ConsumerWidget {
  const Greeting({super.key, required this.summary});

  final String summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final me = ref.watch(currentUserProvider);
    if (me == null) return const SizedBox.shrink();
    final t = context.t;
    final first = me.name.split(' ').first;
    final hour = DateTime.now().hour;
    final hello = hour < 12
        ? t.greetingMorning(first)
        : hour < 17
            ? t.greetingAfternoon(first)
            : t.greetingEvening(first);
    // Two lines: a bold hello, then the day's summary in a lighter weight.
    return Padding(
      padding: const EdgeInsets.only(top: Space.sm, bottom: Space.xl),
      child: Semantics(
        header: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(hello, style: context.text.displaySmall),
            const SizedBox(height: 4),
            Text(
              summary,
              style: context.text.bodyLarge?.copyWith(
                fontSize: 20,
                height: 1.3,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/routes.dart';
import '../../core/data/app_store.dart';
import '../../core/l10n/l10n.dart';
import '../../shared/widgets/feedback.dart';
import '../../shared/widgets/layout.dart';

/// Recovery screen for unknown links (spec 03 §26).
class NotFoundScreen extends ConsumerWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final me = ref.watch(currentUserProvider);
    return PageScaffold(
      title: t.notFoundTitle,
      children: [
        EmptyState(
          icon: Icons.link_off,
          title: t.notFoundTitle,
          body: t.notFoundBody,
          actionLabel: t.goHome,
          onAction: () => context.go(me == null ? Routes.login : Routes.home(me.role)),
        ),
      ],
    );
  }
}

/// Shown in place of content the viewer's role may not see (spec 02 §19).
class NoAccessView extends StatelessWidget {
  const NoAccessView({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return PageScaffold(
      title: t.noAccessTitle,
      children: [
        EmptyState(icon: Icons.lock_outline, title: t.noAccessTitle, body: t.noAccessBody),
      ],
    );
  }
}

/// Temporary stand-in while a screen is being built.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: title,
      children: [
        EmptyState(icon: Icons.construction_outlined, title: title, body: context.t.comingSoon),
      ],
    );
  }
}

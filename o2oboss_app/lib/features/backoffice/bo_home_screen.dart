import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/brand/brand_philosophy.dart';
import '../../core/data/app_store.dart';
import '../../core/data/db_queries.dart';
import '../../core/l10n/l10n.dart';
import '../../core/l10n/labels.dart';
import '../../core/models/models.dart';
import '../../core/utils/format.dart';
import '../../shared/navigation/home_header.dart';
import '../../shared/widgets/brand_widgets.dart';
import '../../shared/widgets/cards.dart';
import '../../shared/widgets/enquiry_list.dart';
import '../../shared/widgets/feedback.dart';
import '../../shared/widgets/kpi.dart';
import '../../shared/widgets/layout.dart';
import 'bo_filters.dart';

/// Back office Home: the one most urgent job first, then only the work
/// queues that have something in them. Empty queues stay out of sight.
class BoHomeScreen extends ConsumerWidget {
  const BoHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final me = ref.watch(currentUserProvider);
    final db = ref.watch(dbProvider);
    if (me == null) return const SizedBox.shrink();
    final now = DateTime.now();
    final mine = db.enquiriesFor(me);
    final tasks = db.tasksOf(me.id).where((x) => !x.done).toList();
    final follow = db.followUpsOf(me.id).where((f) => !f.done).toList();
    final dueToday = follow.where((f) => !f.dueAt.isAfter(DateTime(now.year, now.month, now.day, 23, 59))).length;
    final overdue = [
      ...tasks.where((x) => x.dueAt.isBefore(now)),
      ...follow.where((f) => f.dueAt.isBefore(now)),
    ].length;
    final next = tasks.isEmpty ? null : tasks.first;

    final queues = [
      for (final f in boQueueFilters(t))
        (f, mine.where(f.test).length),
    ].where((q) => q.$2 > 0).toList();

    void openQueue(String key) {
      ref.read(listFilterProvider('bo').notifier).set(key);
      context.go('/bo/enquiries');
    }

    return PageScaffold(
      showAppBar: false,
      onRefresh: () => simulateWork(600),
      children: [
        const HomeTopBar(),
        Greeting(summary: t.boHomeSummary(tasks.length + dueToday)),
        const InspirationCard(
          title: kBackOfficeQuote,
          subtitle: kBackOfficeQuoteBody,
          icon: Icons.support_agent,
          gradient: [Color(0xFFEDE7F6), Color(0xFFD1C4E9)],
        ),
        if (next != null) _NextTask(task: next) else _AllClear(),
        Space.gapLg,
        StatStrip(items: [
          StatItem(
            label: t.boKpiToday,
            value: '$dueToday',
            icon: Icons.phone_callback_outlined,
            onTap: () => context.go('/bo/followups'),
          ),
          StatItem(
            label: t.boKpiOverdue,
            value: '$overdue',
            icon: Icons.warning_amber_rounded,
            tone: overdue > 0 ? Tone.danger : Tone.neutral,
            onTap: () => context.go('/bo/tasks'),
          ),
          StatItem(
            label: t.boKpiTasks,
            value: '${tasks.length}',
            icon: Icons.task_alt,
            tone: Tone.purple,
            onTap: () => context.go('/bo/tasks'),
          ),
          StatItem(
            label: t.boKpiActive,
            value: '${mine.where((e) => !e.status.isEnded).length}',
            icon: Icons.assignment_outlined,
            tone: Tone.success,
            onTap: () => openQueue('all'),
          ),
        ]),
        SectionHeader(t.homeQuickActions),
        TileGrid(children: [
          QuickActionTile(
            icon: Icons.add,
            label: t.boNewEnquiryShort,
            subtitle: t.qaSubNewEnquiry,
            onTap: () => context.push(Routes.refer()),
          ),
          QuickActionTile(
            icon: Icons.call_outlined,
            label: t.listCalls,
            subtitle: t.qaSubCalls,
            tint: ActionTint.green,
            onTap: () => context.push(Routes.calls),
          ),
          QuickActionTile(
            icon: Icons.event_outlined,
            label: t.listVisits,
            subtitle: t.qaSubVisits,
            tint: ActionTint.purple,
            onTap: () => context.push(Routes.appointments),
          ),
          QuickActionTile(
            icon: Icons.chat_bubble_outline,
            label: t.navChat,
            subtitle: t.qaSubChat,
            tint: ActionTint.pink,
            onTap: () => context.push('/chats'),
          ),
        ]),
        SectionHeader(t.boQueues),
        if (queues.isEmpty)
          AppCard(child: EmptyState(compact: true, icon: Icons.inbox_outlined, title: t.boQueuesEmpty))
        else
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (var i = 0; i < queues.length; i++) ...[
                  if (i > 0) const Divider(indent: 52),
                  QueueRow(
                    icon: queues[i].$1.icon,
                    label: queues[i].$1.label,
                    count: queues[i].$2,
                    urgent: queues[i].$1.urgent,
                    onTap: () => openQueue(queues[i].$1.key),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _NextTask extends ConsumerWidget {
  const _NextTask({required this.task});

  final TaskItem task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final e = db.enquiryById(task.enquiryId);
    final late = task.dueAt.isBefore(DateTime.now());
    final dueColor = late ? AppColors.dangerText : AppColors.textSecondary;
    return Semantics(
      button: true,
      child: SoftHeroCard(
        onTap: () => openTask(context, ref, task),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.boNextUp,
                          style: context.text.labelMedium?.copyWith(color: AppColors.primaryDark)),
                      const SizedBox(height: 4),
                      Text(taskTitle(t, task, db), style: context.text.titleLarge),
                      if (e != null) ...[
                        const SizedBox(height: 2),
                        Text('${db.enquiryTitle(e)}, ${db.customerName(e.customerId)}',
                            style: context.text.bodyMedium?.copyWith(color: AppColors.textSecondary)),
                      ],
                    ],
                  ),
                ),
                Space.gapMd,
                GlowIcon(late ? Icons.alarm : Icons.task_alt,
                    color: late ? AppColors.danger : AppColors.primary),
              ],
            ),
            Space.gapLg,
            Row(
              children: [
                PillButtonLabel(t.actionOpen),
                Space.gapMd,
                Icon(late ? Icons.warning_amber_rounded : Icons.schedule, size: 16, color: dueColor),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    late ? t.overdue : t.dueAt(Fmt.dateTime(context, task.dueAt)),
                    style: context.text.bodySmall?.copyWith(color: dueColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AllClear extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return NoteCard(
      tone: Tone.success,
      icon: Icons.check_circle_outline,
      title: t.boAllClearTitle,
      text: t.boAllClearBody,
    );
  }
}

/// Opens the page where a task gets done.
void openTask(BuildContext context, WidgetRef ref, TaskItem task) {
  final db = ref.read(dbProvider);
  final id = task.enquiryId;
  final route = switch (task.kind) {
    TaskKind.verify when id != null => Routes.enquiryPart(id, 'verify'),
    TaskKind.qualify when id != null => Routes.enquiryPart(id, 'qualify'),
    TaskKind.assignVendor || TaskKind.vendorNoResponse when id != null =>
      Routes.enquiryPart(id, 'vendors'),
    TaskKind.reviewQuotation when task.refId != null => Routes.quotation(task.refId!),
    TaskKind.collectPayment when id != null && db.projectFor(id) != null =>
      Routes.project(db.projectFor(id)!.id),
    TaskKind.approveCommission when id != null => Routes.enquiryPart(id, 'commission'),
    TaskKind.approveVendor when task.refId != null => Routes.vendor(task.refId!),
    _ when id != null => Routes.enquiry(id),
    _ => null,
  };
  if (route != null) context.push(route);
}

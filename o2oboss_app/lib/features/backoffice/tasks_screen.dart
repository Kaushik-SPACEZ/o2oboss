import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/data/app_store.dart';
import '../../core/data/db_queries.dart';
import '../../core/l10n/l10n.dart';
import '../../core/l10n/labels.dart';
import '../../core/models/models.dart';
import '../../core/utils/format.dart';
import '../../shared/widgets/buttons.dart';
import '../../shared/widgets/feedback.dart';
import '../../shared/widgets/inputs.dart';
import '../../shared/widgets/layout.dart';
import '../../shared/widgets/sheets.dart';
import 'bo_home_screen.dart';

/// Work the system created (verify, review quotation…) plus the person's
/// own to-dos. System tasks close themselves when the work is done.
class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  bool _showDone = false;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final me = ref.watch(currentUserProvider);
    final db = ref.watch(dbProvider);
    if (me == null) return const SizedBox.shrink();
    final all = db.tasksOf(me.id);
    final open = all.where((x) => !x.done).toList();
    final done = all.where((x) => x.done).toList()
      ..sort((a, b) => (b.doneAt ?? b.dueAt).compareTo(a.doneAt ?? a.dueAt));
    final shown = _showDone ? done.take(30).toList() : open;

    return PageScaffold(
      title: t.navTasks,
      fab: FloatingActionButton.extended(
        onPressed: () => _add(context),
        icon: const Icon(Icons.add),
        label: Text(t.taskAdd),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(0, Space.sm, 0, 120),
        children: [
          FilterChipsRow<bool>(
            items: [(false, t.taskToDo, open.length), (true, t.completed, null)],
            selected: _showDone,
            onSelected: (v) => setState(() => _showDone = v),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Space.page(context)),
            child: shown.isEmpty
                ? EmptyState(
                    icon: Icons.task_alt,
                    title: _showDone ? t.emptyTitle : t.taskEmptyTitle,
                    body: _showDone ? null : t.taskEmptyBody,
                  )
                : AppCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        for (var i = 0; i < shown.length; i++) ...[
                          if (i > 0) const Divider(indent: 56),
                          _TaskRow(task: shown[i]),
                        ],
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _add(BuildContext context) async {
    final t = context.t;
    final result = await showAppSheet<({String title, DateTime due})>(
      context,
      title: t.taskAdd,
      builder: (_) => const _AddTask(),
    );
    if (result == null) return;
    ref.read(dbProvider.notifier).addTask(result.title, result.due);
    if (context.mounted) showToast(context, t.taskAdded);
  }
}

class _TaskRow extends ConsumerWidget {
  const _TaskRow({required this.task});

  final TaskItem task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final late = !task.done && task.dueAt.isBefore(DateTime.now());
    final e = db.enquiryById(task.enquiryId);
    return ListTile(
      contentPadding: const EdgeInsets.fromLTRB(Space.sm, Space.xs, Space.lg, Space.xs),
      leading: Checkbox(
        value: task.done,
        onChanged: task.done
            ? null
            : (_) {
                ref.read(dbProvider.notifier).completeTask(task.id);
                showToast(context, t.taskDone);
              },
      ),
      title: Text(taskTitle(t, task, db),
          style: context.text.bodyLarge?.copyWith(
              decoration: task.done ? TextDecoration.lineThrough : null)),
      subtitle: Text(
        [
          if (e != null) '${db.enquiryTitle(e)}, ${db.customerName(e.customerId)}',
          task.done
              ? t.fuDoneOn(Fmt.dateTime(context, task.doneAt ?? task.dueAt))
              : (late ? '${t.overdue}, ${Fmt.dateTime(context, task.dueAt)}' : t.dueAt(Fmt.dateTime(context, task.dueAt))),
        ].join('\n'),
        style: context.text.bodySmall?.copyWith(color: late ? AppColors.dangerText : null),
      ),
      trailing: task.done || task.kind == TaskKind.general
          ? null
          : const Icon(Icons.chevron_right, color: AppColors.textMuted),
      onTap: task.done ? null : () => openTask(context, ref, task),
    );
  }
}

class _AddTask extends StatefulWidget {
  const _AddTask();

  @override
  State<_AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<_AddTask> {
  final _title = TextEditingController();
  final _form = GlobalKey<FormState>();
  DateTime _due = DateTime.now().add(const Duration(hours: 3));

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            label: t.taskWhat,
            controller: _title,
            required: true,
            autofocus: true,
            validator: (v) => (v ?? '').trim().isEmpty ? t.validationRequired : null,
          ),
          Space.gapLg,
          DateTimeField(
            label: t.taskDue,
            value: _due,
            firstDate: DateTime.now(),
            onChanged: (v) => setState(() => _due = v),
          ),
          Space.gapLg,
          AppButton(t.actionAdd, onPressed: () {
            if (!_form.currentState!.validate()) return;
            Navigator.pop(context, (title: _title.text.trim(), due: _due));
          }),
        ],
      ),
    );
  }
}

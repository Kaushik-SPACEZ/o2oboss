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
import '../../core/l10n/labels.dart';
import '../../core/models/models.dart';
import '../../core/utils/format.dart';
import '../../shared/widgets/feedback.dart';
import '../../shared/widgets/inputs.dart';
import '../../shared/widgets/layout.dart';
import '../../shared/widgets/pills.dart';
import '../../shared/widgets/sheets.dart';
import '../common/system_screens.dart';

/// The conversations of one enquiry: the customer and each vendor, kept
/// separate so each side only sees its own chat with O2O Boss.
class ChatThreadsScreen extends ConsumerWidget {
  const ChatThreadsScreen({super.key, required this.enquiry});

  final Enquiry enquiry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final me = ref.watch(currentUserProvider)!;
    final e = enquiry;
    if (me.role == UserRole.vendor) {
      return ChatScreen(enquiryId: e.id, thread: me.vendorId!);
    }
    if (me.role == UserRole.customer) {
      return ChatScreen(enquiryId: e.id, thread: ChatMessage.customerThread);
    }
    final threads = db.threadsFor(e.id);
    return PageScaffold(
      title: t.navChat,
      children: [
        Text(t.chatThreadsHelp, style: context.text.bodySmall),
        Space.gapLg,
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (var i = 0; i < threads.length; i++) ...[
                if (i > 0) const Divider(indent: 72),
                _ThreadRow(enquiry: e, thread: threads[i]),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ThreadRow extends ConsumerWidget {
  const _ThreadRow({required this.enquiry, required this.thread, this.showEnquiry = false});

  final Enquiry enquiry;
  final String thread;
  final bool showEnquiry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final me = ref.watch(currentUserProvider)!;
    final msgs = db.threadMessages(enquiry.id, thread);
    final last = msgs.lastOrNull;
    final unread = db.unreadInThread(me.id, enquiry.id, thread);
    final isCustomer = thread == ChatMessage.customerThread;
    final name = isCustomer ? db.customerName(enquiry.customerId) : db.vendorName(thread);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.xs),
      leading: InitialsAvatar(name),
      title: Text(
        showEnquiry ? '$name, ${enquiry.id}' : name,
        style: context.text.bodyLarge?.copyWith(
            fontWeight: unread > 0 ? FontWeight.w600 : FontWeight.w500),
      ),
      subtitle: Text(
        last == null
            ? (isCustomer ? t.roleCustomer : t.roleVendor)
            : chatText(t, last.text, (d) => Fmt.dateTime(context, d)),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.text.bodySmall,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (last != null) Text(Fmt.relative(context, last.at), style: context.text.labelSmall),
          if (unread > 0) ...[const SizedBox(height: 4), CountBadge(unread, tone: Tone.info)],
        ],
      ),
      onTap: () => context.push(Routes.chat(enquiry.id, thread)),
    );
  }
}

/// A list of every conversation the person is part of, newest first.
/// The vendor's Chat tab; also useful for back office.
class AllChatsView extends ConsumerWidget {
  const AllChatsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final me = ref.watch(currentUserProvider)!;
    final rows = <(Enquiry, String, DateTime)>[];
    for (final e in db.enquiriesFor(me)) {
      final threads = switch (me.role) {
        UserRole.vendor => [me.vendorId!],
        UserRole.customer => [ChatMessage.customerThread],
        _ => db.threadsFor(e.id),
      };
      for (final th in threads) {
        final last = db.threadMessages(e.id, th).lastOrNull;
        if (last != null) rows.add((e, th, last.at));
      }
    }
    rows.sort((a, b) => b.$3.compareTo(a.$3));
    return PageScaffold(
      title: t.navChat,
      children: [
        if (rows.isEmpty)
          EmptyState(icon: Icons.chat_bubble_outline, title: t.chatNoneTitle, body: t.chatNoneBody)
        else
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (var i = 0; i < rows.length; i++) ...[
                  if (i > 0) const Divider(indent: 72),
                  me.role == UserRole.vendor
                      ? _VendorThreadRow(enquiry: rows[i].$1)
                      : _ThreadRow(enquiry: rows[i].$1, thread: rows[i].$2, showEnquiry: true),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _VendorThreadRow extends ConsumerWidget {
  const _VendorThreadRow({required this.enquiry});

  final Enquiry enquiry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final me = ref.watch(currentUserProvider)!;
    final thread = me.vendorId!;
    final last = db.threadMessages(enquiry.id, thread).lastOrNull;
    final unread = db.unreadInThread(me.id, enquiry.id, thread);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.xs),
      leading: CircleAvatar(
        backgroundColor: AppColors.primaryLight,
        child: Icon(Icons.support_agent, color: AppColors.primary),
      ),
      title: Text('${db.enquiryTitle(enquiry)}, ${enquiry.id}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.text.bodyLarge?.copyWith(
              fontWeight: unread > 0 ? FontWeight.w600 : FontWeight.w500)),
      subtitle: Text(
        last == null ? t.chatWithO2O : chatText(t, last.text, (d) => Fmt.dateTime(context, d)),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.text.bodySmall,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (last != null) Text(Fmt.relative(context, last.at), style: context.text.labelSmall),
          if (unread > 0) ...[const SizedBox(height: 4), CountBadge(unread, tone: Tone.info)],
        ],
      ),
      onTap: () => context.push(Routes.chat(enquiry.id, thread)),
    );
  }
}

/// One conversation. Status updates appear as small centred notes so the
/// chat also works as a history of the referral.
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key, required this.enquiryId, required this.thread});

  final String enquiryId;
  final String thread;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _input = TextEditingController();
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(dbProvider.notifier).markThreadRead(widget.enquiryId, widget.thread);
    });
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send({ChatKind kind = ChatKind.text, String? fileName}) {
    final text = kind == ChatKind.text ? _input.text.trim() : (fileName ?? '');
    if (text.isEmpty) return;
    ref.read(dbProvider.notifier)
        .sendMessage(widget.enquiryId, widget.thread, text, kind: kind, fileName: fileName);
    if (kind == ChatKind.text) _input.clear();
  }

  Future<void> _attach() async {
    final t = context.t;
    final picked = await pickOption<ChatKind>(
      context,
      title: t.chatAttach,
      options: [
        SelectOption(ChatKind.image, t.chatPhoto, icon: Icons.photo_outlined),
        SelectOption(ChatKind.document, t.chatDocument, icon: Icons.description_outlined),
      ],
    );
    if (picked == null) return;
    final name = picked == ChatKind.image
        ? 'photo_${DateTime.now().millisecondsSinceEpoch % 10000}.jpg'
        : 'document_${DateTime.now().millisecondsSinceEpoch % 10000}.pdf';
    _send(kind: picked, fileName: name);
    if (mounted) showToast(context, t.chatAttached);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final me = ref.watch(currentUserProvider);
    final e = db.enquiryById(widget.enquiryId);
    if (me == null) return const SizedBox.shrink();
    if (e == null) return const NotFoundScreen();
    final allowed = db.canView(me, e) &&
        switch (me.role) {
          UserRole.vendor => widget.thread == me.vendorId,
          UserRole.customer => widget.thread == ChatMessage.customerThread,
          UserRole.sales => false,
          _ => true,
        };
    if (!allowed) return const NoAccessView();
    final msgs = db.threadMessages(e.id, widget.thread).reversed.toList();
    final readOnly = me.role == UserRole.franchise || e.status.isClosed;
    final isOpsSide = me.role == UserRole.backOffice || me.role == UserRole.admin;
    final title = me.role == UserRole.vendor || me.role == UserRole.customer
        ? t.chatWithO2O
        : widget.thread == ChatMessage.customerThread
            ? db.customerName(e.customerId)
            : db.vendorName(widget.thread);

    return PageScaffold(
      titleWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: context.text.titleMedium),
          Text('${db.enquiryTitle(e)}, ${e.id}',
              style: context.text.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
      actions: [
        if (me.role == UserRole.vendor || me.role == UserRole.customer)
          IconButton(
            tooltip: t.chatOpenEnquiry,
            icon: const Icon(Icons.info_outline),
            onPressed: () => context.push(Routes.enquiry(e.id)),
          ),
      ],
      body: Column(
        children: [
          Expanded(
            child: msgs.isEmpty
                ? EmptyState(icon: Icons.chat_bubble_outline, title: t.chatEmptyTitle, body: t.chatEmptyBody)
                : ListView.builder(
                    controller: _scroll,
                    reverse: true,
                    padding: EdgeInsets.fromLTRB(
                        Space.page(context), Space.md, Space.page(context), Space.md),
                    itemCount: msgs.length,
                    itemBuilder: (context, i) {
                      final m = msgs[i];
                      final newer = i > 0 ? msgs[i - 1] : null;
                      final older = i + 1 < msgs.length ? msgs[i + 1] : null;
                      final showDay = older == null || !_sameDay(older.at, m.at);
                      // "Mine" means sent by my side of the conversation.
                      final mine = m.senderUserId == me.id ||
                          (isOpsSide &&
                              (m.senderRole == UserRole.backOffice || m.senderRole == UserRole.admin));
                      return Column(
                        children: [
                          if (showDay) _DayLabel(date: m.at),
                          _Bubble(message: m, mine: mine, grouped: newer?.senderUserId == m.senderUserId),
                        ],
                      );
                    },
                  ),
          ),
          if (readOnly)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Space.md),
              color: AppColors.track,
              child: Text(
                me.role == UserRole.franchise ? t.chatReadOnly : t.chatClosed,
                textAlign: TextAlign.center,
                style: context.text.bodySmall,
              ),
            )
          else
            _Composer(controller: _input, onSend: () => _send(), onAttach: _attach),
        ],
      ),
    );
  }

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _DayLabel extends StatelessWidget {
  const _DayLabel({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: Space.md),
        child: Text(Fmt.dayOrDate(context, date), style: context.text.labelSmall),
      );
}

class _Bubble extends ConsumerWidget {
  const _Bubble({required this.message, required this.mine, required this.grouped});

  final ChatMessage message;
  final bool mine;
  final bool grouped;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final m = message;
    final text = chatText(t, m.text, (d) => Fmt.dateTime(context, d));
    if (m.kind == ChatKind.system) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: Space.sm),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: 6),
            decoration: const BoxDecoration(color: AppColors.track, borderRadius: Corners.pillAll),
            child: Text(text, textAlign: TextAlign.center, style: context.text.labelSmall),
          ),
        ),
      );
    }
    final sender = m.senderRole == UserRole.vendor
        ? db.vendorName(db.userById(m.senderUserId)?.vendorId)
        : m.senderRole == UserRole.customer
            ? db.userName(m.senderUserId)
            : t.chatO2OTeam(db.userName(m.senderUserId).split(' ').first);
    final bg = mine ? AppColors.primary : AppColors.surface;
    final fg = mine ? Colors.white : AppColors.text;
    final isFile = m.kind == ChatKind.image || m.kind == ChatKind.document;
    return Align(
      alignment: mine ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.78),
        child: Container(
          margin: EdgeInsets.only(top: grouped ? 3 : Space.sm),
          padding: const EdgeInsets.fromLTRB(Space.md, Space.sm, Space.md, 6),
          decoration: BoxDecoration(
            color: bg,
            border: mine ? null : Border.all(color: AppColors.border),
            borderRadius: BorderRadiusDirectional.only(
              topStart: const Radius.circular(16),
              topEnd: const Radius.circular(16),
              bottomStart: Radius.circular(mine ? 16 : 4),
              bottomEnd: Radius.circular(mine ? 4 : 16),
            ).resolve(Directionality.of(context)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!mine && !grouped)
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(sender,
                      style: context.text.labelSmall
                          ?.copyWith(fontWeight: FontWeight.w700, color: AppColors.primaryDark)),
                ),
              if (isFile)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(m.kind == ChatKind.image ? Icons.image_outlined : Icons.description_outlined,
                        color: fg, size: 20),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(m.fileName ?? text,
                          style: context.text.bodyMedium?.copyWith(
                              color: fg, decoration: TextDecoration.underline)),
                    ),
                  ],
                )
              else
                Text(text, style: context.text.bodyMedium?.copyWith(color: fg)),
              const SizedBox(height: 2),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Text(
                  Fmt.time(context, m.at),
                  style: context.text.labelSmall?.copyWith(
                      color: mine ? Colors.white.withValues(alpha: 0.8) : AppColors.textSecondary,
                      fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Composer extends StatefulWidget {
  const _Composer({required this.controller, required this.onSend, required this.onAttach});

  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onAttach;

  @override
  State<_Composer> createState() => _ComposerState();
}

class _ComposerState extends State<_Composer> {
  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final empty = widget.controller.text.trim().isEmpty;
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(Space.sm, Space.sm, Space.sm, Space.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                tooltip: t.chatAttach,
                icon: const Icon(Icons.attach_file),
                onPressed: widget.onAttach,
              ),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  minLines: 1,
                  maxLines: 4,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (_) => setState(() {}),
                  onSubmitted: (_) => widget.onSend(),
                  decoration: InputDecoration(
                    hintText: t.chatHint,
                    contentPadding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: Space.xs),
              IconButton.filled(
                tooltip: t.actionSend,
                onPressed: empty
                    ? null
                    : () {
                        widget.onSend();
                        setState(() {});
                      },
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

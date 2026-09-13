import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
import '../../shared/widgets/layout.dart';
import '../../shared/widgets/pills.dart';

/// Everything that happened for this person, newest first. Tapping an item
/// marks it read and opens the related page.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final me = ref.watch(currentUserProvider);
    final db = ref.watch(dbProvider);
    if (me == null) return const SizedBox.shrink();
    final items = db.notificationsOf(me.id);
    final unread = items.where((n) => !n.read).length;
    final today = items.where((n) => Fmt.isToday(n.createdAt)).toList();
    final earlier = items.where((n) => !Fmt.isToday(n.createdAt)).toList();

    return PageScaffold(
      title: t.navNotifications,
      actions: [
        if (unread > 0)
          // An icon, not a label: "mark all as read" is long in many
          // languages and would push the app bar past the screen edge.
          IconButton(
            tooltip: t.notifMarkAll,
            icon: const Icon(Icons.done_all),
            onPressed: () {
              ref.read(dbProvider.notifier).markAllNotificationsRead();
              showToast(context, t.notifAllRead);
            },
          ),
      ],
      children: [
        if (items.isEmpty)
          EmptyState(
            icon: Icons.notifications_none,
            title: t.notifEmptyTitle,
            body: t.notifEmptyBody,
          )
        else ...[
          if (today.isNotEmpty) ...[
            SectionHeader(t.today, top: Space.sm),
            _Group(items: today),
          ],
          if (earlier.isNotEmpty) ...[
            SectionHeader(t.notifEarlier, top: today.isEmpty ? Space.sm : Space.xl),
            _Group(items: earlier),
          ],
        ],
      ],
    );
  }
}

class _Group extends StatelessWidget {
  const _Group({required this.items});

  final List<AppNotification> items;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const Divider(indent: 66),
            _NotificationRow(n: items[i]),
          ],
        ],
      ),
    );
  }
}

class _NotificationRow extends ConsumerWidget {
  const _NotificationRow({required this.n});

  final AppNotification n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final (title, body) = notificationText(t, n);
    return Semantics(
      label: n.read ? null : t.notifUnread,
      child: InkWell(
        onTap: () {
          ref.read(dbProvider.notifier).markNotificationRead(n.id);
          if (n.route != null) context.push(n.route!);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconTile(_icon(n.event), tone: _tone(n.event), size: 38),
              Space.gapMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: context.text.bodyLarge?.copyWith(
                            fontWeight: n.read ? FontWeight.w400 : FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(body, style: context.text.bodySmall),
                    const SizedBox(height: 4),
                    Text(Fmt.relative(context, n.createdAt), style: context.text.labelSmall),
                  ],
                ),
              ),
              if (!n.read)
                Container(
                  margin: const EdgeInsets.only(top: 6, left: Space.sm),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                ),
            ],
          ),
        ),
      ),
    );
  }

  static IconData _icon(NotificationEvent e) => switch (e) {
        NotificationEvent.chatMessage => Icons.chat_bubble_outline,
        NotificationEvent.appointmentProposed ||
        NotificationEvent.appointmentConfirmed ||
        NotificationEvent.appointmentChanged =>
          Icons.event_outlined,
        NotificationEvent.quotationSubmitted ||
        NotificationEvent.quotationReceived ||
        NotificationEvent.quotationApproved ||
        NotificationEvent.quotationCopy ||
        NotificationEvent.revisionRequested ||
        NotificationEvent.quotationAccepted ||
        NotificationEvent.quotationRejected =>
          Icons.request_quote_outlined,
        NotificationEvent.paymentRecorded ||
        NotificationEvent.paymentReminder ||
        NotificationEvent.commissionUpdated ||
        NotificationEvent.commissionPaid =>
          Icons.currency_rupee,
        NotificationEvent.enquiryWon => Icons.emoji_events_outlined,
        NotificationEvent.enquiryRejected || NotificationEvent.enquiryLost => Icons.cancel_outlined,
        NotificationEvent.newReferral || NotificationEvent.referralReminder => Icons.inbox_outlined,
        NotificationEvent.projectCreated ||
        NotificationEvent.projectUpdated ||
        NotificationEvent.projectCompleted =>
          Icons.construction_outlined,
        NotificationEvent.followUpDue || NotificationEvent.taskAssigned => Icons.task_alt,
        NotificationEvent.vendorApproved ||
        NotificationEvent.vendorRegistered ||
        NotificationEvent.vendorAssigned ||
        NotificationEvent.vendorConnected ||
        NotificationEvent.referralAccepted ||
        NotificationEvent.referralRejected ||
        NotificationEvent.accountCreated =>
          Icons.storefront_outlined,
        NotificationEvent.enquirySubmitted ||
        NotificationEvent.newEnquiry ||
        NotificationEvent.enquiryVerified ||
        NotificationEvent.enquiryQualified =>
          Icons.assignment_outlined,
        NotificationEvent.configChanged => Icons.tune,
        NotificationEvent.feedbackRequest => Icons.star_outline,
      };

  static Tone _tone(NotificationEvent e) => switch (e) {
        NotificationEvent.enquiryWon ||
        NotificationEvent.quotationAccepted ||
        NotificationEvent.commissionPaid ||
        NotificationEvent.paymentRecorded ||
        NotificationEvent.vendorApproved =>
          Tone.success,
        NotificationEvent.enquiryRejected ||
        NotificationEvent.enquiryLost ||
        NotificationEvent.quotationRejected ||
        NotificationEvent.referralRejected =>
          Tone.danger,
        NotificationEvent.followUpDue ||
        NotificationEvent.referralReminder ||
        NotificationEvent.paymentReminder ||
        NotificationEvent.revisionRequested =>
          Tone.warning,
        _ => Tone.info,
      };
}

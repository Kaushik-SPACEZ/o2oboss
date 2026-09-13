import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/data/app_store.dart';
import '../../core/l10n/l10n.dart';
import '../../shared/widgets/cards.dart';
import '../../shared/widgets/layout.dart';

/// Which channels the person wants updates on. Channels switched off by
/// O2O Boss are shown but cannot be turned on.
class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final me = ref.watch(currentUserProvider);
    final config = ref.watch(configProvider);
    if (me == null) return const SizedBox.shrink();
    final store = ref.read(dbProvider.notifier);
    final rows = [
      (Icons.notifications_active_outlined, t.channelPush, t.channelPushBody, me.pushOn,
          config.pushEnabled, (bool v) => store.setMyNotificationPrefs(push: v)),
      (Icons.email_outlined, t.channelEmail, t.channelEmailBody, me.emailOn,
          config.emailEnabled, (bool v) => store.setMyNotificationPrefs(email: v)),
      (Icons.sms_outlined, t.channelSms, t.channelSmsBody, me.smsOn,
          config.smsEnabled, (bool v) => store.setMyNotificationPrefs(sms: v)),
      (Icons.chat_outlined, t.channelWhatsapp, t.channelWhatsappBody, me.whatsappOn,
          config.whatsappEnabled, (bool v) => store.setMyNotificationPrefs(whatsapp: v)),
    ];
    return PageScaffold(
      title: t.profileNotifications,
      children: [
        NoteCard(text: t.channelInAppNote),
        Space.gapLg,
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (var i = 0; i < rows.length; i++) ...[
                if (i > 0) const Divider(indent: Space.lg),
                SwitchListTile(
                  secondary: Icon(rows[i].$1),
                  title: Text(rows[i].$2, style: context.text.bodyLarge),
                  subtitle: Text(rows[i].$5 ? rows[i].$3 : t.channelOffByAdmin,
                      style: context.text.bodySmall),
                  value: rows[i].$5 && rows[i].$4,
                  onChanged: rows[i].$5 ? rows[i].$6 : null,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

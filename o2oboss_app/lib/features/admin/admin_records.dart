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
import '../../shared/widgets/tones.dart';
import '../common/system_screens.dart';

/// Who changed what, newest first. Filter by the kind of record.
class AdminAuditScreen extends ConsumerStatefulWidget {
  const AdminAuditScreen({super.key});

  @override
  ConsumerState<AdminAuditScreen> createState() => _AdminAuditScreenState();
}

class _AdminAuditScreenState extends ConsumerState<AdminAuditScreen> {
  String _kind = 'all';

  static bool _matches(String kind, AuditEntry a) => switch (kind) {
        'enquiry' => a.enquiryId != null,
        'user' => a.entityType == 'user',
        'config' => a.entityType == 'config',
        'vendor' => a.entityType == 'vendor' || a.entityType == 'assignment',
        _ => true,
      };

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final me = ref.watch(currentUserProvider);
    if (me?.role != UserRole.admin) return const NoAccessView();
    final db = ref.watch(dbProvider);
    final all = [...db.audit]..sort((a, b) => b.at.compareTo(a.at));
    final shown = all.where((a) => _matches(_kind, a)).take(150).toList();
    final kinds = [
      ('all', t.labelAll),
      ('enquiry', t.adAuditEnquiries),
      ('user', t.adAuditPeople),
      ('vendor', t.adAuditVendors),
      ('config', t.adAuditSettings),
    ];

    return PageScaffold(
      title: t.adAudit,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(0, Space.sm, 0, Space.xxxl),
        children: [
          FilterChipsRow<String>(
            items: [for (final (k, l) in kinds) (k, l, all.where((a) => _matches(k, a)).length)],
            selected: _kind,
            onSelected: (k) => setState(() => _kind = k),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Space.page(context)),
            child: shown.isEmpty
                ? EmptyState(icon: Icons.history, title: t.emptyTitle)
                : AppCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        for (var i = 0; i < shown.length; i++) ...[
                          if (i > 0) const Divider(indent: 66),
                          _AuditRow(entry: shown[i]),
                        ],
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _AuditRow extends ConsumerWidget {
  const _AuditRow({required this.entry});

  final AuditEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final a = entry;
    final who = a.userId == null ? t.adSystem : db.userName(a.userId);
    final icon = switch (a.entityType) {
      'user' => Icons.person_outline,
      'config' => Icons.tune,
      'vendor' || 'assignment' => Icons.storefront_outlined,
      'quotation' => Icons.request_quote_outlined,
      'project' || 'payment' => Icons.construction_outlined,
      'commission' => Icons.currency_rupee,
      _ => Icons.assignment_outlined,
    };
    return InkWell(
      onTap: a.enquiryId == null ? null : () => context.push(Routes.enquiry(a.enquiryId!)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconTile(icon, tone: Tone.neutral, size: 38),
            Space.gapMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(auditText(t, a), style: context.text.bodyMedium),
                  const SizedBox(height: 2),
                  Text(
                    [who, ?a.enquiryId, Fmt.relative(context, a.at)].join(', '),
                    style: context.text.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// What each role can do, in one sentence, with how many people have it.
class AdminRolesScreen extends ConsumerWidget {
  const AdminRolesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    String describe(UserRole r) => switch (r) {
          UserRole.sales => t.adRoleSales,
          UserRole.backOffice => t.adRoleBackOffice,
          UserRole.vendor => t.adRoleVendor,
          UserRole.customer => t.adRoleCustomer,
          UserRole.franchise => t.adRoleFranchise,
          UserRole.admin => t.adRoleAdmin,
        };
    return PageScaffold(
      title: t.adRoles,
      children: [
        Gap(children: [
          for (final r in UserRole.values)
            AppCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconTile(roleIcon(r), size: 40),
                  Space.gapMd,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(roleLabel(t, r), style: context.text.titleSmall),
                        const SizedBox(height: 2),
                        Text(describe(r), style: context.text.bodySmall),
                      ],
                    ),
                  ),
                  Space.gapSm,
                  StatusPill(t.adUsersCount(db.usersWithRole(r).length)),
                ],
              ),
            ),
        ]),
      ],
    );
  }
}

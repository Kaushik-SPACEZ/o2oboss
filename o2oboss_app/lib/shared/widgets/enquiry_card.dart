import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/data/app_store.dart';
import '../../core/data/db_queries.dart';
import '../../core/data/visibility.dart';
import '../../core/l10n/l10n.dart';
import '../../core/l10n/labels.dart';
import '../../core/models/models.dart';
import '../../core/utils/format.dart';
import 'journey.dart';
import 'layout.dart';
import 'pills.dart';
import 'tones.dart';

/// Compact enquiry summary used in every list. Shows only what the viewer's
/// role is allowed and needs to see: what, who, where it stands, and when.
class EnquiryCard extends ConsumerWidget {
  const EnquiryCard({super.key, required this.enquiry, this.onTap});

  final Enquiry enquiry;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(dbProvider);
    final me = ref.watch(currentUserProvider);
    if (me == null) return const SizedBox.shrink();
    final e = enquiry;
    final t = context.t;
    final category = db.categoryById(e.categoryId);
    final isVendor = me.role == UserRole.vendor;
    final subject = isVendor || me.role == UserRole.customer
        ? '${e.area}, ${e.city}'
        : db.customerName(e.customerId);
    final value = visibleValue(me, e, db.config);
    // Vendors see their own referral's state first ("New referral").
    final reply = isVendor ? db.assignmentFor(e.id, me.vendorId ?? '')?.status : null;
    final (statusText, tone) = reply == AssignmentStatus.pending
        ? (t.vnStatusNew, Tone.warning)
        : reply == AssignmentStatus.rejected || reply == AssignmentStatus.expired
            ? (assignmentLabel(t, reply!), Tone.neutral)
            : (statusLabelFor(t, me.role, e.status), statusTone(e.status));
    final vendors = isVendor
        ? const <String>[]
        : [
            for (final a in db.activeAssignmentsFor(e.id))
              if (me.role != UserRole.customer || a.status == AssignmentStatus.accepted)
                db.vendorName(a.vendorId),
          ];

    return AppCard(
      onTap: onTap ?? () => context.push(Routes.enquiry(e.id)),
      padding: const EdgeInsets.all(Space.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconTile(categoryIcon(category?.icon ?? 'other'), tone: Tone.info),
              Space.gapMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      db.enquiryTitle(e),
                      style: context.text.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(subject,
                        style: context.text.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              Space.gapSm,
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 156),
                child: StatusPill(statusText, tone: tone),
              ),
            ],
          ),
          Space.gapMd,
          JourneyBar(status: e.status),
          if (vendors.isNotEmpty) ...[
            Space.gapSm,
            Row(
              children: [
                const Icon(Icons.storefront_outlined, size: 15, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(vendors.join(', '),
                      style: context.text.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ],
          Space.gapSm,
          Row(
            children: [
              Text(e.id,
                  style: context.text.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600, color: AppColors.neutralText)),
              Space.gapMd,
              const Icon(Icons.schedule, size: 13, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(Fmt.relative(context, e.updatedAt),
                    style: context.text.labelSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ),
              if (value != null)
                Text(value, style: AppType.money(context)),
            ],
          ),
        ],
      ),
    );
  }
}

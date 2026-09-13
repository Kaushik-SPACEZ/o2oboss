import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/routes.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/data/app_store.dart';
import '../../core/data/db_queries.dart';
import '../../core/l10n/l10n.dart';
import '../../core/l10n/labels.dart';
import '../../core/models/models.dart';
import '../../core/utils/format.dart';
import '../../shared/widgets/layout.dart';
import '../../shared/widgets/pills.dart';
import '../../shared/widgets/tones.dart';

/// Summary of one quotation version: number, who, total and status.
class QuotationCard extends ConsumerWidget {
  const QuotationCard({super.key, required this.quotation, this.showEnquiry = false});

  final Quotation quotation;
  final bool showEnquiry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final me = ref.watch(currentUserProvider);
    final q = quotation;
    final e = db.enquiryById(q.enquiryId);
    final isVendor = me?.role == UserRole.vendor;
    final isCustomer = me?.role == UserRole.customer;
    final status = isCustomer && q.status == QuotationStatus.sent
        ? t.quoteNew
        : quotationLabel(t, q.status);
    final subtitle = showEnquiry && e != null
        ? (isVendor ? '${db.enquiryTitle(e)}, ${e.area}' : '${db.enquiryTitle(e)}, ${db.customerName(e.customerId)}')
        : db.vendorName(q.vendorId);
    return AppCard(
      onTap: () => context.push(Routes.quotation(q.id)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.quoteNumber(q.number, '${q.version}'), style: context.text.titleSmall),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: context.text.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(
                  q.status.isOpen && q.sentAt != null
                      ? t.quoteValidUntil(Fmt.shortDate(context, q.validUntil))
                      : Fmt.shortDate(context, q.submittedAt ?? q.createdAt),
                  style: context.text.labelSmall,
                ),
                Space.gapSm,
                StatusPill(status, tone: quotationTone(q.status)),
              ],
            ),
          ),
          Space.gapMd,
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 130),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(Fmt.money(q.total),
                  style: context.text.titleMedium
                      ?.copyWith(fontFeatures: const [FontFeature.tabularFigures()])),
            ),
          ),
        ],
      ),
    );
  }
}

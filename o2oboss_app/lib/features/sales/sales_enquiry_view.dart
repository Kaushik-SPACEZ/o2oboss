import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/data/app_store.dart';
import '../../core/data/db_queries.dart';
import '../../core/data/visibility.dart';
import '../../core/l10n/l10n.dart';
import '../../core/l10n/labels.dart';
import '../../core/models/models.dart';
import '../../core/utils/format.dart';
import '../../shared/widgets/cards.dart';
import '../../shared/widgets/layout.dart';
import '../../shared/widgets/pills.dart';
import '../../shared/widgets/rows.dart';
import '../../shared/widgets/tones.dart';
import '../enquiry/enquiry_common.dart';

/// A referral as its referral partner sees it: progress first, then the
/// customer, the requirement, the vendor and what they will earn.
class SalesEnquiryView extends ConsumerWidget {
  const SalesEnquiryView({super.key, required this.enquiry});

  final Enquiry enquiry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final me = ref.watch(currentUserProvider)!;
    final config = db.config;
    final e = enquiry;
    final customer = db.customerById(e.customerId);
    final accepted = db
        .activeAssignmentsFor(e.id)
        .where((a) => a.status == AssignmentStatus.accepted)
        .toList();
    final mine = db.commissionsFor(e.id).where((c) => c.beneficiaryUserId == me.id).firstOrNull;
    final value = visibleValue(me, e, config);
    final showEstimate = config.salesValueVisibility != SalesValueVisibility.hidden;
    final base = e.finalValue ?? e.potentialValue;

    return PageScaffold(
      title: t.detailTitleSales,
      children: [
        EnquiryHeader(enquiry: e, simple: true),
        Space.gapMd,
        if (e.status.isEnded) ...[
          NoteCard(
            tone: Tone.danger,
            icon: Icons.info_outline,
            title: simpleStatusLabel(t, e.status),
            text: e.status == EnquiryStatus.rejected
                ? t.salesRejectedBody(reasonLabel(t, e.rejectReason))
                : t.salesLostBody(reasonLabel(t, e.lossReason)),
          ),
          Space.gapMd,
        ],
        SimpleJourneyCard(enquiry: e),
        DetailLabel(t.labelCustomer),
        AppCard(
          child: Column(
            children: [
              InfoRow(icon: Icons.person_outline, label: t.labelName, value: customer?.name ?? ''),
              InfoRow(
                  icon: Icons.phone_outlined,
                  label: t.labelMobile,
                  value: Fmt.phone(customer?.phone ?? '')),
              InfoRow(
                  icon: Icons.place_outlined,
                  label: t.labelLocation,
                  value: '${e.area}, ${e.city}'),
            ],
          ),
        ),
        DetailLabel(t.labelRequirement),
        AppCard(
          child: Column(
            children: [
              InfoRow(icon: Icons.category_outlined, label: t.labelProduct, value: db.enquiryTitle(e)),
              InfoRow(icon: Icons.notes, label: t.labelRequirement, value: e.requirement, maxLines: 8),
              if (value != null)
                InfoRow(
                  icon: Icons.currency_rupee,
                  label: e.finalValue != null ? t.labelFinalValue : t.labelEstimatedValue,
                  value: value,
                ),
            ],
          ),
        ),
        if (accepted.isNotEmpty) ...[
          DetailLabel(t.labelVendor),
          AppCard(
            child: Column(
              children: [
                for (final a in accepted)
                  InfoRow(
                    icon: Icons.storefront_outlined,
                    label: t.salesVendorWorking,
                    value: db.vendorName(a.vendorId),
                  ),
              ],
            ),
          ),
        ],
        DetailLabel(t.detailYourEarning),
        AppCard(
          child: mine != null
              ? Row(
                  children: [
                    Expanded(
                      child: ValueLine(
                        t.earningsLineDetail(e.id, Fmt.percent(mine.percent), Fmt.money(mine.businessValue)),
                        Fmt.money(mine.amount),
                        strong: true,
                      ),
                    ),
                    Space.gapSm,
                    StatusPill(commissionLabel(t, mine.status), tone: commissionTone(mine.status)),
                  ],
                )
              : Text(
                  e.status.isEnded
                      ? t.salesNoEarning
                      : (showEstimate && base != null
                          ? t.salesExpectedEarning(
                              Fmt.money(base * config.salesCommissionPercent / 100),
                              triggerSentence(t, config.commissionTrigger))
                          : t.salesEarningLater(Fmt.percent(config.salesCommissionPercent))),
                  style: TextStyle(
                      color: e.status.isEnded ? AppColors.textSecondary : AppColors.text),
                ),
        ),
      ],
    );
  }
}

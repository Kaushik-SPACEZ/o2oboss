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
import '../../shared/widgets/cards.dart';
import '../../shared/widgets/feedback.dart';
import '../../shared/widgets/layout.dart';
import '../../shared/widgets/pills.dart';
import '../../shared/widgets/rows.dart';
import '../enquiry/enquiry_common.dart';
import '../ops/lists.dart';
import '../ops/ops_actions.dart';
import '../quotation/quotation_card.dart';
import '../visits/visit_widgets.dart';

/// A requirement as the customer sees it: what needs them now, the plain
/// progress, their vendor, visits, quotations, the order and a chat.
class CustomerEnquiryView extends ConsumerWidget {
  const CustomerEnquiryView({super.key, required this.enquiry});

  final Enquiry enquiry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final db = ref.watch(dbProvider);
    final me = ref.watch(currentUserProvider)!;
    final e = enquiry;
    final accepted = db
        .activeAssignmentsFor(e.id)
        .where((a) => a.status == AssignmentStatus.accepted)
        .toList();
    final quotes = db.currentQuotations(e.id).where((q) => q.status.isWithCustomer).toList();
    final waiting = quotes
        .where((q) => q.status == QuotationStatus.sent || q.status == QuotationStatus.viewed)
        .firstOrNull;
    final visits = db
        .appointmentsFor(e.id)
        .where((a) =>
            a.status != AppointmentStatus.proposed &&
            a.status != AppointmentStatus.pendingConfirmation)
        .toList();
    final project = db.projectFor(e.id);

    return PageScaffold(
      title: t.detailTitleCustomer,
      children: [
        EnquiryHeader(enquiry: e, simple: true),
        Space.gapMd,
        if (e.status.isEnded) ...[
          NoteCard(
            tone: Tone.danger,
            title: simpleStatusLabel(t, e.status),
            text: t.cuClosedBody(reasonLabel(t, e.rejectReason ?? e.lossReason)),
          ),
          Space.gapMd,
        ] else if (waiting != null) ...[
          PrimaryActionCard(
            icon: Icons.request_quote_outlined,
            title: t.cuQuoteReadyTitle,
            body: t.cuQuoteReadyBody(db.vendorName(waiting.vendorId), db.enquiryTitle(e)),
            actionLabel: t.cuQuoteReadyButton,
            onTap: () => context.push(Routes.quotation(waiting.id)),
          ),
          Space.gapMd,
        ],
        SimpleJourneyCard(enquiry: e, forCustomer: true),
        DetailLabel(t.cuVendorTitle),
        if (accepted.isEmpty)
          AppCard(
            child: Text(t.cuNoVendorYet,
                style: context.text.bodyMedium?.copyWith(color: AppColors.textSecondary)),
          )
        else
          Gap(children: [
            for (final a in accepted)
              if (db.vendorById(a.vendorId) case final v?)
                _VendorCard(vendor: v, showContact: db.config.customerSeesVendorContact),
          ]),
        if (visits.isNotEmpty) ...[
          DetailLabel(t.listVisits),
          Gap(children: [for (final v in visits) VisitCard(appointment: v)]),
        ],
        if (quotes.isNotEmpty) ...[
          DetailLabel(t.navQuotations),
          Gap(children: [for (final q in quotes) QuotationCard(quotation: q)]),
        ],
        if (project != null) ...[
          DetailLabel(t.navOrders),
          ProjectCard(project: project),
        ],
        DetailLabel(t.labelRequirement),
        AppCard(
          child: Column(
            children: [
              InfoRow(icon: Icons.category_outlined, label: t.labelProduct, value: db.enquiryTitle(e)),
              InfoRow(icon: Icons.notes, label: t.labelRequirement, value: e.requirement, maxLines: 8),
              InfoRow(icon: Icons.place_outlined, label: t.labelLocation, value: '${e.area}, ${e.city}'),
            ],
          ),
        ),
        Space.gapXl,
        AppCard(
          padding: EdgeInsets.zero,
          child: NavRow(
            icon: Icons.chat_bubble_outline,
            title: t.cuChatWithO2O,
            subtitle: t.cuChatHelp,
            badge: db.unreadInThread(me.id, e.id, ChatMessage.customerThread),
            onTap: () => context.push(Routes.chat(e.id, ChatMessage.customerThread)),
          ),
        ),
      ],
    );
  }
}

/// The vendor doing the job, with round call and WhatsApp buttons when the
/// admin allows customers to contact vendors directly.
class _VendorCard extends StatelessWidget {
  const _VendorCard({required this.vendor, required this.showContact});

  final Vendor vendor;
  final bool showContact;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final v = vendor;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              InitialsAvatar(v.companyName, size: 48),
              Space.gapMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(v.companyName, style: context.text.titleSmall),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 16, color: AppColors.warning),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(t.cuRating(v.rating.toStringAsFixed(1)),
                              style: context.text.bodySmall),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (showContact) ...[
                Space.gapSm,
                RoundIconButton(
                  icon: Icons.call,
                  label: t.cuCall(v.companyName),
                  onTap: () => simulateCall(context, name: v.companyName, phone: v.phone),
                ),
                Space.gapSm,
                RoundIconButton(
                  icon: Icons.chat,
                  label: t.cuWhatsApp(v.companyName),
                  color: AppColors.success,
                  onTap: () => showToast(context, t.demoActionNote, tone: Tone.info),
                ),
              ],
            ],
          ),
          if (showContact)
            Padding(
              padding: const EdgeInsets.only(top: Space.sm),
              child: Text(Fmt.phone(v.phone), style: context.text.bodySmall),
            )
          else
            Padding(
              padding: const EdgeInsets.only(top: Space.md),
              child: Text(t.cuVendorHidden, style: context.text.bodySmall),
            ),
        ],
      ),
    );
  }
}

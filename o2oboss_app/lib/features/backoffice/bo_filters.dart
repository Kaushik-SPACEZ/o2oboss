import 'package:flutter/material.dart';

import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';
import '../../shared/widgets/enquiry_list.dart';

/// A work queue: a named filter with an icon for Home.
class QueueFilter extends EnquiryFilter {
  const QueueFilter(super.key, super.label, super.test, this.icon, {this.urgent = false});

  final IconData icon;
  final bool urgent;
}

bool _in(Enquiry e, Set<EnquiryStatus> s) => s.contains(e.status);

/// The operations queues, in the order work flows. Shared by back office,
/// franchise and admin lists.
List<QueueFilter> boQueueFilters(AppLocalizations t) => [
      QueueFilter('verify', t.qVerify,
          (e) => _in(e, {EnquiryStatus.newEnquiry, EnquiryStatus.verificationPending}),
          Icons.phone_in_talk_outlined, urgent: true),
      QueueFilter('qualify', t.qQualify,
          (e) => _in(e, {EnquiryStatus.verified, EnquiryStatus.qualificationPending}),
          Icons.fact_check_outlined),
      QueueFilter('assign', t.qAssign,
          (e) => _in(e, {EnquiryStatus.qualified, EnquiryStatus.vendorMatching}),
          Icons.person_search_outlined, urgent: true),
      QueueFilter('vendorReply', t.qVendorReply,
          (e) => e.status == EnquiryStatus.vendorAssigned, Icons.hourglass_top),
      QueueFilter('visit', t.qVisit,
          (e) => _in(e, {
                EnquiryStatus.vendorAccepted,
                EnquiryStatus.customerContact,
                EnquiryStatus.appointmentScheduled,
              }),
          Icons.event_outlined),
      QueueFilter('quote', t.qQuote,
          (e) => _in(e, {
                EnquiryStatus.appointmentCompleted,
                EnquiryStatus.quotationPending,
                EnquiryStatus.quotationSubmitted,
                EnquiryStatus.negotiation,
              }),
          Icons.request_quote_outlined),
      QueueFilter('project', t.qProject,
          (e) => _in(e, {
                EnquiryStatus.won,
                EnquiryStatus.projectCreated,
                EnquiryStatus.projectInProgress,
              }),
          Icons.construction_outlined),
      QueueFilter('payment', t.qPayment,
          (e) => _in(e, {
                EnquiryStatus.projectCompleted,
                EnquiryStatus.paymentPending,
                EnquiryStatus.paymentCollected,
                EnquiryStatus.commissionCalculated,
              }),
          Icons.currency_rupee),
    ];

/// All filters for an operations enquiry list.
List<EnquiryFilter> opsListFilters(AppLocalizations t) => [
      EnquiryFilter('all', t.filterOpen, (e) => !e.status.isClosed),
      ...boQueueFilters(t),
      EnquiryFilter('done', t.groupCompleted, (e) => e.status == EnquiryStatus.commissionSettled),
      EnquiryFilter('closed', t.salesFilterClosed, (e) => e.status.isEnded),
    ];

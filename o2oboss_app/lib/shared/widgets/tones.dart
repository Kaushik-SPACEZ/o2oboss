import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../core/models/models.dart';

/// Colour tone for each state. Tones are always shown together with a text
/// label, never on their own.

Tone statusTone(EnquiryStatus s) {
  if (s == EnquiryStatus.paymentPending) return Tone.warning;
  return switch (s.group) {
    EnquiryGroup.fresh || EnquiryGroup.verification => Tone.info,
    EnquiryGroup.qualification || EnquiryGroup.vendor => Tone.purple,
    EnquiryGroup.visit => Tone.info,
    EnquiryGroup.quotation => Tone.warning,
    EnquiryGroup.won || EnquiryGroup.project || EnquiryGroup.payment => Tone.success,
    EnquiryGroup.completed => Tone.neutral,
    EnquiryGroup.lost => Tone.danger,
  };
}

Tone quotationTone(QuotationStatus s) => switch (s) {
      QuotationStatus.draft => Tone.neutral,
      QuotationStatus.submitted || QuotationStatus.sent => Tone.info,
      QuotationStatus.viewed => Tone.purple,
      QuotationStatus.revisionRequested => Tone.warning,
      QuotationStatus.accepted => Tone.success,
      QuotationStatus.rejected => Tone.danger,
      QuotationStatus.expired || QuotationStatus.superseded => Tone.neutral,
    };

Tone appointmentTone(AppointmentStatus s) => switch (s) {
      AppointmentStatus.proposed || AppointmentStatus.pendingConfirmation => Tone.warning,
      AppointmentStatus.confirmed || AppointmentStatus.rescheduled => Tone.info,
      AppointmentStatus.completed => Tone.success,
      AppointmentStatus.cancelled || AppointmentStatus.noShow => Tone.danger,
    };

Tone assignmentTone(AssignmentStatus s) => switch (s) {
      AssignmentStatus.pending => Tone.warning,
      AssignmentStatus.accepted => Tone.success,
      AssignmentStatus.rejected => Tone.danger,
      AssignmentStatus.expired || AssignmentStatus.withdrawn => Tone.neutral,
    };

Tone projectTone(ProjectStatus s) => switch (s) {
      ProjectStatus.notStarted => Tone.neutral,
      ProjectStatus.inProgress => Tone.info,
      ProjectStatus.onHold => Tone.warning,
      ProjectStatus.completed => Tone.success,
      ProjectStatus.cancelled => Tone.danger,
    };

Tone paymentTone(PaymentStatus s) => switch (s) {
      PaymentStatus.unpaid => Tone.neutral,
      PaymentStatus.partiallyPaid => Tone.warning,
      PaymentStatus.fullyPaid => Tone.success,
      PaymentStatus.overdue => Tone.danger,
    };

Tone commissionTone(CommissionStatus s) => switch (s) {
      CommissionStatus.pending => Tone.neutral,
      CommissionStatus.approved => Tone.info,
      CommissionStatus.payable => Tone.purple,
      CommissionStatus.paid => Tone.success,
      CommissionStatus.onHold => Tone.warning,
      CommissionStatus.cancelled => Tone.danger,
    };

Tone accountTone(AccountStatus s) => switch (s) {
      AccountStatus.active => Tone.success,
      AccountStatus.pending || AccountStatus.underReview => Tone.warning,
      AccountStatus.rejected || AccountStatus.suspended => Tone.danger,
    };

Tone priorityTone(EnquiryPriority p) => switch (p) {
      EnquiryPriority.low || EnquiryPriority.normal => Tone.neutral,
      EnquiryPriority.high => Tone.warning,
      EnquiryPriority.urgent => Tone.danger,
    };

IconData categoryIcon(String key) => switch (key) {
      'cctv' => Icons.videocam_outlined,
      'ac' => Icons.ac_unit_outlined,
      'solar' => Icons.solar_power_outlined,
      'interior' => Icons.chair_outlined,
      'tiles' => Icons.grid_view_outlined,
      'jewellery' => Icons.diamond_outlined,
      'pooja' => Icons.temple_hindu_outlined,
      'appliance' => Icons.kitchen_outlined,
      'painting' => Icons.format_paint_outlined,
      'water' => Icons.water_drop_outlined,
      'electrical' => Icons.electrical_services_outlined,
      'furniture' => Icons.weekend_outlined,
      _ => Icons.category_outlined,
    };

const categoryIconKeys = [
  'cctv', 'ac', 'solar', 'interior', 'tiles', 'jewellery', 'pooja',
  'appliance', 'painting', 'water', 'electrical', 'furniture', 'other',
];

IconData roleIcon(UserRole r) => switch (r) {
      UserRole.sales => Icons.campaign_outlined,
      UserRole.backOffice => Icons.support_agent_outlined,
      UserRole.vendor => Icons.storefront_outlined,
      UserRole.customer => Icons.person_outline,
      UserRole.franchise => Icons.map_outlined,
      UserRole.admin => Icons.admin_panel_settings_outlined,
    };

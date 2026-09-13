import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import '../../core/data/app_store.dart';
import '../../core/l10n/l10n.dart';
import '../../core/l10n/labels.dart';
import '../../core/models/models.dart';
import '../../core/utils/format.dart';
import '../../shared/widgets/feedback.dart';
import '../../shared/widgets/inputs.dart';
import '../../shared/widgets/layout.dart';
import '../../shared/widgets/rows.dart';
import '../common/system_screens.dart';

typedef _Section = (String key, IconData icon, String title, String help);

List<_Section> _sections(AppLocalizations t) => [
      ('enquiry', Icons.assignment_outlined, t.stSecEnquiry, t.stSecEnquiryHelp),
      ('channels', Icons.forum_outlined, t.stSecChannels, t.stSecChannelsHelp),
      ('vendors', Icons.storefront_outlined, t.stSecVendors, t.stSecVendorsHelp),
      ('visibility', Icons.visibility_outlined, t.stSecVisibility, t.stSecVisibilityHelp),
      ('quotations', Icons.request_quote_outlined, t.stSecQuotes, t.stSecQuotesHelp),
      ('payments', Icons.currency_rupee, t.stSecPayments, t.stSecPaymentsHelp),
      ('commission', Icons.handshake_outlined, t.stSecCommission, t.stSecCommissionHelp),
      ('feedback', Icons.star_outline, t.stSecFeedback, t.stSecFeedbackHelp),
    ];

/// Settings grouped into eight short pages instead of one long form.
class AdminSettingsScreen extends ConsumerWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    if (ref.watch(currentUserProvider)?.role != UserRole.admin) return const NoAccessView();
    return PageScaffold(
      title: t.adSettings,
      children: [
        NavGroup(rows: [
          for (final (key, icon, title, help) in _sections(t))
            NavRow(
              icon: icon,
              title: title,
              subtitle: help,
              onTap: () => context.push(Routes.adminSettingsSection(key)),
            ),
        ]),
      ],
    );
  }
}

/// One settings page. Every change saves at once and is written to the
/// activity log.
class AdminSettingsSectionScreen extends ConsumerWidget {
  const AdminSettingsSectionScreen({super.key, required this.section});

  final String section;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    if (ref.watch(currentUserProvider)?.role != UserRole.admin) return const NoAccessView();
    final c = ref.watch(configProvider);
    final info = _sections(t).where((s) => s.$1 == section).firstOrNull;
    if (info == null) return const NotFoundScreen();

    void save(AppConfig next) {
      ref.read(dbProvider.notifier).updateConfig(next);
      showToast(context, t.stSaved);
    }

    Widget toggle(String label, bool value, AppConfig Function(bool v) next) => SwitchListTile(
          value: value,
          onChanged: (v) => save(next(v)),
          title: Text(label),
        );

    Widget number(String label, double value, String shown, double min, double max, double step,
            AppConfig Function(double v) next) =>
        NumberStepRow(
          label: label,
          value: value,
          shown: shown,
          min: min,
          max: max,
          step: step,
          onChanged: (v) => save(next(v)),
        );

    Widget choice<T>(String label, T value, List<(T, String)> options, AppConfig Function(T v) next) =>
        Padding(
          padding: const EdgeInsets.fromLTRB(Space.lg, Space.sm, Space.lg, Space.md),
          child: SelectField<T>(
            label: label,
            value: value,
            options: [for (final (v, l) in options) SelectOption(v, l)],
            onChanged: (v) => save(next(v)),
          ),
        );

    final rows = switch (section) {
      'enquiry' => [
          toggle(t.stOtp, c.otpEnabled, (v) => c.copyWith(otpEnabled: v)),
          number(t.stExpiryDays, c.enquiryExpiryDays.toDouble(), t.stDays(c.enquiryExpiryDays), 7, 180, 1,
              (v) => c.copyWith(enquiryExpiryDays: v.round())),
          number(t.stProtectionDays, c.referralProtectionDays.toDouble(),
              t.stDays(c.referralProtectionDays), 30, 365, 15,
              (v) => c.copyWith(referralProtectionDays: v.round())),
          choice(t.stDefaultPriority, c.defaultPriority,
              [for (final p in EnquiryPriority.values) (p, priorityLabel(t, p))],
              (v) => c.copyWith(defaultPriority: v)),
        ],
      'channels' => [
          toggle(t.stWhatsapp, c.whatsappEnabled, (v) => c.copyWith(whatsappEnabled: v)),
          toggle(t.stSms, c.smsEnabled, (v) => c.copyWith(smsEnabled: v)),
          toggle(t.stEmail, c.emailEnabled, (v) => c.copyWith(emailEnabled: v)),
          toggle(t.stPush, c.pushEnabled, (v) => c.copyWith(pushEnabled: v)),
          toggle(t.stCalling, c.callingEnabled, (v) => c.copyWith(callingEnabled: v)),
          toggle(t.stRecording, c.callRecordingEnabled, (v) => c.copyWith(callRecordingEnabled: v)),
          toggle(t.stRecordingConsent, c.callRecordingConsentRequired,
              (v) => c.copyWith(callRecordingConsentRequired: v)),
        ],
      'vendors' => [
          toggle(t.stVendorApproval, c.vendorApprovalRequired, (v) => c.copyWith(vendorApprovalRequired: v)),
          number(t.stVendorHours, c.vendorResponseHours.toDouble(), t.stHours(c.vendorResponseHours), 2, 72, 2,
              (v) => c.copyWith(vendorResponseHours: v.round())),
          toggle(t.stAsksPrice, c.vendorResponseAsksPrice, (v) => c.copyWith(vendorResponseAsksPrice: v)),
          toggle(t.stAsksTime, c.vendorResponseAsksTime, (v) => c.copyWith(vendorResponseAsksTime: v)),
        ],
      'visibility' => [
          toggle(t.stSeesVendorContact, c.customerSeesVendorContact,
              (v) => c.copyWith(customerSeesVendorContact: v)),
          toggle(t.stSeesReferrer, c.customerSeesReferrer, (v) => c.copyWith(customerSeesReferrer: v)),
          choice(t.stVendorSeesReferrer, c.vendorSeesReferrer,
              [for (final v in VisibilityLevel.values) (v, visibilityLabel(t, v))],
              (v) => c.copyWith(vendorSeesReferrer: v)),
          choice(t.stSalesValue, c.salesValueVisibility,
              [for (final v in SalesValueVisibility.values) (v, salesValueLabel(t, v))],
              (v) => c.copyWith(salesValueVisibility: v)),
        ],
      'quotations' => [
          toggle(t.stQuoteReview, c.quotationReviewRequired, (v) => c.copyWith(quotationReviewRequired: v)),
          toggle(t.stMultiQuotes, c.multipleQuotationsDefault, (v) => c.copyWith(multipleQuotationsDefault: v)),
          toggle(t.stESign, c.eSignatureRequired, (v) => c.copyWith(eSignatureRequired: v)),
          toggle(t.stAdminCopy, c.adminQuotationCopy, (v) => c.copyWith(adminQuotationCopy: v)),
        ],
      'payments' => [
          toggle(t.stTracking, c.paymentTrackingEnabled, (v) => c.copyWith(paymentTrackingEnabled: v)),
          toggle(t.stOnlinePay, c.onlinePaymentEnabled, (v) => c.copyWith(onlinePaymentEnabled: v)),
        ],
      'commission' => [
          number(t.stSalesPercent, c.salesCommissionPercent, Fmt.percent(c.salesCommissionPercent), 0, 20, 0.5,
              (v) => c.copyWith(salesCommissionPercent: v)),
          number(t.stBoPercent, c.backOfficeCommissionPercent, Fmt.percent(c.backOfficeCommissionPercent), 0, 10,
              0.25, (v) => c.copyWith(backOfficeCommissionPercent: v)),
          number(t.stFranchisePercent, c.franchiseSharePercent, Fmt.percent(c.franchiseSharePercent), 0, 10, 0.25,
              (v) => c.copyWith(franchiseSharePercent: v)),
          choice(t.stTrigger, c.commissionTrigger,
              [for (final v in CommissionTrigger.values) (v, triggerLabel(t, v))],
              (v) => c.copyWith(commissionTrigger: v)),
          toggle(t.stPayoutApproval, c.payoutApprovalRequired, (v) => c.copyWith(payoutApprovalRequired: v)),
        ],
      _ => [
          toggle(t.stFeedbackOn, c.feedbackEnabled, (v) => c.copyWith(feedbackEnabled: v)),
        ],
    };

    return PageScaffold(
      title: info.$3,
      children: [
        AppCard(
          padding: const EdgeInsets.symmetric(vertical: Space.xs),
          child: Column(
            children: [
              for (var i = 0; i < rows.length; i++) ...[
                if (i > 0) const Divider(indent: Space.lg),
                rows[i],
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// A number with big minus and plus buttons, for small ranges.
class NumberStepRow extends StatelessWidget {
  const NumberStepRow({
    super.key,
    required this.label,
    required this.value,
    required this.shown,
    required this.min,
    required this.max,
    required this.step,
    required this.onChanged,
  });

  final String label;
  final double value;

  /// The value as shown, e.g. "24 hours" or "2%".
  final String shown;
  final double min;
  final double max;
  final double step;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    const eps = 1e-9;
    return Padding(
      padding: const EdgeInsets.fromLTRB(Space.lg, Space.sm, Space.sm, Space.sm),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: context.text.bodyLarge),
                Text(shown,
                    style: context.text.titleSmall?.copyWith(color: AppColors.primaryDark)),
              ],
            ),
          ),
          IconButton(
            tooltip: t.stDecrease(label),
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: value - step >= min - eps ? () => onChanged(value - step) : null,
          ),
          IconButton(
            tooltip: t.stIncrease(label),
            icon: const Icon(Icons.add_circle_outline),
            onPressed: value + step <= max + eps ? () => onChanged(value + step) : null,
          ),
        ],
      ),
    );
  }
}

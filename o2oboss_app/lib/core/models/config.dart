import 'enums.dart';
import 'json.dart';

/// Every admin-configurable rule. Defaults follow the client-confirmed initial
/// behaviour (spec section 50); nothing here is a fixed business rule.
class AppConfig {
  const AppConfig({
    this.companyName = 'O2O Boss',
    this.otpEnabled = false,
    this.whatsappEnabled = false,
    this.smsEnabled = false,
    this.emailEnabled = true,
    this.pushEnabled = true,
    this.callingEnabled = true,
    this.callRecordingEnabled = true,
    this.callRecordingConsentRequired = true,
    this.paymentTrackingEnabled = true,
    this.onlinePaymentEnabled = false,
    this.vendorResponseHours = 24,
    this.vendorApprovalRequired = true,
    this.vendorResponseAsksPrice = true,
    this.vendorResponseAsksTime = true,
    this.customerSeesVendorContact = false,
    this.customerSeesReferrer = true,
    this.vendorSeesReferrer = VisibilityLevel.limited,
    this.salesValueVisibility = SalesValueVisibility.full,
    this.quotationReviewRequired = true,
    this.multipleQuotationsDefault = false,
    this.eSignatureRequired = true,
    this.adminQuotationCopy = true,
    this.adminCopyEmail = 'quotes@o2oboss.in',
    this.feedbackEnabled = true,
    this.feedbackScale = 5,
    this.salesCommissionPercent = 2,
    this.backOfficeCommissionPercent = 0.5,
    this.franchiseSharePercent = 1,
    this.commissionTrigger = CommissionTrigger.fullPaymentCollected,
    this.payoutApprovalRequired = true,
    this.referralProtectionDays = 180,
    this.enquiryExpiryDays = 30,
    this.defaultPriority = EnquiryPriority.normal,
    this.termsVersion = 'v1.0',
  });

  final String companyName;

  // Enquiry
  final bool otpEnabled;
  final int enquiryExpiryDays;
  final EnquiryPriority defaultPriority;

  // Communication channels
  final bool whatsappEnabled;
  final bool smsEnabled;
  final bool emailEnabled;
  final bool pushEnabled;
  final bool callingEnabled;
  final bool callRecordingEnabled;
  final bool callRecordingConsentRequired;

  // Payments
  final bool paymentTrackingEnabled;
  final bool onlinePaymentEnabled;

  // Vendor
  final int vendorResponseHours;
  final bool vendorApprovalRequired;
  final bool vendorResponseAsksPrice;
  final bool vendorResponseAsksTime;

  // Visibility
  final bool customerSeesVendorContact;
  final bool customerSeesReferrer;
  final VisibilityLevel vendorSeesReferrer;
  final SalesValueVisibility salesValueVisibility;

  // Quotations
  final bool quotationReviewRequired;
  final bool multipleQuotationsDefault;
  final bool eSignatureRequired;
  final bool adminQuotationCopy;
  final String adminCopyEmail;

  // Feedback
  final bool feedbackEnabled;
  final int feedbackScale;

  // Commission
  final double salesCommissionPercent;
  final double backOfficeCommissionPercent;
  final double franchiseSharePercent;
  final CommissionTrigger commissionTrigger;
  final bool payoutApprovalRequired;

  // Referral protection & legal
  final int referralProtectionDays;
  final String termsVersion;

  AppConfig copyWith({
    String? companyName,
    bool? otpEnabled,
    bool? whatsappEnabled,
    bool? smsEnabled,
    bool? emailEnabled,
    bool? pushEnabled,
    bool? callingEnabled,
    bool? callRecordingEnabled,
    bool? callRecordingConsentRequired,
    bool? paymentTrackingEnabled,
    bool? onlinePaymentEnabled,
    int? vendorResponseHours,
    bool? vendorApprovalRequired,
    bool? vendorResponseAsksPrice,
    bool? vendorResponseAsksTime,
    bool? customerSeesVendorContact,
    bool? customerSeesReferrer,
    VisibilityLevel? vendorSeesReferrer,
    SalesValueVisibility? salesValueVisibility,
    bool? quotationReviewRequired,
    bool? multipleQuotationsDefault,
    bool? eSignatureRequired,
    bool? adminQuotationCopy,
    String? adminCopyEmail,
    bool? feedbackEnabled,
    int? feedbackScale,
    double? salesCommissionPercent,
    double? backOfficeCommissionPercent,
    double? franchiseSharePercent,
    CommissionTrigger? commissionTrigger,
    bool? payoutApprovalRequired,
    int? referralProtectionDays,
    int? enquiryExpiryDays,
    EnquiryPriority? defaultPriority,
    String? termsVersion,
  }) =>
      AppConfig(
        companyName: companyName ?? this.companyName,
        otpEnabled: otpEnabled ?? this.otpEnabled,
        whatsappEnabled: whatsappEnabled ?? this.whatsappEnabled,
        smsEnabled: smsEnabled ?? this.smsEnabled,
        emailEnabled: emailEnabled ?? this.emailEnabled,
        pushEnabled: pushEnabled ?? this.pushEnabled,
        callingEnabled: callingEnabled ?? this.callingEnabled,
        callRecordingEnabled: callRecordingEnabled ?? this.callRecordingEnabled,
        callRecordingConsentRequired:
            callRecordingConsentRequired ?? this.callRecordingConsentRequired,
        paymentTrackingEnabled:
            paymentTrackingEnabled ?? this.paymentTrackingEnabled,
        onlinePaymentEnabled: onlinePaymentEnabled ?? this.onlinePaymentEnabled,
        vendorResponseHours: vendorResponseHours ?? this.vendorResponseHours,
        vendorApprovalRequired:
            vendorApprovalRequired ?? this.vendorApprovalRequired,
        vendorResponseAsksPrice:
            vendorResponseAsksPrice ?? this.vendorResponseAsksPrice,
        vendorResponseAsksTime:
            vendorResponseAsksTime ?? this.vendorResponseAsksTime,
        customerSeesVendorContact:
            customerSeesVendorContact ?? this.customerSeesVendorContact,
        customerSeesReferrer: customerSeesReferrer ?? this.customerSeesReferrer,
        vendorSeesReferrer: vendorSeesReferrer ?? this.vendorSeesReferrer,
        salesValueVisibility: salesValueVisibility ?? this.salesValueVisibility,
        quotationReviewRequired:
            quotationReviewRequired ?? this.quotationReviewRequired,
        multipleQuotationsDefault:
            multipleQuotationsDefault ?? this.multipleQuotationsDefault,
        eSignatureRequired: eSignatureRequired ?? this.eSignatureRequired,
        adminQuotationCopy: adminQuotationCopy ?? this.adminQuotationCopy,
        adminCopyEmail: adminCopyEmail ?? this.adminCopyEmail,
        feedbackEnabled: feedbackEnabled ?? this.feedbackEnabled,
        feedbackScale: feedbackScale ?? this.feedbackScale,
        salesCommissionPercent:
            salesCommissionPercent ?? this.salesCommissionPercent,
        backOfficeCommissionPercent:
            backOfficeCommissionPercent ?? this.backOfficeCommissionPercent,
        franchiseSharePercent:
            franchiseSharePercent ?? this.franchiseSharePercent,
        commissionTrigger: commissionTrigger ?? this.commissionTrigger,
        payoutApprovalRequired:
            payoutApprovalRequired ?? this.payoutApprovalRequired,
        referralProtectionDays:
            referralProtectionDays ?? this.referralProtectionDays,
        enquiryExpiryDays: enquiryExpiryDays ?? this.enquiryExpiryDays,
        defaultPriority: defaultPriority ?? this.defaultPriority,
        termsVersion: termsVersion ?? this.termsVersion,
      );

  Map<String, dynamic> toJson() => {
        'companyName': companyName,
        'otpEnabled': otpEnabled,
        'whatsappEnabled': whatsappEnabled,
        'smsEnabled': smsEnabled,
        'emailEnabled': emailEnabled,
        'pushEnabled': pushEnabled,
        'callingEnabled': callingEnabled,
        'callRecordingEnabled': callRecordingEnabled,
        'callRecordingConsentRequired': callRecordingConsentRequired,
        'paymentTrackingEnabled': paymentTrackingEnabled,
        'onlinePaymentEnabled': onlinePaymentEnabled,
        'vendorResponseHours': vendorResponseHours,
        'vendorApprovalRequired': vendorApprovalRequired,
        'vendorResponseAsksPrice': vendorResponseAsksPrice,
        'vendorResponseAsksTime': vendorResponseAsksTime,
        'customerSeesVendorContact': customerSeesVendorContact,
        'customerSeesReferrer': customerSeesReferrer,
        'vendorSeesReferrer': vendorSeesReferrer.name,
        'salesValueVisibility': salesValueVisibility.name,
        'quotationReviewRequired': quotationReviewRequired,
        'multipleQuotationsDefault': multipleQuotationsDefault,
        'eSignatureRequired': eSignatureRequired,
        'adminQuotationCopy': adminQuotationCopy,
        'adminCopyEmail': adminCopyEmail,
        'feedbackEnabled': feedbackEnabled,
        'feedbackScale': feedbackScale,
        'salesCommissionPercent': salesCommissionPercent,
        'backOfficeCommissionPercent': backOfficeCommissionPercent,
        'franchiseSharePercent': franchiseSharePercent,
        'commissionTrigger': commissionTrigger.name,
        'payoutApprovalRequired': payoutApprovalRequired,
        'referralProtectionDays': referralProtectionDays,
        'enquiryExpiryDays': enquiryExpiryDays,
        'defaultPriority': defaultPriority.name,
        'termsVersion': termsVersion,
      };

  factory AppConfig.fromJson(Map<String, dynamic> j) {
    const d = AppConfig();
    return AppConfig(
      companyName: j['companyName'] as String? ?? d.companyName,
      otpEnabled: j['otpEnabled'] as bool? ?? d.otpEnabled,
      whatsappEnabled: j['whatsappEnabled'] as bool? ?? d.whatsappEnabled,
      smsEnabled: j['smsEnabled'] as bool? ?? d.smsEnabled,
      emailEnabled: j['emailEnabled'] as bool? ?? d.emailEnabled,
      pushEnabled: j['pushEnabled'] as bool? ?? d.pushEnabled,
      callingEnabled: j['callingEnabled'] as bool? ?? d.callingEnabled,
      callRecordingEnabled:
          j['callRecordingEnabled'] as bool? ?? d.callRecordingEnabled,
      callRecordingConsentRequired: j['callRecordingConsentRequired'] as bool? ??
          d.callRecordingConsentRequired,
      paymentTrackingEnabled:
          j['paymentTrackingEnabled'] as bool? ?? d.paymentTrackingEnabled,
      onlinePaymentEnabled:
          j['onlinePaymentEnabled'] as bool? ?? d.onlinePaymentEnabled,
      vendorResponseHours:
          numToInt(j['vendorResponseHours'], d.vendorResponseHours),
      vendorApprovalRequired:
          j['vendorApprovalRequired'] as bool? ?? d.vendorApprovalRequired,
      vendorResponseAsksPrice:
          j['vendorResponseAsksPrice'] as bool? ?? d.vendorResponseAsksPrice,
      vendorResponseAsksTime:
          j['vendorResponseAsksTime'] as bool? ?? d.vendorResponseAsksTime,
      customerSeesVendorContact: j['customerSeesVendorContact'] as bool? ??
          d.customerSeesVendorContact,
      customerSeesReferrer:
          j['customerSeesReferrer'] as bool? ?? d.customerSeesReferrer,
      vendorSeesReferrer: enumByName(
          VisibilityLevel.values, j['vendorSeesReferrer'], d.vendorSeesReferrer),
      salesValueVisibility: enumByName(SalesValueVisibility.values,
          j['salesValueVisibility'], d.salesValueVisibility),
      quotationReviewRequired:
          j['quotationReviewRequired'] as bool? ?? d.quotationReviewRequired,
      multipleQuotationsDefault: j['multipleQuotationsDefault'] as bool? ??
          d.multipleQuotationsDefault,
      eSignatureRequired:
          j['eSignatureRequired'] as bool? ?? d.eSignatureRequired,
      adminQuotationCopy:
          j['adminQuotationCopy'] as bool? ?? d.adminQuotationCopy,
      adminCopyEmail: j['adminCopyEmail'] as String? ?? d.adminCopyEmail,
      feedbackEnabled: j['feedbackEnabled'] as bool? ?? d.feedbackEnabled,
      feedbackScale: numToInt(j['feedbackScale'], d.feedbackScale),
      salesCommissionPercent:
          numToDouble(j['salesCommissionPercent'], d.salesCommissionPercent),
      backOfficeCommissionPercent: numToDouble(
          j['backOfficeCommissionPercent'], d.backOfficeCommissionPercent),
      franchiseSharePercent:
          numToDouble(j['franchiseSharePercent'], d.franchiseSharePercent),
      commissionTrigger: enumByName(
          CommissionTrigger.values, j['commissionTrigger'], d.commissionTrigger),
      payoutApprovalRequired:
          j['payoutApprovalRequired'] as bool? ?? d.payoutApprovalRequired,
      referralProtectionDays:
          numToInt(j['referralProtectionDays'], d.referralProtectionDays),
      enquiryExpiryDays: numToInt(j['enquiryExpiryDays'], d.enquiryExpiryDays),
      defaultPriority: enumByName(
          EnquiryPriority.values, j['defaultPriority'], d.defaultPriority),
      termsVersion: j['termsVersion'] as String? ?? d.termsVersion,
    );
  }
}

import '../data/db_queries.dart';
import '../data/system_text.dart';
import '../models/models.dart';
import '../utils/format.dart';
import 'l10n.dart';

/// Translated names for every fixed state. Kept in one place so the same
/// thing is always called the same name across the app.

String roleLabel(AppLocalizations t, UserRole r) => switch (r) {
      UserRole.sales => t.roleSales,
      UserRole.backOffice => t.roleBackOffice,
      UserRole.vendor => t.roleVendor,
      UserRole.customer => t.roleCustomer,
      UserRole.franchise => t.roleFranchise,
      UserRole.admin => t.roleAdmin,
    };

String salesTypeLabel(AppLocalizations t, SalesType s) => switch (s) {
      SalesType.independent => t.salesIndependent,
      SalesType.company => t.salesCompany,
    };

String statusLabel(AppLocalizations t, EnquiryStatus s) => switch (s) {
      EnquiryStatus.newEnquiry => t.statusNewEnquiry,
      EnquiryStatus.verificationPending => t.statusVerificationPending,
      EnquiryStatus.verified => t.statusVerified,
      EnquiryStatus.rejected => t.statusRejected,
      EnquiryStatus.qualificationPending => t.statusQualificationPending,
      EnquiryStatus.qualified => t.statusQualified,
      EnquiryStatus.vendorMatching => t.statusVendorMatching,
      EnquiryStatus.vendorAssigned => t.statusVendorAssigned,
      EnquiryStatus.vendorAccepted => t.statusVendorAccepted,
      EnquiryStatus.customerContact => t.statusCustomerContact,
      EnquiryStatus.appointmentScheduled => t.statusAppointmentScheduled,
      EnquiryStatus.appointmentCompleted => t.statusAppointmentCompleted,
      EnquiryStatus.quotationPending => t.statusQuotationPending,
      EnquiryStatus.quotationSubmitted => t.statusQuotationSubmitted,
      EnquiryStatus.negotiation => t.statusNegotiation,
      EnquiryStatus.won => t.statusWon,
      EnquiryStatus.lost => t.statusLost,
      EnquiryStatus.projectCreated => t.statusProjectCreated,
      EnquiryStatus.projectInProgress => t.statusProjectInProgress,
      EnquiryStatus.projectCompleted => t.statusProjectCompleted,
      EnquiryStatus.paymentPending => t.statusPaymentPending,
      EnquiryStatus.paymentCollected => t.statusPaymentCollected,
      EnquiryStatus.commissionCalculated => t.statusCommissionCalculated,
      EnquiryStatus.commissionSettled => t.statusCommissionSettled,
    };

/// Plain wording for referral partners and customers, who don't need every
/// internal back-office step.
String simpleStatusLabel(AppLocalizations t, EnquiryStatus s) => switch (s) {
      EnquiryStatus.newEnquiry ||
      EnquiryStatus.verificationPending =>
        t.simpleVerifying,
      EnquiryStatus.rejected => t.simpleNotVerified,
      EnquiryStatus.verified ||
      EnquiryStatus.qualificationPending ||
      EnquiryStatus.qualified =>
        t.simpleVerified,
      EnquiryStatus.vendorMatching => t.simpleFindingVendor,
      EnquiryStatus.vendorAssigned ||
      EnquiryStatus.vendorAccepted ||
      EnquiryStatus.customerContact =>
        t.simpleVendorAssigned,
      EnquiryStatus.appointmentScheduled ||
      EnquiryStatus.appointmentCompleted =>
        t.simpleVisit,
      EnquiryStatus.quotationPending ||
      EnquiryStatus.quotationSubmitted ||
      EnquiryStatus.negotiation =>
        t.simpleQuotation,
      EnquiryStatus.won => t.simpleWon,
      EnquiryStatus.lost => t.simpleLost,
      EnquiryStatus.projectCreated ||
      EnquiryStatus.projectInProgress ||
      EnquiryStatus.projectCompleted =>
        t.simpleWork,
      EnquiryStatus.paymentPending => t.simplePayment,
      EnquiryStatus.paymentCollected ||
      EnquiryStatus.commissionCalculated ||
      EnquiryStatus.commissionSettled =>
        t.simpleDone,
    };

String statusLabelFor(AppLocalizations t, UserRole role, EnquiryStatus s) =>
    role == UserRole.sales || role == UserRole.customer
        ? simpleStatusLabel(t, s)
        : statusLabel(t, s);

String journeyLabel(AppLocalizations t, JourneyStep s) => switch (s) {
      JourneyStep.submitted => t.journeySubmitted,
      JourneyStep.verified => t.journeyVerified,
      JourneyStep.qualified => t.journeyQualified,
      JourneyStep.vendor => t.journeyVendor,
      JourneyStep.visit => t.journeyVisit,
      JourneyStep.quotation => t.journeyQuotation,
      JourneyStep.won => t.journeyWon,
      JourneyStep.project => t.journeyProject,
      JourneyStep.payment => t.journeyPayment,
      JourneyStep.commission => t.journeyCommission,
    };

String groupLabel(AppLocalizations t, EnquiryGroup g) => switch (g) {
      EnquiryGroup.fresh => t.groupFresh,
      EnquiryGroup.verification => t.groupVerification,
      EnquiryGroup.qualification => t.groupQualification,
      EnquiryGroup.vendor => t.groupVendor,
      EnquiryGroup.visit => t.groupVisit,
      EnquiryGroup.quotation => t.groupQuotation,
      EnquiryGroup.won => t.groupWon,
      EnquiryGroup.project => t.groupProject,
      EnquiryGroup.payment => t.groupPayment,
      EnquiryGroup.completed => t.groupCompleted,
      EnquiryGroup.lost => t.groupLost,
    };

String priorityLabel(AppLocalizations t, EnquiryPriority p) => switch (p) {
      EnquiryPriority.low => t.priorityLow,
      EnquiryPriority.normal => t.priorityNormal,
      EnquiryPriority.high => t.priorityHigh,
      EnquiryPriority.urgent => t.priorityUrgent,
    };

String contactPrefLabel(AppLocalizations t, ContactPreference p) => switch (p) {
      ContactPreference.callAnytime => t.contactCallAnytime,
      ContactPreference.callAtTime => t.contactCallAtTime,
      ContactPreference.introduceFirst => t.contactIntroduceFirst,
    };

String outcomeLabel(AppLocalizations t, CallOutcome o) => switch (o) {
      CallOutcome.genuine => t.outcomeGenuine,
      CallOutcome.notGenuine => t.outcomeNotGenuine,
      CallOutcome.wrongNumber => t.outcomeWrongNumber,
      CallOutcome.notInterested => t.outcomeNotInterested,
      CallOutcome.wrongRequirement => t.outcomeWrongRequirement,
      CallOutcome.duplicate => t.outcomeDuplicate,
      CallOutcome.callBackLater => t.outcomeCallBackLater,
      CallOutcome.noAnswer => t.outcomeNoAnswer,
    };

/// Stored reject reasons are outcome names; show them translated when possible.
String reasonLabel(AppLocalizations t, String? raw) {
  if (raw == null || raw.isEmpty) return '';
  final outcome = enumByNameOrNullPublic(CallOutcome.values, raw);
  if (outcome != null) return outcomeLabel(t, outcome);
  final coded = SystemText.decode(raw);
  if (coded != null && coded.$1 == SystemText.otherAccepted) return t.sysOtherAccepted;
  return raw;
}

T? enumByNameOrNullPublic<T extends Enum>(List<T> values, String name) {
  for (final v in values) {
    if (v.name == name) return v;
  }
  return null;
}

String assignmentLabel(AppLocalizations t, AssignmentStatus s) => switch (s) {
      AssignmentStatus.pending => t.assignPending,
      AssignmentStatus.accepted => t.assignAccepted,
      AssignmentStatus.rejected => t.assignRejected,
      AssignmentStatus.expired => t.assignExpired,
      AssignmentStatus.withdrawn => t.assignWithdrawn,
    };

String appointmentLabel(AppLocalizations t, AppointmentStatus s) => switch (s) {
      AppointmentStatus.proposed => t.aptProposed,
      AppointmentStatus.pendingConfirmation => t.aptPendingConfirmation,
      AppointmentStatus.confirmed => t.aptConfirmed,
      AppointmentStatus.rescheduled => t.aptRescheduled,
      AppointmentStatus.cancelled => t.aptCancelled,
      AppointmentStatus.completed => t.aptCompleted,
      AppointmentStatus.noShow => t.aptNoShow,
    };

String quotationLabel(AppLocalizations t, QuotationStatus s) => switch (s) {
      QuotationStatus.draft => t.quoteDraft,
      QuotationStatus.submitted => t.quoteSubmitted,
      QuotationStatus.sent => t.quoteSent,
      QuotationStatus.viewed => t.quoteViewed,
      QuotationStatus.revisionRequested => t.quoteRevisionRequested,
      QuotationStatus.accepted => t.quoteAccepted,
      QuotationStatus.rejected => t.quoteRejected,
      QuotationStatus.expired => t.quoteExpired,
      QuotationStatus.superseded => t.quoteSuperseded,
    };

String projectStatusLabel(AppLocalizations t, ProjectStatus s) => switch (s) {
      ProjectStatus.notStarted => t.projectNotStarted,
      ProjectStatus.inProgress => t.projectInProgress,
      ProjectStatus.onHold => t.projectOnHold,
      ProjectStatus.completed => t.projectCompleted,
      ProjectStatus.cancelled => t.projectCancelled,
    };

String paymentStatusLabel(AppLocalizations t, PaymentStatus s) => switch (s) {
      PaymentStatus.unpaid => t.payUnpaid,
      PaymentStatus.partiallyPaid => t.payPartial,
      PaymentStatus.fullyPaid => t.payFull,
      PaymentStatus.overdue => t.payOverdue,
    };

String methodLabel(AppLocalizations t, PaymentMethod m) => switch (m) {
      PaymentMethod.cash => t.methodCash,
      PaymentMethod.upi => t.methodUpi,
      PaymentMethod.bankTransfer => t.methodBank,
      PaymentMethod.cheque => t.methodCheque,
      PaymentMethod.card => t.methodCard,
    };

String commissionLabel(AppLocalizations t, CommissionStatus s) => switch (s) {
      CommissionStatus.pending => t.comPending,
      CommissionStatus.approved => t.comApproved,
      CommissionStatus.payable => t.comPayable,
      CommissionStatus.paid => t.comPaid,
      CommissionStatus.onHold => t.comOnHold,
      CommissionStatus.cancelled => t.comCancelled,
    };

String triggerLabel(AppLocalizations t, CommissionTrigger c) => switch (c) {
      CommissionTrigger.quotationAccepted => t.trigQuotationAccepted,
      CommissionTrigger.orderConfirmed => t.trigOrderConfirmed,
      CommissionTrigger.projectStarted => t.trigProjectStarted,
      CommissionTrigger.paymentReceived => t.trigPaymentReceived,
      CommissionTrigger.projectCompleted => t.trigProjectCompleted,
      CommissionTrigger.fullPaymentCollected => t.trigFullPayment,
    };

/// The trigger as the end of a sentence: "…due when {the order is confirmed}".
String triggerSentence(AppLocalizations t, CommissionTrigger c) => switch (c) {
      CommissionTrigger.quotationAccepted => t.trigSentenceQuotationAccepted,
      CommissionTrigger.orderConfirmed => t.trigSentenceOrderConfirmed,
      CommissionTrigger.projectStarted => t.trigSentenceProjectStarted,
      CommissionTrigger.paymentReceived => t.trigSentencePaymentReceived,
      CommissionTrigger.projectCompleted => t.trigSentenceProjectCompleted,
      CommissionTrigger.fullPaymentCollected => t.trigSentenceFullPayment,
    };

String milestoneLabel(AppLocalizations t, MilestoneKey k) => switch (k) {
      MilestoneKey.orderConfirmed => t.msOrderConfirmed,
      MilestoneKey.advancePayment => t.msAdvancePayment,
      MilestoneKey.materialOrdered => t.msMaterialOrdered,
      MilestoneKey.workStarted => t.msWorkStarted,
      MilestoneKey.workInProgress => t.msWorkInProgress,
      MilestoneKey.installationDone => t.msInstallationDone,
      MilestoneKey.finalInspection => t.msFinalInspection,
      MilestoneKey.projectCompleted => t.msProjectCompleted,
      MilestoneKey.finalPayment => t.msFinalPayment,
    };

String followUpLabel(AppLocalizations t, FollowUpType f) => switch (f) {
      FollowUpType.customerCall => t.fuCustomerCall,
      FollowUpType.vendorCall => t.fuVendorCall,
      FollowUpType.appointment => t.fuAppointment,
      FollowUpType.quotation => t.fuQuotation,
      FollowUpType.project => t.fuProject,
      FollowUpType.payment => t.fuPayment,
    };

String taskTitle(AppLocalizations t, TaskItem task, DbState db) {
  final id = task.enquiryId ?? '';
  return switch (task.kind) {
    TaskKind.verify => t.taskVerify(id),
    TaskKind.qualify => t.taskQualify(id),
    TaskKind.assignVendor => t.taskAssignVendor(id),
    TaskKind.vendorNoResponse => t.taskVendorNoResponse(id),
    TaskKind.reviewQuotation => t.taskReviewQuotation(id),
    TaskKind.createProject => t.taskCreateProject(id),
    TaskKind.collectPayment => t.taskCollectPayment(id),
    TaskKind.approveCommission => t.taskApproveCommission(id),
    TaskKind.approveVendor => t.taskApproveVendor(db.vendorName(task.refId)),
    TaskKind.general => task.title ?? '',
  };
}

String accountStatusLabel(AppLocalizations t, AccountStatus s) => switch (s) {
      AccountStatus.active => t.accActive,
      AccountStatus.pending => t.accPending,
      AccountStatus.underReview => t.accUnderReview,
      AccountStatus.rejected => t.accRejected,
      AccountStatus.suspended => t.accSuspended,
    };

String docKindLabel(AppLocalizations t, DocKind k) => switch (k) {
      DocKind.gst => t.docGst,
      DocKind.pan => t.docPan,
      DocKind.tradeLicense => t.docTradeLicense,
      DocKind.bankProof => t.docBankProof,
      DocKind.photo => t.docPhoto,
      DocKind.other => t.docOther,
    };

String visibilityLabel(AppLocalizations t, VisibilityLevel v) => switch (v) {
      VisibilityLevel.hidden => t.visHidden,
      VisibilityLevel.limited => t.visLimited,
      VisibilityLevel.full => t.visFull,
    };

String salesValueLabel(AppLocalizations t, SalesValueVisibility v) => switch (v) {
      SalesValueVisibility.full => t.svFull,
      SalesValueVisibility.limited => t.svLimited,
      SalesValueVisibility.commissionOnly => t.svCommissionOnly,
      SalesValueVisibility.hidden => t.svHidden,
      SalesValueVisibility.stageBased => t.svStageBased,
    };

/// Title and body of a notification in the reader's language.
(String, String) notificationText(AppLocalizations t, AppNotification n) {
  final p = n.params;
  final id = p['id'] ?? '';
  final vendor = p['vendor'] ?? '';
  final number = p['number'] ?? '';
  final amountRaw = double.tryParse(p['amount'] ?? '');
  final amount = amountRaw == null ? '' : Fmt.money(amountRaw);
  return switch (n.event) {
    NotificationEvent.enquirySubmitted =>
      (t.nEnquirySubmittedTitle, t.nEnquirySubmittedBody(id)),
    NotificationEvent.newEnquiry => (t.nNewEnquiryTitle, t.nNewEnquiryBody(id)),
    NotificationEvent.enquiryVerified =>
      (t.nEnquiryVerifiedTitle, t.nEnquiryVerifiedBody(id)),
    NotificationEvent.enquiryRejected =>
      (t.nEnquiryRejectedTitle, t.nEnquiryRejectedBody(id)),
    NotificationEvent.enquiryQualified =>
      (t.nEnquiryQualifiedTitle, t.nEnquiryQualifiedBody(id)),
    NotificationEvent.vendorAssigned =>
      (t.nVendorAssignedTitle, t.nVendorAssignedBody(vendor, id)),
    NotificationEvent.newReferral => (t.nNewReferralTitle, t.nNewReferralBody(id)),
    NotificationEvent.referralReminder =>
      (t.nReferralReminderTitle, t.nReferralReminderBody(id)),
    NotificationEvent.referralAccepted =>
      (t.nReferralAcceptedTitle, t.nReferralAcceptedBody(vendor, id)),
    NotificationEvent.referralRejected =>
      (t.nReferralRejectedTitle, t.nReferralRejectedBody(vendor, id)),
    NotificationEvent.vendorConnected =>
      (t.nVendorConnectedTitle, t.nVendorConnectedBody(vendor, id)),
    NotificationEvent.appointmentProposed =>
      (t.nAppointmentProposedTitle, t.nAppointmentProposedBody(id)),
    NotificationEvent.appointmentConfirmed =>
      (t.nAppointmentConfirmedTitle, t.nAppointmentConfirmedBody(id)),
    NotificationEvent.appointmentChanged =>
      (t.nAppointmentChangedTitle, t.nAppointmentChangedBody(id)),
    NotificationEvent.quotationSubmitted =>
      (t.nQuotationSubmittedTitle, t.nQuotationSubmittedBody(vendor, number, id)),
    NotificationEvent.quotationReceived =>
      (t.nQuotationReceivedTitle, t.nQuotationReceivedBody(id)),
    NotificationEvent.quotationApproved =>
      (t.nQuotationApprovedTitle, t.nQuotationApprovedBody(number)),
    NotificationEvent.quotationCopy =>
      (t.nQuotationCopyTitle, t.nQuotationCopyBody(number, vendor)),
    NotificationEvent.revisionRequested =>
      (t.nRevisionRequestedTitle, t.nRevisionRequestedBody(number)),
    NotificationEvent.quotationAccepted =>
      (t.nQuotationAcceptedTitle, t.nQuotationAcceptedBody(number, id)),
    NotificationEvent.quotationRejected =>
      (t.nQuotationRejectedTitle, t.nQuotationRejectedBody(number, id)),
    NotificationEvent.enquiryWon => (t.nEnquiryWonTitle, t.nEnquiryWonBody(id)),
    NotificationEvent.enquiryLost => (t.nEnquiryLostTitle, t.nEnquiryLostBody(id)),
    NotificationEvent.projectCreated =>
      (t.nProjectCreatedTitle, t.nProjectCreatedBody(id)),
    NotificationEvent.projectUpdated =>
      (t.nProjectUpdatedTitle, t.nProjectUpdatedBody(id)),
    NotificationEvent.projectCompleted =>
      (t.nProjectCompletedTitle, t.nProjectCompletedBody(id)),
    NotificationEvent.paymentRecorded =>
      (t.nPaymentRecordedTitle, t.nPaymentRecordedBody(amount, id)),
    NotificationEvent.paymentReminder =>
      (t.nPaymentReminderTitle, t.nPaymentReminderBody(id)),
    NotificationEvent.commissionUpdated =>
      (t.nCommissionUpdatedTitle, t.nCommissionUpdatedBody(amount, id)),
    NotificationEvent.commissionPaid =>
      (t.nCommissionPaidTitle, t.nCommissionPaidBody(amount, id)),
    NotificationEvent.chatMessage =>
      (t.nChatMessageTitle, t.nChatMessageBody(p['from'] ?? '', id)),
    NotificationEvent.followUpDue => (t.nFollowUpDueTitle, t.nFollowUpDueBody(id)),
    NotificationEvent.taskAssigned =>
      (t.nTaskAssignedTitle, t.nTaskAssignedBody(id)),
    NotificationEvent.vendorApproved =>
      (t.nVendorApprovedTitle, t.nVendorApprovedBody),
    NotificationEvent.vendorRegistered =>
      (t.nVendorRegisteredTitle, t.nVendorRegisteredBody(vendor)),
    NotificationEvent.accountCreated =>
      (t.nAccountCreatedTitle, t.nAccountCreatedBody),
    NotificationEvent.feedbackRequest =>
      (t.nFeedbackRequestTitle, t.nFeedbackRequestBody(id)),
    NotificationEvent.configChanged =>
      (t.nConfigChangedTitle, t.nConfigChangedBody),
  };
}

/// Renders a stored chat line. Coded system messages are translated; other
/// text is shown exactly as written.
String chatText(AppLocalizations t, String raw, String Function(DateTime) when) {
  final coded = SystemText.decode(raw);
  if (coded == null) return raw;
  final (key, a) = coded;
  String arg(int i) => i < a.length ? a[i] : '';
  String date(int i) {
    final d = DateTime.tryParse(arg(i));
    return d == null ? arg(i) : when(d);
  }

  return switch (key) {
    SystemText.assigned => t.sysAssigned(arg(0), arg(1)),
    SystemText.newReferral => t.sysNewReferral(arg(0), arg(1)),
    SystemText.referralAccepted => t.sysReferralAccepted(arg(0)),
    SystemText.referralRejected => t.sysReferralRejected(arg(0)),
    SystemText.connected => t.sysConnected(arg(0)),
    SystemText.appointmentProposed => t.sysAppointmentProposed(date(0)),
    SystemText.appointmentConfirmed => t.sysAppointmentConfirmed(date(0)),
    SystemText.appointmentRescheduled => t.sysAppointmentRescheduled(date(0)),
    SystemText.appointmentCancelled => t.sysAppointmentCancelled,
    SystemText.appointmentCompleted => t.sysAppointmentCompleted,
    SystemText.quotationSubmitted => t.sysQuotationSubmitted(arg(0), arg(1)),
    SystemText.quotationSent => t.sysQuotationSent(arg(0), arg(1)),
    SystemText.revisionRequested => t.sysRevisionRequested(arg(0)),
    SystemText.quotationAccepted => t.sysQuotationAccepted(arg(0)),
    SystemText.quotationRejected => t.sysQuotationRejected(arg(0)),
    SystemText.projectCreated => t.sysProjectCreated(arg(0)),
    SystemText.enquiryLost => t.sysEnquiryLost,
    SystemText.otherAccepted => t.sysOtherAccepted,
    _ => raw,
  };
}

/// One line of the activity timeline.
String auditText(AppLocalizations t, AuditEntry a) => switch (a.action) {
      AuditAction.created => t.auditCreated,
      AuditAction.edited => t.auditEdited,
      AuditAction.statusChanged => t.auditStatusChanged(
          enumByNameOrNullPublic(EnquiryStatus.values, a.newValue ?? '') == null
              ? (a.newValue ?? '')
              : statusLabel(t, EnquiryStatus.values.byName(a.newValue!))),
      AuditAction.assigned => t.auditAssigned(a.note ?? ''),
      AuditAction.reassigned => t.auditReassigned,
      AuditAction.vendorAccepted => t.auditVendorAccepted,
      AuditAction.vendorRejected => t.auditVendorRejected,
      AuditAction.callLogged => t.auditCallLogged,
      AuditAction.qualificationSaved => t.auditQualificationSaved,
      AuditAction.appointmentCreated => t.auditAppointmentCreated,
      AuditAction.appointmentChanged => t.auditAppointmentChanged,
      AuditAction.quotationSubmitted => t.auditQuotationSubmitted,
      AuditAction.quotationRevised => t.auditQuotationRevised,
      AuditAction.quotationApproved => t.auditQuotationApproved,
      AuditAction.quotationSent => t.auditQuotationSent,
      AuditAction.quotationAccepted => t.auditQuotationAccepted,
      AuditAction.quotationRejected => t.auditQuotationRejected,
      AuditAction.revisionRequested => t.auditRevisionRequested,
      AuditAction.emailCopySent => t.auditEmailCopySent,
      AuditAction.projectCreated => t.auditProjectCreated,
      AuditAction.milestoneUpdated => t.auditMilestoneUpdated,
      AuditAction.paymentRecorded => t.auditPaymentRecorded,
      AuditAction.commissionCreated => t.auditCommissionCreated,
      AuditAction.commissionApproved => t.auditCommissionApproved,
      AuditAction.commissionPaid => t.auditCommissionPaid,
      AuditAction.configChanged => t.auditConfigChanged,
      AuditAction.userCreated => t.auditUserCreated,
      AuditAction.userUpdated => t.auditUserUpdated,
      AuditAction.passwordReset => t.auditPasswordReset,
      AuditAction.vendorApproved => t.auditVendorApproved,
      AuditAction.vendorSuspended => t.auditVendorSuspended,
      AuditAction.consentGiven => t.auditConsentGiven,
      AuditAction.feedbackGiven => t.auditFeedbackGiven,
    };

String occupationLabel(AppLocalizations t, Occupation o) => switch (o) {
      Occupation.student => t.occStudent,
      Occupation.employed => t.occEmployed,
      Occupation.selfEmployed => t.occSelfEmployed,
      Occupation.homemaker => t.occHomemaker,
      Occupation.retired => t.occRetired,
      Occupation.other => t.occOther,
    };

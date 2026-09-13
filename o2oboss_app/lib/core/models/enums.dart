/// Fixed roles and states shared by every part of the platform.
library;

enum UserRole { sales, backOffice, vendor, customer, franchise, admin }

/// Independent referrers sign up themselves; company sales staff are created by admin.
enum SalesType { independent, company }

enum AccountStatus { active, pending, underReview, rejected, suspended }

enum EnquirySource { sales, customer, backOffice, admin }

enum EnquiryPriority { low, normal, high, urgent }

enum ContactPreference { callAnytime, callAtTime, introduceFirst }

/// The single central status model for an enquiry (spec section 35).
enum EnquiryStatus {
  newEnquiry,
  verificationPending,
  verified,
  rejected,
  qualificationPending,
  qualified,
  vendorMatching,
  vendorAssigned,
  vendorAccepted,
  customerContact,
  appointmentScheduled,
  appointmentCompleted,
  quotationPending,
  quotationSubmitted,
  negotiation,
  won,
  lost,
  projectCreated,
  projectInProgress,
  projectCompleted,
  paymentPending,
  paymentCollected,
  commissionCalculated,
  commissionSettled;

  bool get isEnded => this == rejected || this == lost;

  bool get isClosed => isEnded || this == commissionSettled;

  bool get isWon => index >= won.index && this != lost;

  bool get isQualified =>
      index >= qualified.index && this != rejected && this != lost;

  /// The journey step currently being worked on.
  JourneyStep get step => switch (this) {
        EnquiryStatus.newEnquiry ||
        EnquiryStatus.verificationPending ||
        EnquiryStatus.rejected =>
          JourneyStep.verified,
        EnquiryStatus.verified ||
        EnquiryStatus.qualificationPending =>
          JourneyStep.qualified,
        EnquiryStatus.qualified ||
        EnquiryStatus.vendorMatching ||
        EnquiryStatus.vendorAssigned =>
          JourneyStep.vendor,
        EnquiryStatus.vendorAccepted ||
        EnquiryStatus.customerContact ||
        EnquiryStatus.appointmentScheduled =>
          JourneyStep.visit,
        EnquiryStatus.appointmentCompleted ||
        EnquiryStatus.quotationPending ||
        EnquiryStatus.quotationSubmitted ||
        EnquiryStatus.negotiation =>
          JourneyStep.quotation,
        EnquiryStatus.lost => JourneyStep.won,
        EnquiryStatus.won ||
        EnquiryStatus.projectCreated ||
        EnquiryStatus.projectInProgress =>
          JourneyStep.project,
        EnquiryStatus.projectCompleted ||
        EnquiryStatus.paymentPending =>
          JourneyStep.payment,
        EnquiryStatus.paymentCollected ||
        EnquiryStatus.commissionCalculated ||
        EnquiryStatus.commissionSettled =>
          JourneyStep.commission,
      };

  EnquiryGroup get group => switch (this) {
        EnquiryStatus.newEnquiry => EnquiryGroup.fresh,
        EnquiryStatus.verificationPending ||
        EnquiryStatus.verified =>
          EnquiryGroup.verification,
        EnquiryStatus.qualificationPending ||
        EnquiryStatus.qualified ||
        EnquiryStatus.vendorMatching =>
          EnquiryGroup.qualification,
        EnquiryStatus.vendorAssigned ||
        EnquiryStatus.vendorAccepted ||
        EnquiryStatus.customerContact =>
          EnquiryGroup.vendor,
        EnquiryStatus.appointmentScheduled ||
        EnquiryStatus.appointmentCompleted =>
          EnquiryGroup.visit,
        EnquiryStatus.quotationPending ||
        EnquiryStatus.quotationSubmitted ||
        EnquiryStatus.negotiation =>
          EnquiryGroup.quotation,
        EnquiryStatus.won => EnquiryGroup.won,
        EnquiryStatus.projectCreated ||
        EnquiryStatus.projectInProgress ||
        EnquiryStatus.projectCompleted =>
          EnquiryGroup.project,
        EnquiryStatus.paymentPending ||
        EnquiryStatus.paymentCollected ||
        EnquiryStatus.commissionCalculated =>
          EnquiryGroup.payment,
        EnquiryStatus.commissionSettled => EnquiryGroup.completed,
        EnquiryStatus.lost || EnquiryStatus.rejected => EnquiryGroup.lost,
      };
}

/// Simplified steps of an enquiry's journey, used by progress trackers.
enum JourneyStep {
  submitted,
  verified,
  qualified,
  vendor,
  visit,
  quotation,
  won,
  project,
  payment,
  commission,
}

/// Groups of statuses used by list filter chips.
enum EnquiryGroup {
  fresh,
  verification,
  qualification,
  vendor,
  visit,
  quotation,
  won,
  project,
  payment,
  completed,
  lost,
}

enum CallOutcome {
  genuine,
  notGenuine,
  wrongNumber,
  notInterested,
  wrongRequirement,
  duplicate,
  callBackLater,
  noAnswer;

  /// Outcomes that end the enquiry as rejected.
  bool get rejects => switch (this) {
        CallOutcome.genuine ||
        CallOutcome.callBackLater ||
        CallOutcome.noAnswer =>
          false,
        _ => true,
      };
}

enum CallDirection { outgoing, incoming }

enum AssignmentStatus { pending, accepted, rejected, expired, withdrawn }

enum AppointmentStatus {
  proposed,
  pendingConfirmation,
  confirmed,
  rescheduled,
  cancelled,
  completed,
  noShow;

  bool get isOpen =>
      this == proposed ||
      this == pendingConfirmation ||
      this == confirmed ||
      this == rescheduled;
}

enum QuotationStatus {
  draft,
  submitted,
  sent,
  viewed,
  revisionRequested,
  accepted,
  rejected,
  expired,
  superseded;

  /// Visible to the customer.
  bool get isWithCustomer =>
      this == sent ||
      this == viewed ||
      this == accepted ||
      this == rejected ||
      this == revisionRequested ||
      this == expired;

  bool get isOpen =>
      this == draft ||
      this == submitted ||
      this == sent ||
      this == viewed ||
      this == revisionRequested;
}

enum ProjectStatus { notStarted, inProgress, onHold, completed, cancelled }

enum PaymentStatus { unpaid, partiallyPaid, fullyPaid, overdue }

enum PaymentMethod { cash, upi, bankTransfer, cheque, card }

enum CommissionStatus { pending, approved, payable, paid, onHold, cancelled }

enum CommissionTrigger {
  quotationAccepted,
  orderConfirmed,
  projectStarted,
  paymentReceived,
  projectCompleted,
  fullPaymentCollected,
}

enum MilestoneKey {
  orderConfirmed,
  advancePayment,
  materialOrdered,
  workStarted,
  workInProgress,
  installationDone,
  finalInspection,
  projectCompleted,
  finalPayment,
}

enum FollowUpType {
  customerCall,
  vendorCall,
  appointment,
  quotation,
  project,
  payment,
}

enum TaskKind {
  verify,
  qualify,
  assignVendor,
  vendorNoResponse,
  reviewQuotation,
  createProject,
  collectPayment,
  approveCommission,
  approveVendor,
  general,
}

enum ChatKind { text, image, document, system }

enum QuestionType { text, number, choice, yesNo, date }

/// How a product's price is quoted. `job` prices are for the whole job.
enum PriceUnit { each, visit, kw, sqft, gram, job }

enum DocKind { gst, pan, tradeLicense, bankProof, photo, other }

enum VisibilityLevel { hidden, limited, full }

enum SalesValueVisibility { full, limited, commissionOnly, hidden, stageBased }

enum ConsentAction { terms, privacy, callRecording, communication, dataProcessing }

/// Events that create in-app notifications. Text is localized when shown.
enum NotificationEvent {
  enquirySubmitted,
  newEnquiry,
  enquiryVerified,
  enquiryRejected,
  enquiryQualified,
  vendorAssigned,
  newReferral,
  referralReminder,
  referralAccepted,
  referralRejected,
  vendorConnected,
  appointmentProposed,
  appointmentConfirmed,
  appointmentChanged,
  quotationSubmitted,
  quotationReceived,
  quotationApproved,
  quotationCopy,
  revisionRequested,
  quotationAccepted,
  quotationRejected,
  enquiryWon,
  enquiryLost,
  projectCreated,
  projectUpdated,
  projectCompleted,
  paymentRecorded,
  paymentReminder,
  commissionUpdated,
  commissionPaid,
  chatMessage,
  followUpDue,
  taskAssigned,
  vendorApproved,
  vendorRegistered,
  accountCreated,
  feedbackRequest,
  configChanged,
}

enum AuditAction {
  created,
  edited,
  statusChanged,
  assigned,
  reassigned,
  vendorAccepted,
  vendorRejected,
  callLogged,
  qualificationSaved,
  appointmentCreated,
  appointmentChanged,
  quotationSubmitted,
  quotationRevised,
  quotationApproved,
  quotationSent,
  quotationAccepted,
  quotationRejected,
  revisionRequested,
  emailCopySent,
  projectCreated,
  milestoneUpdated,
  paymentRecorded,
  commissionCreated,
  commissionApproved,
  commissionPaid,
  configChanged,
  userCreated,
  userUpdated,
  passwordReset,
  vendorApproved,
  vendorSuspended,
  consentGiven,
  feedbackGiven,
}

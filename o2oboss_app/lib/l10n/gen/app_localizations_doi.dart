// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dogri (`doi`).
class AppLocalizationsDoi extends AppLocalizations {
  AppLocalizationsDoi([String locale = 'doi']) : super(locale);

  @override
  String get accActive => 'Active';

  @override
  String get accPending => 'Waiting for approval';

  @override
  String get accRejected => 'Rejected';

  @override
  String get accSuspended => 'Suspended';

  @override
  String get accUnderReview => 'Under review';

  @override
  String get actionAdd => 'Add';

  @override
  String get actionApply => 'Apply';

  @override
  String get actionBack => 'Back';

  @override
  String get actionCall => 'Call';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionChange => 'Change';

  @override
  String get actionClearFilters => 'Clear filters';

  @override
  String get actionClose => 'Close';

  @override
  String get actionConfirm => 'Confirm';

  @override
  String get actionContinue => 'Continue';

  @override
  String get actionCopy => 'Copy';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionDiscard => 'Discard';

  @override
  String get actionDone => 'Done';

  @override
  String get actionEdit => 'Edit';

  @override
  String get actionEmail => 'Email';

  @override
  String get actionFilter => 'Filter';

  @override
  String get actionFilters => 'Filters';

  @override
  String get actionKeepEditing => 'Keep editing';

  @override
  String get actionLogout => 'Log out';

  @override
  String get actionMarkDone => 'Mark as done';

  @override
  String get actionMessage => 'Message';

  @override
  String get actionNext => 'Next';

  @override
  String get actionOpen => 'Open';

  @override
  String get actionRemove => 'Remove';

  @override
  String get actionReschedule => 'Reschedule';

  @override
  String get actionReset => 'Reset';

  @override
  String get actionRetry => 'Try again';

  @override
  String get actionSave => 'Save';

  @override
  String get actionSaveChanges => 'Save changes';

  @override
  String get actionSearch => 'Search';

  @override
  String get actionSeeAll => 'See all';

  @override
  String get actionSend => 'Send';

  @override
  String get actionShare => 'Share';

  @override
  String get actionShowLess => 'Show less';

  @override
  String get actionShowMore => 'Show more';

  @override
  String get actionSkip => 'Skip';

  @override
  String get actionSms => 'SMS';

  @override
  String get actionUpload => 'Upload';

  @override
  String get actionView => 'View';

  @override
  String get actionWhatsapp => 'WhatsApp';

  @override
  String get adActivate => 'Activate account';

  @override
  String get adActivated => 'Account activated.';

  @override
  String get adAddUserBody =>
      'Create a login for staff, vendors, partners or customers and share it with them.';

  @override
  String get adAddUserButton => 'Add user';

  @override
  String get adAddUserShort => 'Add user';

  @override
  String get adAddUserTitle => 'Add a new user';

  @override
  String get adArea => 'Area';

  @override
  String get adAudit => 'Activity log';

  @override
  String get adAuditEnquiries => 'Enquiries';

  @override
  String get adAuditPeople => 'People';

  @override
  String get adAuditSettings => 'Settings';

  @override
  String get adAuditVendors => 'Vendors';

  @override
  String get adBizCollected => 'Collected';

  @override
  String get adBizCommission => 'Commission due';

  @override
  String get adBizOutstanding => 'Still to collect';

  @override
  String get adBizWon => 'Business won';

  @override
  String get adBizWork => 'Money and work';

  @override
  String get adBrands => 'Brands';

  @override
  String get adCategories => 'Services and questions';

  @override
  String get adCity => 'City';

  @override
  String get adCompany => 'Business name';

  @override
  String get adContact => 'Contact';

  @override
  String get adCopy => 'Copy';

  @override
  String get adCreateUser => 'Create login';

  @override
  String get adCreated => 'Added on';

  @override
  String adCredsMessage(String name, String login, String password) {
    return 'Hello $name, here is your O2O Boss login. User ID: $login. Password: $password. You will be asked to set a new password.';
  }

  @override
  String get adCredsNote =>
      'This password is shown only once. You can reset it later if needed.';

  @override
  String get adCredsShare => 'Copy message to share';

  @override
  String adCredsSubtitle(String name) {
    return 'Share these with $name. They will set their own password when they first sign in.';
  }

  @override
  String get adCredsTitle => 'Login ready';

  @override
  String get adDone => 'Done';

  @override
  String get adFranchise => 'Franchise';

  @override
  String get adFranchises => 'Franchises';

  @override
  String adHomeSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count approvals are waiting for you.',
      one: '1 approval is waiting for you.',
      zero: 'Everything is running smoothly.',
    );
    return '$_temp0';
  }

  @override
  String get adKpiOpen => 'Open enquiries';

  @override
  String get adKpiUsers => 'Users';

  @override
  String get adKpiVendors => 'Active vendors';

  @override
  String get adKpiWonMonth => 'Won this month';

  @override
  String get adLocations => 'Locations';

  @override
  String get adLogin => 'Login';

  @override
  String get adLoginId => 'User ID';

  @override
  String get adMorePeople => 'People';

  @override
  String get adMoreRecords => 'Records';

  @override
  String get adMoreSetup => 'Setup';

  @override
  String get adOpenCustomer => 'Open customer';

  @override
  String get adOpenVendor => 'Open vendor profile';

  @override
  String get adPassword => 'Password';

  @override
  String get adPayoutsBody =>
      'Approve earned commissions and mark payouts as paid.';

  @override
  String get adPayoutsButton => 'Open commissions';

  @override
  String adPayoutsTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count commissions to settle',
      one: '1 commission to settle',
    );
    return '$_temp0';
  }

  @override
  String get adPickRoleCity => 'Choose a role and a city.';

  @override
  String get adProducts => 'Products';

  @override
  String get adPwSet => 'Set by the user';

  @override
  String get adPwTemp => 'Temporary, must be changed';

  @override
  String get adRepClosed => 'Closed';

  @override
  String get adRepEmpty => 'No data yet.';

  @override
  String get adRepMonths => 'Won in the last 6 months';

  @override
  String get adRepServices => 'Enquiries by service';

  @override
  String get adRepStages => 'Open enquiries by stage';

  @override
  String get adRepVendors => 'Top vendors by jobs';

  @override
  String adResetBody(String name) {
    return '$name will get a new temporary password and must change it when signing in.';
  }

  @override
  String get adResetPw => 'Reset password';

  @override
  String get adResetTitle => 'Reset the password?';

  @override
  String get adRole => 'Role';

  @override
  String get adRoleAdmin =>
      'Sets the rules, manages people and approves payouts.';

  @override
  String get adRoleBackOffice =>
      'Verifies enquiries, finds vendors and runs each job.';

  @override
  String get adRoleCustomer => 'Posts requirements and accepts quotations.';

  @override
  String get adRoleFranchise => 'Looks after one territory and its network.';

  @override
  String get adRoleSales => 'Refers customers and follows their progress.';

  @override
  String get adRoleVendor =>
      'Accepts referrals, visits, quotes and does the work.';

  @override
  String get adRoles => 'Roles';

  @override
  String get adSalesType => 'Partner type';

  @override
  String get adSettings => 'Settings';

  @override
  String get adSuspend => 'Suspend account';

  @override
  String adSuspendBody(String name) {
    return '$name will not be able to sign in until you activate the account again.';
  }

  @override
  String get adSuspendTitle => 'Suspend this account?';

  @override
  String get adSuspended => 'Account suspended.';

  @override
  String get adSystem => 'System';

  @override
  String get adUser => 'User';

  @override
  String get adUsers => 'Users';

  @override
  String adUsersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count users',
      one: '1 user',
    );
    return '$_temp0';
  }

  @override
  String get adVendorApprovals => 'Vendor approvals';

  @override
  String get adVendorsBody =>
      'Check their documents so they can start getting referrals.';

  @override
  String get adVendorsButton => 'Review vendors';

  @override
  String adVendorsTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vendors to approve',
      one: '1 vendor to approve',
    );
    return '$_temp0';
  }

  @override
  String get appName => 'O2O Boss';

  @override
  String get appTagline => 'Verified business referrals';

  @override
  String get aptCancelled => 'Cancelled';

  @override
  String get aptCompleted => 'Completed';

  @override
  String get aptConfirmed => 'Confirmed';

  @override
  String get aptNoShow => 'No-show';

  @override
  String get aptPendingConfirmation => 'Waiting for confirmation';

  @override
  String get aptProposed => 'Proposed';

  @override
  String get aptRescheduled => 'Rescheduled';

  @override
  String get assignAccepted => 'Accepted';

  @override
  String get assignExpired => 'No reply';

  @override
  String get assignPending => 'Waiting for reply';

  @override
  String get assignRejected => 'Declined';

  @override
  String get assignWithdrawn => 'Withdrawn';

  @override
  String get auditAppointmentChanged => 'Visit updated';

  @override
  String get auditAppointmentCreated => 'Visit booked';

  @override
  String auditAssigned(String name) {
    return 'Sent to $name';
  }

  @override
  String auditBy(String name) {
    return 'by $name';
  }

  @override
  String get auditBySystem => 'System';

  @override
  String get auditCallLogged => 'Call logged';

  @override
  String get auditCommissionApproved => 'Commission updated';

  @override
  String get auditCommissionCreated => 'Commission calculated';

  @override
  String get auditCommissionPaid => 'Commission paid';

  @override
  String get auditConfigChanged => 'Setting changed';

  @override
  String get auditConsentGiven => 'Consent recorded';

  @override
  String get auditCreated => 'Enquiry created';

  @override
  String get auditEdited => 'Details updated';

  @override
  String get auditEmailCopySent => 'Copy emailed to O2O Boss';

  @override
  String get auditFeedbackGiven => 'Feedback received';

  @override
  String get auditMilestoneUpdated => 'Project progress updated';

  @override
  String get auditPasswordReset => 'Password changed';

  @override
  String get auditPaymentRecorded => 'Payment recorded';

  @override
  String get auditProjectCreated => 'Project created';

  @override
  String get auditQualificationSaved => 'Requirement details saved';

  @override
  String get auditQuotationAccepted => 'Quotation accepted';

  @override
  String get auditQuotationApproved => 'Quotation approved';

  @override
  String get auditQuotationRejected => 'Quotation rejected';

  @override
  String get auditQuotationRevised => 'Revised quotation submitted';

  @override
  String get auditQuotationSent => 'Quotation sent to customer';

  @override
  String get auditQuotationSubmitted => 'Quotation submitted';

  @override
  String get auditReassigned => 'Reassigned';

  @override
  String get auditRevisionRequested => 'Changes requested';

  @override
  String auditStatusChanged(String status) {
    return 'Moved to $status';
  }

  @override
  String get auditUserCreated => 'User created';

  @override
  String get auditUserUpdated => 'User updated';

  @override
  String get auditVendorAccepted => 'Vendor accepted';

  @override
  String get auditVendorApproved => 'Vendor approved';

  @override
  String get auditVendorRejected => 'Vendor declined';

  @override
  String get auditVendorSuspended => 'Vendor status changed';

  @override
  String get authHidePassword => 'Hide password';

  @override
  String get authShowPassword => 'Show password';

  @override
  String get boAllClearBody =>
      'No tasks are waiting. New enquiries will appear here.';

  @override
  String get boAllClearTitle => 'All caught up';

  @override
  String boHomeSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count things need you today.',
      one: '1 thing needs you today.',
      zero: 'Nothing is waiting for you right now.',
    );
    return '$_temp0';
  }

  @override
  String get boKpiActive => 'Active enquiries';

  @override
  String get boKpiOverdue => 'Overdue';

  @override
  String get boKpiTasks => 'Open tasks';

  @override
  String get boKpiToday => 'Follow-ups today';

  @override
  String get boNewEnquiry => 'Add an enquiry';

  @override
  String get boNewEnquiryShort => 'New enquiry';

  @override
  String get boNextUp => 'Next up';

  @override
  String get boQueues => 'Work queues';

  @override
  String get boQueuesEmpty => 'Every queue is empty.';

  @override
  String callBy(String name) {
    return 'By $name';
  }

  @override
  String get callConnecting => 'Connecting through O2O Boss…';

  @override
  String get callEnd => 'End call';

  @override
  String get callLength => 'How long';

  @override
  String get callLogHeading => 'Call log';

  @override
  String get callLogTitle => 'Log a call';

  @override
  String get callLogged => 'Call saved.';

  @override
  String callMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count min',
      one: '1 min',
    );
    return '$_temp0';
  }

  @override
  String get callNone => 'No calls yet';

  @override
  String get callRecorded => 'This call is recorded';

  @override
  String get callRecordedShort => 'Recorded';

  @override
  String get callWith => 'Call with';

  @override
  String get changePwCurrent => 'Current password';

  @override
  String get changePwDone => 'Password changed.';

  @override
  String get changePwNew => 'New password';

  @override
  String get changePwSubtitle =>
      'Your password was created by admin. Choose a new one to continue.';

  @override
  String get changePwTitle => 'Set your own password';

  @override
  String get changePwWrong => 'Current password is not correct.';

  @override
  String get channelEmail => 'Email';

  @override
  String get channelEmailBody => 'Summaries and quotation copies.';

  @override
  String get channelInAppNote =>
      'Everything also appears under Notifications in the app, whatever you choose here.';

  @override
  String get channelOffByAdmin =>
      'Not available yet. O2O Boss has turned this off.';

  @override
  String get channelPush => 'App notifications';

  @override
  String get channelPushBody => 'Alerts on this phone.';

  @override
  String get channelSms => 'SMS';

  @override
  String get channelSmsBody => 'Important updates by text message.';

  @override
  String get channelWhatsapp => 'WhatsApp';

  @override
  String get channelWhatsappBody => 'Updates on WhatsApp.';

  @override
  String get chatAttach => 'Attach';

  @override
  String get chatAttached => 'File sent.';

  @override
  String get chatClosed => 'This enquiry is closed. The chat is read-only.';

  @override
  String get chatDocument => 'Document';

  @override
  String get chatEmptyBody => 'Say hello or share an update.';

  @override
  String get chatEmptyTitle => 'No messages yet';

  @override
  String get chatHint => 'Write a message';

  @override
  String get chatNoneBody => 'Chats about your referrals will appear here.';

  @override
  String get chatNoneTitle => 'No conversations yet';

  @override
  String chatO2OTeam(String name) {
    return '$name, O2O Boss';
  }

  @override
  String get chatOpenEnquiry => 'Open enquiry';

  @override
  String get chatPhoto => 'Photo';

  @override
  String get chatReadOnly => 'Franchise heads can read chats but not reply.';

  @override
  String get chatThreadsHelp =>
      'Customers and vendors each talk only to O2O Boss. Their numbers stay private.';

  @override
  String get chatWithO2O => 'O2O Boss team';

  @override
  String get comApproved => 'Approved';

  @override
  String get comCancelled => 'Cancelled';

  @override
  String get comOnHold => 'On hold';

  @override
  String get comPaid => 'Paid';

  @override
  String get comPayable => 'Ready to pay';

  @override
  String get comPending => 'Pending';

  @override
  String get comingSoon => 'This screen is being built.';

  @override
  String get commissionAdminOnly =>
      'Only admin can approve and pay commissions.';

  @override
  String get commissionApprove => 'Approve';

  @override
  String get commissionBase => 'Order value';

  @override
  String get commissionHold => 'Put on hold';

  @override
  String get commissionMakePayable => 'Ready to pay';

  @override
  String get commissionMarkPaid => 'Mark as paid';

  @override
  String get commissionNone => 'No commission yet';

  @override
  String get commissionRate => 'Rate';

  @override
  String get commissionReference => 'Payment reference';

  @override
  String get commissionReferenceHint => 'For example: UPI reference number';

  @override
  String get commissionRelease => 'Release hold';

  @override
  String commissionRuleNote(String trigger) {
    return 'Commissions are created when $trigger. Admin approves and pays them.';
  }

  @override
  String get completed => 'Completed';

  @override
  String get contactCallAnytime => 'Call any time';

  @override
  String get contactCallAtTime => 'Call at a set time';

  @override
  String get contactIntroduceFirst => 'I will introduce first';

  @override
  String countEnquiries(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count enquiries',
      one: '1 enquiry',
    );
    return '$_temp0';
  }

  @override
  String countItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
      zero: 'No items',
    );
    return '$_temp0';
  }

  @override
  String get credAvailable => 'Available';

  @override
  String get credConfirmPassword => 'Confirm password';

  @override
  String get credPasswordHelp => 'At least 6 characters.';

  @override
  String get credSubtitle => 'You\'ll use these to sign in.';

  @override
  String get credTitle => 'Create your login';

  @override
  String get credUserIdHelp =>
      '4 to 20 letters or numbers. Dots and underscores are allowed.';

  @override
  String cuCall(String name) {
    return 'Call $name';
  }

  @override
  String get cuChatHelp =>
      'Questions about this requirement? We reply quickly.';

  @override
  String get cuChatWithO2O => 'Chat with O2O Boss';

  @override
  String cuClosedBody(String reason) {
    return '$reason. You can post a new requirement any time.';
  }

  @override
  String get cuEmptyBody => 'Post what you need and follow every step here.';

  @override
  String get cuEmptyTitle => 'No requirements yet';

  @override
  String get cuFilterActive => 'In progress';

  @override
  String get cuFilterClosed => 'Closed';

  @override
  String get cuFilterDone => 'Done';

  @override
  String cuHomeSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count requirements are in progress.',
      one: '1 requirement is in progress.',
      zero: 'Tell us what you need. We find a trusted vendor.',
    );
    return '$_temp0';
  }

  @override
  String get cuMessages => 'Messages';

  @override
  String get cuNewRequirement => 'New requirement';

  @override
  String get cuNoVendorYet => 'We are finding the right vendor for you.';

  @override
  String cuOrdersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count orders',
      one: '1 order',
      zero: 'No orders yet',
    );
    return '$_temp0';
  }

  @override
  String get cuPostBody =>
      'Tell us what you need. We check it and connect a trusted vendor near you.';

  @override
  String get cuPostButton => 'Post a requirement';

  @override
  String get cuPostTitle => 'Need something done?';

  @override
  String cuQuoteReadyBody(String vendor, String job) {
    return '$vendor sent a price for $job. Take a look and decide.';
  }

  @override
  String get cuQuoteReadyButton => 'See quotation';

  @override
  String get cuQuoteReadyTitle => 'Your quotation is ready';

  @override
  String get cuQuotesToDecide => 'To decide';

  @override
  String cuRating(String rating) {
    return 'Rated $rating out of 5';
  }

  @override
  String get cuVendorHidden =>
      'You reach the vendor through O2O Boss. Use the chat below.';

  @override
  String get cuVendorTitle => 'Your vendor';

  @override
  String cuVisitCheckBody(String vendor, String job) {
    return '$vendor marked the visit for $job as done. Please confirm.';
  }

  @override
  String get cuVisitCheckButton => 'Confirm visit';

  @override
  String get cuVisitCheckTitle => 'Did the visit happen?';

  @override
  String cuWhatsApp(String name) {
    return 'WhatsApp $name';
  }

  @override
  String get cuYourRequirements => 'Your requirements';

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String get deadlinePassed => 'Deadline passed';

  @override
  String get demoActionNote => 'In the demo this action is only simulated.';

  @override
  String detailCreatedOn(String id, String date) {
    return '$id, created $date';
  }

  @override
  String get detailProgress => 'Progress';

  @override
  String get detailTitleCustomer => 'Your requirement';

  @override
  String get detailTitleSales => 'Referral';

  @override
  String get detailYourEarning => 'Your earning';

  @override
  String get discardBody => 'Your changes haven\'t been saved.';

  @override
  String get discardTitle => 'Discard changes?';

  @override
  String get docBankProof => 'Bank proof';

  @override
  String get docGst => 'GST certificate';

  @override
  String get docOther => 'Other document';

  @override
  String get docPan => 'PAN card';

  @override
  String get docPhoto => 'Photo';

  @override
  String get docTradeLicense => 'Trade licence';

  @override
  String dueAt(String time) {
    return 'Due $time';
  }

  @override
  String get earningsEmptyBody =>
      'When a referral is won and paid for, your commission appears here.';

  @override
  String get earningsEmptyTitle => 'No commissions yet';

  @override
  String get earningsFilterPaid => 'Paid';

  @override
  String get earningsFilterPending => 'On the way';

  @override
  String earningsLineDetail(String id, String percent, String value) {
    return '$id, $percent of $value';
  }

  @override
  String get earningsListTitle => 'Commissions';

  @override
  String get earningsOnTheWay => 'On the way';

  @override
  String earningsPayoutBank(String last4) {
    return 'Bank account ending $last4';
  }

  @override
  String get earningsPayoutMissing =>
      'Add your UPI ID or bank account to get paid.';

  @override
  String get earningsPayoutTitle => 'Payout details';

  @override
  String earningsPayoutUpi(String upi) {
    return 'UPI: $upi';
  }

  @override
  String earningsRule(String percent, String trigger) {
    return 'You earn $percent of the final order value. It becomes due when $trigger.';
  }

  @override
  String get earningsTitle => 'Earnings';

  @override
  String get earningsTotalPaid => 'Paid to you so far';

  @override
  String get emptyNoResults => 'No results';

  @override
  String get emptyNoResultsBody => 'Try a different word or clear the filters.';

  @override
  String get emptyTitle => 'Nothing here yet';

  @override
  String get faqCustomer1A =>
      'Yes. You only pay the vendor for the work you accept in the quotation.';

  @override
  String get faqCustomer1Q => 'Is this service free for me?';

  @override
  String get faqCustomer2A =>
      'Open Quotations, check the items and total, then tap Accept and type your name to sign.';

  @override
  String get faqCustomer2Q => 'How do I accept a quotation?';

  @override
  String get faqCustomer3A =>
      'Yes. Tap Ask for changes and say what you\'d like. The vendor will send a new version.';

  @override
  String get faqCustomer3Q => 'Can I ask for changes to a quotation?';

  @override
  String get faqLanguageA =>
      'Go to Profile, then Language, and choose from English and 22 Indian languages.';

  @override
  String get faqLanguageQ => 'How do I change the language?';

  @override
  String get faqLogin1A =>
      'On the sign-in screen, tap Forgot password and verify your mobile number to set a new one.';

  @override
  String get faqLogin1Q => 'I forgot my password';

  @override
  String get faqOps1A =>
      'Home shows what needs you now. Work through it from the top, then check Follow-ups and Tasks.';

  @override
  String get faqOps1Q => 'Where do I start each day?';

  @override
  String get faqOps2A =>
      'Only back office, franchise heads and admin. Vendors, customers and referral partners never see them.';

  @override
  String get faqOps2Q => 'Who can see internal notes?';

  @override
  String get faqSales1A =>
      'Your commission becomes due at the stage set by O2O Boss, usually when the customer pays in full. You can follow it under Earnings.';

  @override
  String get faqSales1Q => 'When do I get my commission?';

  @override
  String get faqSales2A =>
      'Our team calls every customer. If the number is wrong, the customer is not interested or it is a duplicate, the referral is closed. The reason is shown on the referral.';

  @override
  String get faqSales2Q => 'Why was my referral not verified?';

  @override
  String get faqSales3A =>
      'Yes, for a different need. For the same need, the first referral is protected and a second one may not count.';

  @override
  String get faqSales3Q => 'Can I refer the same customer again?';

  @override
  String get faqVendor1A =>
      'Accept or decline before the time shown on the referral. Quick replies improve your response rate and bring more referrals.';

  @override
  String get faqVendor1Q => 'How fast should I respond to a referral?';

  @override
  String get faqVendor2A =>
      'O2O Boss connects you with the customer. Use the chat with back office to fix visits and share updates.';

  @override
  String get faqVendor2Q => 'Why can\'t I see the customer\'s phone number?';

  @override
  String get faqVendor3A =>
      'Back office checks it before it goes to the customer. O2O Boss also keeps a copy of every quotation.';

  @override
  String get faqVendor3Q => 'Who checks my quotation?';

  @override
  String feedbackAsk(String vendor) {
    return 'How was the work by $vendor?';
  }

  @override
  String get feedbackReview => 'Anything to add?';

  @override
  String get feedbackSend => 'Send feedback';

  @override
  String get feedbackThanks => 'Thank you for your feedback.';

  @override
  String get feedbackTitle => 'Your feedback';

  @override
  String get filterOpen => 'Open';

  @override
  String get forgotIdLabel => 'User ID or mobile number';

  @override
  String get forgotNotFound =>
      'We couldn\'t find an account with that user ID or number.';

  @override
  String get forgotSendCode => 'Send code';

  @override
  String get forgotSubtitle =>
      'Enter your user ID or registered mobile number.';

  @override
  String get forgotTitle => 'Reset password';

  @override
  String get frCities => 'Cities';

  @override
  String frHeroBody(String value, String cities) {
    return '$value of business won this month in $cities.';
  }

  @override
  String get frHeroButton => 'See business';

  @override
  String frHeroTitle(String name) {
    return '$name';
  }

  @override
  String frHomeSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count enquiries are moving in your territory.',
      one: '1 enquiry is moving in your territory.',
      zero: 'No open enquiries in your territory.',
    );
    return '$_temp0';
  }

  @override
  String get frKpiActive => 'Open enquiries';

  @override
  String get frKpiPartners => 'Sales partners';

  @override
  String get frKpiVendors => 'Vendors';

  @override
  String get frKpiWon => 'Won';

  @override
  String get frLatest => 'Latest enquiries';

  @override
  String get frNoPartners => 'No sales partners in your territory yet.';

  @override
  String get frNoTerritory =>
      'No territory is linked to your account yet. Please contact O2O Boss.';

  @override
  String get frNoVendors => 'No vendors in your territory yet.';

  @override
  String get frPartners => 'Sales partners';

  @override
  String frPendingVendors(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vendors are waiting for approval in your territory.',
      one: '1 vendor is waiting for approval in your territory.',
    );
    return '$_temp0';
  }

  @override
  String frReferralsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count referrals',
      one: '1 referral',
      zero: 'No referrals',
    );
    return '$_temp0';
  }

  @override
  String get frSeeVendors => 'See vendors';

  @override
  String get frShare => 'Your share';

  @override
  String get frTerritory => 'Your territory';

  @override
  String get frTerritoryName => 'Territory';

  @override
  String get frVendors => 'Vendors';

  @override
  String get frVendorsWaiting => 'Waiting';

  @override
  String get fuAdd => 'Add follow-up';

  @override
  String get fuAdded => 'Follow-up added.';

  @override
  String get fuAppointment => 'Visit follow-up';

  @override
  String get fuCompleteTitle => 'Finish follow-up';

  @override
  String get fuCustomerCall => 'Customer call';

  @override
  String get fuDone => 'Follow-up done.';

  @override
  String get fuDoneNext => 'Done. Next follow-up added.';

  @override
  String fuDoneOn(String date) {
    return 'Done $date';
  }

  @override
  String get fuEmptyBody =>
      'Follow-ups you add, or that come from calls and visits, show up here.';

  @override
  String get fuEmptyTitle => 'No follow-ups here';

  @override
  String get fuNextWhen => 'When';

  @override
  String fuOutcome(String outcome) {
    return 'Result: $outcome';
  }

  @override
  String get fuPayment => 'Payment follow-up';

  @override
  String get fuProject => 'Project follow-up';

  @override
  String get fuQuotation => 'Quotation follow-up';

  @override
  String get fuRescheduled => 'Follow-up moved.';

  @override
  String get fuScheduleNext => 'Add another follow-up';

  @override
  String get fuTabToday => 'Today';

  @override
  String get fuType => 'Type';

  @override
  String get fuVendorCall => 'Vendor call';

  @override
  String get fuWhatHappened => 'What happened?';

  @override
  String get goHome => 'Go to home';

  @override
  String get greetHelloAfternoon => 'Good afternoon,';

  @override
  String get greetHelloEvening => 'Good evening,';

  @override
  String get greetHelloMorning => 'Good morning,';

  @override
  String greetingAfternoon(String name) {
    return 'Good afternoon, $name';
  }

  @override
  String greetingEvening(String name) {
    return 'Good evening, $name';
  }

  @override
  String greetingMorning(String name) {
    return 'Good morning, $name';
  }

  @override
  String get groupCompleted => 'Completed';

  @override
  String get groupFresh => 'New';

  @override
  String get groupLost => 'Lost';

  @override
  String get groupPayment => 'Payment';

  @override
  String get groupProject => 'Project';

  @override
  String get groupQualification => 'Qualified';

  @override
  String get groupQuotation => 'Quotation';

  @override
  String get groupVendor => 'Vendor';

  @override
  String get groupVerification => 'Verification';

  @override
  String get groupVisit => 'Appointment';

  @override
  String get groupWon => 'Won';

  @override
  String get helpCall => 'Call support';

  @override
  String get helpContactBody =>
      'Our support team is available Monday to Saturday, 9 am to 7 pm.';

  @override
  String get helpContactTitle => 'Still need help?';

  @override
  String get helpEmail => 'Email support';

  @override
  String get helpFaqTitle => 'Common questions';

  @override
  String get helpTitle => 'Help';

  @override
  String get hiddenValue => 'Hidden';

  @override
  String get homeQuickActions => 'Quick actions';

  @override
  String hoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours ago',
      one: '1 hour ago',
    );
    return '$_temp0';
  }

  @override
  String hoursLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours left',
      one: '1 hour left',
    );
    return '$_temp0';
  }

  @override
  String hoursLeftShort(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours',
      one: '1 hour',
    );
    return '$_temp0';
  }

  @override
  String get jdCommission =>
      'Payment received. Commissions are being processed.';

  @override
  String get jdPayment => 'Waiting for the payment to be completed.';

  @override
  String get jdQuotePreparing => 'The vendor is preparing the quotation.';

  @override
  String get jdQuoteReady => 'The quotation is with the customer.';

  @override
  String get jdQuoteReadyCustomer =>
      'Your quotation is ready. Open it below to review.';

  @override
  String get jdVendor => 'We are choosing a trusted vendor nearby.';

  @override
  String get jdVerifying =>
      'We are calling the customer to confirm the requirement.';

  @override
  String get jdVerifyingCustomer =>
      'Our team will call you to confirm the requirement.';

  @override
  String get jdVisit => 'The vendor will fix a visit with the customer.';

  @override
  String get jdVisitCustomer => 'The vendor will fix a time to visit you.';

  @override
  String jdVisitOn(String date) {
    return 'Visit on $date.';
  }

  @override
  String get jdWon => 'The order is confirmed. Work will start soon.';

  @override
  String jdWork(String done, String total) {
    return 'Work in progress: $done of $total steps done.';
  }

  @override
  String get journeyCommission => 'Commission';

  @override
  String get journeyPayment => 'Payment';

  @override
  String get journeyProject => 'Work';

  @override
  String get journeyQualified => 'Requirement checked';

  @override
  String get journeyQuotation => 'Quotation';

  @override
  String get journeySubmitted => 'Submitted';

  @override
  String get journeyVendor => 'Vendor found';

  @override
  String get journeyVerified => 'Verified';

  @override
  String get journeyVisit => 'Visit';

  @override
  String get journeyWon => 'Won';

  @override
  String get justNow => 'Just now';

  @override
  String get labelAddress => 'Address';

  @override
  String get labelAll => 'All';

  @override
  String get labelAmount => 'Amount';

  @override
  String get labelAnyBrand => 'Any brand';

  @override
  String get labelArea => 'Area';

  @override
  String get labelBackOffice => 'Back office';

  @override
  String get labelBrand => 'Brand';

  @override
  String get labelBrandsYouSupply => 'Brands you supply';

  @override
  String get labelBusinessName => 'Business name';

  @override
  String get labelCategoriesYouServe => 'What do you sell or service?';

  @override
  String get labelCategory => 'Category';

  @override
  String get labelChoose => 'Choose';

  @override
  String get labelCity => 'City';

  @override
  String get labelCreated => 'Created';

  @override
  String get labelCustomer => 'Customer';

  @override
  String get labelDate => 'Date';

  @override
  String get labelDemo => 'Demo';

  @override
  String get labelEmail => 'Email';

  @override
  String get labelEmailOptional => 'Email (optional)';

  @override
  String get labelEnquiryId => 'Enquiry ID';

  @override
  String get labelEstimatedValue => 'Estimated value';

  @override
  String get labelFinalValue => 'Final value';

  @override
  String get labelFranchise => 'Territory';

  @override
  String get labelFullName => 'Full name';

  @override
  String get labelGstin => 'GSTIN';

  @override
  String get labelLocation => 'Location';

  @override
  String get labelMobile => 'Mobile number';

  @override
  String get labelName => 'Name';

  @override
  String get labelNo => 'No';

  @override
  String get labelNone => 'None';

  @override
  String get labelNotes => 'Notes';

  @override
  String get labelNotesOptional => 'Notes (optional)';

  @override
  String get labelOptional => 'Optional';

  @override
  String get labelOther => 'Other';

  @override
  String get labelPassword => 'Password';

  @override
  String get labelPincode => 'Pincode';

  @override
  String get labelPriority => 'Priority';

  @override
  String get labelProduct => 'Product or service';

  @override
  String get labelReason => 'Reason';

  @override
  String get labelRequired => 'Required';

  @override
  String get labelRequirement => 'Requirement';

  @override
  String get labelRole => 'Role';

  @override
  String get labelSalesperson => 'Referred by';

  @override
  String get labelSearchHint => 'Search by name, ID or phone';

  @override
  String get labelServiceCities => 'Cities you serve';

  @override
  String get labelStatus => 'Status';

  @override
  String get labelTime => 'Time';

  @override
  String get labelTotal => 'Total';

  @override
  String get labelUpdated => 'Last update';

  @override
  String get labelUserId => 'User ID';

  @override
  String get labelValue => 'Value';

  @override
  String get labelVendor => 'Vendor';

  @override
  String get labelYes => 'Yes';

  @override
  String get labelYourName => 'Your name';

  @override
  String get langContinue => 'Continue';

  @override
  String get langSubtitle => 'You can change this later in Profile.';

  @override
  String get langTitle => 'Choose your language';

  @override
  String get legalDemoNote =>
      'Sample wording for the demo. The final text will be provided by O2O Boss.';

  @override
  String get legalPrivacy => 'Privacy policy';

  @override
  String get legalTerms => 'Terms of use';

  @override
  String legalVersion(String version) {
    return 'Version $version';
  }

  @override
  String get listActive => 'Active';

  @override
  String get listAwaitingApproval => 'Awaiting approval';

  @override
  String get listCalls => 'Call log';

  @override
  String get listCustomerSince => 'Joined';

  @override
  String get listNeedsAction => 'Needs action';

  @override
  String get listPast => 'Past';

  @override
  String get listPayments => 'Payments';

  @override
  String get listProjects => 'Projects';

  @override
  String get listStopped => 'Stopped';

  @override
  String get listToReview => 'To review';

  @override
  String get listVisits => 'Visits';

  @override
  String get listWithCustomer => 'With customer';

  @override
  String get loading => 'Loading';

  @override
  String get loginButton => 'Sign in';

  @override
  String get loginCreateAccount => 'Create an account';

  @override
  String get loginDemoButton => 'Try a demo account';

  @override
  String loginDemoCredentials(String id, String password) {
    return 'ID: $id, password: $password';
  }

  @override
  String get loginDemoSubtitle =>
      'For testing only. Each one opens a different role.';

  @override
  String get loginDemoTitle => 'Demo accounts';

  @override
  String get loginError =>
      'User ID or password is not correct. Check both and try again.';

  @override
  String get loginForgot => 'Forgot password?';

  @override
  String get loginNoAccount => 'New to O2O Boss?';

  @override
  String get loginSubtitle =>
      'Use the user ID and password from your sign-up, or the one O2O Boss gave you.';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get logoutBody =>
      'You\'ll need your user ID and password to sign in again.';

  @override
  String get logoutTitle => 'Log out?';

  @override
  String get lostReasonDelay => 'Plan postponed';

  @override
  String get lostReasonNoNeed => 'No longer needed';

  @override
  String get lostReasonOther => 'Bought from someone else';

  @override
  String get lostReasonPrice => 'Price too high';

  @override
  String get methodBank => 'Bank transfer';

  @override
  String get methodCard => 'Card';

  @override
  String get methodCash => 'Cash';

  @override
  String get methodCheque => 'Cheque';

  @override
  String get methodUpi => 'UPI';

  @override
  String minutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes ago',
      one: '1 minute ago',
    );
    return '$_temp0';
  }

  @override
  String minutesLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes left',
      one: '1 minute left',
    );
    return '$_temp0';
  }

  @override
  String get moreDirectory => 'People';

  @override
  String get moreMine => 'Mine';

  @override
  String get moreProfileSubtitle => 'Profile, password and language';

  @override
  String get moreWork => 'Work';

  @override
  String get msAdvancePayment => 'Advance payment';

  @override
  String get msFinalInspection => 'Final inspection';

  @override
  String get msFinalPayment => 'Final payment';

  @override
  String get msInstallationDone => 'Installation or service done';

  @override
  String get msMaterialOrdered => 'Material ordered';

  @override
  String get msOrderConfirmed => 'Order confirmed';

  @override
  String get msProjectCompleted => 'Project completed';

  @override
  String get msWorkInProgress => 'Work in progress';

  @override
  String get msWorkStarted => 'Work started';

  @override
  String get nAccountCreatedBody => 'Your account is ready.';

  @override
  String get nAccountCreatedTitle => 'Welcome to O2O Boss';

  @override
  String nAppointmentChangedBody(String id) {
    return 'The visit for $id has changed.';
  }

  @override
  String get nAppointmentChangedTitle => 'Visit updated';

  @override
  String nAppointmentConfirmedBody(String id) {
    return 'The visit for $id is confirmed.';
  }

  @override
  String get nAppointmentConfirmedTitle => 'Visit confirmed';

  @override
  String nAppointmentProposedBody(String id) {
    return 'A visit time was proposed for $id. Please confirm it.';
  }

  @override
  String get nAppointmentProposedTitle => 'Visit time proposed';

  @override
  String nChatMessageBody(String from, String id) {
    return '$from sent a message on $id.';
  }

  @override
  String get nChatMessageTitle => 'New message';

  @override
  String nCommissionPaidBody(String amount, String id) {
    return '$amount for $id has been paid to you.';
  }

  @override
  String get nCommissionPaidTitle => 'Commission paid';

  @override
  String nCommissionUpdatedBody(String amount, String id) {
    return 'Your commission of $amount for $id was updated.';
  }

  @override
  String get nCommissionUpdatedTitle => 'Commission update';

  @override
  String get nConfigChangedBody => 'An admin changed a setting.';

  @override
  String get nConfigChangedTitle => 'Settings changed';

  @override
  String nEnquiryLostBody(String id) {
    return '$id was closed without a deal.';
  }

  @override
  String get nEnquiryLostTitle => 'Enquiry closed';

  @override
  String nEnquiryQualifiedBody(String id) {
    return '$id is ready to be sent to a vendor.';
  }

  @override
  String get nEnquiryQualifiedTitle => 'Requirement confirmed';

  @override
  String nEnquiryRejectedBody(String id) {
    return '$id could not be verified.';
  }

  @override
  String get nEnquiryRejectedTitle => 'Enquiry not verified';

  @override
  String nEnquirySubmittedBody(String id) {
    return '$id is registered. We\'ll verify it soon.';
  }

  @override
  String get nEnquirySubmittedTitle => 'Enquiry registered';

  @override
  String nEnquiryVerifiedBody(String id) {
    return '$id is genuine and moving ahead.';
  }

  @override
  String get nEnquiryVerifiedTitle => 'Enquiry verified';

  @override
  String nEnquiryWonBody(String id) {
    return '$id is won.';
  }

  @override
  String get nEnquiryWonTitle => 'Business won';

  @override
  String nFeedbackRequestBody(String id) {
    return 'Rate the work done for $id.';
  }

  @override
  String get nFeedbackRequestTitle => 'How was the work?';

  @override
  String nFollowUpDueBody(String id) {
    return 'A follow-up on $id is due.';
  }

  @override
  String get nFollowUpDueTitle => 'Follow-up due';

  @override
  String nNewEnquiryBody(String id) {
    return '$id is waiting for verification.';
  }

  @override
  String get nNewEnquiryTitle => 'New enquiry';

  @override
  String nNewReferralBody(String id) {
    return '$id is waiting for your reply.';
  }

  @override
  String get nNewReferralTitle => 'New referral';

  @override
  String nPaymentRecordedBody(String amount, String id) {
    return '$amount received for $id.';
  }

  @override
  String get nPaymentRecordedTitle => 'Payment recorded';

  @override
  String nPaymentReminderBody(String id) {
    return 'Payment for $id is due.';
  }

  @override
  String get nPaymentReminderTitle => 'Payment reminder';

  @override
  String nProjectCompletedBody(String id) {
    return 'Work for $id is complete.';
  }

  @override
  String get nProjectCompletedTitle => 'Work completed';

  @override
  String nProjectCreatedBody(String id) {
    return 'A project for $id has been created.';
  }

  @override
  String get nProjectCreatedTitle => 'Project started';

  @override
  String nProjectUpdatedBody(String id) {
    return 'There is progress on $id.';
  }

  @override
  String get nProjectUpdatedTitle => 'Project update';

  @override
  String nQuotationAcceptedBody(String number, String id) {
    return '$number was accepted for $id.';
  }

  @override
  String get nQuotationAcceptedTitle => 'Quotation accepted';

  @override
  String nQuotationApprovedBody(String number) {
    return '$number was checked and sent to the customer.';
  }

  @override
  String get nQuotationApprovedTitle => 'Quotation sent to customer';

  @override
  String nQuotationCopyBody(String number, String vendor) {
    return 'A copy of $number from $vendor was saved and emailed.';
  }

  @override
  String get nQuotationCopyTitle => 'Quotation copy saved';

  @override
  String nQuotationReceivedBody(String id) {
    return 'A quotation for $id is ready to view.';
  }

  @override
  String get nQuotationReceivedTitle => 'Quotation ready';

  @override
  String nQuotationRejectedBody(String number, String id) {
    return '$number was rejected for $id.';
  }

  @override
  String get nQuotationRejectedTitle => 'Quotation rejected';

  @override
  String nQuotationSubmittedBody(String vendor, String number, String id) {
    return '$vendor sent $number for $id.';
  }

  @override
  String get nQuotationSubmittedTitle => 'Quotation to review';

  @override
  String nReferralAcceptedBody(String vendor, String id) {
    return '$vendor accepted $id.';
  }

  @override
  String get nReferralAcceptedTitle => 'Vendor accepted';

  @override
  String nReferralRejectedBody(String vendor, String id) {
    return '$vendor declined $id. Choose another vendor.';
  }

  @override
  String get nReferralRejectedTitle => 'Vendor declined';

  @override
  String nReferralReminderBody(String id) {
    return 'Please reply to $id before the deadline.';
  }

  @override
  String get nReferralReminderTitle => 'Reply needed';

  @override
  String nRevisionRequestedBody(String number) {
    return 'Changes were requested on $number.';
  }

  @override
  String get nRevisionRequestedTitle => 'Changes requested';

  @override
  String nTaskAssignedBody(String id) {
    return '$id has been assigned to you.';
  }

  @override
  String get nTaskAssignedTitle => 'New work for you';

  @override
  String get nVendorApprovedBody =>
      'Your business is approved. You can now receive referrals.';

  @override
  String get nVendorApprovedTitle => 'Account approved';

  @override
  String nVendorAssignedBody(String vendor, String id) {
    return '$vendor will handle $id.';
  }

  @override
  String get nVendorAssignedTitle => 'Vendor assigned';

  @override
  String nVendorConnectedBody(String vendor, String id) {
    return '$vendor will help you with $id through O2O Boss.';
  }

  @override
  String get nVendorConnectedTitle => 'Vendor connected';

  @override
  String nVendorRegisteredBody(String vendor) {
    return '$vendor registered and needs review.';
  }

  @override
  String get nVendorRegisteredTitle => 'New vendor registration';

  @override
  String get navBusiness => 'Business';

  @override
  String get navChat => 'Chat';

  @override
  String get navEarnings => 'Earnings';

  @override
  String get navEnquiries => 'Enquiries';

  @override
  String get navFollowUps => 'Follow-ups';

  @override
  String get navHome => 'Home';

  @override
  String get navMore => 'More';

  @override
  String get navNetwork => 'Network';

  @override
  String get navNotifications => 'Notifications';

  @override
  String get navOrders => 'Orders';

  @override
  String get navProducts => 'Products';

  @override
  String get navProfile => 'Profile';

  @override
  String get navQuotations => 'Quotations';

  @override
  String get navRefer => 'Refer';

  @override
  String get navReferrals => 'Referrals';

  @override
  String get navReports => 'Reports';

  @override
  String get navRequirement => 'Requirement';

  @override
  String get navTasks => 'Tasks';

  @override
  String get nextAssignBody =>
      'Pick one or more matching vendors to send this referral to.';

  @override
  String get nextAssignButton => 'Find vendors';

  @override
  String get nextAssignTitle => 'Choose a vendor';

  @override
  String get nextCommissionBody =>
      'Payment is complete. Commissions are ready for approval.';

  @override
  String get nextCommissionTitle => 'Settle the commission';

  @override
  String get nextCustomerDecidesBody =>
      'The quotation is with the customer. Follow up if needed.';

  @override
  String get nextCustomerDecidesTitle => 'The customer is deciding';

  @override
  String get nextDoneBody =>
      'The work is complete and every commission is paid.';

  @override
  String get nextDoneTitle => 'All done';

  @override
  String get nextMessageVendor => 'Message vendor';

  @override
  String nextPaymentBody(String amount) {
    return '$amount is still to be paid.';
  }

  @override
  String get nextPaymentButton => 'Record payment';

  @override
  String get nextPaymentTitle => 'Collect the payment';

  @override
  String get nextProjectBody =>
      'The customer accepted. Set the dates so work can be tracked.';

  @override
  String get nextProjectButton => 'Create project';

  @override
  String get nextProjectTitle => 'Create the project';

  @override
  String get nextQualifyBody =>
      'A few questions give the vendor a clear, complete brief.';

  @override
  String get nextQualifyButton => 'Qualify';

  @override
  String get nextQualifyTitle => 'Ask the qualification questions';

  @override
  String nextReviewBody(String number, String vendor) {
    return '$number from $vendor is waiting for your check.';
  }

  @override
  String get nextReviewButton => 'Review quotation';

  @override
  String get nextReviewTitle => 'Review the quotation';

  @override
  String nextVerifyBody(String name) {
    return 'Call $name to confirm the requirement is genuine.';
  }

  @override
  String get nextVerifyButton => 'Verify now';

  @override
  String get nextVerifyTitle => 'Verify the enquiry';

  @override
  String get nextVisitBody =>
      'The vendor accepted. Introduce them to the customer and book a visit.';

  @override
  String get nextVisitButton => 'Book a visit';

  @override
  String nextVisitDoneBody(String date) {
    return 'The visit is on $date. Mark it done once it happens.';
  }

  @override
  String get nextVisitDoneBodyPlain => 'Mark the visit done once it happens.';

  @override
  String get nextVisitDoneTitle => 'Visit booked';

  @override
  String get nextVisitTitle => 'Fix a site visit';

  @override
  String get nextWaitQuoteBody =>
      'The vendor is preparing it. Remind them if it takes long.';

  @override
  String get nextWaitQuoteTitle => 'Waiting for the quotation';

  @override
  String nextWaitVendorBody(String vendor, String time) {
    return '$vendor has not replied yet. $time.';
  }

  @override
  String get nextWaitVendorBodyPlain => 'Vendors have not replied yet.';

  @override
  String get nextWaitVendorTitle => 'Waiting for the vendor';

  @override
  String nextWorkBody(String done, String total) {
    return '$done of $total steps done.';
  }

  @override
  String get nextWorkTitle => 'Track the work';

  @override
  String get noAccessBody => 'This page isn\'t available for your account.';

  @override
  String get noAccessTitle => 'You don\'t have access';

  @override
  String get notFoundBody => 'This page doesn\'t exist or has moved.';

  @override
  String get notFoundTitle => 'Page not found';

  @override
  String get notSet => 'Not set';

  @override
  String get notifAllRead => 'All notifications marked as read.';

  @override
  String get notifEarlier => 'Earlier';

  @override
  String get notifEmptyBody => 'Updates about your enquiries will appear here.';

  @override
  String get notifEmptyTitle => 'No notifications';

  @override
  String get notifMarkAll => 'Mark all as read';

  @override
  String get notifUnread => 'Unread';

  @override
  String get offlineBanner =>
      'You\'re offline. Changes will sync when you\'re back online.';

  @override
  String get opsActivityNote =>
      'Every action is recorded with who did it and when. This history cannot be changed.';

  @override
  String opsActivitySubtitle(String time) {
    return 'Last change $time';
  }

  @override
  String opsAnswers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count answers saved',
      one: '1 answer saved',
      zero: 'No answers yet',
    );
    return '$_temp0';
  }

  @override
  String get opsChangePriority => 'Change priority';

  @override
  String get opsChatSubtitle => 'Messages with the customer and vendors';

  @override
  String get opsClosed => 'Closed';

  @override
  String opsCommissionSummary(String amount) {
    return '$amount in total';
  }

  @override
  String get opsInternalNote => 'Internal note';

  @override
  String get opsInternalNoteHelp =>
      'Only back office, franchise heads and admin can see internal notes.';

  @override
  String get opsInternalNoteLabel => 'Note for the team';

  @override
  String get opsMarkLost => 'Mark as lost';

  @override
  String get opsMarkLostBody =>
      'The enquiry will close and vendors will be told.';

  @override
  String get opsMarkedLost => 'Marked as lost.';

  @override
  String get opsMoreActions => 'More actions';

  @override
  String get opsNextStep => 'Next step';

  @override
  String get opsNoNote => 'No note yet.';

  @override
  String get opsNoQuotesYet => 'No quotations yet';

  @override
  String get opsNoVendorsYet => 'No vendor chosen yet';

  @override
  String get opsNoVisitsYet => 'No visits yet';

  @override
  String get opsNotQualifiedYet => 'Questions not answered yet';

  @override
  String get opsNotVerifiedYet => 'Not verified yet';

  @override
  String get opsOtpVerified => 'Number confirmed by OTP';

  @override
  String get opsOutcome => 'Result';

  @override
  String get opsPartActivity => 'Activity';

  @override
  String get opsPartCalls => 'Verification and calls';

  @override
  String get opsPartCommission => 'Commission';

  @override
  String get opsPartDetails => 'Customer and requirement';

  @override
  String get opsPartProject => 'Project and payments';

  @override
  String get opsPartQualify => 'Qualification';

  @override
  String get opsPartVendors => 'Vendors';

  @override
  String get opsPartVisits => 'Visits';

  @override
  String get opsReassign => 'Reassign back office';

  @override
  String opsReassigned(String name) {
    return 'Now handled by $name.';
  }

  @override
  String get opsReopen => 'Reopen';

  @override
  String get opsReopenBody =>
      'It will go back to the right step so the team can continue.';

  @override
  String get opsReopenTitle => 'Reopen this enquiry?';

  @override
  String get opsReopened => 'Enquiry reopened.';

  @override
  String get opsSections => 'Details';

  @override
  String get opsSource => 'Source';

  @override
  String get opsSourceLabel => 'Came from';

  @override
  String opsStageOf(String stage, String done, String total) {
    return '$stage, step $done of $total';
  }

  @override
  String opsVendorsSummary(String accepted, String waiting) {
    return '$accepted accepted, $waiting waiting';
  }

  @override
  String get opsVerification => 'Verification';

  @override
  String get opsVerifiedBy => 'Checked by';

  @override
  String get otpChangeNumber => 'Change number';

  @override
  String otpDemoHint(String code) {
    return 'Demo code: $code';
  }

  @override
  String get otpLabel => 'Verification code';

  @override
  String get otpResend => 'Send code again';

  @override
  String otpResendIn(String seconds) {
    return 'Send again in ${seconds}s';
  }

  @override
  String get otpResent => 'A new code has been sent.';

  @override
  String otpSubtitle(String phone) {
    return 'Enter the 6-digit code sent to $phone.';
  }

  @override
  String get otpTitle => 'Verify your mobile number';

  @override
  String get otpVerify => 'Verify';

  @override
  String get outcomeCallBackLater => 'Call back later';

  @override
  String get outcomeDuplicate => 'Duplicate';

  @override
  String get outcomeGenuine => 'Genuine';

  @override
  String get outcomeNoAnswer => 'No answer';

  @override
  String get outcomeNotGenuine => 'Not genuine';

  @override
  String get outcomeNotInterested => 'Not interested';

  @override
  String get outcomeWrongNumber => 'Wrong number';

  @override
  String get outcomeWrongRequirement => 'Wrong requirement';

  @override
  String get overdue => 'Overdue';

  @override
  String get payFull => 'Fully paid';

  @override
  String get payOverdue => 'Overdue';

  @override
  String get payPartial => 'Partly paid';

  @override
  String get payUnpaid => 'Unpaid';

  @override
  String get paymentAddProof => 'Add a photo of the receipt';

  @override
  String get paymentMethod => 'Paid by';

  @override
  String get paymentPayOnline => 'Pay online';

  @override
  String get paymentProofAdded => 'Receipt added';

  @override
  String get paymentRecord => 'Record payment';

  @override
  String paymentRecorded(String amount) {
    return 'Payment of $amount saved.';
  }

  @override
  String get paymentReference => 'Reference';

  @override
  String get paymentReferenceHint => 'UPI or cheque number';

  @override
  String get paymentsCollected => 'Collected';

  @override
  String get paymentsDue => 'Payment due';

  @override
  String get paymentsNoneDue => 'Nothing is due';

  @override
  String get paymentsOff => 'Payment tracking is turned off by admin.';

  @override
  String get paymentsOutstanding => 'Still to collect';

  @override
  String get paymentsReceived => 'Received';

  @override
  String get pendingBody =>
      'We check every business before sending referrals. This usually takes one working day.';

  @override
  String get pendingContact => 'Contact support';

  @override
  String get pendingRejectedBody => 'Contact O2O Boss support to know more.';

  @override
  String get pendingRejectedTitle => 'Registration not approved';

  @override
  String get pendingStep1 => 'We verify your documents and details.';

  @override
  String get pendingStep2 => 'You get a notification when approved.';

  @override
  String get pendingStep3 => 'Verified customers start reaching you.';

  @override
  String get pendingSuspendedBody =>
      'Your account is paused for now. Contact O2O Boss support.';

  @override
  String get pendingSuspendedTitle => 'Account paused';

  @override
  String get pendingTitle => 'Your business is being reviewed';

  @override
  String get pendingWhatNext => 'What happens next';

  @override
  String get prAbout => 'About this product';

  @override
  String get prAsk => 'Ask';

  @override
  String get prAskHelp =>
      'Your question goes to the O2O Boss team, not to a vendor. We reply in chat.';

  @override
  String get prAskHint => 'For example: Is installation included?';

  @override
  String get prAskLabel => 'Your question';

  @override
  String prAskTitle(String product) {
    return 'Ask about $product';
  }

  @override
  String get prBrandsAvailable => 'Brands';

  @override
  String get prCantFindBody => 'Post a requirement and we\'ll find it for you.';

  @override
  String get prCantFindTitle => 'Can\'t find what you need?';

  @override
  String prCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count products',
      one: '1 product',
    );
    return '$_temp0';
  }

  @override
  String get prDeliverTo => 'Address';

  @override
  String get prFilterBrands => 'Brands';

  @override
  String prFilterNear(String city) {
    return 'Only show what\'s available in $city';
  }

  @override
  String prFrom(String price) {
    return 'From $price';
  }

  @override
  String get prHow1Body => 'No payment now. Tell us what you need.';

  @override
  String get prHow1Title => 'You order here';

  @override
  String get prHow2Body =>
      'The O2O Boss team calls you and matches a vendor near you.';

  @override
  String get prHow2Title => 'We find a verified vendor';

  @override
  String get prHow3Body =>
      'See the final price and decide. You pay only after you accept.';

  @override
  String get prHow3Title => 'You get a quotation';

  @override
  String get prHowTitle => 'How ordering works';

  @override
  String get prLess => 'One less';

  @override
  String get prMore => 'One more';

  @override
  String prNotNear(String city) {
    return 'Not in $city yet. Order anyway and we\'ll try to find one.';
  }

  @override
  String get prNoteHint => 'For example: size, colour or a preferred day';

  @override
  String get prNoteLabel => 'Anything we should know?';

  @override
  String prOpenRequest(String id) {
    return 'You already have an open request for this ($id).';
  }

  @override
  String get prOrderFootnote =>
      'No payment now. We\'ll call you to confirm the price.';

  @override
  String get prOrderNow => 'Order now';

  @override
  String get prOrderPlaced =>
      'Order placed. The O2O Boss team will call you soon.';

  @override
  String prOrderTitle(String product) {
    return 'Order $product';
  }

  @override
  String get prPlaceOrder => 'Place order';

  @override
  String get prPriceNote =>
      'Estimated price. Your final price comes in the quotation.';

  @override
  String get prPriceOnQuote => 'Price on quotation';

  @override
  String prPriceRange(String from, String to) {
    return '$from to $to';
  }

  @override
  String get prPrivacyNote =>
      'You deal with O2O Boss, not the vendor directly. We stay with you until the job is done.';

  @override
  String get prQuantity => 'Quantity';

  @override
  String get prSearchHint => 'Search products and services';

  @override
  String get prSortFilter => 'Sort and filter';

  @override
  String get prSortName => 'Name: A to Z';

  @override
  String get prSortPopular => 'Most popular';

  @override
  String get prSortPriceHigh => 'Price: high to low';

  @override
  String get prSortPriceLow => 'Price: low to high';

  @override
  String get prSortTitle => 'Sort by';

  @override
  String get prUnitEach => 'each';

  @override
  String get prUnitGram => 'per gram';

  @override
  String get prUnitKw => 'per kW';

  @override
  String get prUnitSqft => 'per sq ft';

  @override
  String get prUnitVisit => 'per visit';

  @override
  String prVendorsNear(int count, String city) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count verified vendors in $city',
      one: '1 verified vendor in $city',
    );
    return '$_temp0';
  }

  @override
  String get prViewRequest => 'View request';

  @override
  String get priorityHigh => 'High';

  @override
  String get priorityLow => 'Low';

  @override
  String get priorityNormal => 'Normal';

  @override
  String get priorityUrgent => 'Urgent';

  @override
  String get privacy1Body =>
      'Your name, mobile number, city and the details you share about requirements, quotations and payments.';

  @override
  String get privacy1Title => 'What we collect';

  @override
  String get privacy2Body =>
      'To verify requirements, connect you with vendors, send updates and calculate commissions.';

  @override
  String get privacy2Title => 'How we use it';

  @override
  String get privacy3Body =>
      'Each role sees only what it needs. Customer phone numbers are not shared with vendors unless O2O Boss allows it.';

  @override
  String get privacy3Title => 'Who can see it';

  @override
  String get privacy4Body =>
      'Calls with our team may be recorded for quality and dispute resolution. All actions are logged for safety.';

  @override
  String get privacy4Title => 'Calls and records';

  @override
  String get profileAccount => 'Account';

  @override
  String get profileBankAccount => 'Bank account number';

  @override
  String get profileChangePassword => 'Change password';

  @override
  String get profileDemo => 'Demo';

  @override
  String get profileEdit => 'Edit profile';

  @override
  String get profileIfsc => 'IFSC code';

  @override
  String get profileNotifications => 'Notifications';

  @override
  String get profilePayoutNote =>
      'Commissions are paid to these details. Double-check them.';

  @override
  String get profilePhoneHelp =>
      'To change your mobile number, contact support.';

  @override
  String get profilePreferences => 'Preferences';

  @override
  String get profileResetDemo => 'Reset demo data';

  @override
  String get profileResetDemoBody => 'Go back to the original sample data.';

  @override
  String get profileResetDemoConfirm =>
      'All changes made in this demo, by every role, will be removed.';

  @override
  String get profileResetDemoDone => 'Demo data has been reset.';

  @override
  String get profileResetDemoTitle => 'Reset demo data?';

  @override
  String get profileSupport => 'Help and legal';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileUpi => 'UPI ID';

  @override
  String profileUserId(String id) {
    return 'User ID: $id';
  }

  @override
  String profileVersion(String version) {
    return 'O2O Boss $version, demo version';
  }

  @override
  String projectBalance(String amount) {
    return 'Balance $amount';
  }

  @override
  String projectBalanceDue(String amount, String date) {
    return 'Balance $amount, due $date';
  }

  @override
  String get projectCancel => 'Cancel project';

  @override
  String get projectCancelBody =>
      'Unpaid commissions will be put on hold for admin to decide.';

  @override
  String get projectCancelCustomer => 'Customer cancelled';

  @override
  String get projectCancelVendor => 'Vendor could not deliver';

  @override
  String get projectCancelled => 'Cancelled';

  @override
  String get projectCompleteBody =>
      'The customer will be asked for feedback and payment follow-up begins.';

  @override
  String get projectCompleteConfirm => 'Mark completed';

  @override
  String get projectCompleteTitle => 'Mark the work as completed?';

  @override
  String get projectCompleted => 'Completed';

  @override
  String get projectCompletedOn => 'Completed on';

  @override
  String get projectCreateNote =>
      'The customer, vendor and referral partner will see the progress.';

  @override
  String get projectCreateSubtitle =>
      'Set the dates. You can change them later.';

  @override
  String get projectCreateTitle => 'Create project';

  @override
  String projectCreated(String id) {
    return 'Project $id created.';
  }

  @override
  String get projectExpectedEnd => 'Expected completion';

  @override
  String get projectHold => 'Put on hold';

  @override
  String get projectInProgress => 'In progress';

  @override
  String get projectNotStarted => 'Not started';

  @override
  String get projectOnHold => 'On hold';

  @override
  String projectOnHoldNote(String reason) {
    return 'On hold: $reason';
  }

  @override
  String projectOpenEnquiry(String id) {
    return 'Open enquiry $id';
  }

  @override
  String projectPaidOf(String paid, String total) {
    return '$paid paid of $total';
  }

  @override
  String get projectPaymentDue => 'Payment due by';

  @override
  String get projectPayments => 'Payments';

  @override
  String get projectResume => 'Resume work';

  @override
  String get projectStart => 'Start date';

  @override
  String get projectSteps => 'Work steps';

  @override
  String get qAssign => 'Need a vendor';

  @override
  String get qPayment => 'Payments and commission';

  @override
  String get qProject => 'Work in progress';

  @override
  String get qQualify => 'To qualify';

  @override
  String get qQuote => 'Quotations';

  @override
  String get qVendorReply => 'Waiting for vendor';

  @override
  String get qVerify => 'To verify';

  @override
  String get qVisit => 'Visits';

  @override
  String get qaSubAddUser => 'Create a login';

  @override
  String get qaSubAudit => 'Who changed what';

  @override
  String get qaSubBusiness => 'Your company details';

  @override
  String get qaSubCalls => 'Calls made and received';

  @override
  String get qaSubChat => 'Customers and vendors';

  @override
  String get qaSubHelp => 'Questions and support';

  @override
  String get qaSubMessages => 'Chat with O2O Boss';

  @override
  String get qaSubNewEnquiry => 'Add a customer\'s need';

  @override
  String get qaSubNewRequirement => 'Tell us what you need';

  @override
  String get qaSubPayments => 'Money received';

  @override
  String get qaSubQuotations => 'Compare and decide';

  @override
  String get qaSubReports => 'See how it\'s going';

  @override
  String get qaSubSettings => 'Rules and options';

  @override
  String get qaSubTrack => 'Track progress';

  @override
  String get qaSubVisits => 'Plan your visits';

  @override
  String get qualifyComplete => 'Mark as qualified';

  @override
  String get qualifyDone => 'Qualified. Now choose a vendor.';

  @override
  String get qualifyLocked =>
      'This enquiry is qualified and already with vendors.';

  @override
  String get qualifySaveLater => 'Save for later';

  @override
  String qualifySubtitle(String category) {
    return 'Questions for $category. Required ones are marked with *.';
  }

  @override
  String get qualifyTitle => 'Qualification';

  @override
  String get qualifyValueHelp =>
      'Your best guess of the order value. Helps vendors and reports.';

  @override
  String get questionNo => 'No';

  @override
  String get questionYes => 'Yes';

  @override
  String get quoteAccept => 'Accept';

  @override
  String get quoteAcceptAgree =>
      'I accept the items, price and terms in this quotation.';

  @override
  String get quoteAcceptTitle => 'Accept this quotation';

  @override
  String get quoteAccepted => 'Accepted';

  @override
  String quoteAcceptedOn(String date) {
    return 'Accepted on $date.';
  }

  @override
  String get quoteAcceptedTitle => 'Accepted';

  @override
  String get quoteAcceptedToast => 'Accepted. The vendor will start the work.';

  @override
  String get quoteApprove => 'Approve and send';

  @override
  String get quoteApproved => 'Sent to the customer.';

  @override
  String get quoteAskChanges => 'Ask for changes';

  @override
  String get quoteAskChangesHint =>
      'For example: reduce the installation charge';

  @override
  String get quoteAskChangesLabel => 'Message to the vendor';

  @override
  String get quoteAskChangesLabelCustomer => 'What would you like changed?';

  @override
  String get quoteAskChangesSub => 'The vendor will send a new version.';

  @override
  String get quoteAskChangesTitle => 'What should change?';

  @override
  String get quoteAttachment => 'Attachment';

  @override
  String get quoteChangesSent => 'Sent to the vendor.';

  @override
  String get quoteChangesSentCustomer =>
      'Your request was sent. You\'ll get a new version.';

  @override
  String quoteCopySent(String email) {
    return 'Copy sent to $email.';
  }

  @override
  String get quoteCustomerChanges => 'Not yet';

  @override
  String get quoteCustomerNote =>
      'Take your time. Ask us anything in the chat.';

  @override
  String quoteDays(String days) {
    return '$days days';
  }

  @override
  String get quoteDecline => 'Decline quotation';

  @override
  String get quoteDeclineElsewhere => 'Going with another option';

  @override
  String get quoteDeclineLater => 'Not now';

  @override
  String get quoteDeclinePrice => 'Price is too high';

  @override
  String get quoteDeclineSub => 'Tell us why so we can help.';

  @override
  String get quoteDeclined => 'Quotation declined.';

  @override
  String get quoteDeclinedReason => 'Declined';

  @override
  String get quoteDelivery => 'Delivery';

  @override
  String get quoteDiscount => 'Discount';

  @override
  String get quoteDraft => 'Draft';

  @override
  String get quoteDraftSaved => 'Draft saved.';

  @override
  String get quoteExpired => 'Expired';

  @override
  String get quoteFormAddItem => 'Add another item';

  @override
  String get quoteFormAttach => 'Add file';

  @override
  String get quoteFormCharges => 'Other charges';

  @override
  String get quoteFormDescription => 'Description';

  @override
  String get quoteFormEdit => 'Edit quotation';

  @override
  String quoteFormItem(String n) {
    return 'Item $n';
  }

  @override
  String get quoteFormNeedItem => 'Add at least one item with a price.';

  @override
  String get quoteFormNew => 'New quotation';

  @override
  String get quoteFormQty => 'Qty';

  @override
  String get quoteFormReviewNote =>
      'Back office checks every quotation before the customer sees it.';

  @override
  String quoteFormRevise(String version) {
    return 'Revised quotation, version $version';
  }

  @override
  String get quoteFormTax => 'GST';

  @override
  String quoteFormTotalLine(String subtotal, String tax) {
    return 'Items $subtotal, GST $tax';
  }

  @override
  String get quoteFormUnitPrice => 'Price per unit';

  @override
  String quoteInclTax(String percent) {
    return 'Includes $percent GST';
  }

  @override
  String get quoteInstallation => 'Installation';

  @override
  String get quoteItems => 'Items';

  @override
  String get quoteNew => 'New';

  @override
  String quoteNumber(String number, String version) {
    return '$number, version $version';
  }

  @override
  String get quoteOtherVersions => 'Other versions';

  @override
  String quoteQtyLine(String qty, String price) {
    return '$qty × $price';
  }

  @override
  String get quoteRejected => 'Rejected';

  @override
  String get quoteReviewNote =>
      'Check prices, items and terms before the customer sees it.';

  @override
  String get quoteRevise => 'Send a revised version';

  @override
  String get quoteRevisionAsked => 'Changes asked for';

  @override
  String get quoteRevisionRequested => 'Changes requested';

  @override
  String get quoteSaveDraft => 'Save draft';

  @override
  String get quoteSendToVendor => 'Send to vendor';

  @override
  String get quoteSent => 'Sent';

  @override
  String get quoteSignHelp => 'This works as your signature.';

  @override
  String get quoteSignLabel => 'Type your full name to sign';

  @override
  String quoteSignedBy(String name, String date) {
    return 'Signed by $name on $date.';
  }

  @override
  String get quoteSubmit => 'Submit';

  @override
  String get quoteSubmitBody =>
      'O2O Boss will check it and send it to the customer. You can\'t edit it after this.';

  @override
  String get quoteSubmitTitle => 'Submit this quotation?';

  @override
  String get quoteSubmitted => 'Under review';

  @override
  String get quoteSubmittedToast => 'Quotation submitted for review.';

  @override
  String get quoteSubtotal => 'Subtotal';

  @override
  String get quoteSuperseded => 'Replaced';

  @override
  String get quoteSupersededNote => 'A newer version of this quotation exists.';

  @override
  String quoteTax(String percent) {
    return 'GST $percent';
  }

  @override
  String get quoteTerms => 'Terms';

  @override
  String get quoteTermsLabel => 'Terms and warranty';

  @override
  String get quoteTimeline => 'Work takes';

  @override
  String quoteValidUntil(String date) {
    return 'Valid until $date';
  }

  @override
  String get quoteValidity => 'Valid for';

  @override
  String get quoteViewed => 'Viewed';

  @override
  String quotesCopyNote(String email) {
    return 'A copy of every quotation is sent to $email.';
  }

  @override
  String get quotesEmptyBody =>
      'Quotations from vendors will appear here after the site visit.';

  @override
  String quotesToReview(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count quotations are waiting for your review.',
      one: '1 quotation is waiting for your review.',
    );
    return '$_temp0';
  }

  @override
  String get referAnother => 'Refer another customer';

  @override
  String get referConsent =>
      'The customer knows about this referral and agreed to be contacted by O2O Boss.';

  @override
  String get referConsentCustomer =>
      'I agree to be contacted by O2O Boss and its partner vendors about this requirement.';

  @override
  String get referConsentError => 'Tick the box to confirm.';

  @override
  String get referContactLabel => 'How should we contact the customer?';

  @override
  String get referContactLabelCustomer => 'How should we contact you?';

  @override
  String get referCustomerSubtitle =>
      'We\'ll call this number to confirm the requirement.';

  @override
  String get referCustomerTitle => 'Who is the customer?';

  @override
  String referDoneId(String id) {
    return 'Enquiry ID $id';
  }

  @override
  String get referDoneTitle => 'Referral sent';

  @override
  String get referDoneTitleCustomer => 'Requirement posted';

  @override
  String referDuplicateBody(String id, String category) {
    return '$id for $category is still open for this number. A new referral for the same need may not count.';
  }

  @override
  String get referDuplicateCheck => 'Go back';

  @override
  String get referDuplicateContinue => 'Continue anyway';

  @override
  String get referDuplicateTitle => 'This customer is already referred';

  @override
  String get referHow1Body =>
      'Takes about a minute. Tell the customer we will call them.';

  @override
  String get referHow1Title => 'Share the customer\'s details';

  @override
  String get referHow2Body =>
      'Our team confirms the need and connects a trusted vendor nearby.';

  @override
  String get referHow2Title => 'We verify and find a vendor';

  @override
  String get referHow3Body =>
      'Follow every step here. Your commission is added when the customer pays.';

  @override
  String get referHow3Title => 'You earn when it\'s paid';

  @override
  String get referHowTitle => 'How referrals work';

  @override
  String get referNeedTitle => 'What do they need?';

  @override
  String get referNeedTitleCustomer => 'What do you need?';

  @override
  String get referNext1Body =>
      'Our team will call the customer, usually within a few hours.';

  @override
  String get referNext1BodyCustomer =>
      'Our team will call you, usually within a few hours.';

  @override
  String get referNext1Title => 'We call to verify';

  @override
  String get referNext2Body =>
      'We pick a verified vendor nearby who serves this need.';

  @override
  String get referNext2Title => 'A trusted vendor is connected';

  @override
  String get referNext3Body =>
      'You can follow each step and your earning in the app.';

  @override
  String get referNext3BodyCustomer =>
      'You\'ll get the quotation here to accept or ask for changes.';

  @override
  String get referNext3Title => 'Quotation and work';

  @override
  String get referNotSure => 'Not sure? Describe the need';

  @override
  String get referOtpNote =>
      'We\'ll send a code to the customer\'s mobile to confirm the number.';

  @override
  String get referPlaceTitle => 'Where is the work?';

  @override
  String get referPreferredTime => 'Best time to call';

  @override
  String get referPreferredTimeHint => 'For example: after 6 pm';

  @override
  String get referPrivacyNote =>
      'The customer\'s number is only shared with O2O Boss. Vendors contact them through us.';

  @override
  String get referRequirementError => 'Add a few words about the requirement.';

  @override
  String get referRequirementHint =>
      'For example: 4 cameras for a 2-floor house, with night vision';

  @override
  String get referReviewSubtitle =>
      'Make sure everything is right. You can change any part.';

  @override
  String get referReviewTitle => 'Check and send';

  @override
  String referRulesBody(String percent, String trigger, String days) {
    return 'You earn $percent of the final order value when $trigger. Your referral is protected for $days days.';
  }

  @override
  String get referSubmit => 'Send referral';

  @override
  String get referSubmitCustomer => 'Post requirement';

  @override
  String get referTabSubtitle =>
      'What does your customer need? Tap one to start.';

  @override
  String get referTabTitle => 'Refer';

  @override
  String get referTitle => 'Refer a customer';

  @override
  String get referTitleCustomer => 'New requirement';

  @override
  String get referTrack => 'Track progress';

  @override
  String get resetButton => 'Save password';

  @override
  String get resetDone => 'Password changed. Sign in with your new password.';

  @override
  String get resetTitle => 'Set a new password';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get roleAdminDesc => 'Manage the whole platform';

  @override
  String get roleBackOffice => 'Back office';

  @override
  String get roleBackOfficeDesc => 'Verify enquiries and manage the work';

  @override
  String get roleCustomer => 'Customer';

  @override
  String get roleCustomerDesc => 'Track your requirement and quotations';

  @override
  String get roleFranchise => 'Franchise head';

  @override
  String get roleFranchiseDesc => 'See business in your territory';

  @override
  String get roleSales => 'Referral partner';

  @override
  String get roleSalesDesc => 'Refer customers and earn commission';

  @override
  String get roleVendor => 'Vendor';

  @override
  String get roleVendorDesc => 'Receive referrals and send quotations';

  @override
  String get salesCompany => 'Company sales team';

  @override
  String salesEarningLater(String percent) {
    return 'You earn $percent of the final order value. The amount appears once a quotation is accepted.';
  }

  @override
  String get salesEmptyBody =>
      'Your referrals and their progress will appear here.';

  @override
  String get salesEmptyTitle => 'No referrals yet';

  @override
  String get salesEnquiriesTitle => 'My referrals';

  @override
  String salesExpectedEarning(String amount, String trigger) {
    return 'You can earn about $amount when $trigger.';
  }

  @override
  String get salesFilterActive => 'In progress';

  @override
  String get salesFilterClosed => 'Closed';

  @override
  String get salesFilterWon => 'Won';

  @override
  String salesHomeSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count referrals are in progress.',
      one: '1 referral is in progress.',
      zero: 'No referrals in progress right now.',
    );
    return '$_temp0';
  }

  @override
  String get salesIndependent => 'Independent referrer';

  @override
  String get salesKpiEarned => 'Earned';

  @override
  String get salesKpiInProgress => 'In progress';

  @override
  String get salesKpiPending => 'On the way';

  @override
  String get salesKpiWon => 'Won';

  @override
  String salesLostBody(String reason) {
    return 'The customer did not go ahead. Reason: $reason.';
  }

  @override
  String get salesNoEarning =>
      'There is no commission for this referral because it was closed.';

  @override
  String get salesRecentTitle => 'Latest referrals';

  @override
  String get salesReferBody =>
      'Know someone who needs CCTV, solar, interiors or more? Share their details and earn when the work is paid for.';

  @override
  String get salesReferButton => 'Start a referral';

  @override
  String get salesReferTitle => 'Refer a customer';

  @override
  String salesRejectedBody(String reason) {
    return 'We could not verify this referral. Reason: $reason.';
  }

  @override
  String get salesVendorWorking => 'Working on it';

  @override
  String get searchCustomers => 'Customers';

  @override
  String get searchHint => 'Search by enquiry ID, product or name';

  @override
  String get searchHintOps => 'Search enquiries, customers or vendors';

  @override
  String get searchStartBody =>
      'Type at least 2 letters, an enquiry ID or part of a phone number.';

  @override
  String get searchStartTitle => 'Search';

  @override
  String get searchVendors => 'Vendors';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsTheme => 'App colours';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get signupBusinessTitle => 'Business details';

  @override
  String get signupCreate => 'Create account';

  @override
  String get signupDetailsTitle => 'Your details';

  @override
  String signupDoneBody(String id) {
    return 'Sign in any time with user ID $id.';
  }

  @override
  String get signupDoneTitle => 'Your account is ready';

  @override
  String get signupGoHome => 'Go to home';

  @override
  String get signupPhoneExists =>
      'This number already has an account. Sign in instead.';

  @override
  String signupStepOf(String step, String total) {
    return 'Step $step of $total';
  }

  @override
  String get signupTerms => 'I agree to the Terms of use and Privacy policy';

  @override
  String get signupTermsError => 'Please accept the terms to continue.';

  @override
  String get signupTitle => 'Create account';

  @override
  String get signupVendorDoneBody =>
      'We check every business before sending referrals. You\'ll be notified when it\'s approved.';

  @override
  String get signupVendorDoneTitle => 'Registration sent for review';

  @override
  String get signupWhoCustomer => 'I need a product or service';

  @override
  String get signupWhoCustomerDesc =>
      'Tell us what you need. We\'ll connect you with a trusted business.';

  @override
  String get signupWhoSales => 'Refer customers and earn';

  @override
  String get signupWhoSalesDesc =>
      'Tell us who needs a product or service. Earn when the business is done.';

  @override
  String get signupWhoTitle => 'How will you use O2O Boss?';

  @override
  String get signupWhoVendor => 'Register my business';

  @override
  String get signupWhoVendorDesc =>
      'Get verified customers for your products and services.';

  @override
  String get simpleDone => 'Completed';

  @override
  String get simpleFindingVendor => 'Finding a vendor';

  @override
  String get simpleLost => 'Lost';

  @override
  String get simpleNotVerified => 'Not verified';

  @override
  String get simplePayment => 'Payment pending';

  @override
  String get simpleQuotation => 'Quotation stage';

  @override
  String get simpleVendorAssigned => 'Vendor assigned';

  @override
  String get simpleVerified => 'Verified';

  @override
  String get simpleVerifying => 'Being verified';

  @override
  String get simpleVisit => 'Visit planned';

  @override
  String get simpleWon => 'Won';

  @override
  String get simpleWork => 'Work in progress';

  @override
  String get sourceAdmin => 'Admin';

  @override
  String get sourceBackOffice => 'Back office';

  @override
  String get sourceCustomer => 'Customer, in the app';

  @override
  String get sourceSales => 'Referral partner';

  @override
  String get stActive => 'Active';

  @override
  String get stActiveHelp => 'Inactive items are hidden from new enquiries.';

  @override
  String get stAddArea => 'Add area';

  @override
  String get stAddBrand => 'Add brand';

  @override
  String get stAddCity => 'Add city';

  @override
  String get stAddFranchise => 'Add franchise';

  @override
  String get stAddProduct => 'Add product';

  @override
  String get stAddQuestion => 'Add question';

  @override
  String get stAddService => 'Add service';

  @override
  String get stAdded => 'Added.';

  @override
  String get stAdminCopy => 'Send a copy of each quotation to admin';

  @override
  String get stAreaName => 'Area name';

  @override
  String stAreasCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count areas',
      one: '1 area',
      zero: 'No areas',
    );
    return '$_temp0';
  }

  @override
  String get stAsksPrice => 'Ask vendors for an expected price';

  @override
  String get stAsksTime => 'Ask vendors for expected days';

  @override
  String get stBoPercent => 'Back office commission';

  @override
  String get stBrandName => 'Brand name';

  @override
  String get stBrandServices => 'Used for';

  @override
  String get stCalling => 'Calls from the app';

  @override
  String get stCityName => 'City';

  @override
  String stDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String stDecrease(String label) {
    return 'Less $label';
  }

  @override
  String get stDefaultPriority => 'Default priority';

  @override
  String get stDeleteQuestion => 'Delete question';

  @override
  String get stDeleteQuestionTitle => 'Delete this question?';

  @override
  String get stDescription => 'Description';

  @override
  String get stESign => 'Customers sign to accept';

  @override
  String get stEditQuestion => 'Edit question';

  @override
  String get stEmail => 'Email';

  @override
  String get stExpiryDays => 'Close quiet enquiries after';

  @override
  String get stFeedbackOn => 'Ask customers for a rating';

  @override
  String get stFranchiseName => 'Franchise name';

  @override
  String get stFranchisePercent => 'Franchise share';

  @override
  String get stHead => 'Franchise head';

  @override
  String stHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours',
      one: '1 hour',
    );
    return '$_temp0';
  }

  @override
  String get stInactive => 'Inactive';

  @override
  String stIncrease(String label) {
    return 'More $label';
  }

  @override
  String get stMultiQuotes => 'Customers can compare quotations by default';

  @override
  String get stNoHead => 'No head assigned';

  @override
  String get stNoQuestions => 'No questions yet.';

  @override
  String get stOnlinePay => 'Online payment';

  @override
  String get stOtp => 'Confirm customer mobile with a code';

  @override
  String get stPayoutApproval => 'Admin approves each payout';

  @override
  String get stPincode => 'Pincode';

  @override
  String get stPincodeError => 'Enter a 6-digit pincode.';

  @override
  String get stProductName => 'Product name';

  @override
  String get stProtectionDays => 'Referral protected for';

  @override
  String get stPush => 'App notifications';

  @override
  String get stQChoice => 'Pick one';

  @override
  String get stQDate => 'Date';

  @override
  String get stQNumber => 'Number';

  @override
  String get stQText => 'Short answer';

  @override
  String get stQYesNo => 'Yes or no';

  @override
  String get stQuestionLabel => 'Question';

  @override
  String get stQuestionOptions => 'Choices';

  @override
  String get stQuestionOptionsHint =>
      'Separate with commas, for example: 1, 2, 3 or more';

  @override
  String get stQuestionRequired => 'Answer is required';

  @override
  String get stQuestionType => 'Answer type';

  @override
  String get stQuestions => 'Qualification questions';

  @override
  String stQuestionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count questions',
      one: '1 question',
      zero: 'No questions',
    );
    return '$_temp0';
  }

  @override
  String get stQuestionsHelp =>
      'Back office asks these when checking an enquiry.';

  @override
  String get stQuoteReview => 'Back office checks quotations first';

  @override
  String get stRecording => 'Record calls';

  @override
  String get stRecordingConsent => 'Ask before recording';

  @override
  String get stRemoveArea => 'Remove area';

  @override
  String stRemoveAreaTitle(String area) {
    return 'Remove $area?';
  }

  @override
  String get stRename => 'Rename';

  @override
  String get stRequired => 'Required';

  @override
  String get stSalesPercent => 'Referral partner commission';

  @override
  String get stSalesValue => 'What referral partners see of the value';

  @override
  String get stSave => 'Save';

  @override
  String get stSaved => 'Setting saved.';

  @override
  String get stSecChannels => 'Messages and calls';

  @override
  String get stSecChannelsHelp => 'WhatsApp, SMS, email, calls and recording';

  @override
  String get stSecCommission => 'Commission';

  @override
  String get stSecCommissionHelp => 'Rates, when it is earned, payout approval';

  @override
  String get stSecEnquiry => 'Enquiries';

  @override
  String get stSecEnquiryHelp => 'Mobile check, expiry and referral protection';

  @override
  String get stSecFeedback => 'Feedback';

  @override
  String get stSecFeedbackHelp => 'Ratings after the work is done';

  @override
  String get stSecPayments => 'Payments';

  @override
  String get stSecPaymentsHelp => 'Tracking and online payment';

  @override
  String get stSecQuotes => 'Quotations';

  @override
  String get stSecQuotesHelp => 'Checking, signing and copies';

  @override
  String get stSecVendors => 'Vendors';

  @override
  String get stSecVendorsHelp => 'Approval and time to reply';

  @override
  String get stSecVisibility => 'Who sees what';

  @override
  String get stSecVisibilityHelp => 'Contact details and order values';

  @override
  String get stSeesReferrer => 'Customers see who referred them';

  @override
  String get stSeesVendorContact => 'Customers see vendor phone numbers';

  @override
  String get stService => 'Service';

  @override
  String get stServiceName => 'Service name';

  @override
  String stShareDefault(String percent) {
    return 'The default share is $percent.';
  }

  @override
  String get stSms => 'SMS messages';

  @override
  String get stState => 'State';

  @override
  String get stTracking => 'Track payments';

  @override
  String get stTrigger => 'Commission is earned when';

  @override
  String get stVendorApproval =>
      'Approve new vendors before they get referrals';

  @override
  String get stVendorHours => 'Time for vendors to reply';

  @override
  String get stVendorSeesReferrer => 'Vendors see the referral partner';

  @override
  String get stWhatsapp => 'WhatsApp messages';

  @override
  String get statusAppointmentCompleted => 'Visit done';

  @override
  String get statusAppointmentScheduled => 'Visit scheduled';

  @override
  String get statusCommissionCalculated => 'Commission calculated';

  @override
  String get statusCommissionSettled => 'Completed';

  @override
  String get statusCustomerContact => 'Customer connected';

  @override
  String get statusLost => 'Lost';

  @override
  String get statusNegotiation => 'Negotiation';

  @override
  String get statusNewEnquiry => 'New';

  @override
  String get statusPaymentCollected => 'Payment collected';

  @override
  String get statusPaymentPending => 'Payment pending';

  @override
  String get statusProjectCompleted => 'Work completed';

  @override
  String get statusProjectCreated => 'Project created';

  @override
  String get statusProjectInProgress => 'Work in progress';

  @override
  String get statusQualificationPending => 'Qualification pending';

  @override
  String get statusQualified => 'Qualified';

  @override
  String get statusQuotationPending => 'Quotation pending';

  @override
  String get statusQuotationSubmitted => 'Quotation submitted';

  @override
  String get statusRejected => 'Not verified';

  @override
  String get statusVendorAccepted => 'Vendor accepted';

  @override
  String get statusVendorAssigned => 'Vendor assigned';

  @override
  String get statusVendorMatching => 'Finding vendor';

  @override
  String get statusVerificationPending => 'Verification pending';

  @override
  String get statusVerified => 'Verified';

  @override
  String get statusWon => 'Won';

  @override
  String get svCommissionOnly => 'Commission only';

  @override
  String get svFull => 'Full value';

  @override
  String get svHidden => 'Hidden';

  @override
  String get svLimited => 'Rounded value';

  @override
  String get svStageBased => 'Only after the deal is won';

  @override
  String get sysAppointmentCancelled => 'Visit cancelled.';

  @override
  String get sysAppointmentCompleted => 'Visit completed.';

  @override
  String sysAppointmentConfirmed(String date) {
    return 'Visit confirmed for $date.';
  }

  @override
  String sysAppointmentProposed(String date) {
    return 'Visit proposed for $date.';
  }

  @override
  String sysAppointmentRescheduled(String date) {
    return 'Visit moved to $date.';
  }

  @override
  String sysAssigned(String id, String vendor) {
    return '$id assigned to $vendor.';
  }

  @override
  String sysConnected(String vendor) {
    return '$vendor is now connected to the customer through O2O Boss.';
  }

  @override
  String get sysEnquiryLost => 'This enquiry was closed.';

  @override
  String sysNewReferral(String id, String hours) {
    return 'New referral $id. Please reply within $hours hours.';
  }

  @override
  String get sysOtherAccepted => 'Another quotation was accepted.';

  @override
  String sysProjectCreated(String project) {
    return 'Project $project started.';
  }

  @override
  String sysQuotationAccepted(String number) {
    return 'The customer accepted $number.';
  }

  @override
  String sysQuotationRejected(String number) {
    return 'The customer rejected $number.';
  }

  @override
  String sysQuotationSent(String number, String version) {
    return 'Quotation $number (version $version) sent to the customer.';
  }

  @override
  String sysQuotationSubmitted(String number, String version) {
    return 'Quotation $number (version $version) submitted.';
  }

  @override
  String sysReferralAccepted(String vendor) {
    return '$vendor accepted the referral.';
  }

  @override
  String sysReferralRejected(String vendor) {
    return '$vendor declined the referral.';
  }

  @override
  String sysRevisionRequested(String number) {
    return 'Changes requested on $number.';
  }

  @override
  String get taskAdd => 'Add task';

  @override
  String get taskAdded => 'Task added.';

  @override
  String taskApproveCommission(String id) {
    return 'Approve commission for $id';
  }

  @override
  String taskApproveVendor(String name) {
    return 'Review new vendor $name';
  }

  @override
  String taskAssignVendor(String id) {
    return 'Choose vendor for $id';
  }

  @override
  String taskCollectPayment(String id) {
    return 'Collect payment for $id';
  }

  @override
  String taskCreateProject(String id) {
    return 'Start project for $id';
  }

  @override
  String get taskDone => 'Task done.';

  @override
  String get taskDue => 'Due';

  @override
  String get taskEmptyBody =>
      'Tasks are created for you as enquiries move. You can add your own too.';

  @override
  String get taskEmptyTitle => 'No tasks';

  @override
  String taskQualify(String id) {
    return 'Check requirement for $id';
  }

  @override
  String taskReviewQuotation(String id) {
    return 'Review quotation for $id';
  }

  @override
  String get taskToDo => 'To do';

  @override
  String taskVendorNoResponse(String id) {
    return 'Vendor hasn\'t replied on $id';
  }

  @override
  String taskVerify(String id) {
    return 'Verify $id';
  }

  @override
  String get taskWhat => 'What needs doing?';

  @override
  String get terms1Body =>
      'O2O Boss connects customers with verified vendors through referrals. By using the app you agree to share accurate information and to use it only for genuine requirements.';

  @override
  String get terms1Title => 'Using O2O Boss';

  @override
  String get terms2Body =>
      'Commission is paid on referrals verified and completed through O2O Boss, according to the rules shown in the app at the time of the referral.';

  @override
  String get terms2Title => 'Referrals and commission';

  @override
  String get terms3Body =>
      'Vendors are responsible for their quotations, work quality and delivery timelines. O2O Boss may review quotations before they reach customers.';

  @override
  String get terms3Title => 'Vendors';

  @override
  String get terms4Body =>
      'Keep your user ID and password private. O2O Boss may suspend accounts that misuse the platform.';

  @override
  String get terms4Title => 'Accounts';

  @override
  String get themeBrand => 'O2O Boss orange';

  @override
  String get themeBrandBody => 'Orange and navy, like our website';

  @override
  String get themeClassic => 'Blue';

  @override
  String get themeClassicBody => 'The standard look';

  @override
  String get toastCopied => 'Copied.';

  @override
  String get toastSaved => 'Saved.';

  @override
  String get toastSent => 'Sent.';

  @override
  String get toastUpdated => 'Updated.';

  @override
  String get today => 'Today';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get trigFullPayment => 'Full payment collected';

  @override
  String get trigOrderConfirmed => 'Order confirmed';

  @override
  String get trigPaymentReceived => 'First payment received';

  @override
  String get trigProjectCompleted => 'Work completed';

  @override
  String get trigProjectStarted => 'Work started';

  @override
  String get trigQuotationAccepted => 'Quotation accepted';

  @override
  String get trigSentenceFullPayment => 'the customer has paid in full';

  @override
  String get trigSentenceOrderConfirmed => 'the order is confirmed';

  @override
  String get trigSentencePaymentReceived => 'the first payment is received';

  @override
  String get trigSentenceProjectCompleted => 'the work is completed';

  @override
  String get trigSentenceProjectStarted => 'the work starts';

  @override
  String get trigSentenceQuotationAccepted =>
      'the customer accepts the quotation';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get validationAmount => 'Enter an amount greater than zero.';

  @override
  String get validationChooseOne => 'Choose one option.';

  @override
  String get validationEmail => 'Enter a valid email address.';

  @override
  String get validationFixErrors =>
      'Some details need attention. Check the highlighted fields.';

  @override
  String get validationLoginIdFormat =>
      'Use 4 to 20 letters, numbers, dots or underscores.';

  @override
  String get validationLoginIdTaken => 'This user ID is taken. Try another.';

  @override
  String get validationName => 'Enter a name.';

  @override
  String get validationNumber => 'Enter a number.';

  @override
  String get validationOtp => 'Enter the 6-digit code.';

  @override
  String get validationOtpWrong =>
      'That code is not right. Check it and try again.';

  @override
  String get validationPasswordLength => 'Use at least 6 characters.';

  @override
  String get validationPasswordMatch => 'Passwords do not match.';

  @override
  String get validationPhone => 'Enter a 10-digit mobile number.';

  @override
  String get validationReason => 'Tell us the reason.';

  @override
  String get validationRequired => 'This field is required.';

  @override
  String get vbAbout => 'About your business';

  @override
  String get vbAboutEmpty => 'Tell customers what you do best.';

  @override
  String get vbAddress => 'Address';

  @override
  String get vbAreasHelp =>
      'Pick the areas you reach in each city. Leave a city\'s areas empty to cover all of it.';

  @override
  String get vbAvailable => 'Taking new referrals';

  @override
  String get vbAvailableOff => 'Paused. You will not get new referrals.';

  @override
  String get vbAvailableOn => 'O2O Boss will send you new customers.';

  @override
  String get vbBrands => 'Brands';

  @override
  String get vbCities => 'Cities';

  @override
  String get vbCompanyName => 'Business name';

  @override
  String get vbCompanyTitle => 'Business profile';

  @override
  String get vbContactPerson => 'Contact person';

  @override
  String get vbDetails => 'Business details';

  @override
  String vbDocUploadedOn(String kind, String date) {
    return '$kind, uploaded $date';
  }

  @override
  String get vbDocsNote =>
      'O2O Boss checks each document. Verified documents help you get more referrals.';

  @override
  String get vbEdit => 'Edit';

  @override
  String get vbEditTitle => 'Edit business details';

  @override
  String get vbEmail => 'Email';

  @override
  String get vbGst => 'GST number';

  @override
  String vbJoined(String date) {
    return 'Partner since $date';
  }

  @override
  String get vbPickCityFirst => 'Choose a city first.';

  @override
  String get vbPickServiceFirst => 'Choose a service first.';

  @override
  String get vbProducts => 'Products';

  @override
  String get vbSave => 'Save changes';

  @override
  String get vbSaved => 'Saved.';

  @override
  String get vbServices => 'Services';

  @override
  String get vbServicesHelp =>
      'Choose what you offer. You only get referrals for these.';

  @override
  String get vbUpload => 'Upload a document';

  @override
  String get vbUploadTitle => 'Which document?';

  @override
  String get vbUploaded => 'Document uploaded. We will check it soon.';

  @override
  String get vendorApprove => 'Approve vendor';

  @override
  String get vendorApproved =>
      'Vendor approved. They can now receive referrals.';

  @override
  String get vendorAwaiting => 'Waiting for approval';

  @override
  String get vendorAwaitingBody =>
      'Check the business details and documents, then approve or reject.';

  @override
  String get vendorBusiness => 'Business';

  @override
  String get vendorDocPending => 'Not checked';

  @override
  String get vendorDocVerified => 'Verified';

  @override
  String get vendorDocVerifiedToast => 'Document verified.';

  @override
  String get vendorDocuments => 'Documents';

  @override
  String get vendorNoDocs => 'No documents uploaded';

  @override
  String get vendorRating => 'Rating';

  @override
  String get vendorReactivate => 'Reactivate vendor';

  @override
  String get vendorReferrals => 'Referrals';

  @override
  String get vendorReject => 'Reject';

  @override
  String get vendorRejectArea => 'Area not covered yet';

  @override
  String get vendorRejectDocs => 'Documents missing or unclear';

  @override
  String get vendorRejectQuality => 'Did not meet quality checks';

  @override
  String get vendorRejected => 'Vendor rejected.';

  @override
  String get vendorResponse => 'Replies on time';

  @override
  String get vendorSuspend => 'Suspend vendor';

  @override
  String get vendorSuspended => 'Vendor suspended.';

  @override
  String get vendorTerms => 'Commercial terms';

  @override
  String get vendorVerifyDoc => 'Mark verified';

  @override
  String get vendorsDeadline => 'Time to reply';

  @override
  String vendorsDeclined(String reason) {
    return 'Declined: $reason';
  }

  @override
  String vendorsExpectedDays(String days) {
    return 'About $days days';
  }

  @override
  String vendorsExpectedPrice(String price) {
    return 'Expected price $price';
  }

  @override
  String get vendorsIntroduce => 'Introduce to customer';

  @override
  String get vendorsIntroduced => 'Vendor introduced to the customer.';

  @override
  String vendorsMeta(String area, String rating, String rate) {
    return '$area, rating $rating, replies $rate%';
  }

  @override
  String get vendorsNoneBody =>
      'No active vendor serves this category in this city yet.';

  @override
  String get vendorsNoneTitle => 'No matching vendor';

  @override
  String get vendorsNotQualified =>
      'Referrals go to vendors only after the enquiry is verified and qualified.';

  @override
  String get vendorsOnThis => 'Vendors on this enquiry';

  @override
  String get vendorsOptions => 'Before sending';

  @override
  String get vendorsProfile => 'Profile';

  @override
  String get vendorsReasonArea => 'Area';

  @override
  String get vendorsReasonBrand => 'Brand';

  @override
  String get vendorsReasonCity => 'City';

  @override
  String get vendorsReasonProduct => 'Product';

  @override
  String vendorsScore(String score) {
    return 'Match $score';
  }

  @override
  String vendorsSendBody(String hours) {
    return 'They will have $hours hours to accept or decline. The customer\'s number stays private.';
  }

  @override
  String vendorsSendButton(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Send to $count vendors',
      one: 'Send to 1 vendor',
    );
    return '$_temp0';
  }

  @override
  String get vendorsSendConfirm => 'Send referral';

  @override
  String vendorsSendTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Send referral to $count vendors?',
      one: 'Send referral to 1 vendor?',
    );
    return '$_temp0';
  }

  @override
  String get vendorsSent => 'Referral sent.';

  @override
  String vendorsSentOn(String date) {
    return 'Sent $date';
  }

  @override
  String get vendorsShowAllQuotes => 'Customer can compare quotations';

  @override
  String get vendorsShowAllQuotesHelp =>
      'When on, the customer sees every vendor\'s quotation. When off, only the one you send.';

  @override
  String vendorsShowPartial(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Show $count partial matches',
      one: 'Show 1 partial match',
    );
    return '$_temp0';
  }

  @override
  String get vendorsSuggested => 'Suggested vendors';

  @override
  String get vendorsSuggestedHelp =>
      'Best matches first, by product, brand, location, rating and response rate.';

  @override
  String get vendorsWithdraw => 'Withdraw';

  @override
  String vendorsWithdrawBody(String vendor) {
    return '$vendor will no longer see this enquiry.';
  }

  @override
  String get vendorsWithdrawTitle => 'Withdraw the referral?';

  @override
  String get vendorsWithdrawn => 'Referral withdrawn.';

  @override
  String get verifyCallAgain => 'Call again';

  @override
  String get verifyCallButton => 'Call customer';

  @override
  String verifyCallLength(String time) {
    return 'Last call: $time';
  }

  @override
  String get verifyCallbackAt => 'When to call back';

  @override
  String get verifyDoneGenuine =>
      'Verified. Now ask the qualification questions.';

  @override
  String get verifyDoneLater => 'Saved. A follow-up was added.';

  @override
  String get verifyDoneRejected => 'Enquiry closed.';

  @override
  String verifyDuplicateNote(String ids) {
    return 'This number also has $ids open. Check it is not a duplicate.';
  }

  @override
  String get verifyExplainGenuine =>
      'The enquiry will be marked verified and move to qualification.';

  @override
  String get verifyExplainLater =>
      'The enquiry stays open and a follow-up is added for you.';

  @override
  String get verifyExplainReject =>
      'The enquiry will be closed and the referral partner told why.';

  @override
  String get verifyNotesHint => 'What the customer said, in a few words';

  @override
  String get verifyRecordingConsent =>
      'The customer agreed to the call being recorded.';

  @override
  String verifyReferredBy(String name) {
    return 'Referred by $name';
  }

  @override
  String verifyRejectBody(String reason) {
    return 'It will be closed as \"$reason\". You can ask admin to reopen it later.';
  }

  @override
  String get verifyRejectConfirm => 'Close enquiry';

  @override
  String get verifyRejectTitle => 'Close this enquiry?';

  @override
  String get verifySave => 'Save result';

  @override
  String get verifyTitle => 'Verify enquiry';

  @override
  String get verifyWhatHappened => 'What happened on the call?';

  @override
  String get visFull => 'Full details';

  @override
  String get visHidden => 'Hidden';

  @override
  String get visLimited => 'Name and area only';

  @override
  String get visitBookTitle => 'Book a visit';

  @override
  String get visitBooked => 'Visit booked. Everyone has been told.';

  @override
  String get visitCancel => 'Cancel visit';

  @override
  String get visitCancelCustomer => 'Customer not available';

  @override
  String visitCancelReason(String reason) {
    return 'Cancelled: $reason';
  }

  @override
  String get visitCancelTitle => 'Cancel the visit';

  @override
  String get visitCancelVendor => 'Vendor not available';

  @override
  String get visitCancelWeather => 'Weather or site not ready';

  @override
  String get visitCancelled => 'Visit cancelled.';

  @override
  String get visitConfirm => 'Confirm';

  @override
  String get visitConfirmed => 'Visit confirmed.';

  @override
  String get visitCustomerConfirm => 'Yes, the vendor visited';

  @override
  String get visitCustomerConfirmed => 'Customer confirmed the visit';

  @override
  String get visitDone => 'Visit marked done.';

  @override
  String get visitDoneBody => 'The vendor can then prepare the quotation.';

  @override
  String get visitDoneTitle => 'Did the visit happen?';

  @override
  String visitIntroduceFirst(String vendor) {
    return '$vendor accepted. Introduce them to the customer before booking a visit.';
  }

  @override
  String get visitMarkDone => 'Mark visit done';

  @override
  String get visitNeedVendor => 'A vendor must accept the referral first.';

  @override
  String get visitNoShow => 'Didn\'t happen';

  @override
  String get visitNoShowSaved => 'Saved. A follow-up call was added.';

  @override
  String get visitProposeSubtitle =>
      'O2O Boss will confirm the time with the customer.';

  @override
  String get visitProposeTitle => 'Propose a visit';

  @override
  String get visitProposed => 'Visit proposed. Back office will confirm.';

  @override
  String get visitPurpose => 'Purpose';

  @override
  String get visitPurposeHint =>
      'For example: measure the site and check wiring';

  @override
  String get visitRescheduled => 'Visit rescheduled.';

  @override
  String get visitThanks => 'Thanks for confirming.';

  @override
  String get visitWhen => 'Date and time';

  @override
  String get vnAccept => 'Accept';

  @override
  String get vnAcceptSubtitle =>
      'Give a rough idea. You will send the exact quotation later.';

  @override
  String get vnAcceptTitle => 'Accept this referral';

  @override
  String get vnAcceptedToast =>
      'Referral accepted. O2O Boss will share the next steps.';

  @override
  String get vnAllClearBody => 'New referrals from O2O Boss will appear here.';

  @override
  String get vnAllClearTitle => 'All caught up';

  @override
  String get vnAreas => 'Service areas';

  @override
  String get vnAreasSubtitle => 'Cities and areas you cover';

  @override
  String get vnBusinessProfile => 'Business profile';

  @override
  String get vnCatalog => 'Products and brands';

  @override
  String get vnCatalogSubtitle => 'What you sell and install';

  @override
  String get vnChatHelp => 'Ask questions or share photos about this job';

  @override
  String get vnChatWithO2O => 'Chat with O2O Boss';

  @override
  String get vnClosedBody =>
      'The customer did not go ahead. Thank you for your time.';

  @override
  String get vnClosedTitle => 'This enquiry is closed';

  @override
  String get vnCustomerHidden => 'Shared after you accept';

  @override
  String get vnDecline => 'Decline';

  @override
  String get vnDeclineArea => 'Area is too far';

  @override
  String get vnDeclineBudget => 'Budget is too low';

  @override
  String get vnDeclineBusy => 'Too busy right now';

  @override
  String get vnDeclineProduct => 'We don\'t offer this product';

  @override
  String get vnDeclineTitle => 'Why are you declining?';

  @override
  String vnDeclinedBody(String reason) {
    return 'Reason: $reason';
  }

  @override
  String get vnDeclinedTitle => 'You declined this referral';

  @override
  String get vnDeclinedToast => 'Referral declined.';

  @override
  String get vnDocumentsSubtitle => 'GST, PAN, licence and bank proof';

  @override
  String get vnEmptyBody =>
      'When O2O Boss sends you a customer, it shows up in this list.';

  @override
  String get vnEmptyTitle => 'No referrals here';

  @override
  String get vnExpectedDays => 'Days to finish the work';

  @override
  String get vnExpectedPrice => 'Expected price';

  @override
  String get vnExpiredBody =>
      'The time to reply ran out, so it went to another vendor.';

  @override
  String get vnExpiredTitle => 'This referral has expired';

  @override
  String get vnFilterActive => 'Active';

  @override
  String get vnFilterClosed => 'Closed';

  @override
  String get vnFilterNew => 'New';

  @override
  String get vnFilterWon => 'Won';

  @override
  String vnHomeSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count new referrals are waiting.',
      one: '1 new referral is waiting.',
      zero: 'No new referrals right now.',
    );
    return '$_temp0';
  }

  @override
  String get vnKpiActive => 'Active jobs';

  @override
  String get vnKpiNew => 'New';

  @override
  String get vnKpiProjects => 'Work going on';

  @override
  String get vnKpiQuotes => 'Open quotes';

  @override
  String get vnMoreBusiness => 'Your business';

  @override
  String vnNewBody(String time) {
    return 'Reply by $time so the customer is not kept waiting.';
  }

  @override
  String get vnNewButton => 'See referral';

  @override
  String get vnNewQuote => 'Create quotation';

  @override
  String vnNewTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count new referrals waiting',
      one: 'New referral waiting',
    );
    return '$_temp0';
  }

  @override
  String get vnNextChangesBody =>
      'Read the note on the quotation and send a new version.';

  @override
  String get vnNextChangesTitle => 'Changes asked';

  @override
  String get vnNextCheckBody =>
      'You will get a message when it goes to the customer.';

  @override
  String get vnNextCheckTitle => 'O2O Boss is checking your quotation';

  @override
  String get vnNextCustomerBody => 'We will tell you as soon as they reply.';

  @override
  String get vnNextCustomerTitle => 'The customer is deciding';

  @override
  String get vnNextDraftBody =>
      'Your draft is saved. Send it when it is ready.';

  @override
  String get vnNextDraftTitle => 'Finish your quotation';

  @override
  String get vnNextLabel => 'Next step';

  @override
  String get vnNextQuoteBody =>
      'Add the items and price. O2O Boss checks it before the customer sees it.';

  @override
  String get vnNextQuoteTitle => 'Send your quotation';

  @override
  String get vnNextVisitBody =>
      'Suggest a time. O2O Boss confirms it with the customer.';

  @override
  String vnNextVisitSetBody(String time, String place) {
    return '$time at $place';
  }

  @override
  String get vnNextVisitSetTitle => 'Visit planned';

  @override
  String get vnNextVisitTitle => 'Plan a site visit';

  @override
  String get vnNextWorkBody =>
      'Tick each step as it is done so everyone can see progress.';

  @override
  String get vnNextWorkTitle => 'Update the work';

  @override
  String get vnNoQuotes => 'No quotation yet';

  @override
  String get vnNoVisits => 'No visit planned yet';

  @override
  String get vnNoteLabel => 'Note for O2O Boss';

  @override
  String get vnOpenDraft => 'Open draft';

  @override
  String get vnOpenProject => 'Open work';

  @override
  String get vnPendingBody =>
      'You can look around. Referrals start once O2O Boss approves your business.';

  @override
  String get vnPendingTitle => 'Your business is being checked';

  @override
  String get vnPrivacyNote =>
      'The customer\'s name is shared after you accept. You always reach them through O2O Boss.';

  @override
  String get vnProposeVisit => 'Suggest a visit';

  @override
  String vnQuoteBody(String job) {
    return '$job is ready for your price.';
  }

  @override
  String get vnQuoteButton => 'Create quotation';

  @override
  String get vnQuoteTitle => 'Send a quotation';

  @override
  String get vnQuotesChecking => 'Being checked';

  @override
  String get vnQuotesDrafts => 'Drafts';

  @override
  String get vnReferralTitle => 'Referral';

  @override
  String vnReplyBy(String time) {
    return 'Please reply by $time';
  }

  @override
  String get vnReplyStatus => 'Status';

  @override
  String get vnRevise => 'Make changes';

  @override
  String get vnStatusNew => 'New referral';

  @override
  String get vnUpcomingVisits => 'Upcoming visits';

  @override
  String get vnYourReply => 'Your reply';

  @override
  String get yesterday => 'Yesterday';
}

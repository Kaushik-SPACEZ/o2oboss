import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_as.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_brx.dart';
import 'app_localizations_doi.dart';
import 'app_localizations_en.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_kok.dart';
import 'app_localizations_ks.dart';
import 'app_localizations_mai.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_mni.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_ne.dart';
import 'app_localizations_or.dart';
import 'app_localizations_pa.dart';
import 'app_localizations_sa.dart';
import 'app_localizations_sat.dart';
import 'app_localizations_sd.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('as'),
    Locale('bn'),
    Locale('brx'),
    Locale('doi'),
    Locale('en'),
    Locale('gu'),
    Locale('hi'),
    Locale('kn'),
    Locale('kok'),
    Locale('ks'),
    Locale('mai'),
    Locale('ml'),
    Locale('mni'),
    Locale('mr'),
    Locale('ne'),
    Locale('or'),
    Locale('pa'),
    Locale('sa'),
    Locale('sat'),
    Locale('sd'),
    Locale('ta'),
    Locale('te'),
    Locale('ur'),
  ];

  /// No description provided for @accActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get accActive;

  /// No description provided for @accPending.
  ///
  /// In en, this message translates to:
  /// **'Waiting for approval'**
  String get accPending;

  /// No description provided for @accRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get accRejected;

  /// No description provided for @accSuspended.
  ///
  /// In en, this message translates to:
  /// **'Suspended'**
  String get accSuspended;

  /// No description provided for @accUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Under review'**
  String get accUnderReview;

  /// No description provided for @actionAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get actionAdd;

  /// No description provided for @actionApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get actionApply;

  /// No description provided for @actionBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get actionBack;

  /// No description provided for @actionCall.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get actionCall;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionChange.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get actionChange;

  /// No description provided for @actionClearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get actionClearFilters;

  /// No description provided for @actionClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get actionClose;

  /// No description provided for @actionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get actionConfirm;

  /// No description provided for @actionContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get actionContinue;

  /// No description provided for @actionCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get actionCopy;

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @actionDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get actionDiscard;

  /// No description provided for @actionDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get actionDone;

  /// No description provided for @actionEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get actionEdit;

  /// No description provided for @actionEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get actionEmail;

  /// No description provided for @actionFilter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get actionFilter;

  /// No description provided for @actionFilters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get actionFilters;

  /// No description provided for @actionKeepEditing.
  ///
  /// In en, this message translates to:
  /// **'Keep editing'**
  String get actionKeepEditing;

  /// No description provided for @actionLogout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get actionLogout;

  /// No description provided for @actionMarkDone.
  ///
  /// In en, this message translates to:
  /// **'Mark as done'**
  String get actionMarkDone;

  /// No description provided for @actionMessage.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get actionMessage;

  /// No description provided for @actionNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get actionNext;

  /// No description provided for @actionOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get actionOpen;

  /// No description provided for @actionRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get actionRemove;

  /// No description provided for @actionReschedule.
  ///
  /// In en, this message translates to:
  /// **'Reschedule'**
  String get actionReschedule;

  /// No description provided for @actionReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get actionReset;

  /// No description provided for @actionRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get actionRetry;

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @actionSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get actionSaveChanges;

  /// No description provided for @actionSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get actionSearch;

  /// No description provided for @actionSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get actionSeeAll;

  /// No description provided for @actionSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get actionSend;

  /// No description provided for @actionShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get actionShare;

  /// No description provided for @actionShowLess.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get actionShowLess;

  /// No description provided for @actionShowMore.
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get actionShowMore;

  /// No description provided for @actionSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get actionSkip;

  /// No description provided for @actionSms.
  ///
  /// In en, this message translates to:
  /// **'SMS'**
  String get actionSms;

  /// No description provided for @actionUpload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get actionUpload;

  /// No description provided for @actionView.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get actionView;

  /// No description provided for @actionWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get actionWhatsapp;

  /// No description provided for @adActivate.
  ///
  /// In en, this message translates to:
  /// **'Activate account'**
  String get adActivate;

  /// No description provided for @adActivated.
  ///
  /// In en, this message translates to:
  /// **'Account activated.'**
  String get adActivated;

  /// No description provided for @adAddUserBody.
  ///
  /// In en, this message translates to:
  /// **'Create a login for staff, vendors, partners or customers and share it with them.'**
  String get adAddUserBody;

  /// No description provided for @adAddUserButton.
  ///
  /// In en, this message translates to:
  /// **'Add user'**
  String get adAddUserButton;

  /// No description provided for @adAddUserShort.
  ///
  /// In en, this message translates to:
  /// **'Add user'**
  String get adAddUserShort;

  /// No description provided for @adAddUserTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a new user'**
  String get adAddUserTitle;

  /// No description provided for @adArea.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get adArea;

  /// No description provided for @adAudit.
  ///
  /// In en, this message translates to:
  /// **'Activity log'**
  String get adAudit;

  /// No description provided for @adAuditEnquiries.
  ///
  /// In en, this message translates to:
  /// **'Enquiries'**
  String get adAuditEnquiries;

  /// No description provided for @adAuditPeople.
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get adAuditPeople;

  /// No description provided for @adAuditSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get adAuditSettings;

  /// No description provided for @adAuditVendors.
  ///
  /// In en, this message translates to:
  /// **'Vendors'**
  String get adAuditVendors;

  /// No description provided for @adBizCollected.
  ///
  /// In en, this message translates to:
  /// **'Collected'**
  String get adBizCollected;

  /// No description provided for @adBizCommission.
  ///
  /// In en, this message translates to:
  /// **'Commission due'**
  String get adBizCommission;

  /// No description provided for @adBizOutstanding.
  ///
  /// In en, this message translates to:
  /// **'Still to collect'**
  String get adBizOutstanding;

  /// No description provided for @adBizWon.
  ///
  /// In en, this message translates to:
  /// **'Business won'**
  String get adBizWon;

  /// No description provided for @adBizWork.
  ///
  /// In en, this message translates to:
  /// **'Money and work'**
  String get adBizWork;

  /// No description provided for @adBrands.
  ///
  /// In en, this message translates to:
  /// **'Brands'**
  String get adBrands;

  /// No description provided for @adCategories.
  ///
  /// In en, this message translates to:
  /// **'Services and questions'**
  String get adCategories;

  /// No description provided for @adCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get adCity;

  /// No description provided for @adCompany.
  ///
  /// In en, this message translates to:
  /// **'Business name'**
  String get adCompany;

  /// No description provided for @adContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get adContact;

  /// No description provided for @adCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get adCopy;

  /// No description provided for @adCreateUser.
  ///
  /// In en, this message translates to:
  /// **'Create login'**
  String get adCreateUser;

  /// No description provided for @adCreated.
  ///
  /// In en, this message translates to:
  /// **'Added on'**
  String get adCreated;

  /// No description provided for @adCredsMessage.
  ///
  /// In en, this message translates to:
  /// **'Hello {name}, here is your O2O Boss login. User ID: {login}. Password: {password}. You will be asked to set a new password.'**
  String adCredsMessage(String name, String login, String password);

  /// No description provided for @adCredsNote.
  ///
  /// In en, this message translates to:
  /// **'This password is shown only once. You can reset it later if needed.'**
  String get adCredsNote;

  /// No description provided for @adCredsShare.
  ///
  /// In en, this message translates to:
  /// **'Copy message to share'**
  String get adCredsShare;

  /// No description provided for @adCredsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share these with {name}. They will set their own password when they first sign in.'**
  String adCredsSubtitle(String name);

  /// No description provided for @adCredsTitle.
  ///
  /// In en, this message translates to:
  /// **'Login ready'**
  String get adCredsTitle;

  /// No description provided for @adDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get adDone;

  /// No description provided for @adFranchise.
  ///
  /// In en, this message translates to:
  /// **'Franchise'**
  String get adFranchise;

  /// No description provided for @adFranchises.
  ///
  /// In en, this message translates to:
  /// **'Franchises'**
  String get adFranchises;

  /// No description provided for @adHomeSummary.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Everything is running smoothly.} =1{1 approval is waiting for you.} other{{count} approvals are waiting for you.}}'**
  String adHomeSummary(int count);

  /// No description provided for @adKpiOpen.
  ///
  /// In en, this message translates to:
  /// **'Open enquiries'**
  String get adKpiOpen;

  /// No description provided for @adKpiUsers.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get adKpiUsers;

  /// No description provided for @adKpiVendors.
  ///
  /// In en, this message translates to:
  /// **'Active vendors'**
  String get adKpiVendors;

  /// No description provided for @adKpiWonMonth.
  ///
  /// In en, this message translates to:
  /// **'Won this month'**
  String get adKpiWonMonth;

  /// No description provided for @adLocations.
  ///
  /// In en, this message translates to:
  /// **'Locations'**
  String get adLocations;

  /// No description provided for @adLogin.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get adLogin;

  /// No description provided for @adLoginId.
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get adLoginId;

  /// No description provided for @adMorePeople.
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get adMorePeople;

  /// No description provided for @adMoreRecords.
  ///
  /// In en, this message translates to:
  /// **'Records'**
  String get adMoreRecords;

  /// No description provided for @adMoreSetup.
  ///
  /// In en, this message translates to:
  /// **'Setup'**
  String get adMoreSetup;

  /// No description provided for @adOpenCustomer.
  ///
  /// In en, this message translates to:
  /// **'Open customer'**
  String get adOpenCustomer;

  /// No description provided for @adOpenVendor.
  ///
  /// In en, this message translates to:
  /// **'Open vendor profile'**
  String get adOpenVendor;

  /// No description provided for @adPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get adPassword;

  /// No description provided for @adPayoutsBody.
  ///
  /// In en, this message translates to:
  /// **'Approve earned commissions and mark payouts as paid.'**
  String get adPayoutsBody;

  /// No description provided for @adPayoutsButton.
  ///
  /// In en, this message translates to:
  /// **'Open commissions'**
  String get adPayoutsButton;

  /// No description provided for @adPayoutsTitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 commission to settle} other{{count} commissions to settle}}'**
  String adPayoutsTitle(int count);

  /// No description provided for @adPickRoleCity.
  ///
  /// In en, this message translates to:
  /// **'Choose a role and a city.'**
  String get adPickRoleCity;

  /// No description provided for @adProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get adProducts;

  /// No description provided for @adPwSet.
  ///
  /// In en, this message translates to:
  /// **'Set by the user'**
  String get adPwSet;

  /// No description provided for @adPwTemp.
  ///
  /// In en, this message translates to:
  /// **'Temporary, must be changed'**
  String get adPwTemp;

  /// No description provided for @adRepAreas.
  ///
  /// In en, this message translates to:
  /// **'Where our people are'**
  String get adRepAreas;

  /// No description provided for @adRepAreasHelp.
  ///
  /// In en, this message translates to:
  /// **'Customers and earners by area. Promote vendors where the numbers are highest.'**
  String get adRepAreasHelp;

  /// No description provided for @adRepClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get adRepClosed;

  /// No description provided for @adRepEmpty.
  ///
  /// In en, this message translates to:
  /// **'No data yet.'**
  String get adRepEmpty;

  /// No description provided for @adRepMonths.
  ///
  /// In en, this message translates to:
  /// **'Won in the last 6 months'**
  String get adRepMonths;

  /// No description provided for @adRepOccupations.
  ///
  /// In en, this message translates to:
  /// **'What our earners do'**
  String get adRepOccupations;

  /// No description provided for @adRepServices.
  ///
  /// In en, this message translates to:
  /// **'Enquiries by service'**
  String get adRepServices;

  /// No description provided for @adRepStages.
  ///
  /// In en, this message translates to:
  /// **'Open enquiries by stage'**
  String get adRepStages;

  /// No description provided for @adRepVendors.
  ///
  /// In en, this message translates to:
  /// **'Top vendors by jobs'**
  String get adRepVendors;

  /// No description provided for @adRepWaitlist.
  ///
  /// In en, this message translates to:
  /// **'Waiting for O2O Boss'**
  String get adRepWaitlist;

  /// No description provided for @adRepWaitlistHelp.
  ///
  /// In en, this message translates to:
  /// **'People from places we don\'t serve yet.'**
  String get adRepWaitlistHelp;

  /// No description provided for @adResetBody.
  ///
  /// In en, this message translates to:
  /// **'{name} will get a new temporary password and must change it when signing in.'**
  String adResetBody(String name);

  /// No description provided for @adResetPw.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get adResetPw;

  /// No description provided for @adResetTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset the password?'**
  String get adResetTitle;

  /// No description provided for @adRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get adRole;

  /// No description provided for @adRoleAdmin.
  ///
  /// In en, this message translates to:
  /// **'Sets the rules, manages people and approves payouts.'**
  String get adRoleAdmin;

  /// No description provided for @adRoleBackOffice.
  ///
  /// In en, this message translates to:
  /// **'Verifies enquiries, finds vendors and runs each job.'**
  String get adRoleBackOffice;

  /// No description provided for @adRoleCustomer.
  ///
  /// In en, this message translates to:
  /// **'Posts requirements and accepts quotations.'**
  String get adRoleCustomer;

  /// No description provided for @adRoleFranchise.
  ///
  /// In en, this message translates to:
  /// **'Looks after one territory and its network.'**
  String get adRoleFranchise;

  /// No description provided for @adRoleSales.
  ///
  /// In en, this message translates to:
  /// **'Refers customers and follows their progress.'**
  String get adRoleSales;

  /// No description provided for @adRoleVendor.
  ///
  /// In en, this message translates to:
  /// **'Accepts referrals, visits, quotes and does the work.'**
  String get adRoleVendor;

  /// No description provided for @adRoles.
  ///
  /// In en, this message translates to:
  /// **'Roles'**
  String get adRoles;

  /// No description provided for @adSalesType.
  ///
  /// In en, this message translates to:
  /// **'Partner type'**
  String get adSalesType;

  /// No description provided for @adSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get adSettings;

  /// No description provided for @adSuspend.
  ///
  /// In en, this message translates to:
  /// **'Suspend account'**
  String get adSuspend;

  /// No description provided for @adSuspendBody.
  ///
  /// In en, this message translates to:
  /// **'{name} will not be able to sign in until you activate the account again.'**
  String adSuspendBody(String name);

  /// No description provided for @adSuspendTitle.
  ///
  /// In en, this message translates to:
  /// **'Suspend this account?'**
  String get adSuspendTitle;

  /// No description provided for @adSuspended.
  ///
  /// In en, this message translates to:
  /// **'Account suspended.'**
  String get adSuspended;

  /// No description provided for @adSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get adSystem;

  /// No description provided for @adUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get adUser;

  /// No description provided for @adUsers.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get adUsers;

  /// No description provided for @adUsersCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 user} other{{count} users}}'**
  String adUsersCount(int count);

  /// No description provided for @adVendorApprovals.
  ///
  /// In en, this message translates to:
  /// **'Vendor approvals'**
  String get adVendorApprovals;

  /// No description provided for @adVendorsBody.
  ///
  /// In en, this message translates to:
  /// **'Check their documents so they can start getting referrals.'**
  String get adVendorsBody;

  /// No description provided for @adVendorsButton.
  ///
  /// In en, this message translates to:
  /// **'Review vendors'**
  String get adVendorsButton;

  /// No description provided for @adVendorsTitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 vendor to approve} other{{count} vendors to approve}}'**
  String adVendorsTitle(int count);

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'O2O Boss'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Verified business referrals'**
  String get appTagline;

  /// No description provided for @aptCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get aptCancelled;

  /// No description provided for @aptCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get aptCompleted;

  /// No description provided for @aptConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get aptConfirmed;

  /// No description provided for @aptNoShow.
  ///
  /// In en, this message translates to:
  /// **'No-show'**
  String get aptNoShow;

  /// No description provided for @aptPendingConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Waiting for confirmation'**
  String get aptPendingConfirmation;

  /// No description provided for @aptProposed.
  ///
  /// In en, this message translates to:
  /// **'Proposed'**
  String get aptProposed;

  /// No description provided for @aptRescheduled.
  ///
  /// In en, this message translates to:
  /// **'Rescheduled'**
  String get aptRescheduled;

  /// No description provided for @assignAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get assignAccepted;

  /// No description provided for @assignExpired.
  ///
  /// In en, this message translates to:
  /// **'No reply'**
  String get assignExpired;

  /// No description provided for @assignPending.
  ///
  /// In en, this message translates to:
  /// **'Waiting for reply'**
  String get assignPending;

  /// No description provided for @assignRejected.
  ///
  /// In en, this message translates to:
  /// **'Declined'**
  String get assignRejected;

  /// No description provided for @assignWithdrawn.
  ///
  /// In en, this message translates to:
  /// **'Withdrawn'**
  String get assignWithdrawn;

  /// No description provided for @auditAppointmentChanged.
  ///
  /// In en, this message translates to:
  /// **'Visit updated'**
  String get auditAppointmentChanged;

  /// No description provided for @auditAppointmentCreated.
  ///
  /// In en, this message translates to:
  /// **'Visit booked'**
  String get auditAppointmentCreated;

  /// No description provided for @auditAssigned.
  ///
  /// In en, this message translates to:
  /// **'Sent to {name}'**
  String auditAssigned(String name);

  /// No description provided for @auditBy.
  ///
  /// In en, this message translates to:
  /// **'by {name}'**
  String auditBy(String name);

  /// No description provided for @auditBySystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get auditBySystem;

  /// No description provided for @auditCallLogged.
  ///
  /// In en, this message translates to:
  /// **'Call logged'**
  String get auditCallLogged;

  /// No description provided for @auditCommissionApproved.
  ///
  /// In en, this message translates to:
  /// **'Commission updated'**
  String get auditCommissionApproved;

  /// No description provided for @auditCommissionCreated.
  ///
  /// In en, this message translates to:
  /// **'Commission calculated'**
  String get auditCommissionCreated;

  /// No description provided for @auditCommissionPaid.
  ///
  /// In en, this message translates to:
  /// **'Commission paid'**
  String get auditCommissionPaid;

  /// No description provided for @auditConfigChanged.
  ///
  /// In en, this message translates to:
  /// **'Setting changed'**
  String get auditConfigChanged;

  /// No description provided for @auditConsentGiven.
  ///
  /// In en, this message translates to:
  /// **'Consent recorded'**
  String get auditConsentGiven;

  /// No description provided for @auditCreated.
  ///
  /// In en, this message translates to:
  /// **'Enquiry created'**
  String get auditCreated;

  /// No description provided for @auditEdited.
  ///
  /// In en, this message translates to:
  /// **'Details updated'**
  String get auditEdited;

  /// No description provided for @auditEmailCopySent.
  ///
  /// In en, this message translates to:
  /// **'Copy emailed to O2O Boss'**
  String get auditEmailCopySent;

  /// No description provided for @auditFeedbackGiven.
  ///
  /// In en, this message translates to:
  /// **'Feedback received'**
  String get auditFeedbackGiven;

  /// No description provided for @auditMilestoneUpdated.
  ///
  /// In en, this message translates to:
  /// **'Project progress updated'**
  String get auditMilestoneUpdated;

  /// No description provided for @auditPasswordReset.
  ///
  /// In en, this message translates to:
  /// **'Password changed'**
  String get auditPasswordReset;

  /// No description provided for @auditPaymentRecorded.
  ///
  /// In en, this message translates to:
  /// **'Payment recorded'**
  String get auditPaymentRecorded;

  /// No description provided for @auditProjectCreated.
  ///
  /// In en, this message translates to:
  /// **'Project created'**
  String get auditProjectCreated;

  /// No description provided for @auditQualificationSaved.
  ///
  /// In en, this message translates to:
  /// **'Requirement details saved'**
  String get auditQualificationSaved;

  /// No description provided for @auditQuotationAccepted.
  ///
  /// In en, this message translates to:
  /// **'Quotation accepted'**
  String get auditQuotationAccepted;

  /// No description provided for @auditQuotationApproved.
  ///
  /// In en, this message translates to:
  /// **'Quotation approved'**
  String get auditQuotationApproved;

  /// No description provided for @auditQuotationRejected.
  ///
  /// In en, this message translates to:
  /// **'Quotation rejected'**
  String get auditQuotationRejected;

  /// No description provided for @auditQuotationRevised.
  ///
  /// In en, this message translates to:
  /// **'Revised quotation submitted'**
  String get auditQuotationRevised;

  /// No description provided for @auditQuotationSent.
  ///
  /// In en, this message translates to:
  /// **'Quotation sent to customer'**
  String get auditQuotationSent;

  /// No description provided for @auditQuotationSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Quotation submitted'**
  String get auditQuotationSubmitted;

  /// No description provided for @auditReassigned.
  ///
  /// In en, this message translates to:
  /// **'Reassigned'**
  String get auditReassigned;

  /// No description provided for @auditRevisionRequested.
  ///
  /// In en, this message translates to:
  /// **'Changes requested'**
  String get auditRevisionRequested;

  /// No description provided for @auditStatusChanged.
  ///
  /// In en, this message translates to:
  /// **'Moved to {status}'**
  String auditStatusChanged(String status);

  /// No description provided for @auditUserCreated.
  ///
  /// In en, this message translates to:
  /// **'User created'**
  String get auditUserCreated;

  /// No description provided for @auditUserUpdated.
  ///
  /// In en, this message translates to:
  /// **'User updated'**
  String get auditUserUpdated;

  /// No description provided for @auditVendorAccepted.
  ///
  /// In en, this message translates to:
  /// **'Vendor accepted'**
  String get auditVendorAccepted;

  /// No description provided for @auditVendorApproved.
  ///
  /// In en, this message translates to:
  /// **'Vendor approved'**
  String get auditVendorApproved;

  /// No description provided for @auditVendorRejected.
  ///
  /// In en, this message translates to:
  /// **'Vendor declined'**
  String get auditVendorRejected;

  /// No description provided for @auditVendorSuspended.
  ///
  /// In en, this message translates to:
  /// **'Vendor status changed'**
  String get auditVendorSuspended;

  /// No description provided for @authHidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get authHidePassword;

  /// No description provided for @authShowPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get authShowPassword;

  /// No description provided for @boAllClearBody.
  ///
  /// In en, this message translates to:
  /// **'No tasks are waiting. New enquiries will appear here.'**
  String get boAllClearBody;

  /// No description provided for @boAllClearTitle.
  ///
  /// In en, this message translates to:
  /// **'All caught up'**
  String get boAllClearTitle;

  /// No description provided for @boHomeSummary.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Nothing is waiting for you right now.} =1{1 thing needs you today.} other{{count} things need you today.}}'**
  String boHomeSummary(int count);

  /// No description provided for @boKpiActive.
  ///
  /// In en, this message translates to:
  /// **'Active enquiries'**
  String get boKpiActive;

  /// No description provided for @boKpiOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get boKpiOverdue;

  /// No description provided for @boKpiTasks.
  ///
  /// In en, this message translates to:
  /// **'Open tasks'**
  String get boKpiTasks;

  /// No description provided for @boKpiToday.
  ///
  /// In en, this message translates to:
  /// **'Follow-ups today'**
  String get boKpiToday;

  /// No description provided for @boNewEnquiry.
  ///
  /// In en, this message translates to:
  /// **'Add an enquiry'**
  String get boNewEnquiry;

  /// No description provided for @boNewEnquiryShort.
  ///
  /// In en, this message translates to:
  /// **'New enquiry'**
  String get boNewEnquiryShort;

  /// No description provided for @boNextUp.
  ///
  /// In en, this message translates to:
  /// **'Next up'**
  String get boNextUp;

  /// No description provided for @boQueues.
  ///
  /// In en, this message translates to:
  /// **'Work queues'**
  String get boQueues;

  /// No description provided for @boQueuesEmpty.
  ///
  /// In en, this message translates to:
  /// **'Every queue is empty.'**
  String get boQueuesEmpty;

  /// No description provided for @callBy.
  ///
  /// In en, this message translates to:
  /// **'By {name}'**
  String callBy(String name);

  /// No description provided for @callConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting through O2O Boss…'**
  String get callConnecting;

  /// No description provided for @callEnd.
  ///
  /// In en, this message translates to:
  /// **'End call'**
  String get callEnd;

  /// No description provided for @callLength.
  ///
  /// In en, this message translates to:
  /// **'How long'**
  String get callLength;

  /// No description provided for @callLogHeading.
  ///
  /// In en, this message translates to:
  /// **'Call log'**
  String get callLogHeading;

  /// No description provided for @callLogTitle.
  ///
  /// In en, this message translates to:
  /// **'Log a call'**
  String get callLogTitle;

  /// No description provided for @callLogged.
  ///
  /// In en, this message translates to:
  /// **'Call saved.'**
  String get callLogged;

  /// No description provided for @callMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 min} other{{count} min}}'**
  String callMinutes(int count);

  /// No description provided for @callNone.
  ///
  /// In en, this message translates to:
  /// **'No calls yet'**
  String get callNone;

  /// No description provided for @callRecorded.
  ///
  /// In en, this message translates to:
  /// **'This call is recorded'**
  String get callRecorded;

  /// No description provided for @callRecordedShort.
  ///
  /// In en, this message translates to:
  /// **'Recorded'**
  String get callRecordedShort;

  /// No description provided for @callWith.
  ///
  /// In en, this message translates to:
  /// **'Call with'**
  String get callWith;

  /// No description provided for @changePwCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get changePwCurrent;

  /// No description provided for @changePwDone.
  ///
  /// In en, this message translates to:
  /// **'Password changed.'**
  String get changePwDone;

  /// No description provided for @changePwNew.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get changePwNew;

  /// No description provided for @changePwSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your password was created by admin. Choose a new one to continue.'**
  String get changePwSubtitle;

  /// No description provided for @changePwTitle.
  ///
  /// In en, this message translates to:
  /// **'Set your own password'**
  String get changePwTitle;

  /// No description provided for @changePwWrong.
  ///
  /// In en, this message translates to:
  /// **'Current password is not correct.'**
  String get changePwWrong;

  /// No description provided for @channelEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get channelEmail;

  /// No description provided for @channelEmailBody.
  ///
  /// In en, this message translates to:
  /// **'Summaries and quotation copies.'**
  String get channelEmailBody;

  /// No description provided for @channelInAppNote.
  ///
  /// In en, this message translates to:
  /// **'Everything also appears under Notifications in the app, whatever you choose here.'**
  String get channelInAppNote;

  /// No description provided for @channelOffByAdmin.
  ///
  /// In en, this message translates to:
  /// **'Not available yet. O2O Boss has turned this off.'**
  String get channelOffByAdmin;

  /// No description provided for @channelPush.
  ///
  /// In en, this message translates to:
  /// **'App notifications'**
  String get channelPush;

  /// No description provided for @channelPushBody.
  ///
  /// In en, this message translates to:
  /// **'Alerts on this phone.'**
  String get channelPushBody;

  /// No description provided for @channelSms.
  ///
  /// In en, this message translates to:
  /// **'SMS'**
  String get channelSms;

  /// No description provided for @channelSmsBody.
  ///
  /// In en, this message translates to:
  /// **'Important updates by text message.'**
  String get channelSmsBody;

  /// No description provided for @channelWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get channelWhatsapp;

  /// No description provided for @channelWhatsappBody.
  ///
  /// In en, this message translates to:
  /// **'Updates on WhatsApp.'**
  String get channelWhatsappBody;

  /// No description provided for @chatAttach.
  ///
  /// In en, this message translates to:
  /// **'Attach'**
  String get chatAttach;

  /// No description provided for @chatAttached.
  ///
  /// In en, this message translates to:
  /// **'File sent.'**
  String get chatAttached;

  /// No description provided for @chatClosed.
  ///
  /// In en, this message translates to:
  /// **'This enquiry is closed. The chat is read-only.'**
  String get chatClosed;

  /// No description provided for @chatDocument.
  ///
  /// In en, this message translates to:
  /// **'Document'**
  String get chatDocument;

  /// No description provided for @chatEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Say hello or share an update.'**
  String get chatEmptyBody;

  /// No description provided for @chatEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get chatEmptyTitle;

  /// No description provided for @chatHint.
  ///
  /// In en, this message translates to:
  /// **'Write a message'**
  String get chatHint;

  /// No description provided for @chatNoneBody.
  ///
  /// In en, this message translates to:
  /// **'Chats about your referrals will appear here.'**
  String get chatNoneBody;

  /// No description provided for @chatNoneTitle.
  ///
  /// In en, this message translates to:
  /// **'No conversations yet'**
  String get chatNoneTitle;

  /// No description provided for @chatO2OTeam.
  ///
  /// In en, this message translates to:
  /// **'{name}, O2O Boss'**
  String chatO2OTeam(String name);

  /// No description provided for @chatOpenEnquiry.
  ///
  /// In en, this message translates to:
  /// **'Open enquiry'**
  String get chatOpenEnquiry;

  /// No description provided for @chatPhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get chatPhoto;

  /// No description provided for @chatReadOnly.
  ///
  /// In en, this message translates to:
  /// **'Franchise heads can read chats but not reply.'**
  String get chatReadOnly;

  /// No description provided for @chatThreadsHelp.
  ///
  /// In en, this message translates to:
  /// **'Customers and vendors each talk only to O2O Boss. Their numbers stay private.'**
  String get chatThreadsHelp;

  /// No description provided for @chatWithO2O.
  ///
  /// In en, this message translates to:
  /// **'O2O Boss team'**
  String get chatWithO2O;

  /// No description provided for @cityNotListed.
  ///
  /// In en, this message translates to:
  /// **'My city is not listed'**
  String get cityNotListed;

  /// No description provided for @comApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get comApproved;

  /// No description provided for @comCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get comCancelled;

  /// No description provided for @comOnHold.
  ///
  /// In en, this message translates to:
  /// **'On hold'**
  String get comOnHold;

  /// No description provided for @comPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get comPaid;

  /// No description provided for @comPayable.
  ///
  /// In en, this message translates to:
  /// **'Ready to pay'**
  String get comPayable;

  /// No description provided for @comPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get comPending;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'This screen is being built.'**
  String get comingSoon;

  /// No description provided for @commissionAdminOnly.
  ///
  /// In en, this message translates to:
  /// **'Only admin can approve and pay commissions.'**
  String get commissionAdminOnly;

  /// No description provided for @commissionApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get commissionApprove;

  /// No description provided for @commissionBase.
  ///
  /// In en, this message translates to:
  /// **'Order value'**
  String get commissionBase;

  /// No description provided for @commissionHold.
  ///
  /// In en, this message translates to:
  /// **'Put on hold'**
  String get commissionHold;

  /// No description provided for @commissionMakePayable.
  ///
  /// In en, this message translates to:
  /// **'Ready to pay'**
  String get commissionMakePayable;

  /// No description provided for @commissionMarkPaid.
  ///
  /// In en, this message translates to:
  /// **'Mark as paid'**
  String get commissionMarkPaid;

  /// No description provided for @commissionNone.
  ///
  /// In en, this message translates to:
  /// **'No commission yet'**
  String get commissionNone;

  /// No description provided for @commissionRate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get commissionRate;

  /// No description provided for @commissionReference.
  ///
  /// In en, this message translates to:
  /// **'Payment reference'**
  String get commissionReference;

  /// No description provided for @commissionReferenceHint.
  ///
  /// In en, this message translates to:
  /// **'For example: UPI reference number'**
  String get commissionReferenceHint;

  /// No description provided for @commissionRelease.
  ///
  /// In en, this message translates to:
  /// **'Release hold'**
  String get commissionRelease;

  /// No description provided for @commissionRuleNote.
  ///
  /// In en, this message translates to:
  /// **'Commissions are created when {trigger}. Admin approves and pays them.'**
  String commissionRuleNote(String trigger);

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @contactCallAnytime.
  ///
  /// In en, this message translates to:
  /// **'Call any time'**
  String get contactCallAnytime;

  /// No description provided for @contactCallAtTime.
  ///
  /// In en, this message translates to:
  /// **'Call at a set time'**
  String get contactCallAtTime;

  /// No description provided for @contactIntroduceFirst.
  ///
  /// In en, this message translates to:
  /// **'I will introduce first'**
  String get contactIntroduceFirst;

  /// No description provided for @countEnquiries.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 enquiry} other{{count} enquiries}}'**
  String countEnquiries(int count);

  /// No description provided for @countItems.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No items} =1{1 item} other{{count} items}}'**
  String countItems(int count);

  /// No description provided for @credAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get credAvailable;

  /// No description provided for @credConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get credConfirmPassword;

  /// No description provided for @credPasswordHelp.
  ///
  /// In en, this message translates to:
  /// **'At least 6 characters.'**
  String get credPasswordHelp;

  /// No description provided for @credSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You\'ll use these to sign in.'**
  String get credSubtitle;

  /// No description provided for @credTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your login'**
  String get credTitle;

  /// No description provided for @credUserIdHelp.
  ///
  /// In en, this message translates to:
  /// **'4 to 20 letters or numbers. Dots and underscores are allowed.'**
  String get credUserIdHelp;

  /// No description provided for @cuCall.
  ///
  /// In en, this message translates to:
  /// **'Call {name}'**
  String cuCall(String name);

  /// No description provided for @cuChatHelp.
  ///
  /// In en, this message translates to:
  /// **'Questions about this requirement? We reply quickly.'**
  String get cuChatHelp;

  /// No description provided for @cuChatWithO2O.
  ///
  /// In en, this message translates to:
  /// **'Chat with O2O Boss'**
  String get cuChatWithO2O;

  /// No description provided for @cuClosedBody.
  ///
  /// In en, this message translates to:
  /// **'{reason}. You can post a new requirement any time.'**
  String cuClosedBody(String reason);

  /// No description provided for @cuEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Post what you need and follow every step here.'**
  String get cuEmptyBody;

  /// No description provided for @cuEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No requirements yet'**
  String get cuEmptyTitle;

  /// No description provided for @cuFilterActive.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get cuFilterActive;

  /// No description provided for @cuFilterClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get cuFilterClosed;

  /// No description provided for @cuFilterDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get cuFilterDone;

  /// No description provided for @cuHomeSummary.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Tell us what you need. We find a trusted vendor.} =1{1 requirement is in progress.} other{{count} requirements are in progress.}}'**
  String cuHomeSummary(int count);

  /// No description provided for @cuMessages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get cuMessages;

  /// No description provided for @cuNewRequirement.
  ///
  /// In en, this message translates to:
  /// **'New requirement'**
  String get cuNewRequirement;

  /// No description provided for @cuNoVendorYet.
  ///
  /// In en, this message translates to:
  /// **'We are finding the right vendor for you.'**
  String get cuNoVendorYet;

  /// No description provided for @cuOrdersCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No orders yet} =1{1 order} other{{count} orders}}'**
  String cuOrdersCount(int count);

  /// No description provided for @cuPostBody.
  ///
  /// In en, this message translates to:
  /// **'Tell us what you need. We check it and connect a trusted vendor near you.'**
  String get cuPostBody;

  /// No description provided for @cuPostButton.
  ///
  /// In en, this message translates to:
  /// **'Post a requirement'**
  String get cuPostButton;

  /// No description provided for @cuPostTitle.
  ///
  /// In en, this message translates to:
  /// **'Need something done?'**
  String get cuPostTitle;

  /// No description provided for @cuQuoteReadyBody.
  ///
  /// In en, this message translates to:
  /// **'{vendor} sent a price for {job}. Take a look and decide.'**
  String cuQuoteReadyBody(String vendor, String job);

  /// No description provided for @cuQuoteReadyButton.
  ///
  /// In en, this message translates to:
  /// **'See quotation'**
  String get cuQuoteReadyButton;

  /// No description provided for @cuQuoteReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your quotation is ready'**
  String get cuQuoteReadyTitle;

  /// No description provided for @cuQuotesToDecide.
  ///
  /// In en, this message translates to:
  /// **'To decide'**
  String get cuQuotesToDecide;

  /// No description provided for @cuRating.
  ///
  /// In en, this message translates to:
  /// **'Rated {rating} out of 5'**
  String cuRating(String rating);

  /// No description provided for @cuVendorHidden.
  ///
  /// In en, this message translates to:
  /// **'You reach the vendor through O2O Boss. Use the chat below.'**
  String get cuVendorHidden;

  /// No description provided for @cuVendorTitle.
  ///
  /// In en, this message translates to:
  /// **'Your vendor'**
  String get cuVendorTitle;

  /// No description provided for @cuVisitCheckBody.
  ///
  /// In en, this message translates to:
  /// **'{vendor} marked the visit for {job} as done. Please confirm.'**
  String cuVisitCheckBody(String vendor, String job);

  /// No description provided for @cuVisitCheckButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm visit'**
  String get cuVisitCheckButton;

  /// No description provided for @cuVisitCheckTitle.
  ///
  /// In en, this message translates to:
  /// **'Did the visit happen?'**
  String get cuVisitCheckTitle;

  /// No description provided for @cuWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp {name}'**
  String cuWhatsApp(String name);

  /// No description provided for @cuYourRequirements.
  ///
  /// In en, this message translates to:
  /// **'Your requirements'**
  String get cuYourRequirements;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day ago} other{{count} days ago}}'**
  String daysAgo(int count);

  /// No description provided for @deadlinePassed.
  ///
  /// In en, this message translates to:
  /// **'Deadline passed'**
  String get deadlinePassed;

  /// No description provided for @demoActionNote.
  ///
  /// In en, this message translates to:
  /// **'In the demo this action is only simulated.'**
  String get demoActionNote;

  /// No description provided for @detailCreatedOn.
  ///
  /// In en, this message translates to:
  /// **'{id}, created {date}'**
  String detailCreatedOn(String id, String date);

  /// No description provided for @detailProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get detailProgress;

  /// No description provided for @detailTitleCustomer.
  ///
  /// In en, this message translates to:
  /// **'Your requirement'**
  String get detailTitleCustomer;

  /// No description provided for @detailTitleSales.
  ///
  /// In en, this message translates to:
  /// **'Referral'**
  String get detailTitleSales;

  /// No description provided for @detailYourEarning.
  ///
  /// In en, this message translates to:
  /// **'Your earning'**
  String get detailYourEarning;

  /// No description provided for @discardBody.
  ///
  /// In en, this message translates to:
  /// **'Your changes haven\'t been saved.'**
  String get discardBody;

  /// No description provided for @discardTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard changes?'**
  String get discardTitle;

  /// No description provided for @docBankProof.
  ///
  /// In en, this message translates to:
  /// **'Bank proof'**
  String get docBankProof;

  /// No description provided for @docGst.
  ///
  /// In en, this message translates to:
  /// **'GST certificate'**
  String get docGst;

  /// No description provided for @docOther.
  ///
  /// In en, this message translates to:
  /// **'Other document'**
  String get docOther;

  /// No description provided for @docPan.
  ///
  /// In en, this message translates to:
  /// **'PAN card'**
  String get docPan;

  /// No description provided for @docPhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get docPhoto;

  /// No description provided for @docTradeLicense.
  ///
  /// In en, this message translates to:
  /// **'Trade licence'**
  String get docTradeLicense;

  /// No description provided for @dueAt.
  ///
  /// In en, this message translates to:
  /// **'Due {time}'**
  String dueAt(String time);

  /// No description provided for @earningsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'When a referral is won and paid for, your commission appears here.'**
  String get earningsEmptyBody;

  /// No description provided for @earningsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No commissions yet'**
  String get earningsEmptyTitle;

  /// No description provided for @earningsFilterPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get earningsFilterPaid;

  /// No description provided for @earningsFilterPending.
  ///
  /// In en, this message translates to:
  /// **'On the way'**
  String get earningsFilterPending;

  /// No description provided for @earningsLineDetail.
  ///
  /// In en, this message translates to:
  /// **'{id}, {percent} of {value}'**
  String earningsLineDetail(String id, String percent, String value);

  /// No description provided for @earningsListTitle.
  ///
  /// In en, this message translates to:
  /// **'Commissions'**
  String get earningsListTitle;

  /// No description provided for @earningsOnTheWay.
  ///
  /// In en, this message translates to:
  /// **'On the way'**
  String get earningsOnTheWay;

  /// No description provided for @earningsPayoutBank.
  ///
  /// In en, this message translates to:
  /// **'Bank account ending {last4}'**
  String earningsPayoutBank(String last4);

  /// No description provided for @earningsPayoutMissing.
  ///
  /// In en, this message translates to:
  /// **'Add your UPI ID or bank account to get paid.'**
  String get earningsPayoutMissing;

  /// No description provided for @earningsPayoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Payout details'**
  String get earningsPayoutTitle;

  /// No description provided for @earningsPayoutUpi.
  ///
  /// In en, this message translates to:
  /// **'UPI: {upi}'**
  String earningsPayoutUpi(String upi);

  /// No description provided for @earningsRule.
  ///
  /// In en, this message translates to:
  /// **'You earn {percent} of the final order value. It becomes due when {trigger}.'**
  String earningsRule(String percent, String trigger);

  /// No description provided for @earningsTitle.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get earningsTitle;

  /// No description provided for @earningsTotalPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid to you so far'**
  String get earningsTotalPaid;

  /// No description provided for @emptyNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get emptyNoResults;

  /// No description provided for @emptyNoResultsBody.
  ///
  /// In en, this message translates to:
  /// **'Try a different word or clear the filters.'**
  String get emptyNoResultsBody;

  /// No description provided for @emptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get emptyTitle;

  /// No description provided for @exHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'I already have an account'**
  String get exHaveAccount;

  /// No description provided for @exOpen.
  ///
  /// In en, this message translates to:
  /// **'What can I do with O2O Boss?'**
  String get exOpen;

  /// No description provided for @exSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Earn, grow or start a business, or buy what you need. All in one place.'**
  String get exSubtitle;

  /// No description provided for @exTitle.
  ///
  /// In en, this message translates to:
  /// **'What would you like to do?'**
  String get exTitle;

  /// No description provided for @exWhoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Anyone can earn with O2O Boss. This helps us train and support you.'**
  String get exWhoSubtitle;

  /// No description provided for @exWhoTitle.
  ///
  /// In en, this message translates to:
  /// **'Which of these describes you?'**
  String get exWhoTitle;

  /// No description provided for @faqCustomer1A.
  ///
  /// In en, this message translates to:
  /// **'Yes. You only pay the vendor for the work you accept in the quotation.'**
  String get faqCustomer1A;

  /// No description provided for @faqCustomer1Q.
  ///
  /// In en, this message translates to:
  /// **'Is this service free for me?'**
  String get faqCustomer1Q;

  /// No description provided for @faqCustomer2A.
  ///
  /// In en, this message translates to:
  /// **'Open Quotations, check the items and total, then tap Accept and type your name to sign.'**
  String get faqCustomer2A;

  /// No description provided for @faqCustomer2Q.
  ///
  /// In en, this message translates to:
  /// **'How do I accept a quotation?'**
  String get faqCustomer2Q;

  /// No description provided for @faqCustomer3A.
  ///
  /// In en, this message translates to:
  /// **'Yes. Tap Ask for changes and say what you\'d like. The vendor will send a new version.'**
  String get faqCustomer3A;

  /// No description provided for @faqCustomer3Q.
  ///
  /// In en, this message translates to:
  /// **'Can I ask for changes to a quotation?'**
  String get faqCustomer3Q;

  /// No description provided for @faqLanguageA.
  ///
  /// In en, this message translates to:
  /// **'Go to Profile, then Language, and choose from English and 22 Indian languages.'**
  String get faqLanguageA;

  /// No description provided for @faqLanguageQ.
  ///
  /// In en, this message translates to:
  /// **'How do I change the language?'**
  String get faqLanguageQ;

  /// No description provided for @faqLogin1A.
  ///
  /// In en, this message translates to:
  /// **'On the sign-in screen, tap Forgot password and verify your mobile number to set a new one.'**
  String get faqLogin1A;

  /// No description provided for @faqLogin1Q.
  ///
  /// In en, this message translates to:
  /// **'I forgot my password'**
  String get faqLogin1Q;

  /// No description provided for @faqOps1A.
  ///
  /// In en, this message translates to:
  /// **'Home shows what needs you now. Work through it from the top, then check Follow-ups and Tasks.'**
  String get faqOps1A;

  /// No description provided for @faqOps1Q.
  ///
  /// In en, this message translates to:
  /// **'Where do I start each day?'**
  String get faqOps1Q;

  /// No description provided for @faqOps2A.
  ///
  /// In en, this message translates to:
  /// **'Only back office, franchise heads and admin. Vendors, customers and referral partners never see them.'**
  String get faqOps2A;

  /// No description provided for @faqOps2Q.
  ///
  /// In en, this message translates to:
  /// **'Who can see internal notes?'**
  String get faqOps2Q;

  /// No description provided for @faqSales1A.
  ///
  /// In en, this message translates to:
  /// **'Your commission becomes due at the stage set by O2O Boss, usually when the customer pays in full. You can follow it under Earnings.'**
  String get faqSales1A;

  /// No description provided for @faqSales1Q.
  ///
  /// In en, this message translates to:
  /// **'When do I get my commission?'**
  String get faqSales1Q;

  /// No description provided for @faqSales2A.
  ///
  /// In en, this message translates to:
  /// **'Our team calls every customer. If the number is wrong, the customer is not interested or it is a duplicate, the referral is closed. The reason is shown on the referral.'**
  String get faqSales2A;

  /// No description provided for @faqSales2Q.
  ///
  /// In en, this message translates to:
  /// **'Why was my referral not verified?'**
  String get faqSales2Q;

  /// No description provided for @faqSales3A.
  ///
  /// In en, this message translates to:
  /// **'Yes, for a different need. For the same need, the first referral is protected and a second one may not count.'**
  String get faqSales3A;

  /// No description provided for @faqSales3Q.
  ///
  /// In en, this message translates to:
  /// **'Can I refer the same customer again?'**
  String get faqSales3Q;

  /// No description provided for @faqVendor1A.
  ///
  /// In en, this message translates to:
  /// **'Accept or decline before the time shown on the referral. Quick replies improve your response rate and bring more referrals.'**
  String get faqVendor1A;

  /// No description provided for @faqVendor1Q.
  ///
  /// In en, this message translates to:
  /// **'How fast should I respond to a referral?'**
  String get faqVendor1Q;

  /// No description provided for @faqVendor2A.
  ///
  /// In en, this message translates to:
  /// **'O2O Boss connects you with the customer. Use the chat with back office to fix visits and share updates.'**
  String get faqVendor2A;

  /// No description provided for @faqVendor2Q.
  ///
  /// In en, this message translates to:
  /// **'Why can\'t I see the customer\'s phone number?'**
  String get faqVendor2Q;

  /// No description provided for @faqVendor3A.
  ///
  /// In en, this message translates to:
  /// **'Back office checks it before it goes to the customer. O2O Boss also keeps a copy of every quotation.'**
  String get faqVendor3A;

  /// No description provided for @faqVendor3Q.
  ///
  /// In en, this message translates to:
  /// **'Who checks my quotation?'**
  String get faqVendor3Q;

  /// No description provided for @feedbackAsk.
  ///
  /// In en, this message translates to:
  /// **'How was the work by {vendor}?'**
  String feedbackAsk(String vendor);

  /// No description provided for @feedbackReview.
  ///
  /// In en, this message translates to:
  /// **'Anything to add?'**
  String get feedbackReview;

  /// No description provided for @feedbackSend.
  ///
  /// In en, this message translates to:
  /// **'Send feedback'**
  String get feedbackSend;

  /// No description provided for @feedbackThanks.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your feedback.'**
  String get feedbackThanks;

  /// No description provided for @feedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Your feedback'**
  String get feedbackTitle;

  /// No description provided for @filterOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get filterOpen;

  /// No description provided for @forgotIdLabel.
  ///
  /// In en, this message translates to:
  /// **'User ID or mobile number'**
  String get forgotIdLabel;

  /// No description provided for @forgotNotFound.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find an account with that user ID or number.'**
  String get forgotNotFound;

  /// No description provided for @forgotSendCode.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get forgotSendCode;

  /// No description provided for @forgotSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your user ID or registered mobile number.'**
  String get forgotSubtitle;

  /// No description provided for @forgotTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get forgotTitle;

  /// No description provided for @frCities.
  ///
  /// In en, this message translates to:
  /// **'Cities'**
  String get frCities;

  /// No description provided for @frHeroBody.
  ///
  /// In en, this message translates to:
  /// **'{value} of business won this month in {cities}.'**
  String frHeroBody(String value, String cities);

  /// No description provided for @frHeroButton.
  ///
  /// In en, this message translates to:
  /// **'See business'**
  String get frHeroButton;

  /// No description provided for @frHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'{name}'**
  String frHeroTitle(String name);

  /// No description provided for @frHomeSummary.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No open enquiries in your territory.} =1{1 enquiry is moving in your territory.} other{{count} enquiries are moving in your territory.}}'**
  String frHomeSummary(int count);

  /// No description provided for @frKpiActive.
  ///
  /// In en, this message translates to:
  /// **'Open enquiries'**
  String get frKpiActive;

  /// No description provided for @frKpiPartners.
  ///
  /// In en, this message translates to:
  /// **'Sales partners'**
  String get frKpiPartners;

  /// No description provided for @frKpiVendors.
  ///
  /// In en, this message translates to:
  /// **'Vendors'**
  String get frKpiVendors;

  /// No description provided for @frKpiWon.
  ///
  /// In en, this message translates to:
  /// **'Won'**
  String get frKpiWon;

  /// No description provided for @frLatest.
  ///
  /// In en, this message translates to:
  /// **'Latest enquiries'**
  String get frLatest;

  /// No description provided for @frNoPartners.
  ///
  /// In en, this message translates to:
  /// **'No sales partners in your territory yet.'**
  String get frNoPartners;

  /// No description provided for @frNoTerritory.
  ///
  /// In en, this message translates to:
  /// **'No territory is linked to your account yet. Please contact O2O Boss.'**
  String get frNoTerritory;

  /// No description provided for @frNoVendors.
  ///
  /// In en, this message translates to:
  /// **'No vendors in your territory yet.'**
  String get frNoVendors;

  /// No description provided for @frPartners.
  ///
  /// In en, this message translates to:
  /// **'Sales partners'**
  String get frPartners;

  /// No description provided for @frPendingVendors.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 vendor is waiting for approval in your territory.} other{{count} vendors are waiting for approval in your territory.}}'**
  String frPendingVendors(int count);

  /// No description provided for @frReferralsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No referrals} =1{1 referral} other{{count} referrals}}'**
  String frReferralsCount(int count);

  /// No description provided for @frSeeVendors.
  ///
  /// In en, this message translates to:
  /// **'See vendors'**
  String get frSeeVendors;

  /// No description provided for @frShare.
  ///
  /// In en, this message translates to:
  /// **'Your share'**
  String get frShare;

  /// No description provided for @frTerritory.
  ///
  /// In en, this message translates to:
  /// **'Your territory'**
  String get frTerritory;

  /// No description provided for @frTerritoryName.
  ///
  /// In en, this message translates to:
  /// **'Territory'**
  String get frTerritoryName;

  /// No description provided for @frVendors.
  ///
  /// In en, this message translates to:
  /// **'Vendors'**
  String get frVendors;

  /// No description provided for @frVendorsWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get frVendorsWaiting;

  /// No description provided for @fsCityLabel.
  ///
  /// In en, this message translates to:
  /// **'City or town for the outlet'**
  String get fsCityLabel;

  /// No description provided for @fsDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your details'**
  String get fsDetailsTitle;

  /// No description provided for @fsDoneBody.
  ///
  /// In en, this message translates to:
  /// **'Our franchise team will call you within 2 to 3 working days to plan your outlet.'**
  String get fsDoneBody;

  /// No description provided for @fsExp3to10.
  ///
  /// In en, this message translates to:
  /// **'3 to 10 years'**
  String get fsExp3to10;

  /// No description provided for @fsExpNone.
  ///
  /// In en, this message translates to:
  /// **'None yet'**
  String get fsExpNone;

  /// No description provided for @fsExpOver10.
  ///
  /// In en, this message translates to:
  /// **'Over 10 years'**
  String get fsExpOver10;

  /// No description provided for @fsExpUnder3.
  ///
  /// In en, this message translates to:
  /// **'Under 3 years'**
  String get fsExpUnder3;

  /// No description provided for @fsExperienceLabel.
  ///
  /// In en, this message translates to:
  /// **'Business experience'**
  String get fsExperienceLabel;

  /// No description provided for @fsHeroBody.
  ///
  /// In en, this message translates to:
  /// **'Like the big chains: the same brand, look and products in every outlet. We set up everything; you run it and earn.'**
  String get fsHeroBody;

  /// No description provided for @fsHeroPrice.
  ///
  /// In en, this message translates to:
  /// **'Packages from {amount}'**
  String fsHeroPrice(String amount);

  /// No description provided for @fsHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Start your own business, fully set up by O2O Boss'**
  String get fsHeroTitle;

  /// No description provided for @fsIncBrand.
  ///
  /// In en, this message translates to:
  /// **'Brand and signboards'**
  String get fsIncBrand;

  /// No description provided for @fsIncBrandBody.
  ///
  /// In en, this message translates to:
  /// **'The O2O Boss name, logo and signage, done the same way everywhere.'**
  String get fsIncBrandBody;

  /// No description provided for @fsIncInterior.
  ///
  /// In en, this message translates to:
  /// **'Theme and interior'**
  String get fsIncInterior;

  /// No description provided for @fsIncInteriorBody.
  ///
  /// In en, this message translates to:
  /// **'Shop design, furniture, lighting and fitting, ready to open.'**
  String get fsIncInteriorBody;

  /// No description provided for @fsIncLaunch.
  ///
  /// In en, this message translates to:
  /// **'Launch and support'**
  String get fsIncLaunch;

  /// No description provided for @fsIncLaunchBody.
  ///
  /// In en, this message translates to:
  /// **'Opening-day promotion, and a team to call when you need help.'**
  String get fsIncLaunchBody;

  /// No description provided for @fsIncProducts.
  ///
  /// In en, this message translates to:
  /// **'Products and first stock'**
  String get fsIncProducts;

  /// No description provided for @fsIncProductsBody.
  ///
  /// In en, this message translates to:
  /// **'A tested product range and your opening stock from our suppliers.'**
  String get fsIncProductsBody;

  /// No description provided for @fsIncTraining.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get fsIncTraining;

  /// No description provided for @fsIncTrainingBody.
  ///
  /// In en, this message translates to:
  /// **'How to run the outlet, serve customers and use the O2O Boss app.'**
  String get fsIncTrainingBody;

  /// No description provided for @fsIncludedTitle.
  ///
  /// In en, this message translates to:
  /// **'What we set up for you'**
  String get fsIncludedTitle;

  /// No description provided for @fsPackageLabel.
  ///
  /// In en, this message translates to:
  /// **'Package'**
  String get fsPackageLabel;

  /// No description provided for @fsPackagesHelp.
  ///
  /// In en, this message translates to:
  /// **'Costs are a starting guide. The final cost depends on the business and your city.'**
  String get fsPackagesHelp;

  /// No description provided for @fsPackagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a size'**
  String get fsPackagesTitle;

  /// No description provided for @fsPkgCustom.
  ///
  /// In en, this message translates to:
  /// **'Bigger or more outlets'**
  String get fsPkgCustom;

  /// No description provided for @fsPkgCustomBody.
  ///
  /// In en, this message translates to:
  /// **'For several outlets or a larger space. We plan it with you.'**
  String get fsPkgCustomBody;

  /// No description provided for @fsPkgCustomPrice.
  ///
  /// In en, this message translates to:
  /// **'Above {amount}'**
  String fsPkgCustomPrice(String amount);

  /// No description provided for @fsPkgFlagship.
  ///
  /// In en, this message translates to:
  /// **'Large store'**
  String get fsPkgFlagship;

  /// No description provided for @fsPkgFlagshipBody.
  ///
  /// In en, this message translates to:
  /// **'A big outlet with the full range and seating or service area.'**
  String get fsPkgFlagshipBody;

  /// No description provided for @fsPkgFrom.
  ///
  /// In en, this message translates to:
  /// **'From {amount}'**
  String fsPkgFrom(String amount);

  /// No description provided for @fsPkgKiosk.
  ///
  /// In en, this message translates to:
  /// **'Kiosk'**
  String get fsPkgKiosk;

  /// No description provided for @fsPkgKioskBody.
  ///
  /// In en, this message translates to:
  /// **'A small counter in a market, mall or bus stand.'**
  String get fsPkgKioskBody;

  /// No description provided for @fsPkgStore.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get fsPkgStore;

  /// No description provided for @fsPkgStoreBody.
  ///
  /// In en, this message translates to:
  /// **'A shop on a busy street, with more products.'**
  String get fsPkgStoreBody;

  /// No description provided for @fsStateLabel.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get fsStateLabel;

  /// No description provided for @fsSubmit.
  ///
  /// In en, this message translates to:
  /// **'Send application'**
  String get fsSubmit;

  /// No description provided for @fsTitle.
  ///
  /// In en, this message translates to:
  /// **'Franchise partner'**
  String get fsTitle;

  /// No description provided for @fsTypeArt.
  ///
  /// In en, this message translates to:
  /// **'Art gallery'**
  String get fsTypeArt;

  /// No description provided for @fsTypeCoffee.
  ///
  /// In en, this message translates to:
  /// **'Coffee kiosk'**
  String get fsTypeCoffee;

  /// No description provided for @fsTypeEgg.
  ///
  /// In en, this message translates to:
  /// **'Egg shop'**
  String get fsTypeEgg;

  /// No description provided for @fsTypeGroceries.
  ///
  /// In en, this message translates to:
  /// **'Monthly groceries'**
  String get fsTypeGroceries;

  /// No description provided for @fsTypeHygiene.
  ///
  /// In en, this message translates to:
  /// **'Women\'s hygiene'**
  String get fsTypeHygiene;

  /// No description provided for @fsTypeSpa.
  ///
  /// In en, this message translates to:
  /// **'Ayurvedic spa'**
  String get fsTypeSpa;

  /// No description provided for @fsTypesTitle.
  ///
  /// In en, this message translates to:
  /// **'Which business interests you?'**
  String get fsTypesTitle;

  /// No description provided for @fuAdd.
  ///
  /// In en, this message translates to:
  /// **'Add follow-up'**
  String get fuAdd;

  /// No description provided for @fuAdded.
  ///
  /// In en, this message translates to:
  /// **'Follow-up added.'**
  String get fuAdded;

  /// No description provided for @fuAppointment.
  ///
  /// In en, this message translates to:
  /// **'Visit follow-up'**
  String get fuAppointment;

  /// No description provided for @fuCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Finish follow-up'**
  String get fuCompleteTitle;

  /// No description provided for @fuCustomerCall.
  ///
  /// In en, this message translates to:
  /// **'Customer call'**
  String get fuCustomerCall;

  /// No description provided for @fuDone.
  ///
  /// In en, this message translates to:
  /// **'Follow-up done.'**
  String get fuDone;

  /// No description provided for @fuDoneNext.
  ///
  /// In en, this message translates to:
  /// **'Done. Next follow-up added.'**
  String get fuDoneNext;

  /// No description provided for @fuDoneOn.
  ///
  /// In en, this message translates to:
  /// **'Done {date}'**
  String fuDoneOn(String date);

  /// No description provided for @fuEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Follow-ups you add, or that come from calls and visits, show up here.'**
  String get fuEmptyBody;

  /// No description provided for @fuEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No follow-ups here'**
  String get fuEmptyTitle;

  /// No description provided for @fuNextWhen.
  ///
  /// In en, this message translates to:
  /// **'When'**
  String get fuNextWhen;

  /// No description provided for @fuOutcome.
  ///
  /// In en, this message translates to:
  /// **'Result: {outcome}'**
  String fuOutcome(String outcome);

  /// No description provided for @fuPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment follow-up'**
  String get fuPayment;

  /// No description provided for @fuProject.
  ///
  /// In en, this message translates to:
  /// **'Project follow-up'**
  String get fuProject;

  /// No description provided for @fuQuotation.
  ///
  /// In en, this message translates to:
  /// **'Quotation follow-up'**
  String get fuQuotation;

  /// No description provided for @fuRescheduled.
  ///
  /// In en, this message translates to:
  /// **'Follow-up moved.'**
  String get fuRescheduled;

  /// No description provided for @fuScheduleNext.
  ///
  /// In en, this message translates to:
  /// **'Add another follow-up'**
  String get fuScheduleNext;

  /// No description provided for @fuTabToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get fuTabToday;

  /// No description provided for @fuType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get fuType;

  /// No description provided for @fuVendorCall.
  ///
  /// In en, this message translates to:
  /// **'Vendor call'**
  String get fuVendorCall;

  /// No description provided for @fuWhatHappened.
  ///
  /// In en, this message translates to:
  /// **'What happened?'**
  String get fuWhatHappened;

  /// No description provided for @goHome.
  ///
  /// In en, this message translates to:
  /// **'Go to home'**
  String get goHome;

  /// No description provided for @goalBuy.
  ///
  /// In en, this message translates to:
  /// **'Buying'**
  String get goalBuy;

  /// No description provided for @goalBuyBody.
  ///
  /// In en, this message translates to:
  /// **'Find products and services near you'**
  String get goalBuyBody;

  /// No description provided for @goalEarn.
  ///
  /// In en, this message translates to:
  /// **'Earning'**
  String get goalEarn;

  /// No description provided for @goalEarnBody.
  ///
  /// In en, this message translates to:
  /// **'Earn money by referring customers'**
  String get goalEarnBody;

  /// No description provided for @goalGrow.
  ///
  /// In en, this message translates to:
  /// **'Growing your business'**
  String get goalGrow;

  /// No description provided for @goalGrowBody.
  ///
  /// In en, this message translates to:
  /// **'List your shop and get more customers'**
  String get goalGrowBody;

  /// No description provided for @goalStart.
  ///
  /// In en, this message translates to:
  /// **'Starting your business'**
  String get goalStart;

  /// No description provided for @goalStartBody.
  ///
  /// In en, this message translates to:
  /// **'Own an O2O Boss franchise, fully set up for you'**
  String get goalStartBody;

  /// No description provided for @greetHelloAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon,'**
  String get greetHelloAfternoon;

  /// No description provided for @greetHelloEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening,'**
  String get greetHelloEvening;

  /// No description provided for @greetHelloMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning,'**
  String get greetHelloMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon, {name}'**
  String greetingAfternoon(String name);

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening, {name}'**
  String greetingEvening(String name);

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning, {name}'**
  String greetingMorning(String name);

  /// No description provided for @groupCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get groupCompleted;

  /// No description provided for @groupFresh.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get groupFresh;

  /// No description provided for @groupLost.
  ///
  /// In en, this message translates to:
  /// **'Lost'**
  String get groupLost;

  /// No description provided for @groupPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get groupPayment;

  /// No description provided for @groupProject.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get groupProject;

  /// No description provided for @groupQualification.
  ///
  /// In en, this message translates to:
  /// **'Qualified'**
  String get groupQualification;

  /// No description provided for @groupQuotation.
  ///
  /// In en, this message translates to:
  /// **'Quotation'**
  String get groupQuotation;

  /// No description provided for @groupVendor.
  ///
  /// In en, this message translates to:
  /// **'Vendor'**
  String get groupVendor;

  /// No description provided for @groupVerification.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get groupVerification;

  /// No description provided for @groupVisit.
  ///
  /// In en, this message translates to:
  /// **'Appointment'**
  String get groupVisit;

  /// No description provided for @groupWon.
  ///
  /// In en, this message translates to:
  /// **'Won'**
  String get groupWon;

  /// No description provided for @helpCall.
  ///
  /// In en, this message translates to:
  /// **'Call support'**
  String get helpCall;

  /// No description provided for @helpContactBody.
  ///
  /// In en, this message translates to:
  /// **'Our support team is available Monday to Saturday, 9 am to 7 pm.'**
  String get helpContactBody;

  /// No description provided for @helpContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Still need help?'**
  String get helpContactTitle;

  /// No description provided for @helpEmail.
  ///
  /// In en, this message translates to:
  /// **'Email support'**
  String get helpEmail;

  /// No description provided for @helpFaqTitle.
  ///
  /// In en, this message translates to:
  /// **'Common questions'**
  String get helpFaqTitle;

  /// No description provided for @helpTitle.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get helpTitle;

  /// No description provided for @hiddenValue.
  ///
  /// In en, this message translates to:
  /// **'Hidden'**
  String get hiddenValue;

  /// No description provided for @homeQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get homeQuickActions;

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hour ago} other{{count} hours ago}}'**
  String hoursAgo(int count);

  /// No description provided for @hoursLeft.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hour left} other{{count} hours left}}'**
  String hoursLeft(int count);

  /// No description provided for @hoursLeftShort.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hour} other{{count} hours}}'**
  String hoursLeftShort(int count);

  /// No description provided for @jdCommission.
  ///
  /// In en, this message translates to:
  /// **'Payment received. Commissions are being processed.'**
  String get jdCommission;

  /// No description provided for @jdPayment.
  ///
  /// In en, this message translates to:
  /// **'Waiting for the payment to be completed.'**
  String get jdPayment;

  /// No description provided for @jdQuotePreparing.
  ///
  /// In en, this message translates to:
  /// **'The vendor is preparing the quotation.'**
  String get jdQuotePreparing;

  /// No description provided for @jdQuoteReady.
  ///
  /// In en, this message translates to:
  /// **'The quotation is with the customer.'**
  String get jdQuoteReady;

  /// No description provided for @jdQuoteReadyCustomer.
  ///
  /// In en, this message translates to:
  /// **'Your quotation is ready. Open it below to review.'**
  String get jdQuoteReadyCustomer;

  /// No description provided for @jdVendor.
  ///
  /// In en, this message translates to:
  /// **'We are choosing a trusted vendor nearby.'**
  String get jdVendor;

  /// No description provided for @jdVerifying.
  ///
  /// In en, this message translates to:
  /// **'We are calling the customer to confirm the requirement.'**
  String get jdVerifying;

  /// No description provided for @jdVerifyingCustomer.
  ///
  /// In en, this message translates to:
  /// **'Our team will call you to confirm the requirement.'**
  String get jdVerifyingCustomer;

  /// No description provided for @jdVisit.
  ///
  /// In en, this message translates to:
  /// **'The vendor will fix a visit with the customer.'**
  String get jdVisit;

  /// No description provided for @jdVisitCustomer.
  ///
  /// In en, this message translates to:
  /// **'The vendor will fix a time to visit you.'**
  String get jdVisitCustomer;

  /// No description provided for @jdVisitOn.
  ///
  /// In en, this message translates to:
  /// **'Visit on {date}.'**
  String jdVisitOn(String date);

  /// No description provided for @jdWon.
  ///
  /// In en, this message translates to:
  /// **'The order is confirmed. Work will start soon.'**
  String get jdWon;

  /// No description provided for @jdWork.
  ///
  /// In en, this message translates to:
  /// **'Work in progress: {done} of {total} steps done.'**
  String jdWork(String done, String total);

  /// No description provided for @journeyCommission.
  ///
  /// In en, this message translates to:
  /// **'Commission'**
  String get journeyCommission;

  /// No description provided for @journeyPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get journeyPayment;

  /// No description provided for @journeyProject.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get journeyProject;

  /// No description provided for @journeyQualified.
  ///
  /// In en, this message translates to:
  /// **'Requirement checked'**
  String get journeyQualified;

  /// No description provided for @journeyQuotation.
  ///
  /// In en, this message translates to:
  /// **'Quotation'**
  String get journeyQuotation;

  /// No description provided for @journeySubmitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get journeySubmitted;

  /// No description provided for @journeyVendor.
  ///
  /// In en, this message translates to:
  /// **'Vendor found'**
  String get journeyVendor;

  /// No description provided for @journeyVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get journeyVerified;

  /// No description provided for @journeyVisit.
  ///
  /// In en, this message translates to:
  /// **'Visit'**
  String get journeyVisit;

  /// No description provided for @journeyWon.
  ///
  /// In en, this message translates to:
  /// **'Won'**
  String get journeyWon;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @labelAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get labelAddress;

  /// No description provided for @labelAge.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get labelAge;

  /// No description provided for @labelAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get labelAll;

  /// No description provided for @labelAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get labelAmount;

  /// No description provided for @labelAnyBrand.
  ///
  /// In en, this message translates to:
  /// **'Any brand'**
  String get labelAnyBrand;

  /// No description provided for @labelArea.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get labelArea;

  /// No description provided for @labelBackOffice.
  ///
  /// In en, this message translates to:
  /// **'Back office'**
  String get labelBackOffice;

  /// No description provided for @labelBrand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get labelBrand;

  /// No description provided for @labelBrandsYouSupply.
  ///
  /// In en, this message translates to:
  /// **'Brands you supply'**
  String get labelBrandsYouSupply;

  /// No description provided for @labelBusinessName.
  ///
  /// In en, this message translates to:
  /// **'Business name'**
  String get labelBusinessName;

  /// No description provided for @labelCategoriesYouServe.
  ///
  /// In en, this message translates to:
  /// **'What do you sell or service?'**
  String get labelCategoriesYouServe;

  /// No description provided for @labelCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get labelCategory;

  /// No description provided for @labelChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose'**
  String get labelChoose;

  /// No description provided for @labelCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get labelCity;

  /// No description provided for @labelCreated.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get labelCreated;

  /// No description provided for @labelCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get labelCustomer;

  /// No description provided for @labelDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get labelDate;

  /// No description provided for @labelDemo.
  ///
  /// In en, this message translates to:
  /// **'Demo'**
  String get labelDemo;

  /// No description provided for @labelEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get labelEmail;

  /// No description provided for @labelEmailOptional.
  ///
  /// In en, this message translates to:
  /// **'Email (optional)'**
  String get labelEmailOptional;

  /// No description provided for @labelEnquiryId.
  ///
  /// In en, this message translates to:
  /// **'Enquiry ID'**
  String get labelEnquiryId;

  /// No description provided for @labelEstimatedValue.
  ///
  /// In en, this message translates to:
  /// **'Estimated value'**
  String get labelEstimatedValue;

  /// No description provided for @labelFinalValue.
  ///
  /// In en, this message translates to:
  /// **'Final value'**
  String get labelFinalValue;

  /// No description provided for @labelFranchise.
  ///
  /// In en, this message translates to:
  /// **'Territory'**
  String get labelFranchise;

  /// No description provided for @labelFullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get labelFullName;

  /// No description provided for @labelGstin.
  ///
  /// In en, this message translates to:
  /// **'GSTIN'**
  String get labelGstin;

  /// No description provided for @labelLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get labelLocation;

  /// No description provided for @labelMobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get labelMobile;

  /// No description provided for @labelName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get labelName;

  /// No description provided for @labelNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get labelNo;

  /// No description provided for @labelNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get labelNone;

  /// No description provided for @labelNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get labelNotes;

  /// No description provided for @labelNotesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get labelNotesOptional;

  /// No description provided for @labelOptional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get labelOptional;

  /// No description provided for @labelOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get labelOther;

  /// No description provided for @labelPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get labelPassword;

  /// No description provided for @labelPincode.
  ///
  /// In en, this message translates to:
  /// **'Pincode'**
  String get labelPincode;

  /// No description provided for @labelPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get labelPriority;

  /// No description provided for @labelProduct.
  ///
  /// In en, this message translates to:
  /// **'Product or service'**
  String get labelProduct;

  /// No description provided for @labelReason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get labelReason;

  /// No description provided for @labelRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get labelRequired;

  /// No description provided for @labelRequirement.
  ///
  /// In en, this message translates to:
  /// **'Requirement'**
  String get labelRequirement;

  /// No description provided for @labelRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get labelRole;

  /// No description provided for @labelSalesperson.
  ///
  /// In en, this message translates to:
  /// **'Referred by'**
  String get labelSalesperson;

  /// No description provided for @labelSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name, ID or phone'**
  String get labelSearchHint;

  /// No description provided for @labelServiceCities.
  ///
  /// In en, this message translates to:
  /// **'Cities you serve'**
  String get labelServiceCities;

  /// No description provided for @labelStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get labelStatus;

  /// No description provided for @labelTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get labelTime;

  /// No description provided for @labelTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get labelTotal;

  /// No description provided for @labelUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last update'**
  String get labelUpdated;

  /// No description provided for @labelUserId.
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get labelUserId;

  /// No description provided for @labelValue.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get labelValue;

  /// No description provided for @labelVendor.
  ///
  /// In en, this message translates to:
  /// **'Vendor'**
  String get labelVendor;

  /// No description provided for @labelYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get labelYes;

  /// No description provided for @labelYourArea.
  ///
  /// In en, this message translates to:
  /// **'Your area'**
  String get labelYourArea;

  /// No description provided for @labelYourCity.
  ///
  /// In en, this message translates to:
  /// **'Your city or district'**
  String get labelYourCity;

  /// No description provided for @labelYourName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get labelYourName;

  /// No description provided for @langContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get langContinue;

  /// No description provided for @langSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You can change this later in Profile.'**
  String get langSubtitle;

  /// No description provided for @langTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get langTitle;

  /// No description provided for @legalDemoNote.
  ///
  /// In en, this message translates to:
  /// **'Sample wording for the demo. The final text will be provided by O2O Boss.'**
  String get legalDemoNote;

  /// No description provided for @legalPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get legalPrivacy;

  /// No description provided for @legalTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms of use'**
  String get legalTerms;

  /// No description provided for @legalVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String legalVersion(String version);

  /// No description provided for @listActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get listActive;

  /// No description provided for @listAwaitingApproval.
  ///
  /// In en, this message translates to:
  /// **'Awaiting approval'**
  String get listAwaitingApproval;

  /// No description provided for @listCalls.
  ///
  /// In en, this message translates to:
  /// **'Call log'**
  String get listCalls;

  /// No description provided for @listCustomerSince.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get listCustomerSince;

  /// No description provided for @listNeedsAction.
  ///
  /// In en, this message translates to:
  /// **'Needs action'**
  String get listNeedsAction;

  /// No description provided for @listPast.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get listPast;

  /// No description provided for @listPayments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get listPayments;

  /// No description provided for @listProjects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get listProjects;

  /// No description provided for @listStopped.
  ///
  /// In en, this message translates to:
  /// **'Stopped'**
  String get listStopped;

  /// No description provided for @listToReview.
  ///
  /// In en, this message translates to:
  /// **'To review'**
  String get listToReview;

  /// No description provided for @listVisits.
  ///
  /// In en, this message translates to:
  /// **'Visits'**
  String get listVisits;

  /// No description provided for @listWithCustomer.
  ///
  /// In en, this message translates to:
  /// **'With customer'**
  String get listWithCustomer;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginButton;

  /// No description provided for @loginCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get loginCreateAccount;

  /// No description provided for @loginDemoButton.
  ///
  /// In en, this message translates to:
  /// **'Try a demo account'**
  String get loginDemoButton;

  /// No description provided for @loginDemoCredentials.
  ///
  /// In en, this message translates to:
  /// **'ID: {id}, password: {password}'**
  String loginDemoCredentials(String id, String password);

  /// No description provided for @loginDemoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'For testing only. Each one opens a different role.'**
  String get loginDemoSubtitle;

  /// No description provided for @loginDemoTitle.
  ///
  /// In en, this message translates to:
  /// **'Demo accounts'**
  String get loginDemoTitle;

  /// No description provided for @loginError.
  ///
  /// In en, this message translates to:
  /// **'User ID or password is not correct. Check both and try again.'**
  String get loginError;

  /// No description provided for @loginForgot.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get loginForgot;

  /// No description provided for @loginNoAccount.
  ///
  /// In en, this message translates to:
  /// **'New to O2O Boss?'**
  String get loginNoAccount;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use the user ID and password from your sign-up, or the one O2O Boss gave you.'**
  String get loginSubtitle;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginTitle;

  /// No description provided for @logoutBody.
  ///
  /// In en, this message translates to:
  /// **'You\'ll need your user ID and password to sign in again.'**
  String get logoutBody;

  /// No description provided for @logoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out?'**
  String get logoutTitle;

  /// No description provided for @lostReasonDelay.
  ///
  /// In en, this message translates to:
  /// **'Plan postponed'**
  String get lostReasonDelay;

  /// No description provided for @lostReasonNoNeed.
  ///
  /// In en, this message translates to:
  /// **'No longer needed'**
  String get lostReasonNoNeed;

  /// No description provided for @lostReasonOther.
  ///
  /// In en, this message translates to:
  /// **'Bought from someone else'**
  String get lostReasonOther;

  /// No description provided for @lostReasonPrice.
  ///
  /// In en, this message translates to:
  /// **'Price too high'**
  String get lostReasonPrice;

  /// No description provided for @methodBank.
  ///
  /// In en, this message translates to:
  /// **'Bank transfer'**
  String get methodBank;

  /// No description provided for @methodCard.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get methodCard;

  /// No description provided for @methodCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get methodCash;

  /// No description provided for @methodCheque.
  ///
  /// In en, this message translates to:
  /// **'Cheque'**
  String get methodCheque;

  /// No description provided for @methodUpi.
  ///
  /// In en, this message translates to:
  /// **'UPI'**
  String get methodUpi;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 minute ago} other{{count} minutes ago}}'**
  String minutesAgo(int count);

  /// No description provided for @minutesLeft.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 minute left} other{{count} minutes left}}'**
  String minutesLeft(int count);

  /// No description provided for @moreDirectory.
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get moreDirectory;

  /// No description provided for @moreMine.
  ///
  /// In en, this message translates to:
  /// **'Mine'**
  String get moreMine;

  /// No description provided for @moreProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Profile, password and language'**
  String get moreProfileSubtitle;

  /// No description provided for @moreWork.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get moreWork;

  /// No description provided for @msAdvancePayment.
  ///
  /// In en, this message translates to:
  /// **'Advance payment'**
  String get msAdvancePayment;

  /// No description provided for @msFinalInspection.
  ///
  /// In en, this message translates to:
  /// **'Final inspection'**
  String get msFinalInspection;

  /// No description provided for @msFinalPayment.
  ///
  /// In en, this message translates to:
  /// **'Final payment'**
  String get msFinalPayment;

  /// No description provided for @msInstallationDone.
  ///
  /// In en, this message translates to:
  /// **'Installation or service done'**
  String get msInstallationDone;

  /// No description provided for @msMaterialOrdered.
  ///
  /// In en, this message translates to:
  /// **'Material ordered'**
  String get msMaterialOrdered;

  /// No description provided for @msOrderConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Order confirmed'**
  String get msOrderConfirmed;

  /// No description provided for @msProjectCompleted.
  ///
  /// In en, this message translates to:
  /// **'Project completed'**
  String get msProjectCompleted;

  /// No description provided for @msWorkInProgress.
  ///
  /// In en, this message translates to:
  /// **'Work in progress'**
  String get msWorkInProgress;

  /// No description provided for @msWorkStarted.
  ///
  /// In en, this message translates to:
  /// **'Work started'**
  String get msWorkStarted;

  /// No description provided for @nAccountCreatedBody.
  ///
  /// In en, this message translates to:
  /// **'Your account is ready.'**
  String get nAccountCreatedBody;

  /// No description provided for @nAccountCreatedTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to O2O Boss'**
  String get nAccountCreatedTitle;

  /// No description provided for @nAppointmentChangedBody.
  ///
  /// In en, this message translates to:
  /// **'The visit for {id} has changed.'**
  String nAppointmentChangedBody(String id);

  /// No description provided for @nAppointmentChangedTitle.
  ///
  /// In en, this message translates to:
  /// **'Visit updated'**
  String get nAppointmentChangedTitle;

  /// No description provided for @nAppointmentConfirmedBody.
  ///
  /// In en, this message translates to:
  /// **'The visit for {id} is confirmed.'**
  String nAppointmentConfirmedBody(String id);

  /// No description provided for @nAppointmentConfirmedTitle.
  ///
  /// In en, this message translates to:
  /// **'Visit confirmed'**
  String get nAppointmentConfirmedTitle;

  /// No description provided for @nAppointmentProposedBody.
  ///
  /// In en, this message translates to:
  /// **'A visit time was proposed for {id}. Please confirm it.'**
  String nAppointmentProposedBody(String id);

  /// No description provided for @nAppointmentProposedTitle.
  ///
  /// In en, this message translates to:
  /// **'Visit time proposed'**
  String get nAppointmentProposedTitle;

  /// No description provided for @nChatMessageBody.
  ///
  /// In en, this message translates to:
  /// **'{from} sent a message on {id}.'**
  String nChatMessageBody(String from, String id);

  /// No description provided for @nChatMessageTitle.
  ///
  /// In en, this message translates to:
  /// **'New message'**
  String get nChatMessageTitle;

  /// No description provided for @nCommissionPaidBody.
  ///
  /// In en, this message translates to:
  /// **'{amount} for {id} has been paid to you.'**
  String nCommissionPaidBody(String amount, String id);

  /// No description provided for @nCommissionPaidTitle.
  ///
  /// In en, this message translates to:
  /// **'Commission paid'**
  String get nCommissionPaidTitle;

  /// No description provided for @nCommissionUpdatedBody.
  ///
  /// In en, this message translates to:
  /// **'Your commission of {amount} for {id} was updated.'**
  String nCommissionUpdatedBody(String amount, String id);

  /// No description provided for @nCommissionUpdatedTitle.
  ///
  /// In en, this message translates to:
  /// **'Commission update'**
  String get nCommissionUpdatedTitle;

  /// No description provided for @nConfigChangedBody.
  ///
  /// In en, this message translates to:
  /// **'An admin changed a setting.'**
  String get nConfigChangedBody;

  /// No description provided for @nConfigChangedTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings changed'**
  String get nConfigChangedTitle;

  /// No description provided for @nEnquiryLostBody.
  ///
  /// In en, this message translates to:
  /// **'{id} was closed without a deal.'**
  String nEnquiryLostBody(String id);

  /// No description provided for @nEnquiryLostTitle.
  ///
  /// In en, this message translates to:
  /// **'Enquiry closed'**
  String get nEnquiryLostTitle;

  /// No description provided for @nEnquiryQualifiedBody.
  ///
  /// In en, this message translates to:
  /// **'{id} is ready to be sent to a vendor.'**
  String nEnquiryQualifiedBody(String id);

  /// No description provided for @nEnquiryQualifiedTitle.
  ///
  /// In en, this message translates to:
  /// **'Requirement confirmed'**
  String get nEnquiryQualifiedTitle;

  /// No description provided for @nEnquiryRejectedBody.
  ///
  /// In en, this message translates to:
  /// **'{id} could not be verified.'**
  String nEnquiryRejectedBody(String id);

  /// No description provided for @nEnquiryRejectedTitle.
  ///
  /// In en, this message translates to:
  /// **'Enquiry not verified'**
  String get nEnquiryRejectedTitle;

  /// No description provided for @nEnquirySubmittedBody.
  ///
  /// In en, this message translates to:
  /// **'{id} is registered. We\'ll verify it soon.'**
  String nEnquirySubmittedBody(String id);

  /// No description provided for @nEnquirySubmittedTitle.
  ///
  /// In en, this message translates to:
  /// **'Enquiry registered'**
  String get nEnquirySubmittedTitle;

  /// No description provided for @nEnquiryVerifiedBody.
  ///
  /// In en, this message translates to:
  /// **'{id} is genuine and moving ahead.'**
  String nEnquiryVerifiedBody(String id);

  /// No description provided for @nEnquiryVerifiedTitle.
  ///
  /// In en, this message translates to:
  /// **'Enquiry verified'**
  String get nEnquiryVerifiedTitle;

  /// No description provided for @nEnquiryWonBody.
  ///
  /// In en, this message translates to:
  /// **'{id} is won.'**
  String nEnquiryWonBody(String id);

  /// No description provided for @nEnquiryWonTitle.
  ///
  /// In en, this message translates to:
  /// **'Business won'**
  String get nEnquiryWonTitle;

  /// No description provided for @nFeedbackRequestBody.
  ///
  /// In en, this message translates to:
  /// **'Rate the work done for {id}.'**
  String nFeedbackRequestBody(String id);

  /// No description provided for @nFeedbackRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'How was the work?'**
  String get nFeedbackRequestTitle;

  /// No description provided for @nFollowUpDueBody.
  ///
  /// In en, this message translates to:
  /// **'A follow-up on {id} is due.'**
  String nFollowUpDueBody(String id);

  /// No description provided for @nFollowUpDueTitle.
  ///
  /// In en, this message translates to:
  /// **'Follow-up due'**
  String get nFollowUpDueTitle;

  /// No description provided for @nNewEnquiryBody.
  ///
  /// In en, this message translates to:
  /// **'{id} is waiting for verification.'**
  String nNewEnquiryBody(String id);

  /// No description provided for @nNewEnquiryTitle.
  ///
  /// In en, this message translates to:
  /// **'New enquiry'**
  String get nNewEnquiryTitle;

  /// No description provided for @nNewReferralBody.
  ///
  /// In en, this message translates to:
  /// **'{id} is waiting for your reply.'**
  String nNewReferralBody(String id);

  /// No description provided for @nNewReferralTitle.
  ///
  /// In en, this message translates to:
  /// **'New referral'**
  String get nNewReferralTitle;

  /// No description provided for @nPaymentRecordedBody.
  ///
  /// In en, this message translates to:
  /// **'{amount} received for {id}.'**
  String nPaymentRecordedBody(String amount, String id);

  /// No description provided for @nPaymentRecordedTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment recorded'**
  String get nPaymentRecordedTitle;

  /// No description provided for @nPaymentReminderBody.
  ///
  /// In en, this message translates to:
  /// **'Payment for {id} is due.'**
  String nPaymentReminderBody(String id);

  /// No description provided for @nPaymentReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment reminder'**
  String get nPaymentReminderTitle;

  /// No description provided for @nProjectCompletedBody.
  ///
  /// In en, this message translates to:
  /// **'Work for {id} is complete.'**
  String nProjectCompletedBody(String id);

  /// No description provided for @nProjectCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Work completed'**
  String get nProjectCompletedTitle;

  /// No description provided for @nProjectCreatedBody.
  ///
  /// In en, this message translates to:
  /// **'A project for {id} has been created.'**
  String nProjectCreatedBody(String id);

  /// No description provided for @nProjectCreatedTitle.
  ///
  /// In en, this message translates to:
  /// **'Project started'**
  String get nProjectCreatedTitle;

  /// No description provided for @nProjectUpdatedBody.
  ///
  /// In en, this message translates to:
  /// **'There is progress on {id}.'**
  String nProjectUpdatedBody(String id);

  /// No description provided for @nProjectUpdatedTitle.
  ///
  /// In en, this message translates to:
  /// **'Project update'**
  String get nProjectUpdatedTitle;

  /// No description provided for @nQuotationAcceptedBody.
  ///
  /// In en, this message translates to:
  /// **'{number} was accepted for {id}.'**
  String nQuotationAcceptedBody(String number, String id);

  /// No description provided for @nQuotationAcceptedTitle.
  ///
  /// In en, this message translates to:
  /// **'Quotation accepted'**
  String get nQuotationAcceptedTitle;

  /// No description provided for @nQuotationApprovedBody.
  ///
  /// In en, this message translates to:
  /// **'{number} was checked and sent to the customer.'**
  String nQuotationApprovedBody(String number);

  /// No description provided for @nQuotationApprovedTitle.
  ///
  /// In en, this message translates to:
  /// **'Quotation sent to customer'**
  String get nQuotationApprovedTitle;

  /// No description provided for @nQuotationCopyBody.
  ///
  /// In en, this message translates to:
  /// **'A copy of {number} from {vendor} was saved and emailed.'**
  String nQuotationCopyBody(String number, String vendor);

  /// No description provided for @nQuotationCopyTitle.
  ///
  /// In en, this message translates to:
  /// **'Quotation copy saved'**
  String get nQuotationCopyTitle;

  /// No description provided for @nQuotationReceivedBody.
  ///
  /// In en, this message translates to:
  /// **'A quotation for {id} is ready to view.'**
  String nQuotationReceivedBody(String id);

  /// No description provided for @nQuotationReceivedTitle.
  ///
  /// In en, this message translates to:
  /// **'Quotation ready'**
  String get nQuotationReceivedTitle;

  /// No description provided for @nQuotationRejectedBody.
  ///
  /// In en, this message translates to:
  /// **'{number} was rejected for {id}.'**
  String nQuotationRejectedBody(String number, String id);

  /// No description provided for @nQuotationRejectedTitle.
  ///
  /// In en, this message translates to:
  /// **'Quotation rejected'**
  String get nQuotationRejectedTitle;

  /// No description provided for @nQuotationSubmittedBody.
  ///
  /// In en, this message translates to:
  /// **'{vendor} sent {number} for {id}.'**
  String nQuotationSubmittedBody(String vendor, String number, String id);

  /// No description provided for @nQuotationSubmittedTitle.
  ///
  /// In en, this message translates to:
  /// **'Quotation to review'**
  String get nQuotationSubmittedTitle;

  /// No description provided for @nReferralAcceptedBody.
  ///
  /// In en, this message translates to:
  /// **'{vendor} accepted {id}.'**
  String nReferralAcceptedBody(String vendor, String id);

  /// No description provided for @nReferralAcceptedTitle.
  ///
  /// In en, this message translates to:
  /// **'Vendor accepted'**
  String get nReferralAcceptedTitle;

  /// No description provided for @nReferralRejectedBody.
  ///
  /// In en, this message translates to:
  /// **'{vendor} declined {id}. Choose another vendor.'**
  String nReferralRejectedBody(String vendor, String id);

  /// No description provided for @nReferralRejectedTitle.
  ///
  /// In en, this message translates to:
  /// **'Vendor declined'**
  String get nReferralRejectedTitle;

  /// No description provided for @nReferralReminderBody.
  ///
  /// In en, this message translates to:
  /// **'Please reply to {id} before the deadline.'**
  String nReferralReminderBody(String id);

  /// No description provided for @nReferralReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Reply needed'**
  String get nReferralReminderTitle;

  /// No description provided for @nRevisionRequestedBody.
  ///
  /// In en, this message translates to:
  /// **'Changes were requested on {number}.'**
  String nRevisionRequestedBody(String number);

  /// No description provided for @nRevisionRequestedTitle.
  ///
  /// In en, this message translates to:
  /// **'Changes requested'**
  String get nRevisionRequestedTitle;

  /// No description provided for @nTaskAssignedBody.
  ///
  /// In en, this message translates to:
  /// **'{id} has been assigned to you.'**
  String nTaskAssignedBody(String id);

  /// No description provided for @nTaskAssignedTitle.
  ///
  /// In en, this message translates to:
  /// **'New work for you'**
  String get nTaskAssignedTitle;

  /// No description provided for @nVendorApprovedBody.
  ///
  /// In en, this message translates to:
  /// **'Your business is approved. You can now receive referrals.'**
  String get nVendorApprovedBody;

  /// No description provided for @nVendorApprovedTitle.
  ///
  /// In en, this message translates to:
  /// **'Account approved'**
  String get nVendorApprovedTitle;

  /// No description provided for @nVendorAssignedBody.
  ///
  /// In en, this message translates to:
  /// **'{vendor} will handle {id}.'**
  String nVendorAssignedBody(String vendor, String id);

  /// No description provided for @nVendorAssignedTitle.
  ///
  /// In en, this message translates to:
  /// **'Vendor assigned'**
  String get nVendorAssignedTitle;

  /// No description provided for @nVendorConnectedBody.
  ///
  /// In en, this message translates to:
  /// **'{vendor} will help you with {id} through O2O Boss.'**
  String nVendorConnectedBody(String vendor, String id);

  /// No description provided for @nVendorConnectedTitle.
  ///
  /// In en, this message translates to:
  /// **'Vendor connected'**
  String get nVendorConnectedTitle;

  /// No description provided for @nVendorRegisteredBody.
  ///
  /// In en, this message translates to:
  /// **'{vendor} registered and needs review.'**
  String nVendorRegisteredBody(String vendor);

  /// No description provided for @nVendorRegisteredTitle.
  ///
  /// In en, this message translates to:
  /// **'New vendor registration'**
  String get nVendorRegisteredTitle;

  /// No description provided for @navBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get navBusiness;

  /// No description provided for @navChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get navChat;

  /// No description provided for @navEarnings.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get navEarnings;

  /// No description provided for @navEnquiries.
  ///
  /// In en, this message translates to:
  /// **'Enquiries'**
  String get navEnquiries;

  /// No description provided for @navFollowUps.
  ///
  /// In en, this message translates to:
  /// **'Follow-ups'**
  String get navFollowUps;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// No description provided for @navNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get navNetwork;

  /// No description provided for @navNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get navNotifications;

  /// No description provided for @navOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get navOrders;

  /// No description provided for @navProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get navProducts;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @navQuotations.
  ///
  /// In en, this message translates to:
  /// **'Quotations'**
  String get navQuotations;

  /// No description provided for @navRefer.
  ///
  /// In en, this message translates to:
  /// **'Refer'**
  String get navRefer;

  /// No description provided for @navReferrals.
  ///
  /// In en, this message translates to:
  /// **'Referrals'**
  String get navReferrals;

  /// No description provided for @navReports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get navReports;

  /// No description provided for @navRequirement.
  ///
  /// In en, this message translates to:
  /// **'Requirement'**
  String get navRequirement;

  /// No description provided for @navTasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get navTasks;

  /// No description provided for @nextAssignBody.
  ///
  /// In en, this message translates to:
  /// **'Pick one or more matching vendors to send this referral to.'**
  String get nextAssignBody;

  /// No description provided for @nextAssignButton.
  ///
  /// In en, this message translates to:
  /// **'Find vendors'**
  String get nextAssignButton;

  /// No description provided for @nextAssignTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a vendor'**
  String get nextAssignTitle;

  /// No description provided for @nextCommissionBody.
  ///
  /// In en, this message translates to:
  /// **'Payment is complete. Commissions are ready for approval.'**
  String get nextCommissionBody;

  /// No description provided for @nextCommissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Settle the commission'**
  String get nextCommissionTitle;

  /// No description provided for @nextCustomerDecidesBody.
  ///
  /// In en, this message translates to:
  /// **'The quotation is with the customer. Follow up if needed.'**
  String get nextCustomerDecidesBody;

  /// No description provided for @nextCustomerDecidesTitle.
  ///
  /// In en, this message translates to:
  /// **'The customer is deciding'**
  String get nextCustomerDecidesTitle;

  /// No description provided for @nextDoneBody.
  ///
  /// In en, this message translates to:
  /// **'The work is complete and every commission is paid.'**
  String get nextDoneBody;

  /// No description provided for @nextDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'All done'**
  String get nextDoneTitle;

  /// No description provided for @nextMessageVendor.
  ///
  /// In en, this message translates to:
  /// **'Message vendor'**
  String get nextMessageVendor;

  /// No description provided for @nextPaymentBody.
  ///
  /// In en, this message translates to:
  /// **'{amount} is still to be paid.'**
  String nextPaymentBody(String amount);

  /// No description provided for @nextPaymentButton.
  ///
  /// In en, this message translates to:
  /// **'Record payment'**
  String get nextPaymentButton;

  /// No description provided for @nextPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Collect the payment'**
  String get nextPaymentTitle;

  /// No description provided for @nextProjectBody.
  ///
  /// In en, this message translates to:
  /// **'The customer accepted. Set the dates so work can be tracked.'**
  String get nextProjectBody;

  /// No description provided for @nextProjectButton.
  ///
  /// In en, this message translates to:
  /// **'Create project'**
  String get nextProjectButton;

  /// No description provided for @nextProjectTitle.
  ///
  /// In en, this message translates to:
  /// **'Create the project'**
  String get nextProjectTitle;

  /// No description provided for @nextQualifyBody.
  ///
  /// In en, this message translates to:
  /// **'A few questions give the vendor a clear, complete brief.'**
  String get nextQualifyBody;

  /// No description provided for @nextQualifyButton.
  ///
  /// In en, this message translates to:
  /// **'Qualify'**
  String get nextQualifyButton;

  /// No description provided for @nextQualifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Ask the qualification questions'**
  String get nextQualifyTitle;

  /// No description provided for @nextReviewBody.
  ///
  /// In en, this message translates to:
  /// **'{number} from {vendor} is waiting for your check.'**
  String nextReviewBody(String number, String vendor);

  /// No description provided for @nextReviewButton.
  ///
  /// In en, this message translates to:
  /// **'Review quotation'**
  String get nextReviewButton;

  /// No description provided for @nextReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review the quotation'**
  String get nextReviewTitle;

  /// No description provided for @nextVerifyBody.
  ///
  /// In en, this message translates to:
  /// **'Call {name} to confirm the requirement is genuine.'**
  String nextVerifyBody(String name);

  /// No description provided for @nextVerifyButton.
  ///
  /// In en, this message translates to:
  /// **'Verify now'**
  String get nextVerifyButton;

  /// No description provided for @nextVerifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify the enquiry'**
  String get nextVerifyTitle;

  /// No description provided for @nextVisitBody.
  ///
  /// In en, this message translates to:
  /// **'The vendor accepted. Introduce them to the customer and book a visit.'**
  String get nextVisitBody;

  /// No description provided for @nextVisitButton.
  ///
  /// In en, this message translates to:
  /// **'Book a visit'**
  String get nextVisitButton;

  /// No description provided for @nextVisitDoneBody.
  ///
  /// In en, this message translates to:
  /// **'The visit is on {date}. Mark it done once it happens.'**
  String nextVisitDoneBody(String date);

  /// No description provided for @nextVisitDoneBodyPlain.
  ///
  /// In en, this message translates to:
  /// **'Mark the visit done once it happens.'**
  String get nextVisitDoneBodyPlain;

  /// No description provided for @nextVisitDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Visit booked'**
  String get nextVisitDoneTitle;

  /// No description provided for @nextVisitTitle.
  ///
  /// In en, this message translates to:
  /// **'Fix a site visit'**
  String get nextVisitTitle;

  /// No description provided for @nextWaitQuoteBody.
  ///
  /// In en, this message translates to:
  /// **'The vendor is preparing it. Remind them if it takes long.'**
  String get nextWaitQuoteBody;

  /// No description provided for @nextWaitQuoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Waiting for the quotation'**
  String get nextWaitQuoteTitle;

  /// No description provided for @nextWaitVendorBody.
  ///
  /// In en, this message translates to:
  /// **'{vendor} has not replied yet. {time}.'**
  String nextWaitVendorBody(String vendor, String time);

  /// No description provided for @nextWaitVendorBodyPlain.
  ///
  /// In en, this message translates to:
  /// **'Vendors have not replied yet.'**
  String get nextWaitVendorBodyPlain;

  /// No description provided for @nextWaitVendorTitle.
  ///
  /// In en, this message translates to:
  /// **'Waiting for the vendor'**
  String get nextWaitVendorTitle;

  /// No description provided for @nextWorkBody.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} steps done.'**
  String nextWorkBody(String done, String total);

  /// No description provided for @nextWorkTitle.
  ///
  /// In en, this message translates to:
  /// **'Track the work'**
  String get nextWorkTitle;

  /// No description provided for @noAccessBody.
  ///
  /// In en, this message translates to:
  /// **'This page isn\'t available for your account.'**
  String get noAccessBody;

  /// No description provided for @noAccessTitle.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have access'**
  String get noAccessTitle;

  /// No description provided for @notFoundBody.
  ///
  /// In en, this message translates to:
  /// **'This page doesn\'t exist or has moved.'**
  String get notFoundBody;

  /// No description provided for @notFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get notFoundTitle;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @notifAllRead.
  ///
  /// In en, this message translates to:
  /// **'All notifications marked as read.'**
  String get notifAllRead;

  /// No description provided for @notifEarlier.
  ///
  /// In en, this message translates to:
  /// **'Earlier'**
  String get notifEarlier;

  /// No description provided for @notifEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Updates about your enquiries will appear here.'**
  String get notifEmptyBody;

  /// No description provided for @notifEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get notifEmptyTitle;

  /// No description provided for @notifMarkAll.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get notifMarkAll;

  /// No description provided for @notifUnread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get notifUnread;

  /// No description provided for @occEmployed.
  ///
  /// In en, this message translates to:
  /// **'Employed'**
  String get occEmployed;

  /// No description provided for @occEmployedBody.
  ///
  /// In en, this message translates to:
  /// **'Earn alongside your job'**
  String get occEmployedBody;

  /// No description provided for @occHomemaker.
  ///
  /// In en, this message translates to:
  /// **'Homemaker'**
  String get occHomemaker;

  /// No description provided for @occHomemakerBody.
  ///
  /// In en, this message translates to:
  /// **'Earn from home, at your own pace'**
  String get occHomemakerBody;

  /// No description provided for @occLabel.
  ///
  /// In en, this message translates to:
  /// **'What do you do?'**
  String get occLabel;

  /// No description provided for @occOther.
  ///
  /// In en, this message translates to:
  /// **'Something else'**
  String get occOther;

  /// No description provided for @occOtherBody.
  ///
  /// In en, this message translates to:
  /// **'Anyone who knows people can earn'**
  String get occOtherBody;

  /// No description provided for @occRetired.
  ///
  /// In en, this message translates to:
  /// **'Retired'**
  String get occRetired;

  /// No description provided for @occRetiredBody.
  ///
  /// In en, this message translates to:
  /// **'Put your contacts and experience to use'**
  String get occRetiredBody;

  /// No description provided for @occSelfEmployed.
  ///
  /// In en, this message translates to:
  /// **'Self-employed'**
  String get occSelfEmployed;

  /// No description provided for @occSelfEmployedBody.
  ///
  /// In en, this message translates to:
  /// **'Add income to your own work'**
  String get occSelfEmployedBody;

  /// No description provided for @occStudent.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get occStudent;

  /// No description provided for @occStudentBody.
  ///
  /// In en, this message translates to:
  /// **'Earn in your free time'**
  String get occStudentBody;

  /// No description provided for @offlineBanner.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline. Changes will sync when you\'re back online.'**
  String get offlineBanner;

  /// No description provided for @opsActivityNote.
  ///
  /// In en, this message translates to:
  /// **'Every action is recorded with who did it and when. This history cannot be changed.'**
  String get opsActivityNote;

  /// No description provided for @opsActivitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Last change {time}'**
  String opsActivitySubtitle(String time);

  /// No description provided for @opsAnswers.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No answers yet} =1{1 answer saved} other{{count} answers saved}}'**
  String opsAnswers(int count);

  /// No description provided for @opsChangePriority.
  ///
  /// In en, this message translates to:
  /// **'Change priority'**
  String get opsChangePriority;

  /// No description provided for @opsChatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Messages with the customer and vendors'**
  String get opsChatSubtitle;

  /// No description provided for @opsClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get opsClosed;

  /// No description provided for @opsCommissionSummary.
  ///
  /// In en, this message translates to:
  /// **'{amount} in total'**
  String opsCommissionSummary(String amount);

  /// No description provided for @opsInternalNote.
  ///
  /// In en, this message translates to:
  /// **'Internal note'**
  String get opsInternalNote;

  /// No description provided for @opsInternalNoteHelp.
  ///
  /// In en, this message translates to:
  /// **'Only back office, franchise heads and admin can see internal notes.'**
  String get opsInternalNoteHelp;

  /// No description provided for @opsInternalNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Note for the team'**
  String get opsInternalNoteLabel;

  /// No description provided for @opsMarkLost.
  ///
  /// In en, this message translates to:
  /// **'Mark as lost'**
  String get opsMarkLost;

  /// No description provided for @opsMarkLostBody.
  ///
  /// In en, this message translates to:
  /// **'The enquiry will close and vendors will be told.'**
  String get opsMarkLostBody;

  /// No description provided for @opsMarkedLost.
  ///
  /// In en, this message translates to:
  /// **'Marked as lost.'**
  String get opsMarkedLost;

  /// No description provided for @opsMoreActions.
  ///
  /// In en, this message translates to:
  /// **'More actions'**
  String get opsMoreActions;

  /// No description provided for @opsNextStep.
  ///
  /// In en, this message translates to:
  /// **'Next step'**
  String get opsNextStep;

  /// No description provided for @opsNoNote.
  ///
  /// In en, this message translates to:
  /// **'No note yet.'**
  String get opsNoNote;

  /// No description provided for @opsNoQuotesYet.
  ///
  /// In en, this message translates to:
  /// **'No quotations yet'**
  String get opsNoQuotesYet;

  /// No description provided for @opsNoVendorsYet.
  ///
  /// In en, this message translates to:
  /// **'No vendor chosen yet'**
  String get opsNoVendorsYet;

  /// No description provided for @opsNoVisitsYet.
  ///
  /// In en, this message translates to:
  /// **'No visits yet'**
  String get opsNoVisitsYet;

  /// No description provided for @opsNotQualifiedYet.
  ///
  /// In en, this message translates to:
  /// **'Questions not answered yet'**
  String get opsNotQualifiedYet;

  /// No description provided for @opsNotVerifiedYet.
  ///
  /// In en, this message translates to:
  /// **'Not verified yet'**
  String get opsNotVerifiedYet;

  /// No description provided for @opsOtpVerified.
  ///
  /// In en, this message translates to:
  /// **'Number confirmed by OTP'**
  String get opsOtpVerified;

  /// No description provided for @opsOutcome.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get opsOutcome;

  /// No description provided for @opsPartActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get opsPartActivity;

  /// No description provided for @opsPartCalls.
  ///
  /// In en, this message translates to:
  /// **'Verification and calls'**
  String get opsPartCalls;

  /// No description provided for @opsPartCommission.
  ///
  /// In en, this message translates to:
  /// **'Commission'**
  String get opsPartCommission;

  /// No description provided for @opsPartDetails.
  ///
  /// In en, this message translates to:
  /// **'Customer and requirement'**
  String get opsPartDetails;

  /// No description provided for @opsPartProject.
  ///
  /// In en, this message translates to:
  /// **'Project and payments'**
  String get opsPartProject;

  /// No description provided for @opsPartQualify.
  ///
  /// In en, this message translates to:
  /// **'Qualification'**
  String get opsPartQualify;

  /// No description provided for @opsPartVendors.
  ///
  /// In en, this message translates to:
  /// **'Vendors'**
  String get opsPartVendors;

  /// No description provided for @opsPartVisits.
  ///
  /// In en, this message translates to:
  /// **'Visits'**
  String get opsPartVisits;

  /// No description provided for @opsReassign.
  ///
  /// In en, this message translates to:
  /// **'Reassign back office'**
  String get opsReassign;

  /// No description provided for @opsReassigned.
  ///
  /// In en, this message translates to:
  /// **'Now handled by {name}.'**
  String opsReassigned(String name);

  /// No description provided for @opsReopen.
  ///
  /// In en, this message translates to:
  /// **'Reopen'**
  String get opsReopen;

  /// No description provided for @opsReopenBody.
  ///
  /// In en, this message translates to:
  /// **'It will go back to the right step so the team can continue.'**
  String get opsReopenBody;

  /// No description provided for @opsReopenTitle.
  ///
  /// In en, this message translates to:
  /// **'Reopen this enquiry?'**
  String get opsReopenTitle;

  /// No description provided for @opsReopened.
  ///
  /// In en, this message translates to:
  /// **'Enquiry reopened.'**
  String get opsReopened;

  /// No description provided for @opsSections.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get opsSections;

  /// No description provided for @opsSource.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get opsSource;

  /// No description provided for @opsSourceLabel.
  ///
  /// In en, this message translates to:
  /// **'Came from'**
  String get opsSourceLabel;

  /// No description provided for @opsStageOf.
  ///
  /// In en, this message translates to:
  /// **'{stage}, step {done} of {total}'**
  String opsStageOf(String stage, String done, String total);

  /// No description provided for @opsVendorsSummary.
  ///
  /// In en, this message translates to:
  /// **'{accepted} accepted, {waiting} waiting'**
  String opsVendorsSummary(String accepted, String waiting);

  /// No description provided for @opsVerification.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get opsVerification;

  /// No description provided for @opsVerifiedBy.
  ///
  /// In en, this message translates to:
  /// **'Checked by'**
  String get opsVerifiedBy;

  /// No description provided for @otpChangeNumber.
  ///
  /// In en, this message translates to:
  /// **'Change number'**
  String get otpChangeNumber;

  /// No description provided for @otpDemoHint.
  ///
  /// In en, this message translates to:
  /// **'Demo code: {code}'**
  String otpDemoHint(String code);

  /// No description provided for @otpLabel.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get otpLabel;

  /// No description provided for @otpResend.
  ///
  /// In en, this message translates to:
  /// **'Send code again'**
  String get otpResend;

  /// No description provided for @otpResendIn.
  ///
  /// In en, this message translates to:
  /// **'Send again in {seconds}s'**
  String otpResendIn(String seconds);

  /// No description provided for @otpResent.
  ///
  /// In en, this message translates to:
  /// **'A new code has been sent.'**
  String get otpResent;

  /// No description provided for @otpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code sent to {phone}.'**
  String otpSubtitle(String phone);

  /// No description provided for @otpTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify your mobile number'**
  String get otpTitle;

  /// No description provided for @otpVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get otpVerify;

  /// No description provided for @outcomeCallBackLater.
  ///
  /// In en, this message translates to:
  /// **'Call back later'**
  String get outcomeCallBackLater;

  /// No description provided for @outcomeDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get outcomeDuplicate;

  /// No description provided for @outcomeGenuine.
  ///
  /// In en, this message translates to:
  /// **'Genuine'**
  String get outcomeGenuine;

  /// No description provided for @outcomeNoAnswer.
  ///
  /// In en, this message translates to:
  /// **'No answer'**
  String get outcomeNoAnswer;

  /// No description provided for @outcomeNotGenuine.
  ///
  /// In en, this message translates to:
  /// **'Not genuine'**
  String get outcomeNotGenuine;

  /// No description provided for @outcomeNotInterested.
  ///
  /// In en, this message translates to:
  /// **'Not interested'**
  String get outcomeNotInterested;

  /// No description provided for @outcomeWrongNumber.
  ///
  /// In en, this message translates to:
  /// **'Wrong number'**
  String get outcomeWrongNumber;

  /// No description provided for @outcomeWrongRequirement.
  ///
  /// In en, this message translates to:
  /// **'Wrong requirement'**
  String get outcomeWrongRequirement;

  /// No description provided for @overdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get overdue;

  /// No description provided for @payFull.
  ///
  /// In en, this message translates to:
  /// **'Fully paid'**
  String get payFull;

  /// No description provided for @payOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get payOverdue;

  /// No description provided for @payPartial.
  ///
  /// In en, this message translates to:
  /// **'Partly paid'**
  String get payPartial;

  /// No description provided for @payUnpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get payUnpaid;

  /// No description provided for @paymentAddProof.
  ///
  /// In en, this message translates to:
  /// **'Add a photo of the receipt'**
  String get paymentAddProof;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Paid by'**
  String get paymentMethod;

  /// No description provided for @paymentPayOnline.
  ///
  /// In en, this message translates to:
  /// **'Pay online'**
  String get paymentPayOnline;

  /// No description provided for @paymentProofAdded.
  ///
  /// In en, this message translates to:
  /// **'Receipt added'**
  String get paymentProofAdded;

  /// No description provided for @paymentRecord.
  ///
  /// In en, this message translates to:
  /// **'Record payment'**
  String get paymentRecord;

  /// No description provided for @paymentRecorded.
  ///
  /// In en, this message translates to:
  /// **'Payment of {amount} saved.'**
  String paymentRecorded(String amount);

  /// No description provided for @paymentReference.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get paymentReference;

  /// No description provided for @paymentReferenceHint.
  ///
  /// In en, this message translates to:
  /// **'UPI or cheque number'**
  String get paymentReferenceHint;

  /// No description provided for @paymentsCollected.
  ///
  /// In en, this message translates to:
  /// **'Collected'**
  String get paymentsCollected;

  /// No description provided for @paymentsDue.
  ///
  /// In en, this message translates to:
  /// **'Payment due'**
  String get paymentsDue;

  /// No description provided for @paymentsNoneDue.
  ///
  /// In en, this message translates to:
  /// **'Nothing is due'**
  String get paymentsNoneDue;

  /// No description provided for @paymentsOff.
  ///
  /// In en, this message translates to:
  /// **'Payment tracking is turned off by admin.'**
  String get paymentsOff;

  /// No description provided for @paymentsOutstanding.
  ///
  /// In en, this message translates to:
  /// **'Still to collect'**
  String get paymentsOutstanding;

  /// No description provided for @paymentsReceived.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get paymentsReceived;

  /// No description provided for @pendingBody.
  ///
  /// In en, this message translates to:
  /// **'We check every business before sending referrals. This usually takes one working day.'**
  String get pendingBody;

  /// No description provided for @pendingContact.
  ///
  /// In en, this message translates to:
  /// **'Contact support'**
  String get pendingContact;

  /// No description provided for @pendingRejectedBody.
  ///
  /// In en, this message translates to:
  /// **'Contact O2O Boss support to know more.'**
  String get pendingRejectedBody;

  /// No description provided for @pendingRejectedTitle.
  ///
  /// In en, this message translates to:
  /// **'Registration not approved'**
  String get pendingRejectedTitle;

  /// No description provided for @pendingStep1.
  ///
  /// In en, this message translates to:
  /// **'We verify your documents and details.'**
  String get pendingStep1;

  /// No description provided for @pendingStep2.
  ///
  /// In en, this message translates to:
  /// **'You get a notification when approved.'**
  String get pendingStep2;

  /// No description provided for @pendingStep3.
  ///
  /// In en, this message translates to:
  /// **'Verified customers start reaching you.'**
  String get pendingStep3;

  /// No description provided for @pendingSuspendedBody.
  ///
  /// In en, this message translates to:
  /// **'Your account is paused for now. Contact O2O Boss support.'**
  String get pendingSuspendedBody;

  /// No description provided for @pendingSuspendedTitle.
  ///
  /// In en, this message translates to:
  /// **'Account paused'**
  String get pendingSuspendedTitle;

  /// No description provided for @pendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Your business is being reviewed'**
  String get pendingTitle;

  /// No description provided for @pendingWhatNext.
  ///
  /// In en, this message translates to:
  /// **'What happens next'**
  String get pendingWhatNext;

  /// No description provided for @prAbout.
  ///
  /// In en, this message translates to:
  /// **'About this product'**
  String get prAbout;

  /// No description provided for @prAsk.
  ///
  /// In en, this message translates to:
  /// **'Ask'**
  String get prAsk;

  /// No description provided for @prAskHelp.
  ///
  /// In en, this message translates to:
  /// **'Your question goes to the O2O Boss team, not to a vendor. We reply in chat.'**
  String get prAskHelp;

  /// No description provided for @prAskHint.
  ///
  /// In en, this message translates to:
  /// **'For example: Is installation included?'**
  String get prAskHint;

  /// No description provided for @prAskLabel.
  ///
  /// In en, this message translates to:
  /// **'Your question'**
  String get prAskLabel;

  /// No description provided for @prAskTitle.
  ///
  /// In en, this message translates to:
  /// **'Ask about {product}'**
  String prAskTitle(String product);

  /// No description provided for @prBrandsAvailable.
  ///
  /// In en, this message translates to:
  /// **'Brands'**
  String get prBrandsAvailable;

  /// No description provided for @prCantFindBody.
  ///
  /// In en, this message translates to:
  /// **'Post a requirement and we\'ll find it for you.'**
  String get prCantFindBody;

  /// No description provided for @prCantFindTitle.
  ///
  /// In en, this message translates to:
  /// **'Can\'t find what you need?'**
  String get prCantFindTitle;

  /// No description provided for @prCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 product} other{{count} products}}'**
  String prCount(int count);

  /// No description provided for @prDeliverTo.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get prDeliverTo;

  /// No description provided for @prEnquire.
  ///
  /// In en, this message translates to:
  /// **'Enquire'**
  String get prEnquire;

  /// No description provided for @prFilterBrands.
  ///
  /// In en, this message translates to:
  /// **'Brands'**
  String get prFilterBrands;

  /// No description provided for @prFilterNear.
  ///
  /// In en, this message translates to:
  /// **'Only show what\'s available in {city}'**
  String prFilterNear(String city);

  /// No description provided for @prFrom.
  ///
  /// In en, this message translates to:
  /// **'From {price}'**
  String prFrom(String price);

  /// No description provided for @prHow1Body.
  ///
  /// In en, this message translates to:
  /// **'No payment now. Tell us what you need.'**
  String get prHow1Body;

  /// No description provided for @prHow1Title.
  ///
  /// In en, this message translates to:
  /// **'You send an enquiry'**
  String get prHow1Title;

  /// No description provided for @prHow2Body.
  ///
  /// In en, this message translates to:
  /// **'The O2O Boss team calls you and checks price and stock with verified sellers near you.'**
  String get prHow2Body;

  /// No description provided for @prHow2Title.
  ///
  /// In en, this message translates to:
  /// **'We find the right seller'**
  String get prHow2Title;

  /// No description provided for @prHow3Body.
  ///
  /// In en, this message translates to:
  /// **'See the final price and decide. You pay only after you accept.'**
  String get prHow3Body;

  /// No description provided for @prHow3Title.
  ///
  /// In en, this message translates to:
  /// **'You get a quotation'**
  String get prHow3Title;

  /// No description provided for @prHowTitle.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get prHowTitle;

  /// No description provided for @prLess.
  ///
  /// In en, this message translates to:
  /// **'One less'**
  String get prLess;

  /// No description provided for @prMore.
  ///
  /// In en, this message translates to:
  /// **'One more'**
  String get prMore;

  /// No description provided for @prNotNear.
  ///
  /// In en, this message translates to:
  /// **'No verified seller in {city} yet. Enquire anyway and we\'ll find one.'**
  String prNotNear(String city);

  /// No description provided for @prNoteHint.
  ///
  /// In en, this message translates to:
  /// **'For example: size, colour or a preferred day'**
  String get prNoteHint;

  /// No description provided for @prNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Anything we should know?'**
  String get prNoteLabel;

  /// No description provided for @prOpenRequest.
  ///
  /// In en, this message translates to:
  /// **'You already have an open request for this ({id}).'**
  String prOpenRequest(String id);

  /// No description provided for @prOrderFootnote.
  ///
  /// In en, this message translates to:
  /// **'No payment now. We\'ll call you with the best price.'**
  String get prOrderFootnote;

  /// No description provided for @prOrderNow.
  ///
  /// In en, this message translates to:
  /// **'Enquire now'**
  String get prOrderNow;

  /// No description provided for @prOrderPlaced.
  ///
  /// In en, this message translates to:
  /// **'Enquiry sent. The O2O Boss team will call you soon.'**
  String get prOrderPlaced;

  /// No description provided for @prOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'Enquire about {product}'**
  String prOrderTitle(String product);

  /// No description provided for @prPhotoLabel.
  ///
  /// In en, this message translates to:
  /// **'Photo {index} of {count}'**
  String prPhotoLabel(String index, String count);

  /// No description provided for @prPlaceOrder.
  ///
  /// In en, this message translates to:
  /// **'Send enquiry'**
  String get prPlaceOrder;

  /// No description provided for @prPriceNote.
  ///
  /// In en, this message translates to:
  /// **'Estimated price. Your final price comes in the quotation.'**
  String get prPriceNote;

  /// No description provided for @prPriceOnQuote.
  ///
  /// In en, this message translates to:
  /// **'Price on quotation'**
  String get prPriceOnQuote;

  /// No description provided for @prPriceRange.
  ///
  /// In en, this message translates to:
  /// **'{from} to {to}'**
  String prPriceRange(String from, String to);

  /// No description provided for @prPrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'You deal with O2O Boss, not the seller directly. We stay with you until the job is done.'**
  String get prPrivacyNote;

  /// No description provided for @prQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get prQuantity;

  /// No description provided for @prSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search products and services'**
  String get prSearchHint;

  /// No description provided for @prSellerAbout.
  ///
  /// In en, this message translates to:
  /// **'About this seller'**
  String get prSellerAbout;

  /// No description provided for @prSellerAreas.
  ///
  /// In en, this message translates to:
  /// **'Serves {areas}'**
  String prSellerAreas(String areas);

  /// No description provided for @prSellerBrands.
  ///
  /// In en, this message translates to:
  /// **'Brands: {brands}'**
  String prSellerBrands(String brands);

  /// No description provided for @prSellerCode.
  ///
  /// In en, this message translates to:
  /// **'Seller {code}'**
  String prSellerCode(String code);

  /// No description provided for @prSellerPicked.
  ///
  /// In en, this message translates to:
  /// **'Seller you picked'**
  String get prSellerPicked;

  /// No description provided for @prSellerRating.
  ///
  /// In en, this message translates to:
  /// **'Rated {rating} out of 5 by customers'**
  String prSellerRating(String rating);

  /// No description provided for @prSellerReplies.
  ///
  /// In en, this message translates to:
  /// **'Replies to {percent}% of requests on time'**
  String prSellerReplies(String percent);

  /// No description provided for @prSellerSince.
  ///
  /// In en, this message translates to:
  /// **'With O2O Boss since {year}'**
  String prSellerSince(String year);

  /// No description provided for @prSellerTitle.
  ///
  /// In en, this message translates to:
  /// **'Verified seller in {place}'**
  String prSellerTitle(String place);

  /// No description provided for @prSellerVerified.
  ///
  /// In en, this message translates to:
  /// **'Documents checked by O2O Boss'**
  String get prSellerVerified;

  /// No description provided for @prSellersHelp.
  ///
  /// In en, this message translates to:
  /// **'Open a seller to see their page. Your enquiry still goes through O2O Boss.'**
  String get prSellersHelp;

  /// No description provided for @prSellersTitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Seller near you} other{Sellers near you}}'**
  String prSellersTitle(int count);

  /// No description provided for @prSortFilter.
  ///
  /// In en, this message translates to:
  /// **'Sort and filter'**
  String get prSortFilter;

  /// No description provided for @prSortName.
  ///
  /// In en, this message translates to:
  /// **'Name: A to Z'**
  String get prSortName;

  /// No description provided for @prSortPopular.
  ///
  /// In en, this message translates to:
  /// **'Most popular'**
  String get prSortPopular;

  /// No description provided for @prSortPriceHigh.
  ///
  /// In en, this message translates to:
  /// **'Price: high to low'**
  String get prSortPriceHigh;

  /// No description provided for @prSortPriceLow.
  ///
  /// In en, this message translates to:
  /// **'Price: low to high'**
  String get prSortPriceLow;

  /// No description provided for @prSortTitle.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get prSortTitle;

  /// No description provided for @prUnitEach.
  ///
  /// In en, this message translates to:
  /// **'each'**
  String get prUnitEach;

  /// No description provided for @prUnitGram.
  ///
  /// In en, this message translates to:
  /// **'per gram'**
  String get prUnitGram;

  /// No description provided for @prUnitKw.
  ///
  /// In en, this message translates to:
  /// **'per kW'**
  String get prUnitKw;

  /// No description provided for @prUnitSqft.
  ///
  /// In en, this message translates to:
  /// **'per sq ft'**
  String get prUnitSqft;

  /// No description provided for @prUnitVisit.
  ///
  /// In en, this message translates to:
  /// **'per visit'**
  String get prUnitVisit;

  /// No description provided for @prVendorsNear.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 verified seller in {city}} other{{count} verified sellers in {city}}}'**
  String prVendorsNear(int count, String city);

  /// No description provided for @prViewRequest.
  ///
  /// In en, this message translates to:
  /// **'View request'**
  String get prViewRequest;

  /// No description provided for @priorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get priorityHigh;

  /// No description provided for @priorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get priorityLow;

  /// No description provided for @priorityNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get priorityNormal;

  /// No description provided for @priorityUrgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get priorityUrgent;

  /// No description provided for @privacy1Body.
  ///
  /// In en, this message translates to:
  /// **'Your name, mobile number, city and the details you share about requirements, quotations and payments.'**
  String get privacy1Body;

  /// No description provided for @privacy1Title.
  ///
  /// In en, this message translates to:
  /// **'What we collect'**
  String get privacy1Title;

  /// No description provided for @privacy2Body.
  ///
  /// In en, this message translates to:
  /// **'To verify requirements, connect you with vendors, send updates and calculate commissions.'**
  String get privacy2Body;

  /// No description provided for @privacy2Title.
  ///
  /// In en, this message translates to:
  /// **'How we use it'**
  String get privacy2Title;

  /// No description provided for @privacy3Body.
  ///
  /// In en, this message translates to:
  /// **'Each role sees only what it needs. Customer phone numbers are not shared with vendors unless O2O Boss allows it.'**
  String get privacy3Body;

  /// No description provided for @privacy3Title.
  ///
  /// In en, this message translates to:
  /// **'Who can see it'**
  String get privacy3Title;

  /// No description provided for @privacy4Body.
  ///
  /// In en, this message translates to:
  /// **'Calls with our team may be recorded for quality and dispute resolution. All actions are logged for safety.'**
  String get privacy4Body;

  /// No description provided for @privacy4Title.
  ///
  /// In en, this message translates to:
  /// **'Calls and records'**
  String get privacy4Title;

  /// No description provided for @profileAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get profileAccount;

  /// No description provided for @profileBankAccount.
  ///
  /// In en, this message translates to:
  /// **'Bank account number'**
  String get profileBankAccount;

  /// No description provided for @profileChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get profileChangePassword;

  /// No description provided for @profileDemo.
  ///
  /// In en, this message translates to:
  /// **'Demo'**
  String get profileDemo;

  /// No description provided for @profileEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get profileEdit;

  /// No description provided for @profileIfsc.
  ///
  /// In en, this message translates to:
  /// **'IFSC code'**
  String get profileIfsc;

  /// No description provided for @profileNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get profileNotifications;

  /// No description provided for @profilePayoutNote.
  ///
  /// In en, this message translates to:
  /// **'Commissions are paid to these details. Double-check them.'**
  String get profilePayoutNote;

  /// No description provided for @profilePhoneHelp.
  ///
  /// In en, this message translates to:
  /// **'To change your mobile number, contact support.'**
  String get profilePhoneHelp;

  /// No description provided for @profilePreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get profilePreferences;

  /// No description provided for @profileResetDemo.
  ///
  /// In en, this message translates to:
  /// **'Reset demo data'**
  String get profileResetDemo;

  /// No description provided for @profileResetDemoBody.
  ///
  /// In en, this message translates to:
  /// **'Go back to the original sample data.'**
  String get profileResetDemoBody;

  /// No description provided for @profileResetDemoConfirm.
  ///
  /// In en, this message translates to:
  /// **'All changes made in this demo, by every role, will be removed.'**
  String get profileResetDemoConfirm;

  /// No description provided for @profileResetDemoDone.
  ///
  /// In en, this message translates to:
  /// **'Demo data has been reset.'**
  String get profileResetDemoDone;

  /// No description provided for @profileResetDemoTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset demo data?'**
  String get profileResetDemoTitle;

  /// No description provided for @profileSupport.
  ///
  /// In en, this message translates to:
  /// **'Help and legal'**
  String get profileSupport;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileUpi.
  ///
  /// In en, this message translates to:
  /// **'UPI ID'**
  String get profileUpi;

  /// No description provided for @profileUserId.
  ///
  /// In en, this message translates to:
  /// **'User ID: {id}'**
  String profileUserId(String id);

  /// No description provided for @profileVersion.
  ///
  /// In en, this message translates to:
  /// **'O2O Boss {version}, demo version'**
  String profileVersion(String version);

  /// No description provided for @projectBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance {amount}'**
  String projectBalance(String amount);

  /// No description provided for @projectBalanceDue.
  ///
  /// In en, this message translates to:
  /// **'Balance {amount}, due {date}'**
  String projectBalanceDue(String amount, String date);

  /// No description provided for @projectCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel project'**
  String get projectCancel;

  /// No description provided for @projectCancelBody.
  ///
  /// In en, this message translates to:
  /// **'Unpaid commissions will be put on hold for admin to decide.'**
  String get projectCancelBody;

  /// No description provided for @projectCancelCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer cancelled'**
  String get projectCancelCustomer;

  /// No description provided for @projectCancelVendor.
  ///
  /// In en, this message translates to:
  /// **'Vendor could not deliver'**
  String get projectCancelVendor;

  /// No description provided for @projectCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get projectCancelled;

  /// No description provided for @projectCompleteBody.
  ///
  /// In en, this message translates to:
  /// **'The customer will be asked for feedback and payment follow-up begins.'**
  String get projectCompleteBody;

  /// No description provided for @projectCompleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Mark completed'**
  String get projectCompleteConfirm;

  /// No description provided for @projectCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Mark the work as completed?'**
  String get projectCompleteTitle;

  /// No description provided for @projectCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get projectCompleted;

  /// No description provided for @projectCompletedOn.
  ///
  /// In en, this message translates to:
  /// **'Completed on'**
  String get projectCompletedOn;

  /// No description provided for @projectCreateNote.
  ///
  /// In en, this message translates to:
  /// **'The customer, vendor and referral partner will see the progress.'**
  String get projectCreateNote;

  /// No description provided for @projectCreateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set the dates. You can change them later.'**
  String get projectCreateSubtitle;

  /// No description provided for @projectCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create project'**
  String get projectCreateTitle;

  /// No description provided for @projectCreated.
  ///
  /// In en, this message translates to:
  /// **'Project {id} created.'**
  String projectCreated(String id);

  /// No description provided for @projectExpectedEnd.
  ///
  /// In en, this message translates to:
  /// **'Expected completion'**
  String get projectExpectedEnd;

  /// No description provided for @projectHold.
  ///
  /// In en, this message translates to:
  /// **'Put on hold'**
  String get projectHold;

  /// No description provided for @projectInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get projectInProgress;

  /// No description provided for @projectNotStarted.
  ///
  /// In en, this message translates to:
  /// **'Not started'**
  String get projectNotStarted;

  /// No description provided for @projectOnHold.
  ///
  /// In en, this message translates to:
  /// **'On hold'**
  String get projectOnHold;

  /// No description provided for @projectOnHoldNote.
  ///
  /// In en, this message translates to:
  /// **'On hold: {reason}'**
  String projectOnHoldNote(String reason);

  /// No description provided for @projectOpenEnquiry.
  ///
  /// In en, this message translates to:
  /// **'Open enquiry {id}'**
  String projectOpenEnquiry(String id);

  /// No description provided for @projectPaidOf.
  ///
  /// In en, this message translates to:
  /// **'{paid} paid of {total}'**
  String projectPaidOf(String paid, String total);

  /// No description provided for @projectPaymentDue.
  ///
  /// In en, this message translates to:
  /// **'Payment due by'**
  String get projectPaymentDue;

  /// No description provided for @projectPayments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get projectPayments;

  /// No description provided for @projectResume.
  ///
  /// In en, this message translates to:
  /// **'Resume work'**
  String get projectResume;

  /// No description provided for @projectStart.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get projectStart;

  /// No description provided for @projectSteps.
  ///
  /// In en, this message translates to:
  /// **'Work steps'**
  String get projectSteps;

  /// No description provided for @qAssign.
  ///
  /// In en, this message translates to:
  /// **'Need a vendor'**
  String get qAssign;

  /// No description provided for @qPayment.
  ///
  /// In en, this message translates to:
  /// **'Payments and commission'**
  String get qPayment;

  /// No description provided for @qProject.
  ///
  /// In en, this message translates to:
  /// **'Work in progress'**
  String get qProject;

  /// No description provided for @qQualify.
  ///
  /// In en, this message translates to:
  /// **'To qualify'**
  String get qQualify;

  /// No description provided for @qQuote.
  ///
  /// In en, this message translates to:
  /// **'Quotations'**
  String get qQuote;

  /// No description provided for @qVendorReply.
  ///
  /// In en, this message translates to:
  /// **'Waiting for vendor'**
  String get qVendorReply;

  /// No description provided for @qVerify.
  ///
  /// In en, this message translates to:
  /// **'To verify'**
  String get qVerify;

  /// No description provided for @qVisit.
  ///
  /// In en, this message translates to:
  /// **'Visits'**
  String get qVisit;

  /// No description provided for @qaSubAddUser.
  ///
  /// In en, this message translates to:
  /// **'Create a login'**
  String get qaSubAddUser;

  /// No description provided for @qaSubAudit.
  ///
  /// In en, this message translates to:
  /// **'Who changed what'**
  String get qaSubAudit;

  /// No description provided for @qaSubBusiness.
  ///
  /// In en, this message translates to:
  /// **'Your company details'**
  String get qaSubBusiness;

  /// No description provided for @qaSubCalls.
  ///
  /// In en, this message translates to:
  /// **'Calls made and received'**
  String get qaSubCalls;

  /// No description provided for @qaSubChat.
  ///
  /// In en, this message translates to:
  /// **'Customers and vendors'**
  String get qaSubChat;

  /// No description provided for @qaSubHelp.
  ///
  /// In en, this message translates to:
  /// **'Questions and support'**
  String get qaSubHelp;

  /// No description provided for @qaSubMessages.
  ///
  /// In en, this message translates to:
  /// **'Chat with O2O Boss'**
  String get qaSubMessages;

  /// No description provided for @qaSubNewEnquiry.
  ///
  /// In en, this message translates to:
  /// **'Add a customer\'s need'**
  String get qaSubNewEnquiry;

  /// No description provided for @qaSubNewRequirement.
  ///
  /// In en, this message translates to:
  /// **'Tell us what you need'**
  String get qaSubNewRequirement;

  /// No description provided for @qaSubPayments.
  ///
  /// In en, this message translates to:
  /// **'Money received'**
  String get qaSubPayments;

  /// No description provided for @qaSubQuotations.
  ///
  /// In en, this message translates to:
  /// **'Compare and decide'**
  String get qaSubQuotations;

  /// No description provided for @qaSubReports.
  ///
  /// In en, this message translates to:
  /// **'See how it\'s going'**
  String get qaSubReports;

  /// No description provided for @qaSubSettings.
  ///
  /// In en, this message translates to:
  /// **'Rules and options'**
  String get qaSubSettings;

  /// No description provided for @qaSubTrack.
  ///
  /// In en, this message translates to:
  /// **'Track progress'**
  String get qaSubTrack;

  /// No description provided for @qaSubVisits.
  ///
  /// In en, this message translates to:
  /// **'Plan your visits'**
  String get qaSubVisits;

  /// No description provided for @qualifyComplete.
  ///
  /// In en, this message translates to:
  /// **'Mark as qualified'**
  String get qualifyComplete;

  /// No description provided for @qualifyDone.
  ///
  /// In en, this message translates to:
  /// **'Qualified. Now choose a vendor.'**
  String get qualifyDone;

  /// No description provided for @qualifyLocked.
  ///
  /// In en, this message translates to:
  /// **'This enquiry is qualified and already with vendors.'**
  String get qualifyLocked;

  /// No description provided for @qualifySaveLater.
  ///
  /// In en, this message translates to:
  /// **'Save for later'**
  String get qualifySaveLater;

  /// No description provided for @qualifySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Questions for {category}. Required ones are marked with *.'**
  String qualifySubtitle(String category);

  /// No description provided for @qualifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Qualification'**
  String get qualifyTitle;

  /// No description provided for @qualifyValueHelp.
  ///
  /// In en, this message translates to:
  /// **'Your best guess of the order value. Helps vendors and reports.'**
  String get qualifyValueHelp;

  /// No description provided for @questionNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get questionNo;

  /// No description provided for @questionYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get questionYes;

  /// No description provided for @quoteAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get quoteAccept;

  /// No description provided for @quoteAcceptAgree.
  ///
  /// In en, this message translates to:
  /// **'I accept the items, price and terms in this quotation.'**
  String get quoteAcceptAgree;

  /// No description provided for @quoteAcceptTitle.
  ///
  /// In en, this message translates to:
  /// **'Accept this quotation'**
  String get quoteAcceptTitle;

  /// No description provided for @quoteAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get quoteAccepted;

  /// No description provided for @quoteAcceptedOn.
  ///
  /// In en, this message translates to:
  /// **'Accepted on {date}.'**
  String quoteAcceptedOn(String date);

  /// No description provided for @quoteAcceptedTitle.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get quoteAcceptedTitle;

  /// No description provided for @quoteAcceptedToast.
  ///
  /// In en, this message translates to:
  /// **'Accepted. The vendor will start the work.'**
  String get quoteAcceptedToast;

  /// No description provided for @quoteApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve and send'**
  String get quoteApprove;

  /// No description provided for @quoteApproved.
  ///
  /// In en, this message translates to:
  /// **'Sent to the customer.'**
  String get quoteApproved;

  /// No description provided for @quoteAskChanges.
  ///
  /// In en, this message translates to:
  /// **'Ask for changes'**
  String get quoteAskChanges;

  /// No description provided for @quoteAskChangesHint.
  ///
  /// In en, this message translates to:
  /// **'For example: reduce the installation charge'**
  String get quoteAskChangesHint;

  /// No description provided for @quoteAskChangesLabel.
  ///
  /// In en, this message translates to:
  /// **'Message to the vendor'**
  String get quoteAskChangesLabel;

  /// No description provided for @quoteAskChangesLabelCustomer.
  ///
  /// In en, this message translates to:
  /// **'What would you like changed?'**
  String get quoteAskChangesLabelCustomer;

  /// No description provided for @quoteAskChangesSub.
  ///
  /// In en, this message translates to:
  /// **'The vendor will send a new version.'**
  String get quoteAskChangesSub;

  /// No description provided for @quoteAskChangesTitle.
  ///
  /// In en, this message translates to:
  /// **'What should change?'**
  String get quoteAskChangesTitle;

  /// No description provided for @quoteAttachment.
  ///
  /// In en, this message translates to:
  /// **'Attachment'**
  String get quoteAttachment;

  /// No description provided for @quoteChangesSent.
  ///
  /// In en, this message translates to:
  /// **'Sent to the vendor.'**
  String get quoteChangesSent;

  /// No description provided for @quoteChangesSentCustomer.
  ///
  /// In en, this message translates to:
  /// **'Your request was sent. You\'ll get a new version.'**
  String get quoteChangesSentCustomer;

  /// No description provided for @quoteCopySent.
  ///
  /// In en, this message translates to:
  /// **'Copy sent to {email}.'**
  String quoteCopySent(String email);

  /// No description provided for @quoteCustomerChanges.
  ///
  /// In en, this message translates to:
  /// **'Not yet'**
  String get quoteCustomerChanges;

  /// No description provided for @quoteCustomerNote.
  ///
  /// In en, this message translates to:
  /// **'Take your time. Ask us anything in the chat.'**
  String get quoteCustomerNote;

  /// No description provided for @quoteDays.
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String quoteDays(String days);

  /// No description provided for @quoteDecline.
  ///
  /// In en, this message translates to:
  /// **'Decline quotation'**
  String get quoteDecline;

  /// No description provided for @quoteDeclineElsewhere.
  ///
  /// In en, this message translates to:
  /// **'Going with another option'**
  String get quoteDeclineElsewhere;

  /// No description provided for @quoteDeclineLater.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get quoteDeclineLater;

  /// No description provided for @quoteDeclinePrice.
  ///
  /// In en, this message translates to:
  /// **'Price is too high'**
  String get quoteDeclinePrice;

  /// No description provided for @quoteDeclineSub.
  ///
  /// In en, this message translates to:
  /// **'Tell us why so we can help.'**
  String get quoteDeclineSub;

  /// No description provided for @quoteDeclined.
  ///
  /// In en, this message translates to:
  /// **'Quotation declined.'**
  String get quoteDeclined;

  /// No description provided for @quoteDeclinedReason.
  ///
  /// In en, this message translates to:
  /// **'Declined'**
  String get quoteDeclinedReason;

  /// No description provided for @quoteDelivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get quoteDelivery;

  /// No description provided for @quoteDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get quoteDiscount;

  /// No description provided for @quoteDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get quoteDraft;

  /// No description provided for @quoteDraftSaved.
  ///
  /// In en, this message translates to:
  /// **'Draft saved.'**
  String get quoteDraftSaved;

  /// No description provided for @quoteExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get quoteExpired;

  /// No description provided for @quoteFormAddItem.
  ///
  /// In en, this message translates to:
  /// **'Add another item'**
  String get quoteFormAddItem;

  /// No description provided for @quoteFormAttach.
  ///
  /// In en, this message translates to:
  /// **'Add file'**
  String get quoteFormAttach;

  /// No description provided for @quoteFormCharges.
  ///
  /// In en, this message translates to:
  /// **'Other charges'**
  String get quoteFormCharges;

  /// No description provided for @quoteFormDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get quoteFormDescription;

  /// No description provided for @quoteFormEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit quotation'**
  String get quoteFormEdit;

  /// No description provided for @quoteFormItem.
  ///
  /// In en, this message translates to:
  /// **'Item {n}'**
  String quoteFormItem(String n);

  /// No description provided for @quoteFormNeedItem.
  ///
  /// In en, this message translates to:
  /// **'Add at least one item with a price.'**
  String get quoteFormNeedItem;

  /// No description provided for @quoteFormNew.
  ///
  /// In en, this message translates to:
  /// **'New quotation'**
  String get quoteFormNew;

  /// No description provided for @quoteFormQty.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get quoteFormQty;

  /// No description provided for @quoteFormReviewNote.
  ///
  /// In en, this message translates to:
  /// **'Back office checks every quotation before the customer sees it.'**
  String get quoteFormReviewNote;

  /// No description provided for @quoteFormRevise.
  ///
  /// In en, this message translates to:
  /// **'Revised quotation, version {version}'**
  String quoteFormRevise(String version);

  /// No description provided for @quoteFormTax.
  ///
  /// In en, this message translates to:
  /// **'GST'**
  String get quoteFormTax;

  /// No description provided for @quoteFormTotalLine.
  ///
  /// In en, this message translates to:
  /// **'Items {subtotal}, GST {tax}'**
  String quoteFormTotalLine(String subtotal, String tax);

  /// No description provided for @quoteFormUnitPrice.
  ///
  /// In en, this message translates to:
  /// **'Price per unit'**
  String get quoteFormUnitPrice;

  /// No description provided for @quoteInclTax.
  ///
  /// In en, this message translates to:
  /// **'Includes {percent} GST'**
  String quoteInclTax(String percent);

  /// No description provided for @quoteInstallation.
  ///
  /// In en, this message translates to:
  /// **'Installation'**
  String get quoteInstallation;

  /// No description provided for @quoteItems.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get quoteItems;

  /// No description provided for @quoteNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get quoteNew;

  /// No description provided for @quoteNumber.
  ///
  /// In en, this message translates to:
  /// **'{number}, version {version}'**
  String quoteNumber(String number, String version);

  /// No description provided for @quoteOtherVersions.
  ///
  /// In en, this message translates to:
  /// **'Other versions'**
  String get quoteOtherVersions;

  /// No description provided for @quoteQtyLine.
  ///
  /// In en, this message translates to:
  /// **'{qty} × {price}'**
  String quoteQtyLine(String qty, String price);

  /// No description provided for @quoteRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get quoteRejected;

  /// No description provided for @quoteReviewNote.
  ///
  /// In en, this message translates to:
  /// **'Check prices, items and terms before the customer sees it.'**
  String get quoteReviewNote;

  /// No description provided for @quoteRevise.
  ///
  /// In en, this message translates to:
  /// **'Send a revised version'**
  String get quoteRevise;

  /// No description provided for @quoteRevisionAsked.
  ///
  /// In en, this message translates to:
  /// **'Changes asked for'**
  String get quoteRevisionAsked;

  /// No description provided for @quoteRevisionRequested.
  ///
  /// In en, this message translates to:
  /// **'Changes requested'**
  String get quoteRevisionRequested;

  /// No description provided for @quoteSaveDraft.
  ///
  /// In en, this message translates to:
  /// **'Save draft'**
  String get quoteSaveDraft;

  /// No description provided for @quoteSendToVendor.
  ///
  /// In en, this message translates to:
  /// **'Send to vendor'**
  String get quoteSendToVendor;

  /// No description provided for @quoteSent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get quoteSent;

  /// No description provided for @quoteSignHelp.
  ///
  /// In en, this message translates to:
  /// **'This works as your signature.'**
  String get quoteSignHelp;

  /// No description provided for @quoteSignLabel.
  ///
  /// In en, this message translates to:
  /// **'Type your full name to sign'**
  String get quoteSignLabel;

  /// No description provided for @quoteSignedBy.
  ///
  /// In en, this message translates to:
  /// **'Signed by {name} on {date}.'**
  String quoteSignedBy(String name, String date);

  /// No description provided for @quoteSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get quoteSubmit;

  /// No description provided for @quoteSubmitBody.
  ///
  /// In en, this message translates to:
  /// **'O2O Boss will check it and send it to the customer. You can\'t edit it after this.'**
  String get quoteSubmitBody;

  /// No description provided for @quoteSubmitTitle.
  ///
  /// In en, this message translates to:
  /// **'Submit this quotation?'**
  String get quoteSubmitTitle;

  /// No description provided for @quoteSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Under review'**
  String get quoteSubmitted;

  /// No description provided for @quoteSubmittedToast.
  ///
  /// In en, this message translates to:
  /// **'Quotation submitted for review.'**
  String get quoteSubmittedToast;

  /// No description provided for @quoteSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get quoteSubtotal;

  /// No description provided for @quoteSuperseded.
  ///
  /// In en, this message translates to:
  /// **'Replaced'**
  String get quoteSuperseded;

  /// No description provided for @quoteSupersededNote.
  ///
  /// In en, this message translates to:
  /// **'A newer version of this quotation exists.'**
  String get quoteSupersededNote;

  /// No description provided for @quoteTax.
  ///
  /// In en, this message translates to:
  /// **'GST {percent}'**
  String quoteTax(String percent);

  /// No description provided for @quoteTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms'**
  String get quoteTerms;

  /// No description provided for @quoteTermsLabel.
  ///
  /// In en, this message translates to:
  /// **'Terms and warranty'**
  String get quoteTermsLabel;

  /// No description provided for @quoteTimeline.
  ///
  /// In en, this message translates to:
  /// **'Work takes'**
  String get quoteTimeline;

  /// No description provided for @quoteValidUntil.
  ///
  /// In en, this message translates to:
  /// **'Valid until {date}'**
  String quoteValidUntil(String date);

  /// No description provided for @quoteValidity.
  ///
  /// In en, this message translates to:
  /// **'Valid for'**
  String get quoteValidity;

  /// No description provided for @quoteViewed.
  ///
  /// In en, this message translates to:
  /// **'Viewed'**
  String get quoteViewed;

  /// No description provided for @quotesCopyNote.
  ///
  /// In en, this message translates to:
  /// **'A copy of every quotation is sent to {email}.'**
  String quotesCopyNote(String email);

  /// No description provided for @quotesEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Quotations from vendors will appear here after the site visit.'**
  String get quotesEmptyBody;

  /// No description provided for @quotesToReview.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 quotation is waiting for your review.} other{{count} quotations are waiting for your review.}}'**
  String quotesToReview(int count);

  /// No description provided for @referAnother.
  ///
  /// In en, this message translates to:
  /// **'Refer another customer'**
  String get referAnother;

  /// No description provided for @referConsent.
  ///
  /// In en, this message translates to:
  /// **'The customer knows about this referral and agreed to be contacted by O2O Boss.'**
  String get referConsent;

  /// No description provided for @referConsentCustomer.
  ///
  /// In en, this message translates to:
  /// **'I agree to be contacted by O2O Boss and its partner vendors about this requirement.'**
  String get referConsentCustomer;

  /// No description provided for @referConsentError.
  ///
  /// In en, this message translates to:
  /// **'Tick the box to confirm.'**
  String get referConsentError;

  /// No description provided for @referContactLabel.
  ///
  /// In en, this message translates to:
  /// **'How should we contact the customer?'**
  String get referContactLabel;

  /// No description provided for @referContactLabelCustomer.
  ///
  /// In en, this message translates to:
  /// **'How should we contact you?'**
  String get referContactLabelCustomer;

  /// No description provided for @referCustomerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll call this number to confirm the requirement.'**
  String get referCustomerSubtitle;

  /// No description provided for @referCustomerTitle.
  ///
  /// In en, this message translates to:
  /// **'Who is the customer?'**
  String get referCustomerTitle;

  /// No description provided for @referDoneId.
  ///
  /// In en, this message translates to:
  /// **'Enquiry ID {id}'**
  String referDoneId(String id);

  /// No description provided for @referDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Referral sent'**
  String get referDoneTitle;

  /// No description provided for @referDoneTitleCustomer.
  ///
  /// In en, this message translates to:
  /// **'Requirement posted'**
  String get referDoneTitleCustomer;

  /// No description provided for @referDuplicateBody.
  ///
  /// In en, this message translates to:
  /// **'{id} for {category} is still open for this number. A new referral for the same need may not count.'**
  String referDuplicateBody(String id, String category);

  /// No description provided for @referDuplicateCheck.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get referDuplicateCheck;

  /// No description provided for @referDuplicateContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue anyway'**
  String get referDuplicateContinue;

  /// No description provided for @referDuplicateTitle.
  ///
  /// In en, this message translates to:
  /// **'This customer is already referred'**
  String get referDuplicateTitle;

  /// No description provided for @referHow1Body.
  ///
  /// In en, this message translates to:
  /// **'Takes about a minute. Tell the customer we will call them.'**
  String get referHow1Body;

  /// No description provided for @referHow1Title.
  ///
  /// In en, this message translates to:
  /// **'Share the customer\'s details'**
  String get referHow1Title;

  /// No description provided for @referHow2Body.
  ///
  /// In en, this message translates to:
  /// **'Our team confirms the need and connects a trusted vendor nearby.'**
  String get referHow2Body;

  /// No description provided for @referHow2Title.
  ///
  /// In en, this message translates to:
  /// **'We verify and find a vendor'**
  String get referHow2Title;

  /// No description provided for @referHow3Body.
  ///
  /// In en, this message translates to:
  /// **'Follow every step here. Your commission is added when the customer pays.'**
  String get referHow3Body;

  /// No description provided for @referHow3Title.
  ///
  /// In en, this message translates to:
  /// **'You earn when it\'s paid'**
  String get referHow3Title;

  /// No description provided for @referHowTitle.
  ///
  /// In en, this message translates to:
  /// **'How referrals work'**
  String get referHowTitle;

  /// No description provided for @referNeedTitle.
  ///
  /// In en, this message translates to:
  /// **'What do they need?'**
  String get referNeedTitle;

  /// No description provided for @referNeedTitleCustomer.
  ///
  /// In en, this message translates to:
  /// **'What do you need?'**
  String get referNeedTitleCustomer;

  /// No description provided for @referNext1Body.
  ///
  /// In en, this message translates to:
  /// **'Our team will call the customer, usually within a few hours.'**
  String get referNext1Body;

  /// No description provided for @referNext1BodyCustomer.
  ///
  /// In en, this message translates to:
  /// **'Our team will call you, usually within a few hours.'**
  String get referNext1BodyCustomer;

  /// No description provided for @referNext1Title.
  ///
  /// In en, this message translates to:
  /// **'We call to verify'**
  String get referNext1Title;

  /// No description provided for @referNext2Body.
  ///
  /// In en, this message translates to:
  /// **'We pick a verified vendor nearby who serves this need.'**
  String get referNext2Body;

  /// No description provided for @referNext2Title.
  ///
  /// In en, this message translates to:
  /// **'A trusted vendor is connected'**
  String get referNext2Title;

  /// No description provided for @referNext3Body.
  ///
  /// In en, this message translates to:
  /// **'You can follow each step and your earning in the app.'**
  String get referNext3Body;

  /// No description provided for @referNext3BodyCustomer.
  ///
  /// In en, this message translates to:
  /// **'You\'ll get the quotation here to accept or ask for changes.'**
  String get referNext3BodyCustomer;

  /// No description provided for @referNext3Title.
  ///
  /// In en, this message translates to:
  /// **'Quotation and work'**
  String get referNext3Title;

  /// No description provided for @referNotSure.
  ///
  /// In en, this message translates to:
  /// **'Not sure? Describe the need'**
  String get referNotSure;

  /// No description provided for @referOtpNote.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send a code to the customer\'s mobile to confirm the number.'**
  String get referOtpNote;

  /// No description provided for @referPlaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Where is the work?'**
  String get referPlaceTitle;

  /// No description provided for @referPreferredTime.
  ///
  /// In en, this message translates to:
  /// **'Best time to call'**
  String get referPreferredTime;

  /// No description provided for @referPreferredTimeHint.
  ///
  /// In en, this message translates to:
  /// **'For example: after 6 pm'**
  String get referPreferredTimeHint;

  /// No description provided for @referPrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'The customer\'s number is only shared with O2O Boss. Vendors contact them through us.'**
  String get referPrivacyNote;

  /// No description provided for @referRequirementError.
  ///
  /// In en, this message translates to:
  /// **'Add a few words about the requirement.'**
  String get referRequirementError;

  /// No description provided for @referRequirementHint.
  ///
  /// In en, this message translates to:
  /// **'For example: 4 cameras for a 2-floor house, with night vision'**
  String get referRequirementHint;

  /// No description provided for @referReviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Make sure everything is right. You can change any part.'**
  String get referReviewSubtitle;

  /// No description provided for @referReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Check and send'**
  String get referReviewTitle;

  /// No description provided for @referRulesBody.
  ///
  /// In en, this message translates to:
  /// **'You earn {percent} of the final order value when {trigger}. Your referral is protected for {days} days.'**
  String referRulesBody(String percent, String trigger, String days);

  /// No description provided for @referSubmit.
  ///
  /// In en, this message translates to:
  /// **'Send referral'**
  String get referSubmit;

  /// No description provided for @referSubmitCustomer.
  ///
  /// In en, this message translates to:
  /// **'Post requirement'**
  String get referSubmitCustomer;

  /// No description provided for @referTabSubtitle.
  ///
  /// In en, this message translates to:
  /// **'What does your customer need? Tap one to start.'**
  String get referTabSubtitle;

  /// No description provided for @referTabTitle.
  ///
  /// In en, this message translates to:
  /// **'Refer'**
  String get referTabTitle;

  /// No description provided for @referTitle.
  ///
  /// In en, this message translates to:
  /// **'Refer a customer'**
  String get referTitle;

  /// No description provided for @referTitleCustomer.
  ///
  /// In en, this message translates to:
  /// **'New requirement'**
  String get referTitleCustomer;

  /// No description provided for @referTrack.
  ///
  /// In en, this message translates to:
  /// **'Track progress'**
  String get referTrack;

  /// No description provided for @resetButton.
  ///
  /// In en, this message translates to:
  /// **'Save password'**
  String get resetButton;

  /// No description provided for @resetDone.
  ///
  /// In en, this message translates to:
  /// **'Password changed. Sign in with your new password.'**
  String get resetDone;

  /// No description provided for @resetTitle.
  ///
  /// In en, this message translates to:
  /// **'Set a new password'**
  String get resetTitle;

  /// No description provided for @roleAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get roleAdmin;

  /// No description provided for @roleAdminDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage the whole platform'**
  String get roleAdminDesc;

  /// No description provided for @roleBackOffice.
  ///
  /// In en, this message translates to:
  /// **'Back office'**
  String get roleBackOffice;

  /// No description provided for @roleBackOfficeDesc.
  ///
  /// In en, this message translates to:
  /// **'Verify enquiries and manage the work'**
  String get roleBackOfficeDesc;

  /// No description provided for @roleCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get roleCustomer;

  /// No description provided for @roleCustomerDesc.
  ///
  /// In en, this message translates to:
  /// **'Track your requirement and quotations'**
  String get roleCustomerDesc;

  /// No description provided for @roleFranchise.
  ///
  /// In en, this message translates to:
  /// **'Franchise head'**
  String get roleFranchise;

  /// No description provided for @roleFranchiseDesc.
  ///
  /// In en, this message translates to:
  /// **'See business in your territory'**
  String get roleFranchiseDesc;

  /// No description provided for @roleSales.
  ///
  /// In en, this message translates to:
  /// **'Referral partner'**
  String get roleSales;

  /// No description provided for @roleSalesDesc.
  ///
  /// In en, this message translates to:
  /// **'Refer customers and earn commission'**
  String get roleSalesDesc;

  /// No description provided for @roleVendor.
  ///
  /// In en, this message translates to:
  /// **'Vendor'**
  String get roleVendor;

  /// No description provided for @roleVendorDesc.
  ///
  /// In en, this message translates to:
  /// **'Receive referrals and send quotations'**
  String get roleVendorDesc;

  /// No description provided for @salesCompany.
  ///
  /// In en, this message translates to:
  /// **'Company sales team'**
  String get salesCompany;

  /// No description provided for @salesEarningLater.
  ///
  /// In en, this message translates to:
  /// **'You earn {percent} of the final order value. The amount appears once a quotation is accepted.'**
  String salesEarningLater(String percent);

  /// No description provided for @salesEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Your referrals and their progress will appear here.'**
  String get salesEmptyBody;

  /// No description provided for @salesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No referrals yet'**
  String get salesEmptyTitle;

  /// No description provided for @salesEnquiriesTitle.
  ///
  /// In en, this message translates to:
  /// **'My referrals'**
  String get salesEnquiriesTitle;

  /// No description provided for @salesExpectedEarning.
  ///
  /// In en, this message translates to:
  /// **'You can earn about {amount} when {trigger}.'**
  String salesExpectedEarning(String amount, String trigger);

  /// No description provided for @salesFilterActive.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get salesFilterActive;

  /// No description provided for @salesFilterClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get salesFilterClosed;

  /// No description provided for @salesFilterWon.
  ///
  /// In en, this message translates to:
  /// **'Won'**
  String get salesFilterWon;

  /// No description provided for @salesHomeSummary.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No referrals in progress right now.} =1{1 referral is in progress.} other{{count} referrals are in progress.}}'**
  String salesHomeSummary(int count);

  /// No description provided for @salesIndependent.
  ///
  /// In en, this message translates to:
  /// **'Independent referrer'**
  String get salesIndependent;

  /// No description provided for @salesKpiEarned.
  ///
  /// In en, this message translates to:
  /// **'Earned'**
  String get salesKpiEarned;

  /// No description provided for @salesKpiInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get salesKpiInProgress;

  /// No description provided for @salesKpiPending.
  ///
  /// In en, this message translates to:
  /// **'On the way'**
  String get salesKpiPending;

  /// No description provided for @salesKpiWon.
  ///
  /// In en, this message translates to:
  /// **'Won'**
  String get salesKpiWon;

  /// No description provided for @salesLostBody.
  ///
  /// In en, this message translates to:
  /// **'The customer did not go ahead. Reason: {reason}.'**
  String salesLostBody(String reason);

  /// No description provided for @salesNoEarning.
  ///
  /// In en, this message translates to:
  /// **'There is no commission for this referral because it was closed.'**
  String get salesNoEarning;

  /// No description provided for @salesRecentTitle.
  ///
  /// In en, this message translates to:
  /// **'Latest referrals'**
  String get salesRecentTitle;

  /// No description provided for @salesReferBody.
  ///
  /// In en, this message translates to:
  /// **'Know someone who needs CCTV, solar, interiors or more? Share their details and earn when the work is paid for.'**
  String get salesReferBody;

  /// No description provided for @salesReferButton.
  ///
  /// In en, this message translates to:
  /// **'Start a referral'**
  String get salesReferButton;

  /// No description provided for @salesReferTitle.
  ///
  /// In en, this message translates to:
  /// **'Refer a customer'**
  String get salesReferTitle;

  /// No description provided for @salesRejectedBody.
  ///
  /// In en, this message translates to:
  /// **'We could not verify this referral. Reason: {reason}.'**
  String salesRejectedBody(String reason);

  /// No description provided for @salesVendorWorking.
  ///
  /// In en, this message translates to:
  /// **'Working on it'**
  String get salesVendorWorking;

  /// No description provided for @searchCustomers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get searchCustomers;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by enquiry ID, product or name'**
  String get searchHint;

  /// No description provided for @searchHintOps.
  ///
  /// In en, this message translates to:
  /// **'Search enquiries, customers or vendors'**
  String get searchHintOps;

  /// No description provided for @searchStartBody.
  ///
  /// In en, this message translates to:
  /// **'Type at least 2 letters, an enquiry ID or part of a phone number.'**
  String get searchStartBody;

  /// No description provided for @searchStartTitle.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchStartTitle;

  /// No description provided for @searchVendors.
  ///
  /// In en, this message translates to:
  /// **'Vendors'**
  String get searchVendors;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'App colours'**
  String get settingsTheme;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @signupBusinessTitle.
  ///
  /// In en, this message translates to:
  /// **'Business details'**
  String get signupBusinessTitle;

  /// No description provided for @signupCreate.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get signupCreate;

  /// No description provided for @signupDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your details'**
  String get signupDetailsTitle;

  /// No description provided for @signupDoneBody.
  ///
  /// In en, this message translates to:
  /// **'Sign in any time with user ID {id}.'**
  String signupDoneBody(String id);

  /// No description provided for @signupDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Your account is ready'**
  String get signupDoneTitle;

  /// No description provided for @signupGoHome.
  ///
  /// In en, this message translates to:
  /// **'Go to home'**
  String get signupGoHome;

  /// No description provided for @signupPhoneExists.
  ///
  /// In en, this message translates to:
  /// **'This number already has an account. Sign in instead.'**
  String get signupPhoneExists;

  /// No description provided for @signupStepOf.
  ///
  /// In en, this message translates to:
  /// **'Step {step} of {total}'**
  String signupStepOf(String step, String total);

  /// No description provided for @signupTerms.
  ///
  /// In en, this message translates to:
  /// **'I agree to the Terms of use and Privacy policy'**
  String get signupTerms;

  /// No description provided for @signupTermsError.
  ///
  /// In en, this message translates to:
  /// **'Please accept the terms to continue.'**
  String get signupTermsError;

  /// No description provided for @signupTitle.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get signupTitle;

  /// No description provided for @signupVendorDoneBody.
  ///
  /// In en, this message translates to:
  /// **'We check every business before sending referrals. You\'ll be notified when it\'s approved.'**
  String get signupVendorDoneBody;

  /// No description provided for @signupVendorDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Registration sent for review'**
  String get signupVendorDoneTitle;

  /// No description provided for @signupWhoCustomer.
  ///
  /// In en, this message translates to:
  /// **'I need a product or service'**
  String get signupWhoCustomer;

  /// No description provided for @signupWhoCustomerDesc.
  ///
  /// In en, this message translates to:
  /// **'Tell us what you need. We\'ll connect you with a trusted business.'**
  String get signupWhoCustomerDesc;

  /// No description provided for @signupWhoFranchise.
  ///
  /// In en, this message translates to:
  /// **'Become a franchise partner'**
  String get signupWhoFranchise;

  /// No description provided for @signupWhoFranchiseDesc.
  ///
  /// In en, this message translates to:
  /// **'Start your own business with our full support'**
  String get signupWhoFranchiseDesc;

  /// No description provided for @signupWhoSales.
  ///
  /// In en, this message translates to:
  /// **'Refer customers and earn'**
  String get signupWhoSales;

  /// No description provided for @signupWhoSalesDesc.
  ///
  /// In en, this message translates to:
  /// **'Tell us who needs a product or service. Earn when the business is done.'**
  String get signupWhoSalesDesc;

  /// No description provided for @signupWhoTitle.
  ///
  /// In en, this message translates to:
  /// **'How will you use O2O Boss?'**
  String get signupWhoTitle;

  /// No description provided for @signupWhoVendor.
  ///
  /// In en, this message translates to:
  /// **'Register my business'**
  String get signupWhoVendor;

  /// No description provided for @signupWhoVendorDesc.
  ///
  /// In en, this message translates to:
  /// **'Get verified customers for your products and services.'**
  String get signupWhoVendorDesc;

  /// No description provided for @simpleDone.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get simpleDone;

  /// No description provided for @simpleFindingVendor.
  ///
  /// In en, this message translates to:
  /// **'Finding a vendor'**
  String get simpleFindingVendor;

  /// No description provided for @simpleLost.
  ///
  /// In en, this message translates to:
  /// **'Lost'**
  String get simpleLost;

  /// No description provided for @simpleNotVerified.
  ///
  /// In en, this message translates to:
  /// **'Not verified'**
  String get simpleNotVerified;

  /// No description provided for @simplePayment.
  ///
  /// In en, this message translates to:
  /// **'Payment pending'**
  String get simplePayment;

  /// No description provided for @simpleQuotation.
  ///
  /// In en, this message translates to:
  /// **'Quotation stage'**
  String get simpleQuotation;

  /// No description provided for @simpleVendorAssigned.
  ///
  /// In en, this message translates to:
  /// **'Vendor assigned'**
  String get simpleVendorAssigned;

  /// No description provided for @simpleVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get simpleVerified;

  /// No description provided for @simpleVerifying.
  ///
  /// In en, this message translates to:
  /// **'Being verified'**
  String get simpleVerifying;

  /// No description provided for @simpleVisit.
  ///
  /// In en, this message translates to:
  /// **'Visit planned'**
  String get simpleVisit;

  /// No description provided for @simpleWon.
  ///
  /// In en, this message translates to:
  /// **'Won'**
  String get simpleWon;

  /// No description provided for @simpleWork.
  ///
  /// In en, this message translates to:
  /// **'Work in progress'**
  String get simpleWork;

  /// No description provided for @soonBackToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Back to sign in'**
  String get soonBackToSignIn;

  /// No description provided for @soonDoneBody.
  ///
  /// In en, this message translates to:
  /// **'O2O Boss will start in {city} shortly. We will let you know as soon as we do.'**
  String soonDoneBody(String city);

  /// No description provided for @soonDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Thank you, {name}'**
  String soonDoneTitle(String name);

  /// No description provided for @soonNoteBody.
  ///
  /// In en, this message translates to:
  /// **'We\'ll start operating there shortly and let you know. Leave your details and we\'ll tell you first.'**
  String get soonNoteBody;

  /// No description provided for @soonNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'We\'re not in {city} yet'**
  String soonNoteTitle(String city);

  /// No description provided for @soonNoteTitleAny.
  ///
  /// In en, this message translates to:
  /// **'We\'re not in your city yet'**
  String get soonNoteTitleAny;

  /// No description provided for @soonNotify.
  ///
  /// In en, this message translates to:
  /// **'Notify me'**
  String get soonNotify;

  /// No description provided for @soonWeAreThere.
  ///
  /// In en, this message translates to:
  /// **'Good news: O2O Boss is already in {city}. Pick your area.'**
  String soonWeAreThere(String city);

  /// No description provided for @sourceAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get sourceAdmin;

  /// No description provided for @sourceBackOffice.
  ///
  /// In en, this message translates to:
  /// **'Back office'**
  String get sourceBackOffice;

  /// No description provided for @sourceCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer, in the app'**
  String get sourceCustomer;

  /// No description provided for @sourceSales.
  ///
  /// In en, this message translates to:
  /// **'Referral partner'**
  String get sourceSales;

  /// No description provided for @srcBody.
  ///
  /// In en, this message translates to:
  /// **'Anything under the sun: if it\'s not here, we\'ll source it for you. Ask and we\'ll get back to you.'**
  String get srcBody;

  /// No description provided for @srcButton.
  ///
  /// In en, this message translates to:
  /// **'Ask us to find it'**
  String get srcButton;

  /// No description provided for @srcDoneBody.
  ///
  /// In en, this message translates to:
  /// **'We will get back to you with information about “{query}”.'**
  String srcDoneBody(String query);

  /// No description provided for @srcDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Request received'**
  String get srcDoneTitle;

  /// No description provided for @srcRequirement.
  ///
  /// In en, this message translates to:
  /// **'Please find: {query}'**
  String srcRequirement(String query);

  /// No description provided for @srcTitle.
  ///
  /// In en, this message translates to:
  /// **'We don\'t list “{query}” yet'**
  String srcTitle(String query);

  /// No description provided for @stActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get stActive;

  /// No description provided for @stActiveHelp.
  ///
  /// In en, this message translates to:
  /// **'Inactive items are hidden from new enquiries.'**
  String get stActiveHelp;

  /// No description provided for @stAddArea.
  ///
  /// In en, this message translates to:
  /// **'Add area'**
  String get stAddArea;

  /// No description provided for @stAddBrand.
  ///
  /// In en, this message translates to:
  /// **'Add brand'**
  String get stAddBrand;

  /// No description provided for @stAddCity.
  ///
  /// In en, this message translates to:
  /// **'Add city'**
  String get stAddCity;

  /// No description provided for @stAddFranchise.
  ///
  /// In en, this message translates to:
  /// **'Add franchise'**
  String get stAddFranchise;

  /// No description provided for @stAddProduct.
  ///
  /// In en, this message translates to:
  /// **'Add product'**
  String get stAddProduct;

  /// No description provided for @stAddQuestion.
  ///
  /// In en, this message translates to:
  /// **'Add question'**
  String get stAddQuestion;

  /// No description provided for @stAddService.
  ///
  /// In en, this message translates to:
  /// **'Add service'**
  String get stAddService;

  /// No description provided for @stAdded.
  ///
  /// In en, this message translates to:
  /// **'Added.'**
  String get stAdded;

  /// No description provided for @stAdminCopy.
  ///
  /// In en, this message translates to:
  /// **'Send a copy of each quotation to admin'**
  String get stAdminCopy;

  /// No description provided for @stAreaName.
  ///
  /// In en, this message translates to:
  /// **'Area name'**
  String get stAreaName;

  /// No description provided for @stAreasCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No areas} =1{1 area} other{{count} areas}}'**
  String stAreasCount(int count);

  /// No description provided for @stAsksPrice.
  ///
  /// In en, this message translates to:
  /// **'Ask vendors for an expected price'**
  String get stAsksPrice;

  /// No description provided for @stAsksTime.
  ///
  /// In en, this message translates to:
  /// **'Ask vendors for expected days'**
  String get stAsksTime;

  /// No description provided for @stBoPercent.
  ///
  /// In en, this message translates to:
  /// **'Back office commission'**
  String get stBoPercent;

  /// No description provided for @stBrandName.
  ///
  /// In en, this message translates to:
  /// **'Brand name'**
  String get stBrandName;

  /// No description provided for @stBrandServices.
  ///
  /// In en, this message translates to:
  /// **'Used for'**
  String get stBrandServices;

  /// No description provided for @stCalling.
  ///
  /// In en, this message translates to:
  /// **'Calls from the app'**
  String get stCalling;

  /// No description provided for @stCityName.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get stCityName;

  /// No description provided for @stDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String stDays(int count);

  /// No description provided for @stDecrease.
  ///
  /// In en, this message translates to:
  /// **'Less {label}'**
  String stDecrease(String label);

  /// No description provided for @stDefaultPriority.
  ///
  /// In en, this message translates to:
  /// **'Default priority'**
  String get stDefaultPriority;

  /// No description provided for @stDeleteQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete question'**
  String get stDeleteQuestion;

  /// No description provided for @stDeleteQuestionTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this question?'**
  String get stDeleteQuestionTitle;

  /// No description provided for @stDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get stDescription;

  /// No description provided for @stESign.
  ///
  /// In en, this message translates to:
  /// **'Customers sign to accept'**
  String get stESign;

  /// No description provided for @stEditQuestion.
  ///
  /// In en, this message translates to:
  /// **'Edit question'**
  String get stEditQuestion;

  /// No description provided for @stEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get stEmail;

  /// No description provided for @stExpiryDays.
  ///
  /// In en, this message translates to:
  /// **'Close quiet enquiries after'**
  String get stExpiryDays;

  /// No description provided for @stFeedbackOn.
  ///
  /// In en, this message translates to:
  /// **'Ask customers for a rating'**
  String get stFeedbackOn;

  /// No description provided for @stFranchiseName.
  ///
  /// In en, this message translates to:
  /// **'Franchise name'**
  String get stFranchiseName;

  /// No description provided for @stFranchisePercent.
  ///
  /// In en, this message translates to:
  /// **'Franchise share'**
  String get stFranchisePercent;

  /// No description provided for @stHead.
  ///
  /// In en, this message translates to:
  /// **'Franchise head'**
  String get stHead;

  /// No description provided for @stHours.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hour} other{{count} hours}}'**
  String stHours(int count);

  /// No description provided for @stInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get stInactive;

  /// No description provided for @stIncrease.
  ///
  /// In en, this message translates to:
  /// **'More {label}'**
  String stIncrease(String label);

  /// No description provided for @stMultiQuotes.
  ///
  /// In en, this message translates to:
  /// **'Customers can compare quotations by default'**
  String get stMultiQuotes;

  /// No description provided for @stNoHead.
  ///
  /// In en, this message translates to:
  /// **'No head assigned'**
  String get stNoHead;

  /// No description provided for @stNoQuestions.
  ///
  /// In en, this message translates to:
  /// **'No questions yet.'**
  String get stNoQuestions;

  /// No description provided for @stOnlinePay.
  ///
  /// In en, this message translates to:
  /// **'Online payment'**
  String get stOnlinePay;

  /// No description provided for @stOtp.
  ///
  /// In en, this message translates to:
  /// **'Confirm customer mobile with a code'**
  String get stOtp;

  /// No description provided for @stPayoutApproval.
  ///
  /// In en, this message translates to:
  /// **'Admin approves each payout'**
  String get stPayoutApproval;

  /// No description provided for @stPincode.
  ///
  /// In en, this message translates to:
  /// **'Pincode'**
  String get stPincode;

  /// No description provided for @stPincodeError.
  ///
  /// In en, this message translates to:
  /// **'Enter a 6-digit pincode.'**
  String get stPincodeError;

  /// No description provided for @stProductName.
  ///
  /// In en, this message translates to:
  /// **'Product name'**
  String get stProductName;

  /// No description provided for @stProtectionDays.
  ///
  /// In en, this message translates to:
  /// **'Referral protected for'**
  String get stProtectionDays;

  /// No description provided for @stPush.
  ///
  /// In en, this message translates to:
  /// **'App notifications'**
  String get stPush;

  /// No description provided for @stQChoice.
  ///
  /// In en, this message translates to:
  /// **'Pick one'**
  String get stQChoice;

  /// No description provided for @stQDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get stQDate;

  /// No description provided for @stQNumber.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get stQNumber;

  /// No description provided for @stQText.
  ///
  /// In en, this message translates to:
  /// **'Short answer'**
  String get stQText;

  /// No description provided for @stQYesNo.
  ///
  /// In en, this message translates to:
  /// **'Yes or no'**
  String get stQYesNo;

  /// No description provided for @stQuestionLabel.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get stQuestionLabel;

  /// No description provided for @stQuestionOptions.
  ///
  /// In en, this message translates to:
  /// **'Choices'**
  String get stQuestionOptions;

  /// No description provided for @stQuestionOptionsHint.
  ///
  /// In en, this message translates to:
  /// **'Separate with commas, for example: 1, 2, 3 or more'**
  String get stQuestionOptionsHint;

  /// No description provided for @stQuestionRequired.
  ///
  /// In en, this message translates to:
  /// **'Answer is required'**
  String get stQuestionRequired;

  /// No description provided for @stQuestionType.
  ///
  /// In en, this message translates to:
  /// **'Answer type'**
  String get stQuestionType;

  /// No description provided for @stQuestions.
  ///
  /// In en, this message translates to:
  /// **'Qualification questions'**
  String get stQuestions;

  /// No description provided for @stQuestionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No questions} =1{1 question} other{{count} questions}}'**
  String stQuestionsCount(int count);

  /// No description provided for @stQuestionsHelp.
  ///
  /// In en, this message translates to:
  /// **'Back office asks these when checking an enquiry.'**
  String get stQuestionsHelp;

  /// No description provided for @stQuoteReview.
  ///
  /// In en, this message translates to:
  /// **'Back office checks quotations first'**
  String get stQuoteReview;

  /// No description provided for @stRecording.
  ///
  /// In en, this message translates to:
  /// **'Record calls'**
  String get stRecording;

  /// No description provided for @stRecordingConsent.
  ///
  /// In en, this message translates to:
  /// **'Ask before recording'**
  String get stRecordingConsent;

  /// No description provided for @stRemoveArea.
  ///
  /// In en, this message translates to:
  /// **'Remove area'**
  String get stRemoveArea;

  /// No description provided for @stRemoveAreaTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove {area}?'**
  String stRemoveAreaTitle(String area);

  /// No description provided for @stRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get stRename;

  /// No description provided for @stRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get stRequired;

  /// No description provided for @stSalesPercent.
  ///
  /// In en, this message translates to:
  /// **'Referral partner commission'**
  String get stSalesPercent;

  /// No description provided for @stSalesValue.
  ///
  /// In en, this message translates to:
  /// **'What referral partners see of the value'**
  String get stSalesValue;

  /// No description provided for @stSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get stSave;

  /// No description provided for @stSaved.
  ///
  /// In en, this message translates to:
  /// **'Setting saved.'**
  String get stSaved;

  /// No description provided for @stSecChannels.
  ///
  /// In en, this message translates to:
  /// **'Messages and calls'**
  String get stSecChannels;

  /// No description provided for @stSecChannelsHelp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp, SMS, email, calls and recording'**
  String get stSecChannelsHelp;

  /// No description provided for @stSecCommission.
  ///
  /// In en, this message translates to:
  /// **'Commission'**
  String get stSecCommission;

  /// No description provided for @stSecCommissionHelp.
  ///
  /// In en, this message translates to:
  /// **'Rates, when it is earned, payout approval'**
  String get stSecCommissionHelp;

  /// No description provided for @stSecEnquiry.
  ///
  /// In en, this message translates to:
  /// **'Enquiries'**
  String get stSecEnquiry;

  /// No description provided for @stSecEnquiryHelp.
  ///
  /// In en, this message translates to:
  /// **'Mobile check, expiry and referral protection'**
  String get stSecEnquiryHelp;

  /// No description provided for @stSecFeedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get stSecFeedback;

  /// No description provided for @stSecFeedbackHelp.
  ///
  /// In en, this message translates to:
  /// **'Ratings after the work is done'**
  String get stSecFeedbackHelp;

  /// No description provided for @stSecPayments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get stSecPayments;

  /// No description provided for @stSecPaymentsHelp.
  ///
  /// In en, this message translates to:
  /// **'Tracking and online payment'**
  String get stSecPaymentsHelp;

  /// No description provided for @stSecQuotes.
  ///
  /// In en, this message translates to:
  /// **'Quotations'**
  String get stSecQuotes;

  /// No description provided for @stSecQuotesHelp.
  ///
  /// In en, this message translates to:
  /// **'Checking, signing and copies'**
  String get stSecQuotesHelp;

  /// No description provided for @stSecVendors.
  ///
  /// In en, this message translates to:
  /// **'Vendors'**
  String get stSecVendors;

  /// No description provided for @stSecVendorsHelp.
  ///
  /// In en, this message translates to:
  /// **'Approval and time to reply'**
  String get stSecVendorsHelp;

  /// No description provided for @stSecVisibility.
  ///
  /// In en, this message translates to:
  /// **'Who sees what'**
  String get stSecVisibility;

  /// No description provided for @stSecVisibilityHelp.
  ///
  /// In en, this message translates to:
  /// **'Contact details and order values'**
  String get stSecVisibilityHelp;

  /// No description provided for @stSeesReferrer.
  ///
  /// In en, this message translates to:
  /// **'Customers see who referred them'**
  String get stSeesReferrer;

  /// No description provided for @stSeesVendorContact.
  ///
  /// In en, this message translates to:
  /// **'Customers see vendor phone numbers'**
  String get stSeesVendorContact;

  /// No description provided for @stService.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get stService;

  /// No description provided for @stServiceName.
  ///
  /// In en, this message translates to:
  /// **'Service name'**
  String get stServiceName;

  /// No description provided for @stShareDefault.
  ///
  /// In en, this message translates to:
  /// **'The default share is {percent}.'**
  String stShareDefault(String percent);

  /// No description provided for @stSms.
  ///
  /// In en, this message translates to:
  /// **'SMS messages'**
  String get stSms;

  /// No description provided for @stState.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get stState;

  /// No description provided for @stTracking.
  ///
  /// In en, this message translates to:
  /// **'Track payments'**
  String get stTracking;

  /// No description provided for @stTrigger.
  ///
  /// In en, this message translates to:
  /// **'Commission is earned when'**
  String get stTrigger;

  /// No description provided for @stVendorApproval.
  ///
  /// In en, this message translates to:
  /// **'Approve new vendors before they get referrals'**
  String get stVendorApproval;

  /// No description provided for @stVendorHours.
  ///
  /// In en, this message translates to:
  /// **'Time for vendors to reply'**
  String get stVendorHours;

  /// No description provided for @stVendorSeesReferrer.
  ///
  /// In en, this message translates to:
  /// **'Vendors see the referral partner'**
  String get stVendorSeesReferrer;

  /// No description provided for @stWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp messages'**
  String get stWhatsapp;

  /// No description provided for @statusAppointmentCompleted.
  ///
  /// In en, this message translates to:
  /// **'Visit done'**
  String get statusAppointmentCompleted;

  /// No description provided for @statusAppointmentScheduled.
  ///
  /// In en, this message translates to:
  /// **'Visit scheduled'**
  String get statusAppointmentScheduled;

  /// No description provided for @statusCommissionCalculated.
  ///
  /// In en, this message translates to:
  /// **'Commission calculated'**
  String get statusCommissionCalculated;

  /// No description provided for @statusCommissionSettled.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCommissionSettled;

  /// No description provided for @statusCustomerContact.
  ///
  /// In en, this message translates to:
  /// **'Customer connected'**
  String get statusCustomerContact;

  /// No description provided for @statusLost.
  ///
  /// In en, this message translates to:
  /// **'Lost'**
  String get statusLost;

  /// No description provided for @statusNegotiation.
  ///
  /// In en, this message translates to:
  /// **'Negotiation'**
  String get statusNegotiation;

  /// No description provided for @statusNewEnquiry.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get statusNewEnquiry;

  /// No description provided for @statusPaymentCollected.
  ///
  /// In en, this message translates to:
  /// **'Payment collected'**
  String get statusPaymentCollected;

  /// No description provided for @statusPaymentPending.
  ///
  /// In en, this message translates to:
  /// **'Payment pending'**
  String get statusPaymentPending;

  /// No description provided for @statusProjectCompleted.
  ///
  /// In en, this message translates to:
  /// **'Work completed'**
  String get statusProjectCompleted;

  /// No description provided for @statusProjectCreated.
  ///
  /// In en, this message translates to:
  /// **'Project created'**
  String get statusProjectCreated;

  /// No description provided for @statusProjectInProgress.
  ///
  /// In en, this message translates to:
  /// **'Work in progress'**
  String get statusProjectInProgress;

  /// No description provided for @statusQualificationPending.
  ///
  /// In en, this message translates to:
  /// **'Qualification pending'**
  String get statusQualificationPending;

  /// No description provided for @statusQualified.
  ///
  /// In en, this message translates to:
  /// **'Qualified'**
  String get statusQualified;

  /// No description provided for @statusQuotationPending.
  ///
  /// In en, this message translates to:
  /// **'Quotation pending'**
  String get statusQuotationPending;

  /// No description provided for @statusQuotationSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Quotation submitted'**
  String get statusQuotationSubmitted;

  /// No description provided for @statusRejected.
  ///
  /// In en, this message translates to:
  /// **'Not verified'**
  String get statusRejected;

  /// No description provided for @statusVendorAccepted.
  ///
  /// In en, this message translates to:
  /// **'Vendor accepted'**
  String get statusVendorAccepted;

  /// No description provided for @statusVendorAssigned.
  ///
  /// In en, this message translates to:
  /// **'Vendor assigned'**
  String get statusVendorAssigned;

  /// No description provided for @statusVendorMatching.
  ///
  /// In en, this message translates to:
  /// **'Finding vendor'**
  String get statusVendorMatching;

  /// No description provided for @statusVerificationPending.
  ///
  /// In en, this message translates to:
  /// **'Verification pending'**
  String get statusVerificationPending;

  /// No description provided for @statusVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get statusVerified;

  /// No description provided for @statusWon.
  ///
  /// In en, this message translates to:
  /// **'Won'**
  String get statusWon;

  /// No description provided for @svCommissionOnly.
  ///
  /// In en, this message translates to:
  /// **'Commission only'**
  String get svCommissionOnly;

  /// No description provided for @svFull.
  ///
  /// In en, this message translates to:
  /// **'Full value'**
  String get svFull;

  /// No description provided for @svHidden.
  ///
  /// In en, this message translates to:
  /// **'Hidden'**
  String get svHidden;

  /// No description provided for @svLimited.
  ///
  /// In en, this message translates to:
  /// **'Rounded value'**
  String get svLimited;

  /// No description provided for @svStageBased.
  ///
  /// In en, this message translates to:
  /// **'Only after the deal is won'**
  String get svStageBased;

  /// No description provided for @sysAppointmentCancelled.
  ///
  /// In en, this message translates to:
  /// **'Visit cancelled.'**
  String get sysAppointmentCancelled;

  /// No description provided for @sysAppointmentCompleted.
  ///
  /// In en, this message translates to:
  /// **'Visit completed.'**
  String get sysAppointmentCompleted;

  /// No description provided for @sysAppointmentConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Visit confirmed for {date}.'**
  String sysAppointmentConfirmed(String date);

  /// No description provided for @sysAppointmentProposed.
  ///
  /// In en, this message translates to:
  /// **'Visit proposed for {date}.'**
  String sysAppointmentProposed(String date);

  /// No description provided for @sysAppointmentRescheduled.
  ///
  /// In en, this message translates to:
  /// **'Visit moved to {date}.'**
  String sysAppointmentRescheduled(String date);

  /// No description provided for @sysAssigned.
  ///
  /// In en, this message translates to:
  /// **'{id} assigned to {vendor}.'**
  String sysAssigned(String id, String vendor);

  /// No description provided for @sysConnected.
  ///
  /// In en, this message translates to:
  /// **'{vendor} is now connected to the customer through O2O Boss.'**
  String sysConnected(String vendor);

  /// No description provided for @sysEnquiryLost.
  ///
  /// In en, this message translates to:
  /// **'This enquiry was closed.'**
  String get sysEnquiryLost;

  /// No description provided for @sysNewReferral.
  ///
  /// In en, this message translates to:
  /// **'New referral {id}. Please reply within {hours} hours.'**
  String sysNewReferral(String id, String hours);

  /// No description provided for @sysOtherAccepted.
  ///
  /// In en, this message translates to:
  /// **'Another quotation was accepted.'**
  String get sysOtherAccepted;

  /// No description provided for @sysProjectCreated.
  ///
  /// In en, this message translates to:
  /// **'Project {project} started.'**
  String sysProjectCreated(String project);

  /// No description provided for @sysQuotationAccepted.
  ///
  /// In en, this message translates to:
  /// **'The customer accepted {number}.'**
  String sysQuotationAccepted(String number);

  /// No description provided for @sysQuotationRejected.
  ///
  /// In en, this message translates to:
  /// **'The customer rejected {number}.'**
  String sysQuotationRejected(String number);

  /// No description provided for @sysQuotationSent.
  ///
  /// In en, this message translates to:
  /// **'Quotation {number} (version {version}) sent to the customer.'**
  String sysQuotationSent(String number, String version);

  /// No description provided for @sysQuotationSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Quotation {number} (version {version}) submitted.'**
  String sysQuotationSubmitted(String number, String version);

  /// No description provided for @sysReferralAccepted.
  ///
  /// In en, this message translates to:
  /// **'{vendor} accepted the referral.'**
  String sysReferralAccepted(String vendor);

  /// No description provided for @sysReferralRejected.
  ///
  /// In en, this message translates to:
  /// **'{vendor} declined the referral.'**
  String sysReferralRejected(String vendor);

  /// No description provided for @sysRevisionRequested.
  ///
  /// In en, this message translates to:
  /// **'Changes requested on {number}.'**
  String sysRevisionRequested(String number);

  /// No description provided for @taskAdd.
  ///
  /// In en, this message translates to:
  /// **'Add task'**
  String get taskAdd;

  /// No description provided for @taskAdded.
  ///
  /// In en, this message translates to:
  /// **'Task added.'**
  String get taskAdded;

  /// No description provided for @taskApproveCommission.
  ///
  /// In en, this message translates to:
  /// **'Approve commission for {id}'**
  String taskApproveCommission(String id);

  /// No description provided for @taskApproveVendor.
  ///
  /// In en, this message translates to:
  /// **'Review new vendor {name}'**
  String taskApproveVendor(String name);

  /// No description provided for @taskAssignVendor.
  ///
  /// In en, this message translates to:
  /// **'Choose vendor for {id}'**
  String taskAssignVendor(String id);

  /// No description provided for @taskCollectPayment.
  ///
  /// In en, this message translates to:
  /// **'Collect payment for {id}'**
  String taskCollectPayment(String id);

  /// No description provided for @taskCreateProject.
  ///
  /// In en, this message translates to:
  /// **'Start project for {id}'**
  String taskCreateProject(String id);

  /// No description provided for @taskDone.
  ///
  /// In en, this message translates to:
  /// **'Task done.'**
  String get taskDone;

  /// No description provided for @taskDue.
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get taskDue;

  /// No description provided for @taskEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Tasks are created for you as enquiries move. You can add your own too.'**
  String get taskEmptyBody;

  /// No description provided for @taskEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No tasks'**
  String get taskEmptyTitle;

  /// No description provided for @taskQualify.
  ///
  /// In en, this message translates to:
  /// **'Check requirement for {id}'**
  String taskQualify(String id);

  /// No description provided for @taskReviewQuotation.
  ///
  /// In en, this message translates to:
  /// **'Review quotation for {id}'**
  String taskReviewQuotation(String id);

  /// No description provided for @taskToDo.
  ///
  /// In en, this message translates to:
  /// **'To do'**
  String get taskToDo;

  /// No description provided for @taskVendorNoResponse.
  ///
  /// In en, this message translates to:
  /// **'Vendor hasn\'t replied on {id}'**
  String taskVendorNoResponse(String id);

  /// No description provided for @taskVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify {id}'**
  String taskVerify(String id);

  /// No description provided for @taskWhat.
  ///
  /// In en, this message translates to:
  /// **'What needs doing?'**
  String get taskWhat;

  /// No description provided for @terms1Body.
  ///
  /// In en, this message translates to:
  /// **'O2O Boss connects customers with verified vendors through referrals. By using the app you agree to share accurate information and to use it only for genuine requirements.'**
  String get terms1Body;

  /// No description provided for @terms1Title.
  ///
  /// In en, this message translates to:
  /// **'Using O2O Boss'**
  String get terms1Title;

  /// No description provided for @terms2Body.
  ///
  /// In en, this message translates to:
  /// **'Commission is paid on referrals verified and completed through O2O Boss, according to the rules shown in the app at the time of the referral.'**
  String get terms2Body;

  /// No description provided for @terms2Title.
  ///
  /// In en, this message translates to:
  /// **'Referrals and commission'**
  String get terms2Title;

  /// No description provided for @terms3Body.
  ///
  /// In en, this message translates to:
  /// **'Vendors are responsible for their quotations, work quality and delivery timelines. O2O Boss may review quotations before they reach customers.'**
  String get terms3Body;

  /// No description provided for @terms3Title.
  ///
  /// In en, this message translates to:
  /// **'Vendors'**
  String get terms3Title;

  /// No description provided for @terms4Body.
  ///
  /// In en, this message translates to:
  /// **'Keep your user ID and password private. O2O Boss may suspend accounts that misuse the platform.'**
  String get terms4Body;

  /// No description provided for @terms4Title.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get terms4Title;

  /// No description provided for @themeBrand.
  ///
  /// In en, this message translates to:
  /// **'O2O Boss orange'**
  String get themeBrand;

  /// No description provided for @themeBrandBody.
  ///
  /// In en, this message translates to:
  /// **'Orange and navy, like our website'**
  String get themeBrandBody;

  /// No description provided for @themeClassic.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get themeClassic;

  /// No description provided for @themeClassicBody.
  ///
  /// In en, this message translates to:
  /// **'The standard look'**
  String get themeClassicBody;

  /// No description provided for @toastCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied.'**
  String get toastCopied;

  /// No description provided for @toastSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved.'**
  String get toastSaved;

  /// No description provided for @toastSent.
  ///
  /// In en, this message translates to:
  /// **'Sent.'**
  String get toastSent;

  /// No description provided for @toastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Updated.'**
  String get toastUpdated;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @trigFullPayment.
  ///
  /// In en, this message translates to:
  /// **'Full payment collected'**
  String get trigFullPayment;

  /// No description provided for @trigOrderConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Order confirmed'**
  String get trigOrderConfirmed;

  /// No description provided for @trigPaymentReceived.
  ///
  /// In en, this message translates to:
  /// **'First payment received'**
  String get trigPaymentReceived;

  /// No description provided for @trigProjectCompleted.
  ///
  /// In en, this message translates to:
  /// **'Work completed'**
  String get trigProjectCompleted;

  /// No description provided for @trigProjectStarted.
  ///
  /// In en, this message translates to:
  /// **'Work started'**
  String get trigProjectStarted;

  /// No description provided for @trigQuotationAccepted.
  ///
  /// In en, this message translates to:
  /// **'Quotation accepted'**
  String get trigQuotationAccepted;

  /// No description provided for @trigSentenceFullPayment.
  ///
  /// In en, this message translates to:
  /// **'the customer has paid in full'**
  String get trigSentenceFullPayment;

  /// No description provided for @trigSentenceOrderConfirmed.
  ///
  /// In en, this message translates to:
  /// **'the order is confirmed'**
  String get trigSentenceOrderConfirmed;

  /// No description provided for @trigSentencePaymentReceived.
  ///
  /// In en, this message translates to:
  /// **'the first payment is received'**
  String get trigSentencePaymentReceived;

  /// No description provided for @trigSentenceProjectCompleted.
  ///
  /// In en, this message translates to:
  /// **'the work is completed'**
  String get trigSentenceProjectCompleted;

  /// No description provided for @trigSentenceProjectStarted.
  ///
  /// In en, this message translates to:
  /// **'the work starts'**
  String get trigSentenceProjectStarted;

  /// No description provided for @trigSentenceQuotationAccepted.
  ///
  /// In en, this message translates to:
  /// **'the customer accepts the quotation'**
  String get trigSentenceQuotationAccepted;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @validationAge.
  ///
  /// In en, this message translates to:
  /// **'Enter your age in years'**
  String get validationAge;

  /// No description provided for @validationAgeMin.
  ///
  /// In en, this message translates to:
  /// **'You need to be 18 or older to earn with O2O Boss'**
  String get validationAgeMin;

  /// No description provided for @validationAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount greater than zero.'**
  String get validationAmount;

  /// No description provided for @validationChooseOne.
  ///
  /// In en, this message translates to:
  /// **'Choose one option.'**
  String get validationChooseOne;

  /// No description provided for @validationEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get validationEmail;

  /// No description provided for @validationFixErrors.
  ///
  /// In en, this message translates to:
  /// **'Some details need attention. Check the highlighted fields.'**
  String get validationFixErrors;

  /// No description provided for @validationLoginIdFormat.
  ///
  /// In en, this message translates to:
  /// **'Use 4 to 20 letters, numbers, dots or underscores.'**
  String get validationLoginIdFormat;

  /// No description provided for @validationLoginIdTaken.
  ///
  /// In en, this message translates to:
  /// **'This user ID is taken. Try another.'**
  String get validationLoginIdTaken;

  /// No description provided for @validationName.
  ///
  /// In en, this message translates to:
  /// **'Enter a name.'**
  String get validationName;

  /// No description provided for @validationNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a number.'**
  String get validationNumber;

  /// No description provided for @validationOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code.'**
  String get validationOtp;

  /// No description provided for @validationOtpWrong.
  ///
  /// In en, this message translates to:
  /// **'That code is not right. Check it and try again.'**
  String get validationOtpWrong;

  /// No description provided for @validationPasswordLength.
  ///
  /// In en, this message translates to:
  /// **'Use at least 6 characters.'**
  String get validationPasswordLength;

  /// No description provided for @validationPasswordMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get validationPasswordMatch;

  /// No description provided for @validationPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a 10-digit mobile number.'**
  String get validationPhone;

  /// No description provided for @validationReason.
  ///
  /// In en, this message translates to:
  /// **'Tell us the reason.'**
  String get validationReason;

  /// No description provided for @validationRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required.'**
  String get validationRequired;

  /// No description provided for @vbAbout.
  ///
  /// In en, this message translates to:
  /// **'About your business'**
  String get vbAbout;

  /// No description provided for @vbAboutEmpty.
  ///
  /// In en, this message translates to:
  /// **'Tell customers what you do best.'**
  String get vbAboutEmpty;

  /// No description provided for @vbAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get vbAddress;

  /// No description provided for @vbAreasHelp.
  ///
  /// In en, this message translates to:
  /// **'Pick the areas you reach in each city. Leave a city\'s areas empty to cover all of it.'**
  String get vbAreasHelp;

  /// No description provided for @vbAvailable.
  ///
  /// In en, this message translates to:
  /// **'Taking new referrals'**
  String get vbAvailable;

  /// No description provided for @vbAvailableOff.
  ///
  /// In en, this message translates to:
  /// **'Paused. You will not get new referrals.'**
  String get vbAvailableOff;

  /// No description provided for @vbAvailableOn.
  ///
  /// In en, this message translates to:
  /// **'O2O Boss will send you new customers.'**
  String get vbAvailableOn;

  /// No description provided for @vbBrands.
  ///
  /// In en, this message translates to:
  /// **'Brands'**
  String get vbBrands;

  /// No description provided for @vbCities.
  ///
  /// In en, this message translates to:
  /// **'Cities'**
  String get vbCities;

  /// No description provided for @vbCompanyName.
  ///
  /// In en, this message translates to:
  /// **'Business name'**
  String get vbCompanyName;

  /// No description provided for @vbCompanyTitle.
  ///
  /// In en, this message translates to:
  /// **'Business profile'**
  String get vbCompanyTitle;

  /// No description provided for @vbContactPerson.
  ///
  /// In en, this message translates to:
  /// **'Contact person'**
  String get vbContactPerson;

  /// No description provided for @vbDetails.
  ///
  /// In en, this message translates to:
  /// **'Business details'**
  String get vbDetails;

  /// No description provided for @vbDocUploadedOn.
  ///
  /// In en, this message translates to:
  /// **'{kind}, uploaded {date}'**
  String vbDocUploadedOn(String kind, String date);

  /// No description provided for @vbDocsNote.
  ///
  /// In en, this message translates to:
  /// **'O2O Boss checks each document. Verified documents help you get more referrals.'**
  String get vbDocsNote;

  /// No description provided for @vbEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get vbEdit;

  /// No description provided for @vbEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit business details'**
  String get vbEditTitle;

  /// No description provided for @vbEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get vbEmail;

  /// No description provided for @vbGst.
  ///
  /// In en, this message translates to:
  /// **'GST number'**
  String get vbGst;

  /// No description provided for @vbJoined.
  ///
  /// In en, this message translates to:
  /// **'Partner since {date}'**
  String vbJoined(String date);

  /// No description provided for @vbPickCityFirst.
  ///
  /// In en, this message translates to:
  /// **'Choose a city first.'**
  String get vbPickCityFirst;

  /// No description provided for @vbPickServiceFirst.
  ///
  /// In en, this message translates to:
  /// **'Choose a service first.'**
  String get vbPickServiceFirst;

  /// No description provided for @vbProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get vbProducts;

  /// No description provided for @vbSave.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get vbSave;

  /// No description provided for @vbSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved.'**
  String get vbSaved;

  /// No description provided for @vbServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get vbServices;

  /// No description provided for @vbServicesHelp.
  ///
  /// In en, this message translates to:
  /// **'Choose what you offer. You only get referrals for these.'**
  String get vbServicesHelp;

  /// No description provided for @vbUpload.
  ///
  /// In en, this message translates to:
  /// **'Upload a document'**
  String get vbUpload;

  /// No description provided for @vbUploadTitle.
  ///
  /// In en, this message translates to:
  /// **'Which document?'**
  String get vbUploadTitle;

  /// No description provided for @vbUploaded.
  ///
  /// In en, this message translates to:
  /// **'Document uploaded. We will check it soon.'**
  String get vbUploaded;

  /// No description provided for @vendorApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve vendor'**
  String get vendorApprove;

  /// No description provided for @vendorApproved.
  ///
  /// In en, this message translates to:
  /// **'Vendor approved. They can now receive referrals.'**
  String get vendorApproved;

  /// No description provided for @vendorAwaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting for approval'**
  String get vendorAwaiting;

  /// No description provided for @vendorAwaitingBody.
  ///
  /// In en, this message translates to:
  /// **'Check the business details and documents, then approve or reject.'**
  String get vendorAwaitingBody;

  /// No description provided for @vendorBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get vendorBusiness;

  /// No description provided for @vendorDocPending.
  ///
  /// In en, this message translates to:
  /// **'Not checked'**
  String get vendorDocPending;

  /// No description provided for @vendorDocVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get vendorDocVerified;

  /// No description provided for @vendorDocVerifiedToast.
  ///
  /// In en, this message translates to:
  /// **'Document verified.'**
  String get vendorDocVerifiedToast;

  /// No description provided for @vendorDocuments.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get vendorDocuments;

  /// No description provided for @vendorNoDocs.
  ///
  /// In en, this message translates to:
  /// **'No documents uploaded'**
  String get vendorNoDocs;

  /// No description provided for @vendorRating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get vendorRating;

  /// No description provided for @vendorReactivate.
  ///
  /// In en, this message translates to:
  /// **'Reactivate vendor'**
  String get vendorReactivate;

  /// No description provided for @vendorReferrals.
  ///
  /// In en, this message translates to:
  /// **'Referrals'**
  String get vendorReferrals;

  /// No description provided for @vendorReject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get vendorReject;

  /// No description provided for @vendorRejectArea.
  ///
  /// In en, this message translates to:
  /// **'Area not covered yet'**
  String get vendorRejectArea;

  /// No description provided for @vendorRejectDocs.
  ///
  /// In en, this message translates to:
  /// **'Documents missing or unclear'**
  String get vendorRejectDocs;

  /// No description provided for @vendorRejectQuality.
  ///
  /// In en, this message translates to:
  /// **'Did not meet quality checks'**
  String get vendorRejectQuality;

  /// No description provided for @vendorRejected.
  ///
  /// In en, this message translates to:
  /// **'Vendor rejected.'**
  String get vendorRejected;

  /// No description provided for @vendorResponse.
  ///
  /// In en, this message translates to:
  /// **'Replies on time'**
  String get vendorResponse;

  /// No description provided for @vendorSuspend.
  ///
  /// In en, this message translates to:
  /// **'Suspend vendor'**
  String get vendorSuspend;

  /// No description provided for @vendorSuspended.
  ///
  /// In en, this message translates to:
  /// **'Vendor suspended.'**
  String get vendorSuspended;

  /// No description provided for @vendorTerms.
  ///
  /// In en, this message translates to:
  /// **'Commercial terms'**
  String get vendorTerms;

  /// No description provided for @vendorVerifyDoc.
  ///
  /// In en, this message translates to:
  /// **'Mark verified'**
  String get vendorVerifyDoc;

  /// No description provided for @vendorsCustomerPick.
  ///
  /// In en, this message translates to:
  /// **'Customer\'s pick'**
  String get vendorsCustomerPick;

  /// No description provided for @vendorsDeadline.
  ///
  /// In en, this message translates to:
  /// **'Time to reply'**
  String get vendorsDeadline;

  /// No description provided for @vendorsDeclined.
  ///
  /// In en, this message translates to:
  /// **'Declined: {reason}'**
  String vendorsDeclined(String reason);

  /// No description provided for @vendorsExpectedDays.
  ///
  /// In en, this message translates to:
  /// **'About {days} days'**
  String vendorsExpectedDays(String days);

  /// No description provided for @vendorsExpectedPrice.
  ///
  /// In en, this message translates to:
  /// **'Expected price {price}'**
  String vendorsExpectedPrice(String price);

  /// No description provided for @vendorsIntroduce.
  ///
  /// In en, this message translates to:
  /// **'Introduce to customer'**
  String get vendorsIntroduce;

  /// No description provided for @vendorsIntroduced.
  ///
  /// In en, this message translates to:
  /// **'Vendor introduced to the customer.'**
  String get vendorsIntroduced;

  /// No description provided for @vendorsMeta.
  ///
  /// In en, this message translates to:
  /// **'{area}, rating {rating}, replies {rate}%'**
  String vendorsMeta(String area, String rating, String rate);

  /// No description provided for @vendorsNoneBody.
  ///
  /// In en, this message translates to:
  /// **'No active vendor serves this category in this city yet.'**
  String get vendorsNoneBody;

  /// No description provided for @vendorsNoneTitle.
  ///
  /// In en, this message translates to:
  /// **'No matching vendor'**
  String get vendorsNoneTitle;

  /// No description provided for @vendorsNotQualified.
  ///
  /// In en, this message translates to:
  /// **'Referrals go to vendors only after the enquiry is verified and qualified.'**
  String get vendorsNotQualified;

  /// No description provided for @vendorsOnThis.
  ///
  /// In en, this message translates to:
  /// **'Vendors on this enquiry'**
  String get vendorsOnThis;

  /// No description provided for @vendorsOptions.
  ///
  /// In en, this message translates to:
  /// **'Before sending'**
  String get vendorsOptions;

  /// No description provided for @vendorsProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get vendorsProfile;

  /// No description provided for @vendorsReasonArea.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get vendorsReasonArea;

  /// No description provided for @vendorsReasonBrand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get vendorsReasonBrand;

  /// No description provided for @vendorsReasonCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get vendorsReasonCity;

  /// No description provided for @vendorsReasonProduct.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get vendorsReasonProduct;

  /// No description provided for @vendorsScore.
  ///
  /// In en, this message translates to:
  /// **'Match {score}'**
  String vendorsScore(String score);

  /// No description provided for @vendorsSendBody.
  ///
  /// In en, this message translates to:
  /// **'They will have {hours} hours to accept or decline. The customer\'s number stays private.'**
  String vendorsSendBody(String hours);

  /// No description provided for @vendorsSendButton.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Send to 1 vendor} other{Send to {count} vendors}}'**
  String vendorsSendButton(int count);

  /// No description provided for @vendorsSendConfirm.
  ///
  /// In en, this message translates to:
  /// **'Send referral'**
  String get vendorsSendConfirm;

  /// No description provided for @vendorsSendTitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Send referral to 1 vendor?} other{Send referral to {count} vendors?}}'**
  String vendorsSendTitle(int count);

  /// No description provided for @vendorsSent.
  ///
  /// In en, this message translates to:
  /// **'Referral sent.'**
  String get vendorsSent;

  /// No description provided for @vendorsSentOn.
  ///
  /// In en, this message translates to:
  /// **'Sent {date}'**
  String vendorsSentOn(String date);

  /// No description provided for @vendorsShowAllQuotes.
  ///
  /// In en, this message translates to:
  /// **'Customer can compare quotations'**
  String get vendorsShowAllQuotes;

  /// No description provided for @vendorsShowAllQuotesHelp.
  ///
  /// In en, this message translates to:
  /// **'When on, the customer sees every vendor\'s quotation. When off, only the one you send.'**
  String get vendorsShowAllQuotesHelp;

  /// No description provided for @vendorsShowPartial.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Show 1 partial match} other{Show {count} partial matches}}'**
  String vendorsShowPartial(int count);

  /// No description provided for @vendorsSuggested.
  ///
  /// In en, this message translates to:
  /// **'Suggested vendors'**
  String get vendorsSuggested;

  /// No description provided for @vendorsSuggestedHelp.
  ///
  /// In en, this message translates to:
  /// **'Best matches first, by product, brand, location, rating and response rate.'**
  String get vendorsSuggestedHelp;

  /// No description provided for @vendorsWithdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get vendorsWithdraw;

  /// No description provided for @vendorsWithdrawBody.
  ///
  /// In en, this message translates to:
  /// **'{vendor} will no longer see this enquiry.'**
  String vendorsWithdrawBody(String vendor);

  /// No description provided for @vendorsWithdrawTitle.
  ///
  /// In en, this message translates to:
  /// **'Withdraw the referral?'**
  String get vendorsWithdrawTitle;

  /// No description provided for @vendorsWithdrawn.
  ///
  /// In en, this message translates to:
  /// **'Referral withdrawn.'**
  String get vendorsWithdrawn;

  /// No description provided for @verifyCallAgain.
  ///
  /// In en, this message translates to:
  /// **'Call again'**
  String get verifyCallAgain;

  /// No description provided for @verifyCallButton.
  ///
  /// In en, this message translates to:
  /// **'Call customer'**
  String get verifyCallButton;

  /// No description provided for @verifyCallLength.
  ///
  /// In en, this message translates to:
  /// **'Last call: {time}'**
  String verifyCallLength(String time);

  /// No description provided for @verifyCallbackAt.
  ///
  /// In en, this message translates to:
  /// **'When to call back'**
  String get verifyCallbackAt;

  /// No description provided for @verifyDoneGenuine.
  ///
  /// In en, this message translates to:
  /// **'Verified. Now ask the qualification questions.'**
  String get verifyDoneGenuine;

  /// No description provided for @verifyDoneLater.
  ///
  /// In en, this message translates to:
  /// **'Saved. A follow-up was added.'**
  String get verifyDoneLater;

  /// No description provided for @verifyDoneRejected.
  ///
  /// In en, this message translates to:
  /// **'Enquiry closed.'**
  String get verifyDoneRejected;

  /// No description provided for @verifyDuplicateNote.
  ///
  /// In en, this message translates to:
  /// **'This number also has {ids} open. Check it is not a duplicate.'**
  String verifyDuplicateNote(String ids);

  /// No description provided for @verifyExplainGenuine.
  ///
  /// In en, this message translates to:
  /// **'The enquiry will be marked verified and move to qualification.'**
  String get verifyExplainGenuine;

  /// No description provided for @verifyExplainLater.
  ///
  /// In en, this message translates to:
  /// **'The enquiry stays open and a follow-up is added for you.'**
  String get verifyExplainLater;

  /// No description provided for @verifyExplainReject.
  ///
  /// In en, this message translates to:
  /// **'The enquiry will be closed and the referral partner told why.'**
  String get verifyExplainReject;

  /// No description provided for @verifyNotesHint.
  ///
  /// In en, this message translates to:
  /// **'What the customer said, in a few words'**
  String get verifyNotesHint;

  /// No description provided for @verifyRecordingConsent.
  ///
  /// In en, this message translates to:
  /// **'The customer agreed to the call being recorded.'**
  String get verifyRecordingConsent;

  /// No description provided for @verifyReferredBy.
  ///
  /// In en, this message translates to:
  /// **'Referred by {name}'**
  String verifyReferredBy(String name);

  /// No description provided for @verifyRejectBody.
  ///
  /// In en, this message translates to:
  /// **'It will be closed as \"{reason}\". You can ask admin to reopen it later.'**
  String verifyRejectBody(String reason);

  /// No description provided for @verifyRejectConfirm.
  ///
  /// In en, this message translates to:
  /// **'Close enquiry'**
  String get verifyRejectConfirm;

  /// No description provided for @verifyRejectTitle.
  ///
  /// In en, this message translates to:
  /// **'Close this enquiry?'**
  String get verifyRejectTitle;

  /// No description provided for @verifySave.
  ///
  /// In en, this message translates to:
  /// **'Save result'**
  String get verifySave;

  /// No description provided for @verifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify enquiry'**
  String get verifyTitle;

  /// No description provided for @verifyWhatHappened.
  ///
  /// In en, this message translates to:
  /// **'What happened on the call?'**
  String get verifyWhatHappened;

  /// No description provided for @visFull.
  ///
  /// In en, this message translates to:
  /// **'Full details'**
  String get visFull;

  /// No description provided for @visHidden.
  ///
  /// In en, this message translates to:
  /// **'Hidden'**
  String get visHidden;

  /// No description provided for @visLimited.
  ///
  /// In en, this message translates to:
  /// **'Name and area only'**
  String get visLimited;

  /// No description provided for @visitBookTitle.
  ///
  /// In en, this message translates to:
  /// **'Book a visit'**
  String get visitBookTitle;

  /// No description provided for @visitBooked.
  ///
  /// In en, this message translates to:
  /// **'Visit booked. Everyone has been told.'**
  String get visitBooked;

  /// No description provided for @visitCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel visit'**
  String get visitCancel;

  /// No description provided for @visitCancelCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer not available'**
  String get visitCancelCustomer;

  /// No description provided for @visitCancelReason.
  ///
  /// In en, this message translates to:
  /// **'Cancelled: {reason}'**
  String visitCancelReason(String reason);

  /// No description provided for @visitCancelTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel the visit'**
  String get visitCancelTitle;

  /// No description provided for @visitCancelVendor.
  ///
  /// In en, this message translates to:
  /// **'Vendor not available'**
  String get visitCancelVendor;

  /// No description provided for @visitCancelWeather.
  ///
  /// In en, this message translates to:
  /// **'Weather or site not ready'**
  String get visitCancelWeather;

  /// No description provided for @visitCancelled.
  ///
  /// In en, this message translates to:
  /// **'Visit cancelled.'**
  String get visitCancelled;

  /// No description provided for @visitConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get visitConfirm;

  /// No description provided for @visitConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Visit confirmed.'**
  String get visitConfirmed;

  /// No description provided for @visitCustomerConfirm.
  ///
  /// In en, this message translates to:
  /// **'Yes, the vendor visited'**
  String get visitCustomerConfirm;

  /// No description provided for @visitCustomerConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Customer confirmed the visit'**
  String get visitCustomerConfirmed;

  /// No description provided for @visitDone.
  ///
  /// In en, this message translates to:
  /// **'Visit marked done.'**
  String get visitDone;

  /// No description provided for @visitDoneBody.
  ///
  /// In en, this message translates to:
  /// **'The vendor can then prepare the quotation.'**
  String get visitDoneBody;

  /// No description provided for @visitDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Did the visit happen?'**
  String get visitDoneTitle;

  /// No description provided for @visitIntroduceFirst.
  ///
  /// In en, this message translates to:
  /// **'{vendor} accepted. Introduce them to the customer before booking a visit.'**
  String visitIntroduceFirst(String vendor);

  /// No description provided for @visitMarkDone.
  ///
  /// In en, this message translates to:
  /// **'Mark visit done'**
  String get visitMarkDone;

  /// No description provided for @visitNeedVendor.
  ///
  /// In en, this message translates to:
  /// **'A vendor must accept the referral first.'**
  String get visitNeedVendor;

  /// No description provided for @visitNoShow.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t happen'**
  String get visitNoShow;

  /// No description provided for @visitNoShowSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved. A follow-up call was added.'**
  String get visitNoShowSaved;

  /// No description provided for @visitProposeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'O2O Boss will confirm the time with the customer.'**
  String get visitProposeSubtitle;

  /// No description provided for @visitProposeTitle.
  ///
  /// In en, this message translates to:
  /// **'Propose a visit'**
  String get visitProposeTitle;

  /// No description provided for @visitProposed.
  ///
  /// In en, this message translates to:
  /// **'Visit proposed. Back office will confirm.'**
  String get visitProposed;

  /// No description provided for @visitPurpose.
  ///
  /// In en, this message translates to:
  /// **'Purpose'**
  String get visitPurpose;

  /// No description provided for @visitPurposeHint.
  ///
  /// In en, this message translates to:
  /// **'For example: measure the site and check wiring'**
  String get visitPurposeHint;

  /// No description provided for @visitRescheduled.
  ///
  /// In en, this message translates to:
  /// **'Visit rescheduled.'**
  String get visitRescheduled;

  /// No description provided for @visitThanks.
  ///
  /// In en, this message translates to:
  /// **'Thanks for confirming.'**
  String get visitThanks;

  /// No description provided for @visitWhen.
  ///
  /// In en, this message translates to:
  /// **'Date and time'**
  String get visitWhen;

  /// No description provided for @vnAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get vnAccept;

  /// No description provided for @vnAcceptSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Give a rough idea. You will send the exact quotation later.'**
  String get vnAcceptSubtitle;

  /// No description provided for @vnAcceptTitle.
  ///
  /// In en, this message translates to:
  /// **'Accept this referral'**
  String get vnAcceptTitle;

  /// No description provided for @vnAcceptedToast.
  ///
  /// In en, this message translates to:
  /// **'Referral accepted. O2O Boss will share the next steps.'**
  String get vnAcceptedToast;

  /// No description provided for @vnAllClearBody.
  ///
  /// In en, this message translates to:
  /// **'New referrals from O2O Boss will appear here.'**
  String get vnAllClearBody;

  /// No description provided for @vnAllClearTitle.
  ///
  /// In en, this message translates to:
  /// **'All caught up'**
  String get vnAllClearTitle;

  /// No description provided for @vnAreas.
  ///
  /// In en, this message translates to:
  /// **'Service areas'**
  String get vnAreas;

  /// No description provided for @vnAreasSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Cities and areas you cover'**
  String get vnAreasSubtitle;

  /// No description provided for @vnBusinessProfile.
  ///
  /// In en, this message translates to:
  /// **'Business profile'**
  String get vnBusinessProfile;

  /// No description provided for @vnCatalog.
  ///
  /// In en, this message translates to:
  /// **'Products and brands'**
  String get vnCatalog;

  /// No description provided for @vnCatalogSubtitle.
  ///
  /// In en, this message translates to:
  /// **'What you sell and install'**
  String get vnCatalogSubtitle;

  /// No description provided for @vnChatHelp.
  ///
  /// In en, this message translates to:
  /// **'Ask questions or share photos about this job'**
  String get vnChatHelp;

  /// No description provided for @vnChatWithO2O.
  ///
  /// In en, this message translates to:
  /// **'Chat with O2O Boss'**
  String get vnChatWithO2O;

  /// No description provided for @vnClosedBody.
  ///
  /// In en, this message translates to:
  /// **'The customer did not go ahead. Thank you for your time.'**
  String get vnClosedBody;

  /// No description provided for @vnClosedTitle.
  ///
  /// In en, this message translates to:
  /// **'This enquiry is closed'**
  String get vnClosedTitle;

  /// No description provided for @vnCustomerHidden.
  ///
  /// In en, this message translates to:
  /// **'Shared after you accept'**
  String get vnCustomerHidden;

  /// No description provided for @vnDecline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get vnDecline;

  /// No description provided for @vnDeclineArea.
  ///
  /// In en, this message translates to:
  /// **'Area is too far'**
  String get vnDeclineArea;

  /// No description provided for @vnDeclineBudget.
  ///
  /// In en, this message translates to:
  /// **'Budget is too low'**
  String get vnDeclineBudget;

  /// No description provided for @vnDeclineBusy.
  ///
  /// In en, this message translates to:
  /// **'Too busy right now'**
  String get vnDeclineBusy;

  /// No description provided for @vnDeclineProduct.
  ///
  /// In en, this message translates to:
  /// **'We don\'t offer this product'**
  String get vnDeclineProduct;

  /// No description provided for @vnDeclineTitle.
  ///
  /// In en, this message translates to:
  /// **'Why are you declining?'**
  String get vnDeclineTitle;

  /// No description provided for @vnDeclinedBody.
  ///
  /// In en, this message translates to:
  /// **'Reason: {reason}'**
  String vnDeclinedBody(String reason);

  /// No description provided for @vnDeclinedTitle.
  ///
  /// In en, this message translates to:
  /// **'You declined this referral'**
  String get vnDeclinedTitle;

  /// No description provided for @vnDeclinedToast.
  ///
  /// In en, this message translates to:
  /// **'Referral declined.'**
  String get vnDeclinedToast;

  /// No description provided for @vnDocumentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'GST, PAN, licence and bank proof'**
  String get vnDocumentsSubtitle;

  /// No description provided for @vnEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'When O2O Boss sends you a customer, it shows up in this list.'**
  String get vnEmptyBody;

  /// No description provided for @vnEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No referrals here'**
  String get vnEmptyTitle;

  /// No description provided for @vnExpectedDays.
  ///
  /// In en, this message translates to:
  /// **'Days to finish the work'**
  String get vnExpectedDays;

  /// No description provided for @vnExpectedPrice.
  ///
  /// In en, this message translates to:
  /// **'Expected price'**
  String get vnExpectedPrice;

  /// No description provided for @vnExpiredBody.
  ///
  /// In en, this message translates to:
  /// **'The time to reply ran out, so it went to another vendor.'**
  String get vnExpiredBody;

  /// No description provided for @vnExpiredTitle.
  ///
  /// In en, this message translates to:
  /// **'This referral has expired'**
  String get vnExpiredTitle;

  /// No description provided for @vnFilterActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get vnFilterActive;

  /// No description provided for @vnFilterClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get vnFilterClosed;

  /// No description provided for @vnFilterNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get vnFilterNew;

  /// No description provided for @vnFilterWon.
  ///
  /// In en, this message translates to:
  /// **'Won'**
  String get vnFilterWon;

  /// No description provided for @vnHomeSummary.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No new referrals right now.} =1{1 new referral is waiting.} other{{count} new referrals are waiting.}}'**
  String vnHomeSummary(int count);

  /// No description provided for @vnKpiActive.
  ///
  /// In en, this message translates to:
  /// **'Active jobs'**
  String get vnKpiActive;

  /// No description provided for @vnKpiNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get vnKpiNew;

  /// No description provided for @vnKpiProjects.
  ///
  /// In en, this message translates to:
  /// **'Work going on'**
  String get vnKpiProjects;

  /// No description provided for @vnKpiQuotes.
  ///
  /// In en, this message translates to:
  /// **'Open quotes'**
  String get vnKpiQuotes;

  /// No description provided for @vnMoreBusiness.
  ///
  /// In en, this message translates to:
  /// **'Your business'**
  String get vnMoreBusiness;

  /// No description provided for @vnNewBody.
  ///
  /// In en, this message translates to:
  /// **'Reply by {time} so the customer is not kept waiting.'**
  String vnNewBody(String time);

  /// No description provided for @vnNewButton.
  ///
  /// In en, this message translates to:
  /// **'See referral'**
  String get vnNewButton;

  /// No description provided for @vnNewQuote.
  ///
  /// In en, this message translates to:
  /// **'Create quotation'**
  String get vnNewQuote;

  /// No description provided for @vnNewTitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{New referral waiting} other{{count} new referrals waiting}}'**
  String vnNewTitle(int count);

  /// No description provided for @vnNextChangesBody.
  ///
  /// In en, this message translates to:
  /// **'Read the note on the quotation and send a new version.'**
  String get vnNextChangesBody;

  /// No description provided for @vnNextChangesTitle.
  ///
  /// In en, this message translates to:
  /// **'Changes asked'**
  String get vnNextChangesTitle;

  /// No description provided for @vnNextCheckBody.
  ///
  /// In en, this message translates to:
  /// **'You will get a message when it goes to the customer.'**
  String get vnNextCheckBody;

  /// No description provided for @vnNextCheckTitle.
  ///
  /// In en, this message translates to:
  /// **'O2O Boss is checking your quotation'**
  String get vnNextCheckTitle;

  /// No description provided for @vnNextCustomerBody.
  ///
  /// In en, this message translates to:
  /// **'We will tell you as soon as they reply.'**
  String get vnNextCustomerBody;

  /// No description provided for @vnNextCustomerTitle.
  ///
  /// In en, this message translates to:
  /// **'The customer is deciding'**
  String get vnNextCustomerTitle;

  /// No description provided for @vnNextDraftBody.
  ///
  /// In en, this message translates to:
  /// **'Your draft is saved. Send it when it is ready.'**
  String get vnNextDraftBody;

  /// No description provided for @vnNextDraftTitle.
  ///
  /// In en, this message translates to:
  /// **'Finish your quotation'**
  String get vnNextDraftTitle;

  /// No description provided for @vnNextLabel.
  ///
  /// In en, this message translates to:
  /// **'Next step'**
  String get vnNextLabel;

  /// No description provided for @vnNextQuoteBody.
  ///
  /// In en, this message translates to:
  /// **'Add the items and price. O2O Boss checks it before the customer sees it.'**
  String get vnNextQuoteBody;

  /// No description provided for @vnNextQuoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Send your quotation'**
  String get vnNextQuoteTitle;

  /// No description provided for @vnNextVisitBody.
  ///
  /// In en, this message translates to:
  /// **'Suggest a time. O2O Boss confirms it with the customer.'**
  String get vnNextVisitBody;

  /// No description provided for @vnNextVisitSetBody.
  ///
  /// In en, this message translates to:
  /// **'{time} at {place}'**
  String vnNextVisitSetBody(String time, String place);

  /// No description provided for @vnNextVisitSetTitle.
  ///
  /// In en, this message translates to:
  /// **'Visit planned'**
  String get vnNextVisitSetTitle;

  /// No description provided for @vnNextVisitTitle.
  ///
  /// In en, this message translates to:
  /// **'Plan a site visit'**
  String get vnNextVisitTitle;

  /// No description provided for @vnNextWorkBody.
  ///
  /// In en, this message translates to:
  /// **'Tick each step as it is done so everyone can see progress.'**
  String get vnNextWorkBody;

  /// No description provided for @vnNextWorkTitle.
  ///
  /// In en, this message translates to:
  /// **'Update the work'**
  String get vnNextWorkTitle;

  /// No description provided for @vnNoQuotes.
  ///
  /// In en, this message translates to:
  /// **'No quotation yet'**
  String get vnNoQuotes;

  /// No description provided for @vnNoVisits.
  ///
  /// In en, this message translates to:
  /// **'No visit planned yet'**
  String get vnNoVisits;

  /// No description provided for @vnNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Note for O2O Boss'**
  String get vnNoteLabel;

  /// No description provided for @vnOpenDraft.
  ///
  /// In en, this message translates to:
  /// **'Open draft'**
  String get vnOpenDraft;

  /// No description provided for @vnOpenProject.
  ///
  /// In en, this message translates to:
  /// **'Open work'**
  String get vnOpenProject;

  /// No description provided for @vnPendingBody.
  ///
  /// In en, this message translates to:
  /// **'You can look around. Referrals start once O2O Boss approves your business.'**
  String get vnPendingBody;

  /// No description provided for @vnPendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Your business is being checked'**
  String get vnPendingTitle;

  /// No description provided for @vnPrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'The customer\'s name is shared after you accept. You always reach them through O2O Boss.'**
  String get vnPrivacyNote;

  /// No description provided for @vnProposeVisit.
  ///
  /// In en, this message translates to:
  /// **'Suggest a visit'**
  String get vnProposeVisit;

  /// No description provided for @vnQuoteBody.
  ///
  /// In en, this message translates to:
  /// **'{job} is ready for your price.'**
  String vnQuoteBody(String job);

  /// No description provided for @vnQuoteButton.
  ///
  /// In en, this message translates to:
  /// **'Create quotation'**
  String get vnQuoteButton;

  /// No description provided for @vnQuoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Send a quotation'**
  String get vnQuoteTitle;

  /// No description provided for @vnQuotesChecking.
  ///
  /// In en, this message translates to:
  /// **'Being checked'**
  String get vnQuotesChecking;

  /// No description provided for @vnQuotesDrafts.
  ///
  /// In en, this message translates to:
  /// **'Drafts'**
  String get vnQuotesDrafts;

  /// No description provided for @vnReferralTitle.
  ///
  /// In en, this message translates to:
  /// **'Referral'**
  String get vnReferralTitle;

  /// No description provided for @vnReplyBy.
  ///
  /// In en, this message translates to:
  /// **'Please reply by {time}'**
  String vnReplyBy(String time);

  /// No description provided for @vnReplyStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get vnReplyStatus;

  /// No description provided for @vnRevise.
  ///
  /// In en, this message translates to:
  /// **'Make changes'**
  String get vnRevise;

  /// No description provided for @vnStatusNew.
  ///
  /// In en, this message translates to:
  /// **'New referral'**
  String get vnStatusNew;

  /// No description provided for @vnUpcomingVisits.
  ///
  /// In en, this message translates to:
  /// **'Upcoming visits'**
  String get vnUpcomingVisits;

  /// No description provided for @vnYourReply.
  ///
  /// In en, this message translates to:
  /// **'Your reply'**
  String get vnYourReply;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'as',
    'bn',
    'brx',
    'doi',
    'en',
    'gu',
    'hi',
    'kn',
    'kok',
    'ks',
    'mai',
    'ml',
    'mni',
    'mr',
    'ne',
    'or',
    'pa',
    'sa',
    'sat',
    'sd',
    'ta',
    'te',
    'ur',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'as':
      return AppLocalizationsAs();
    case 'bn':
      return AppLocalizationsBn();
    case 'brx':
      return AppLocalizationsBrx();
    case 'doi':
      return AppLocalizationsDoi();
    case 'en':
      return AppLocalizationsEn();
    case 'gu':
      return AppLocalizationsGu();
    case 'hi':
      return AppLocalizationsHi();
    case 'kn':
      return AppLocalizationsKn();
    case 'kok':
      return AppLocalizationsKok();
    case 'ks':
      return AppLocalizationsKs();
    case 'mai':
      return AppLocalizationsMai();
    case 'ml':
      return AppLocalizationsMl();
    case 'mni':
      return AppLocalizationsMni();
    case 'mr':
      return AppLocalizationsMr();
    case 'ne':
      return AppLocalizationsNe();
    case 'or':
      return AppLocalizationsOr();
    case 'pa':
      return AppLocalizationsPa();
    case 'sa':
      return AppLocalizationsSa();
    case 'sat':
      return AppLocalizationsSat();
    case 'sd':
      return AppLocalizationsSd();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

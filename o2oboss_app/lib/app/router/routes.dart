import '../../core/models/models.dart';

/// Every path in the app, in one place.
abstract final class Routes {
  static const welcome = '/welcome';
  static const login = '/login';
  static const signup = '/signup';
  static const signupFranchise = '/signup/franchise';
  static const forgot = '/forgot';
  static const pending = '/pending';
  static const changePassword = '/change-password';

  static const notifications = '/notifications';
  static const search = '/search';
  static const profile = '/profile';
  static const editProfile = '/profile/edit';
  static const settings = '/settings';
  static const language = '/settings/language';
  static const notificationSettings = '/settings/notifications';
  static const help = '/help';
  static String legal(String doc) => '/legal/$doc';

  static String enquiry(String id) => '/enquiry/$id';
  static String enquiryPart(String id, String part) => '/enquiry/$id/$part';
  static String chat(String enquiryId, String thread) => '/enquiry/$enquiryId/chat/$thread';
  static String refer({String? category}) =>
      category == null ? '/refer/new' : '/refer/new?category=$category';

  static String quotation(String id) => '/quotation/$id';
  static String newQuotation(String enquiryId, String vendorId) =>
      '/quotation/new?enquiry=$enquiryId&vendor=$vendorId';
  static String editQuotation(String id) => '/quotation/$id/edit';
  static String reviseQuotation(String id) => '/quotation/$id/revise';
  static String project(String id) => '/project/$id';
  static String product(String id) => '/products/$id';

  // Shared lists opened from "More" pages.
  static const appointments = '/appointments';
  static const projects = '/projects';
  static const payments = '/payments';
  static const commissions = '/commissions';
  static const calls = '/calls';
  static const quotations = '/quotations';
  static const customers = '/customers';
  static String customer(String id) => '/customers/$id';
  static const vendors = '/vendors';
  static String vendor(String id) => '/vendors/$id';
  static String person(String userId) => '/people/$userId';
  static String report(String type) => '/reports/$type';

  // Vendor business profile.
  static const vendorCompany = '/business/profile';
  static const vendorCatalog = '/business/catalog';
  static const vendorAreas = '/business/areas';
  static const vendorDocuments = '/business/documents';

  // Franchise.
  static const territory = '/territory';

  // Admin tools.
  static const adminUsers = '/manage/users';
  static const adminNewUser = '/manage/users/new';
  static String adminUser(String id) => '/manage/users/$id';
  static const adminSettings = '/manage/settings';
  static String adminSettingsSection(String s) => '/manage/settings/$s';
  static const adminCategories = '/manage/categories';
  static String adminCategory(String id) => '/manage/categories/$id';
  static const adminBrands = '/manage/brands';
  static const adminProducts = '/manage/products';
  static const adminLocations = '/manage/locations';
  static const adminFranchises = '/manage/franchises';
  static String adminFranchise(String id) => '/manage/franchises/$id';
  static const adminAudit = '/manage/audit';
  static const adminVendorApprovals = '/manage/vendor-approvals';
  static const adminRoles = '/manage/roles';

  static String prefix(UserRole r) => switch (r) {
        UserRole.sales => '/sales',
        UserRole.backOffice => '/bo',
        UserRole.vendor => '/vendor',
        UserRole.customer => '/customer',
        UserRole.franchise => '/franchise',
        UserRole.admin => '/admin',
      };

  static String home(UserRole r) => '${prefix(r)}/home';

  /// Where each role's own profile lives (a tab for some, a page for others).
  static String profileFor(UserRole r) => switch (r) {
        UserRole.sales => '/sales/profile',
        UserRole.customer => '/customer/profile',
        _ => profile,
      };
}

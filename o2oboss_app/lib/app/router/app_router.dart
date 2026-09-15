import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/app_store.dart';
import '../../core/l10n/locale_controller.dart';
import '../../core/models/models.dart';
import '../../features/admin/admin_catalog.dart';
import '../../features/admin/admin_records.dart';
import '../../features/admin/admin_settings.dart';
import '../../features/admin/admin_tabs.dart';
import '../../features/admin/admin_users.dart';
import '../../features/auth/account_gate_screens.dart';
import '../../features/auth/explore_screen.dart';
import '../../features/auth/forgot_password_screen.dart';
import '../../features/auth/language_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/signup_screen.dart';
import '../../features/auth/franchise_signup_screen.dart';
import '../../features/backoffice/bo_home_screen.dart';
import '../../features/backoffice/bo_more_screen.dart';
import '../../features/backoffice/followups_screen.dart';
import '../../features/backoffice/ops_enquiries_screen.dart';
import '../../features/backoffice/tasks_screen.dart';
import '../../features/chat/chat_screens.dart';
import '../../features/customer/customer_home_screen.dart';
import '../../features/customer/customer_requirements_screen.dart';
import '../../features/customer/product_screens.dart';
import '../../features/common/earnings_screen.dart';
import '../../features/ops/enquiry_part_screen.dart';
import '../../features/ops/lists.dart';
import '../../features/project/project_screen.dart';
import '../../features/quotation/quotation_form_screen.dart';
import '../../features/quotation/quotation_screen.dart';
import '../../features/common/edit_profile_screen.dart';
import '../../features/common/help_screen.dart';
import '../../features/common/legal_screen.dart';
import '../../features/common/notification_settings_screen.dart';
import '../../features/common/notifications_screen.dart';
import '../../features/common/profile_screen.dart';
import '../../features/common/search_screen.dart';
import '../../features/common/system_screens.dart';
import '../../features/common/about_screen.dart';
import '../../features/enquiry/enquiry_detail_screen.dart';
import '../../features/enquiry/new_enquiry_screen.dart';
import '../../features/franchise/franchise_screens.dart';
import '../../features/sales/refer_tab_screen.dart';
import '../../features/sales/sales_enquiries_screen.dart';
import '../../features/sales/sales_home_screen.dart';
import '../../features/vendor/vendor_business_screens.dart';
import '../../features/vendor/vendor_home_screen.dart';
import '../../features/vendor/vendor_more_screen.dart';
import '../../features/vendor/vendor_referrals_screen.dart';
import '../../shared/navigation/role_shell.dart';
import '../../shared/navigation/role_tabs.dart';
import 'routes.dart';
import 'transitions.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// Re-runs redirects when sign-in, language choice or account state changes.
class _RouterRefresh extends ChangeNotifier {
  _RouterRefresh(Ref ref) {
    ref.listen(sessionProvider, (_, _) => notifyListeners());
    ref.listen(localeProvider, (prev, next) {
      if ((prev == null) != (next == null)) notifyListeners();
    });
    ref.listen(
      currentUserProvider.select((u) => '${u?.status.name}|${u?.mustChangePassword}'),
      (_, _) => notifyListeners(),
    );
  }
}

const _publicRoutes = {
  Routes.welcome, Routes.login, Routes.explore, Routes.signup, Routes.signupFranchise, Routes.forgot,
};

String? _redirect(Ref ref, GoRouterState state) {
  final loc = state.matchedLocation;
  if (ref.read(localeProvider) == null) {
    return loc == Routes.welcome ? null : Routes.welcome;
  }
  final user = ref.read(currentUserProvider);
  final isPublic = _publicRoutes.contains(loc) ||
      loc.startsWith('/legal/') ||
      (user == null && loc == Routes.help);
  if (user == null) return isPublic ? null : Routes.login;
  if (user.status != AccountStatus.active) {
    const allowed = {Routes.pending, Routes.help};
    return allowed.contains(loc) || loc.startsWith('/legal/') ? null : Routes.pending;
  }
  if (user.mustChangePassword) {
    return loc == Routes.changePassword ? null : Routes.changePassword;
  }
  if (_publicRoutes.contains(loc) || loc == '/' || loc == Routes.pending) {
    return Routes.home(user.role);
  }
  // Each role only reaches its own tab area.
  for (final r in UserRole.values) {
    if (r != user.role && loc.startsWith('${Routes.prefix(r)}/')) {
      return Routes.home(user.role);
    }
  }
  return null;
}

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _RouterRefresh(ref);
  final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    refreshListenable: refresh,
    redirect: (context, state) => _redirect(ref, state),
    errorPageBuilder: (context, state) => fadePage(state, const NotFoundScreen()),
    routes: [
      GoRoute(path: '/', builder: (_, _) => const SizedBox.shrink()),
      GoRoute(
        path: Routes.welcome,
        pageBuilder: (_, s) => fadePage(s, const LanguageScreen()),
      ),
      GoRoute(path: Routes.login, pageBuilder: (_, s) => fadePage(s, const LoginScreen())),
      GoRoute(path: Routes.explore, pageBuilder: (_, s) => pushPage(s, const ExploreScreen())),
      GoRoute(
        path: Routes.signup,
        pageBuilder: (_, s) => pushPage(
          s,
          SignupScreen(
            initialRole: UserRole.values.asNameMap()[s.uri.queryParameters['role']],
            initialOccupation: Occupation.values.asNameMap()[s.uri.queryParameters['occupation']],
          ),
        ),
      ),
      GoRoute(path: Routes.signupFranchise, pageBuilder: (_, s) => pushPage(s, const FranchiseSignupScreen())),
      GoRoute(
        path: Routes.forgot,
        pageBuilder: (_, s) => pushPage(s, const ForgotPasswordScreen()),
      ),
      GoRoute(path: Routes.pending, pageBuilder: (_, s) => fadePage(s, const PendingScreen())),
      GoRoute(
        path: Routes.changePassword,
        pageBuilder: (_, s) => pushPage(s, const ChangePasswordScreen()),
      ),
      for (final role in UserRole.values) _shell(role),
      ...pageRoutes(),
    ],
  );
  ref.onDispose(() {
    router.dispose();
    refresh.dispose();
  });
  return router;
});

StatefulShellRoute _shell(UserRole role) => StatefulShellRoute(
      builder: (context, state, shell) => RoleShell(role: role, shell: shell),
      navigatorContainerBuilder: (context, shell, children) =>
          FadeBranchContainer(index: shell.currentIndex, children: children),
      branches: [
        for (final tab in tabsFor(role))
          StatefulShellBranch(routes: [
            GoRoute(
              path: tab.path,
              pageBuilder: (_, s) => NoTransitionPage(key: s.pageKey, child: tabScreen(tab.path)),
            ),
          ]),
      ],
    );

/// The screen for each bottom tab.
Widget tabScreen(String path) => switch (path) {
      '/sales/home' => const SalesHomeScreen(),
      '/sales/enquiries' => const SalesEnquiriesScreen(),
      '/sales/refer' => const ReferTabScreen(),
      '/sales/earnings' => const EarningsScreen(),
      '/sales/profile' => const ProfileScreen(),
      '/bo/home' => const BoHomeScreen(),
      '/bo/enquiries' => const OpsEnquiriesScreen(listKey: 'bo'),
      '/bo/followups' => const FollowUpsScreen(),
      '/bo/tasks' => const TasksScreen(),
      '/bo/more' => const BoMoreScreen(),
      '/vendor/home' => const VendorHomeScreen(),
      '/vendor/referrals' => const VendorReferralsScreen(),
      '/vendor/chat' => const AllChatsView(),
      '/vendor/quotations' => const QuotationsListScreen(),
      '/vendor/more' => const VendorMoreScreen(),
      '/customer/home' => const CustomerHomeScreen(),
      '/customer/requirement' => const CustomerRequirementsScreen(),
      '/customer/quotations' => const QuotationsListScreen(),
      '/customer/products' => const ProductsScreen(),
      '/customer/profile' => const ProfileScreen(),
      '/franchise/home' => const FranchiseHomeScreen(),
      '/franchise/business' => const OpsEnquiriesScreen(listKey: 'franchise'),
      '/franchise/network' => const FranchiseNetworkScreen(),
      '/franchise/earnings' => const EarningsScreen(),
      '/franchise/more' => const FranchiseMoreScreen(),
      '/admin/home' => const AdminHomeScreen(),
      '/admin/enquiries' => const OpsEnquiriesScreen(listKey: 'admin'),
      '/admin/business' => const AdminBusinessScreen(),
      '/admin/reports' => const AdminReportsScreen(),
      '/admin/more' => const AdminMoreScreen(),
      _ => PlaceholderScreen(path),
    };

GoRoute _push(String path, Widget Function(GoRouterState s) build,
        {List<RouteBase> routes = const []}) =>
    GoRoute(
      path: path,
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (_, s) => pushPage(s, build(s)),
      routes: routes,
    );

/// Full-screen pages that open on top of the tabs.
List<RouteBase> pageRoutes() => [
      _push('/enquiry/:id', (s) => EnquiryDetailScreen(id: s.pathParameters['id']!)),
      _push('/enquiry/:id/chat/:thread',
          (s) => ChatScreen(enquiryId: s.pathParameters['id']!, thread: s.pathParameters['thread']!)),
      _push('/enquiry/:id/:part',
          (s) => EnquiryPartScreen(id: s.pathParameters['id']!, part: s.pathParameters['part']!)),
      _push('/quotation/new', (s) => QuotationFormScreen(
            mode: QuotationFormMode.create,
            enquiryId: s.uri.queryParameters['enquiry'],
            vendorId: s.uri.queryParameters['vendor'],
          )),
      _push('/quotation/:id', (s) => QuotationScreen(id: s.pathParameters['id']!)),
      _push('/quotation/:id/edit', (s) => QuotationFormScreen(
          mode: QuotationFormMode.edit, quotationId: s.pathParameters['id'])),
      _push('/quotation/:id/revise', (s) => QuotationFormScreen(
          mode: QuotationFormMode.revise, quotationId: s.pathParameters['id'])),
      _push('/project/:id', (s) => ProjectScreen(id: s.pathParameters['id']!)),
      _push('/products/:id', (s) => ProductDetailScreen(id: s.pathParameters['id']!)),
      _push('/products/:id/sellers/:code', (s) => SellerOfferScreen(
          productId: s.pathParameters['id']!, code: s.pathParameters['code']!)),
      _push(Routes.appointments, (_) => const AppointmentsListScreen()),
      _push(Routes.quotations, (_) => const QuotationsListScreen()),
      _push(Routes.projects, (_) => const ProjectsListScreen()),
      _push(Routes.payments, (_) => const PaymentsListScreen()),
      _push(Routes.commissions, (_) => const CommissionsScreen()),
      _push(Routes.calls, (_) => const CallsListScreen()),
      _push('/chats', (_) => const AllChatsView()),
      _push(Routes.customers, (_) => const CustomersListScreen()),
      _push('/customers/:id', (s) => CustomerDetailScreen(id: s.pathParameters['id']!)),
      _push(Routes.vendors, (s) => VendorsListScreen(initialFilter: s.uri.queryParameters['filter'])),
      _push('/vendors/:id', (s) => VendorDetailScreen(id: s.pathParameters['id']!)),
      _push(Routes.adminUsers, (_) => const AdminUsersScreen()),
      _push(Routes.adminNewUser, (_) => const AdminNewUserScreen()),
      _push('/manage/users/:id', (s) => AdminUserScreen(id: s.pathParameters['id']!)),
      _push(Routes.adminAudit, (_) => const AdminAuditScreen()),
      _push(Routes.adminSettings, (_) => const AdminSettingsScreen()),
      _push('/manage/settings/:section',
          (s) => AdminSettingsSectionScreen(section: s.pathParameters['section']!)),
      _push(Routes.adminCategories, (_) => const AdminCategoriesScreen()),
      _push('/manage/categories/:id', (s) => AdminCategoryScreen(id: s.pathParameters['id']!)),
      _push(Routes.adminProducts, (_) => const AdminProductsScreen()),
      _push(Routes.adminBrands, (_) => const AdminBrandsScreen()),
      _push(Routes.adminLocations, (_) => const AdminLocationsScreen()),
      _push('/manage/locations/:id', (s) => AdminCityScreen(id: s.pathParameters['id']!)),
      _push(Routes.adminFranchises, (_) => const AdminFranchisesScreen()),
      _push('/manage/franchises/:id', (s) => AdminFranchiseScreen(id: s.pathParameters['id']!)),
      _push(Routes.adminRoles, (_) => const AdminRolesScreen()),
      _push(Routes.vendorCompany, (_) => const VendorCompanyScreen()),
      _push(Routes.vendorCatalog, (_) => const VendorCatalogScreen()),
      _push(Routes.vendorAreas, (_) => const VendorAreasScreen()),
      _push(Routes.vendorDocuments, (_) => const VendorDocumentsScreen()),
      _push('/refer/new',
          (s) => NewEnquiryScreen(categoryId: s.uri.queryParameters['category'])),
      _push(Routes.notifications, (_) => const NotificationsScreen()),
      _push(Routes.search, (_) => const SearchScreen()),
      _push(Routes.profile, (_) => const ProfileScreen()),
      _push(Routes.editProfile, (_) => const EditProfileScreen()),
      _push(Routes.settings, (_) => const ProfileScreen()),
      _push(Routes.language, (_) => const LanguageScreen(fromSettings: true)),
      _push(Routes.notificationSettings, (_) => const NotificationSettingsScreen()),
      _push(Routes.help, (_) => const HelpScreen()),
      _push(Routes.about, (_) => const AboutScreen()),
      _push('/legal/:doc', (s) => LegalScreen(doc: s.pathParameters['doc']!)),
    ];

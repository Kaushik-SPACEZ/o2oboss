import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:o2oboss_app/app/router/app_router.dart';
import 'package:o2oboss_app/app/router/routes.dart';
import 'package:o2oboss_app/shared/navigation/role_tabs.dart';
import 'package:o2oboss_app/core/models/models.dart';

import 'support/harness.dart';

const _opsPages = [
  '/enquiry/ENQ-1033',
  '/enquiry/ENQ-1003',
  '/enquiry/ENQ-1033/verify',
  '/enquiry/ENQ-1024/details',
  '/enquiry/ENQ-1024/calls',
  '/enquiry/ENQ-1032/qualify',
  '/enquiry/ENQ-1023/vendors',
  '/enquiry/ENQ-1029/visits',
  '/enquiry/ENQ-1024/quotations',
  '/enquiry/ENQ-1024/chat',
  '/enquiry/ENQ-1024/chat/v_securevision',
  '/enquiry/ENQ-1024/activity',
  '/enquiry/ENQ-1012/commission',
  '/quotation/q_2024_2',
  '/quotation/q_2012',
  '/project/PRJ-3001',
  '/project/PRJ-3005',
  '/appointments',
  '/quotations',
  '/projects',
  '/payments',
  '/commissions',
  '/calls',
  '/chats',
  '/customers',
  '/customers/c_yuvaraj',
  '/vendors',
  '/vendors?filter=pending',
  '/vendors/v_securevision',
];

/// Opens every screen for every role at phone size and fails on any layout
/// or build error. Also runs in Urdu (right-to-left) and Tamil (long text).
void main() {
  testWidgets('sales home renders its main action', (tester) async {
    await pumpApp(tester, as: 'sales');
    expect(find.text('Refer a customer'), findsOneWidget);
    // The list sits below the inspiration card, so scroll it into view.
    await tester.scrollUntilVisible(find.text('Latest referrals'), 300,
        scrollable: find.byType(Scrollable).first);
    expect(find.text('Latest referrals'), findsOneWidget);
  });

  testWidgets('public screens', (tester) async {
    await pumpApp(tester, location: Routes.login);
    expect(find.byType(Scaffold), findsWidgets);
    await pumpApp(tester, location: Routes.signup);
    await pumpApp(tester, location: Routes.forgot);
  });

  const roleKeys = {
    UserRole.sales: 'sales',
    UserRole.backOffice: 'backoffice',
    UserRole.vendor: 'vendor',
    UserRole.customer: 'customer',
    UserRole.franchise: 'franchise',
    UserRole.admin: 'admin',
  };

  const commonPages = [
    Routes.notifications,
    Routes.search,
    Routes.profile,
    Routes.editProfile,
    Routes.language,
    Routes.notificationSettings,
    Routes.help,
    '/legal/terms',
    '/legal/privacy',
    '/enquiry/ENQ-1024',
  ];
  const rolePages = {
    'sales': [
      '/refer/new',
      '/refer/new?category=cat_cctv',
      '/enquiry/ENQ-1003',
      '/enquiry/ENQ-1021',
      '/enquiry/ENQ-1033',
      '/enquiry/ENQ-1029',
      '/enquiry/ENQ-1015',
    ],
    'vendor': [
      '/enquiry/ENQ-1031',
      '/enquiry/ENQ-1029',
      '/enquiry/ENQ-1018',
      '/enquiry/ENQ-1012',
      '/quotation/q_2024_2',
      '/project/PRJ-3004',
      '/quotations',
      '/appointments',
      '/projects',
      '/payments',
      '/chats',
      '/enquiry/ENQ-1024/chat/v_securevision',
      '/business/profile',
      '/business/catalog',
      '/business/areas',
      '/business/documents',
    ],
    'customer': [
      '/enquiry/ENQ-1003',
      '/enquiry/ENQ-1024/chat',
      '/quotation/q_2024_2',
      '/project/PRJ-3001',
      '/quotations',
      '/projects',
      '/chats',
      '/refer/new',
      '/products/p_split_ac',
      '/products/p_gold',
      '/products/p_tv',
    ],
    'backoffice': _opsPages,
    'admin': [
      ..._opsPages,
      '/manage/users',
      '/manage/users/new',
      '/manage/users/u_sales_arun',
      '/manage/audit',
      '/manage/roles',
      '/manage/settings',
      '/manage/settings/enquiry',
      '/manage/settings/channels',
      '/manage/settings/vendors',
      '/manage/settings/visibility',
      '/manage/settings/quotations',
      '/manage/settings/payments',
      '/manage/settings/commission',
      '/manage/settings/feedback',
      '/manage/categories',
      '/manage/categories/cat_cctv',
      '/manage/products',
      '/manage/brands',
      '/manage/locations',
      '/manage/locations/city_vellore',
      '/manage/franchises',
      '/manage/franchises/f_vellore',
    ],
    'franchise': _opsPages,
  };

  for (final lang in ['en', 'hi', 'ur', 'ta']) {
    for (final entry in roleKeys.entries) {
      testWidgets('${entry.value} pages ($lang)', (tester) async {
        final c = await pumpApp(tester, as: entry.value, lang: lang);
        for (final page in [...commonPages, ...?rolePages[entry.value]]) {
          c.read(routerProvider).go(Routes.home(entry.key));
          await settle(tester, 1);
          c.read(routerProvider).push(page);
          await settle(tester);
          final error = tester.takeException();
          expect(error, isNull,
              reason: '$page\n${error is FlutterError ? error.toStringDeep() : error}');
        }
      });
    }
  }

  for (final lang in ['en', 'hi', 'ur', 'ta']) {
    for (final entry in roleKeys.entries) {
      testWidgets('${entry.value} tabs ($lang)', (tester) async {
        final c = await pumpApp(tester, as: entry.value, lang: lang);
        for (final tab in tabsFor(entry.key)) {
          c.read(routerProvider).go(tab.path);
          await settle(tester);
          expect(tester.takeException(), isNull, reason: tab.path);
        }
      });
    }
  }
}

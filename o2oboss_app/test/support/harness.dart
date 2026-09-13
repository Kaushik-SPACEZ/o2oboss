import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:o2oboss_app/app/app.dart';
import 'package:o2oboss_app/app/router/app_router.dart';
import 'package:o2oboss_app/app/theme/app_typography.dart';
import 'package:o2oboss_app/core/data/app_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Demo user for each role, as used by the widget tests.
const demoUsers = {
  'sales': 'u_sales_arun',
  'backoffice': 'u_bo_divya',
  'vendor': 'u_v_securevision',
  'customer': 'u_customer',
  'franchise': 'u_franchise',
  'admin': 'u_admin',
};

const phone = Size(390, 844);

/// Starts the whole app signed in as [as] (a key of [demoUsers]) and opens
/// [location]. Returns the provider container so tests can drive the store.
Future<ProviderContainer> pumpApp(
  WidgetTester tester, {
  String? as,
  String location = '/',
  String lang = 'en',
  Size size = phone,
}) async {
  AppType.useGoogleFonts = false;
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  SharedPreferences.setMockInitialValues({
    'o2o.locale': lang,
    'o2o.languageChosen': true,
    if (as != null) 'o2o.session': demoUsers[as]!,
  });
  final prefs = await SharedPreferences.getInstance();
  final container = ProviderContainer(
    overrides: [prefsProvider.overrideWithValue(prefs)],
  );
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const O2OBossApp()),
  );
  await settle(tester);
  if (location != '/') {
    container.read(routerProvider).go(location);
    await settle(tester);
  }
  return container;
}

/// Pumps enough frames for page transitions and demo loading delays, without
/// waiting on endless animations such as skeleton pulses.
Future<void> settle(WidgetTester tester, [int seconds = 2]) async {
  await tester.pump();
  for (var i = 0; i < seconds * 4; i++) {
    await tester.pump(const Duration(milliseconds: 250));
  }
}

/// Opens [location] on top of the current screen, like a tap would.
Future<void> push(WidgetTester tester, ProviderContainer c, String location) async {
  c.read(routerProvider).push(location);
  await settle(tester);
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:o2oboss_app/app/router/app_router.dart';
import 'package:o2oboss_app/app/theme/app_colors.dart';
import 'package:o2oboss_app/app/theme/theme_controller.dart';
import 'package:o2oboss_app/core/data/app_store.dart';
import 'package:o2oboss_app/core/models/models.dart';

import 'support/harness.dart';

void main() {
  testWidgets('customer searches products and places an order', (tester) async {
    final c = await pumpApp(tester, as: 'customer', location: '/customer/products');
    expect(find.text('Split AC'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'water');
    await settle(tester, 1);
    expect(find.text('Split AC'), findsNothing);
    expect(find.text('RO water purifier'), findsOneWidget);

    await tester.tap(find.text('RO water purifier'));
    await settle(tester);
    // Vendors are never named on the product page.
    expect(find.textContaining('Secure'), findsNothing);

    final before = c.read(dbProvider).enquiries.length;
    await tester.tap(find.text('Order now'));
    await settle(tester);
    await tester.tap(find.byTooltip('One more'));
    await tester.pump();
    await tester.ensureVisible(find.text('Place order'));
    await tester.tap(find.text('Place order'));
    await settle(tester);

    final db = c.read(dbProvider);
    expect(db.enquiries.length, before + 1);
    final e = db.enquiries.last;
    expect(e.productId, 'p_ro');
    expect(e.source, EnquirySource.customer);
    expect(e.requirement, contains('× 2'));
    expect(tester.takeException(), isNull);
  });

  testWidgets('a product question reaches the O2O Boss team in chat', (tester) async {
    final c = await pumpApp(tester, as: 'customer', location: '/products/p_tv');
    await tester.tap(find.text('Ask'));
    await settle(tester);
    await tester.enterText(find.byType(TextField).last, 'Is wall mounting free?');
    await tester.tap(find.text('Send'));
    await settle(tester);

    final db = c.read(dbProvider);
    final e = db.enquiries.last;
    expect(e.productId, 'p_tv');
    expect(
      db.messages.where((m) => m.enquiryId == e.id && m.thread == ChatMessage.customerThread),
      isNotEmpty,
    );
    expect(find.text('Is wall mounting free?'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('orders live in the customer profile', (tester) async {
    await pumpApp(tester, as: 'customer', location: '/customer/profile');
    await tester.tap(find.text('Orders'));
    await settle(tester);
    expect(find.text('Orders'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the orange theme recolours the whole app and is remembered', (tester) async {
    final c = await pumpApp(tester, as: 'customer', location: '/customer/profile');
    expect(AppColors.primary, AppPalette.classic.primary);

    await tester.ensureVisible(find.text('App colours'));
    await tester.tap(find.text('App colours'));
    await settle(tester);
    await tester.tap(find.text('O2O Boss orange'));
    await settle(tester);

    expect(c.read(themeProvider), AppThemeId.brand);
    expect(AppColors.primary, AppPalette.brand.primary);
    final ctx = tester.element(find.text('Products').first);
    expect(Theme.of(ctx).colorScheme.primary, AppPalette.brand.primary);
    expect(c.read(storageProvider).themeId, 'brand');

    c.read(routerProvider).go('/customer/products');
    await settle(tester);
    expect(tester.takeException(), isNull);
  });

  testWidgets('long pages scroll without a scrollbar, even on desktop', (tester) async {
    // Desktop browsers are where Flutter would normally draw the scrollbar.
    debugDefaultTargetPlatformOverride = TargetPlatform.windows;
    try {
      await pumpApp(tester, as: 'customer', location: '/products/p_split_ac');
      expect(find.byType(Scrollbar), findsNothing);
      expect(find.byType(RawScrollbar), findsNothing);
      final list = find.byType(Scrollable).first;
      final before = tester.state<ScrollableState>(list).position.pixels;
      await tester.drag(list, const Offset(0, -400));
      await settle(tester, 1);
      expect(tester.state<ScrollableState>(list).position.pixels, greaterThan(before));
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });
}

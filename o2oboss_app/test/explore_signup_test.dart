import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:o2oboss_app/core/data/app_store.dart';
import 'package:o2oboss_app/core/models/models.dart';
import 'package:o2oboss_app/shared/widgets/inputs.dart';

import 'support/harness.dart';

Future<void> tapText(WidgetTester tester, String text) async {
  await tester.ensureVisible(find.text(text).first);
  await tester.tap(find.text(text).first);
  await settle(tester);
}

/// The text box under the field label [label].
Finder fieldFor(String label) {
  final l = find.byWidgetPredicate((w) => w is FieldLabel && w.text == label);
  return find.descendant(
    of: find.ancestor(of: l, matching: find.byType(Column)).first,
    matching: find.byType(TextFormField),
  );
}

Future<void> fill(WidgetTester tester, String label, String value) async {
  // Long forms build lazily, so bring the field into view first.
  await tester.scrollUntilVisible(
    find.byWidgetPredicate((w) => w is FieldLabel && w.text == label),
    200,
    scrollable: find.byType(Scrollable).first,
  );
  final field = fieldFor(label).first;
  await tester.ensureVisible(field);
  await tester.enterText(field, value);
  await tester.pump();
}

Future<void> choose(WidgetTester tester, String field, String option) async {
  final select = find.byWidgetPredicate((w) => w is SelectField && w.label == field);
  await tester.scrollUntilVisible(select, 200, scrollable: find.byType(Scrollable).first);
  await tester.ensureVisible(select);
  await tester.tap(select);
  await settle(tester);
  await tester.tap(find.text(option).last);
  await settle(tester);
}

void main() {
  testWidgets('the logo opens Explore, and Earning asks what you do', (tester) async {
    await pumpApp(tester, location: '/login');
    await tester.tap(find.byTooltip('What can I do with O2O Boss?'));
    await settle(tester);

    expect(find.text('What would you like to do?'), findsOneWidget);
    for (final goal in ['Earning', 'Growing your business', 'Starting your business', 'Buying']) {
      await tester.scrollUntilVisible(find.text(goal), 200, scrollable: find.byType(Scrollable).first);
    }
    await tester.scrollUntilVisible(find.text('Earning'), -200, scrollable: find.byType(Scrollable).first);

    await tapText(tester, 'Earning');
    expect(find.text('Which of these describes you?'), findsOneWidget);
    for (final o in ['Student', 'Employed', 'Self-employed', 'Homemaker', 'Retired']) {
      await tester.scrollUntilVisible(find.text(o), 200, scrollable: find.byType(Scrollable).first);
    }
    await tester.scrollUntilVisible(find.text('Student'), -200, scrollable: find.byType(Scrollable).first);

    await tapText(tester, 'Student');
    // Straight to the short form, with Student already picked.
    expect(fieldFor('Age'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('sign-up cards carry their goal as a tagline', (tester) async {
    await pumpApp(tester, location: '/signup');
    for (final goal in ['Earning', 'Growing your business', 'Buying', 'Starting your business']) {
      await tester.scrollUntilVisible(find.text(goal), 200, scrollable: find.byType(Scrollable).first);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('a student signs up with age and area, and it is saved', (tester) async {
    final c = await pumpApp(tester, location: '/signup?role=sales&occupation=student');
    await fill(tester, 'Full name', 'Divya Student');
    await fill(tester, 'Age', '16');
    await fill(tester, 'Mobile number', '9876501234');
    await choose(tester, 'City', 'Bengaluru');
    await choose(tester, 'Area', 'Malleshwaram');
    await tapText(tester, 'Continue');
    // Under 18 cannot earn.
    expect(find.text('You need to be 18 or older to earn with O2O Boss'), findsOneWidget);

    await fill(tester, 'Age', '19');
    final terms = find.byType(Checkbox).first;
    await tester.ensureVisible(terms);
    await tester.tap(terms);
    await tapText(tester, 'Continue');

    // OTP, then login details.
    await tester.enterText(find.byType(TextField).first, '123456');
    await settle(tester);
    await fill(tester, 'Password', 'Secret@123');
    await fill(tester, 'Confirm password', 'Secret@123');
    // The page title says "Create account" too; the button is the last one.
    await tester.tap(find.text('Create account').last);
    await settle(tester);

    final u = c.read(dbProvider).users.firstWhere((u) => u.name == 'Divya Student');
    expect(u.name, 'Divya Student');
    expect(u.role, UserRole.sales);
    expect(u.occupation, Occupation.student);
    expect(u.age, 19);
    expect(u.city, 'Bengaluru');
    expect(u.area, 'Malleshwaram');
    expect(tester.takeException(), isNull);
  });

  testWidgets('someone from Guntur is told we are coming soon and joins the waitlist',
      (tester) async {
    final c = await pumpApp(tester, location: '/signup?role=customer');
    final before = c.read(dbProvider).waitlist.length;
    await fill(tester, 'Full name', 'Ramesh Guntur');
    await fill(tester, 'Mobile number', '9876505678');
    await choose(tester, 'City', 'My city is not listed');
    await fill(tester, 'Your city or district', 'Guntur');
    await fill(tester, 'Your area', 'Brodipet');
    expect(find.text("We're not in Guntur yet"), findsOneWidget);

    final terms = find.byType(Checkbox).first;
    await tester.ensureVisible(terms);
    await tester.tap(terms);
    await tapText(tester, 'Notify me');

    expect(find.textContaining('O2O Boss will start in Guntur shortly'), findsOneWidget);
    final db = c.read(dbProvider);
    expect(db.waitlist.length, before + 1);
    expect(db.waitlist.last.city, 'Guntur');
    expect(db.waitlist.last.area, 'Brodipet');
    expect(db.users.where((u) => u.name == 'Ramesh Guntur'), isEmpty);
    expect(tester.takeException(), isNull);
  });

  testWidgets('franchise shows the turnkey setup and packages, and takes an application',
      (tester) async {
    await pumpApp(tester, location: '/signup/franchise');
    expect(find.text('Start your own business, fully set up by O2O Boss'), findsOneWidget);
    final list = find.byType(Scrollable).first;
    await tester.scrollUntilVisible(find.text('Products and first stock'), 200, scrollable: list);
    await tester.scrollUntilVisible(find.text('From ₹10 L'), 200, scrollable: list);
    await tester.tap(find.text('From ₹10 L'));
    await tester.pump();

    await fill(tester, 'Full name', 'Anand Partner');
    await fill(tester, 'Mobile number', '9876509999');
    await fill(tester, 'City or town for the outlet', 'Vellore');
    await choose(tester, 'State', 'Bihar');
    await tapText(tester, '3 to 10 years');
    final terms = find.byType(Checkbox).first;
    await tester.ensureVisible(terms);
    await tester.tap(terms);
    await tapText(tester, 'Send application');

    expect(find.textContaining('franchise team will call you'), findsOneWidget);
    expect(find.textContaining('Store (From ₹10 L)'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

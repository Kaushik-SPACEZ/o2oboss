import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../data/db_queries.dart';
import '../l10n/l10n.dart';

/// Display formatting. Money always uses Indian grouping (₹1,20,320);
/// dates follow the reader's language.
abstract final class Fmt {
  static final _money =
      NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
  static final _number = NumberFormat.decimalPattern('en_IN');

  static String money(num v) => _money.format(v);

  /// ₹4.8K, ₹1.2 L, ₹2.5 Cr — for tight spaces such as KPI tiles.
  static String moneyCompact(num v) {
    final a = v.abs();
    String trim(num x) => x >= 100
        ? x.toStringAsFixed(0)
        : x.toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '');
    if (a >= 1e7) return '₹${trim(v / 1e7)} Cr';
    if (a >= 1e5) return '₹${trim(v / 1e5)} L';
    if (a >= 1e3) return '₹${trim(v / 1e3)}K';
    return money(v);
  }

  static String number(num v) => _number.format(v);

  static String percent(num v) =>
      '${v % 1 == 0 ? v.toStringAsFixed(0) : v.toStringAsFixed(1)}%';

  static String phone(String p) {
    final d = digitsOnly(p);
    if (d.length != 10) return p;
    return '+91 ${d.substring(0, 5)} ${d.substring(5)}';
  }

  /// Keeps private numbers private while still being recognisable.
  static String maskedPhone(String p) {
    final d = digitsOnly(p);
    if (d.length != 10) return '••••••••••';
    return '+91 ${d.substring(0, 2)}••• •••${d.substring(8)}';
  }

  static String date(BuildContext c, DateTime d) =>
      DateFormat.yMMMd(intlLocaleOf(c)).format(d);

  static String shortDate(BuildContext c, DateTime d) {
    final sameYear = d.year == DateTime.now().year;
    return (sameYear ? DateFormat.MMMd(intlLocaleOf(c)) : DateFormat.yMMMd(intlLocaleOf(c)))
        .format(d);
  }

  static String weekday(BuildContext c, DateTime d) =>
      DateFormat.E(intlLocaleOf(c)).format(d);

  static String time(BuildContext c, DateTime d) =>
      DateFormat.jm(intlLocaleOf(c)).format(d);

  static String dateTime(BuildContext c, DateTime d) =>
      '${dayOrDate(c, d)}, ${time(c, d)}';

  static int _dayDiff(DateTime from, DateTime to) =>
      DateTime(to.year, to.month, to.day)
          .difference(DateTime(from.year, from.month, from.day))
          .inDays;

  static bool isToday(DateTime d) => _dayDiff(DateTime.now(), d) == 0;

  static String dayOrDate(BuildContext c, DateTime d) {
    final days = _dayDiff(DateTime.now(), d);
    if (days == 0) return c.t.today;
    if (days == -1) return c.t.yesterday;
    if (days == 1) return c.t.tomorrow;
    return shortDate(c, d);
  }

  static String relative(BuildContext c, DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.isNegative) return dateTime(c, d);
    if (diff.inMinutes < 1) return c.t.justNow;
    if (diff.inMinutes < 60) return c.t.minutesAgo(diff.inMinutes);
    if (diff.inHours < 24) return c.t.hoursAgo(diff.inHours);
    if (diff.inDays < 7) return c.t.daysAgo(diff.inDays);
    return shortDate(c, d);
  }

  static String timeLeft(BuildContext c, DateTime deadline) {
    final diff = deadline.difference(DateTime.now());
    if (diff.isNegative) return c.t.deadlinePassed;
    if (diff.inHours >= 1) return c.t.hoursLeft(diff.inHours);
    return c.t.minutesLeft(diff.inMinutes.clamp(1, 59));
  }

  static String duration(int secs) =>
      '${secs ~/ 60}:${(secs % 60).toString().padLeft(2, '0')}';
}

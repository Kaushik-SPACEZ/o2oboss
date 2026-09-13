import '../data/db_queries.dart';
import '../l10n/l10n.dart';

/// Form validators returning translated messages that say how to fix it.
abstract final class Validators {
  static String? required(AppLocalizations t, String? v) =>
      (v == null || v.trim().isEmpty) ? t.validationRequired : null;

  static String? name(AppLocalizations t, String? v) =>
      (v == null || v.trim().length < 2) ? t.validationName : null;

  static String? phone(AppLocalizations t, String? v) {
    final d = digitsOnly(v ?? '');
    if (d.length != 10 || !RegExp(r'^[6-9]').hasMatch(d)) return t.validationPhone;
    return null;
  }

  static String? email(AppLocalizations t, String? v, {bool required = false}) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return required ? t.validationEmail : null;
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(s) ? null : t.validationEmail;
  }

  static String? password(AppLocalizations t, String? v) =>
      (v == null || v.length < 6) ? t.validationPasswordLength : null;

  static String? loginId(AppLocalizations t, String? v) {
    final s = (v ?? '').trim();
    return RegExp(r'^[a-zA-Z0-9._]{4,20}$').hasMatch(s) ? null : t.validationLoginIdFormat;
  }

  static String? amount(AppLocalizations t, String? v, {bool allowZero = false}) {
    final n = double.tryParse((v ?? '').trim());
    if (n == null) return t.validationAmount;
    if (allowZero ? n < 0 : n <= 0) return t.validationAmount;
    return null;
  }

  static String? number(AppLocalizations t, String? v, {bool required = false}) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return required ? t.validationNumber : null;
    return double.tryParse(s) == null ? t.validationNumber : null;
  }
}

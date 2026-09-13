import '../models/models.dart';
import '../utils/format.dart';

/// Business value as the given person is allowed to see it (spec 50.19).
/// Returns null when the value should not be shown at all.
String? visibleValue(AppUser u, Enquiry e, AppConfig c) {
  final value = e.finalValue ?? e.potentialValue;
  if (value == null) return null;
  switch (u.role) {
    case UserRole.sales:
      return switch (c.salesValueVisibility) {
        SalesValueVisibility.full => Fmt.money(value),
        SalesValueVisibility.limited => '~${Fmt.moneyCompact((value / 10000).round() * 10000)}',
        SalesValueVisibility.commissionOnly || SalesValueVisibility.hidden => null,
        SalesValueVisibility.stageBased =>
          e.status.isWon && e.finalValue != null ? Fmt.money(e.finalValue!) : null,
      };
    case UserRole.customer:
    case UserRole.vendor:
      return e.finalValue == null ? null : Fmt.money(e.finalValue!);
    case UserRole.backOffice:
    case UserRole.franchise:
    case UserRole.admin:
      return Fmt.money(value);
  }
}

/// How much of the referrer a vendor may see (spec 50.5).
String? referrerForVendor(AppUser? referrer, AppConfig c) {
  if (referrer == null) return null;
  return switch (c.vendorSeesReferrer) {
    VisibilityLevel.hidden => null,
    VisibilityLevel.limited => referrer.name.split(' ').first,
    VisibilityLevel.full => '${referrer.name}, ${Fmt.phone(referrer.phone)}',
  };
}

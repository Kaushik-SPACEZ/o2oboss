import '../models/models.dart';
import 'db_queries.dart';

/// One vendor recommendation with the reasons behind it.
class VendorMatch {
  const VendorMatch({
    required this.vendor,
    required this.score,
    required this.productOk,
    required this.brandOk,
    required this.brandAsked,
    required this.cityOk,
    required this.areaOk,
    this.existing,
  });

  final Vendor vendor;

  /// 0–100. Internal decision support; never shown to vendors or customers.
  final int score;
  final bool productOk;
  final bool brandOk;
  final bool brandAsked;
  final bool cityOk;
  final bool areaOk;

  /// Set when this vendor already has the referral.
  final VendorAssignment? existing;

  /// Exact matches can supply the requested brand and serve the location.
  bool get isExact => brandOk && cityOk;
}

/// Basic matching (spec 50.7): category, product, brand, location, service
/// area, capability and active status. Weights are simple and transparent so
/// back office can see why a vendor is recommended and override it.
List<VendorMatch> matchVendors(DbState db, Enquiry e) {
  final results = <VendorMatch>[];
  for (final v in db.vendors) {
    if (!v.isActive || !v.available) continue;
    if (!v.categoryIds.contains(e.categoryId)) continue;

    final productOk = e.productId == null || v.productIds.contains(e.productId);
    final brandAsked = e.brandId != null;
    final brandOk = !brandAsked || v.brandIds.contains(e.brandId);
    final cityOk = v.serviceCities.contains(e.city);
    final areaOk = cityOk && (v.serviceAreas.isEmpty || v.serviceAreas.contains(e.area));

    var score = 40.0;
    if (productOk) score += 15;
    if (brandOk) score += 20;
    if (areaOk) {
      score += 15;
    } else if (cityOk) {
      score += 8;
    }
    score += (v.rating / 5) * 6;
    score += (v.responseRate / 100) * 4;

    results.add(VendorMatch(
      vendor: v,
      score: score.round().clamp(0, 100),
      productOk: productOk,
      brandOk: brandOk,
      brandAsked: brandAsked,
      cityOk: cityOk,
      areaOk: areaOk,
      existing: db.assignmentFor(e.id, v.id),
    ));
  }
  results.sort((a, b) {
    if (a.isExact != b.isExact) return a.isExact ? -1 : 1;
    return b.score.compareTo(a.score);
  });
  return results;
}

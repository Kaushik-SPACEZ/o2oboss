import '../../core/data/db_queries.dart';
import '../../core/models/models.dart';

/// Work the vendor is still doing on an accepted referral.
bool vendorJobActive(Enquiry e) =>
    !e.status.isClosed && e.status.index < EnquiryStatus.paymentCollected.index;

/// The visit is done (or skipped) and no quotation has been started yet.
bool vendorNeedsQuote(DbState db, Enquiry e, String vendorId) =>
    (e.status == EnquiryStatus.appointmentCompleted ||
        e.status == EnquiryStatus.quotationPending) &&
    db.currentQuotations(e.id, vendorId: vendorId).isEmpty;

/// Referrals sent to this vendor, newest activity first, with their assignment.
List<(Enquiry, VendorAssignment)> vendorReferrals(DbState db, String vendorId) {
  final result = <(Enquiry, VendorAssignment)>[];
  for (final a in db.assignments) {
    if (a.vendorId != vendorId || a.status == AssignmentStatus.withdrawn) continue;
    final e = db.enquiryById(a.enquiryId);
    if (e != null) result.add((e, a));
  }
  result.sort((x, y) => y.$1.updatedAt.compareTo(x.$1.updatedAt));
  return result;
}

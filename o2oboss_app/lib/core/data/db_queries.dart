import '../models/models.dart';

/// Read-only lookups over the shared demo database. Lists are small, so
/// simple scans keep this easy to follow.
extension DbQueries on DbState {
  // ── Lookups by ID ────────────────────────────────────────────────────────
  AppUser? userById(String? id) =>
      id == null ? null : users.where((u) => u.id == id).firstOrNull;

  AppUser? userByLogin(String loginId) {
    final key = loginId.trim().toLowerCase();
    return users.where((u) => u.loginId.toLowerCase() == key).firstOrNull;
  }

  AppUser? userByPhone(String phone) {
    final key = digitsOnly(phone);
    return users.where((u) => digitsOnly(u.phone) == key).firstOrNull;
  }

  Vendor? vendorById(String? id) =>
      id == null ? null : vendors.where((v) => v.id == id).firstOrNull;

  Customer? customerById(String? id) =>
      id == null ? null : customers.where((c) => c.id == id).firstOrNull;

  Customer? customerByPhone(String phone) {
    final key = digitsOnly(phone);
    return customers.where((c) => digitsOnly(c.phone) == key).firstOrNull;
  }

  ServiceCategory? categoryById(String? id) =>
      id == null ? null : categories.where((c) => c.id == id).firstOrNull;

  Product? productById(String? id) =>
      id == null ? null : products.where((p) => p.id == id).firstOrNull;

  Brand? brandById(String? id) =>
      id == null ? null : brands.where((b) => b.id == id).firstOrNull;

  City? cityByName(String name) =>
      cities.where((c) => c.name == name).firstOrNull;

  Franchise? franchiseById(String? id) =>
      id == null ? null : franchises.where((f) => f.id == id).firstOrNull;

  Franchise? franchiseForCity(String city) =>
      franchises.where((f) => f.active && f.cities.contains(city)).firstOrNull;

  Enquiry? enquiryById(String? id) =>
      id == null ? null : enquiries.where((e) => e.id == id).firstOrNull;

  Quotation? quotationById(String? id) =>
      id == null ? null : quotations.where((q) => q.id == id).firstOrNull;

  Project? projectById(String? id) =>
      id == null ? null : projects.where((p) => p.id == id).firstOrNull;

  Appointment? appointmentById(String? id) =>
      id == null ? null : appointments.where((a) => a.id == id).firstOrNull;

  VendorAssignment? assignmentById(String? id) =>
      id == null ? null : assignments.where((a) => a.id == id).firstOrNull;

  Commission? commissionById(String? id) =>
      id == null ? null : commissions.where((c) => c.id == id).firstOrNull;

  // ── Names (safe fallbacks for display) ───────────────────────────────────
  String userName(String? id) => userById(id)?.name ?? '—';
  String vendorName(String? id) => vendorById(id)?.companyName ?? '—';
  String customerName(String? id) => customerById(id)?.name ?? '—';
  String categoryName(String? id) => categoryById(id)?.name ?? '—';
  String productName(String? id) => productById(id)?.name ?? '';
  String brandName(String? id) => brandById(id)?.name ?? '';

  /// "Bosch CCTV camera installation", or the category name when no product.
  String enquiryTitle(Enquiry e) {
    final product = productById(e.productId)?.name;
    final brand = brandById(e.brandId)?.name;
    final base = product ?? categoryName(e.categoryId);
    return brand == null ? base : '$brand $base';
  }

  // ── Enquiry relations ────────────────────────────────────────────────────
  List<VendorAssignment> assignmentsFor(String enquiryId) =>
      assignments.where((a) => a.enquiryId == enquiryId).toList()
        ..sort((a, b) => a.assignedAt.compareTo(b.assignedAt));

  List<VendorAssignment> activeAssignmentsFor(String enquiryId) =>
      assignmentsFor(enquiryId)
          .where((a) =>
              a.status == AssignmentStatus.pending ||
              a.status == AssignmentStatus.accepted)
          .toList();

  VendorAssignment? assignmentFor(String enquiryId, String vendorId) => assignments
      .where((a) => a.enquiryId == enquiryId && a.vendorId == vendorId)
      .lastOrNull;

  List<Quotation> quotationsFor(String enquiryId, {String? vendorId}) =>
      quotations
          .where((q) =>
              q.enquiryId == enquiryId &&
              (vendorId == null || q.vendorId == vendorId))
          .toList()
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

  /// Latest version of each quotation number for an enquiry.
  List<Quotation> currentQuotations(String enquiryId, {String? vendorId}) {
    final latest = <String, Quotation>{};
    for (final q in quotationsFor(enquiryId, vendorId: vendorId)) {
      final existing = latest[q.number];
      if (existing == null || q.version > existing.version) latest[q.number] = q;
    }
    return latest.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  List<Quotation> versionsOf(String number) =>
      quotations.where((q) => q.number == number).toList()
        ..sort((a, b) => b.version.compareTo(a.version));

  Quotation? acceptedQuotation(String enquiryId) => quotations
      .where((q) => q.enquiryId == enquiryId && q.status == QuotationStatus.accepted)
      .lastOrNull;

  List<Appointment> appointmentsFor(String enquiryId) =>
      appointments.where((a) => a.enquiryId == enquiryId).toList()
        ..sort((a, b) => b.at.compareTo(a.at));

  Appointment? nextAppointment(String enquiryId) {
    final open = appointments
        .where((a) => a.enquiryId == enquiryId && a.status.isOpen)
        .toList()
      ..sort((a, b) => a.at.compareTo(b.at));
    return open.firstOrNull;
  }

  Project? projectFor(String enquiryId) =>
      projects.where((p) => p.enquiryId == enquiryId).lastOrNull;

  List<PaymentRecord> paymentsFor(String projectId) =>
      payments.where((p) => p.projectId == projectId).toList()
        ..sort((a, b) => b.at.compareTo(a.at));

  double paidFor(String projectId) =>
      paymentsFor(projectId).fold(0, (sum, p) => sum + p.amount);

  PaymentStatus paymentStatusOf(Project p, DateTime now) {
    final paid = paidFor(p.id);
    if (paid >= p.finalValue - 0.5) return PaymentStatus.fullyPaid;
    final overdue = p.paymentDueDate != null && p.paymentDueDate!.isBefore(now);
    if (overdue) return PaymentStatus.overdue;
    return paid > 0 ? PaymentStatus.partiallyPaid : PaymentStatus.unpaid;
  }

  List<Commission> commissionsFor(String enquiryId) =>
      commissions.where((c) => c.enquiryId == enquiryId).toList();

  List<Commission> commissionsOf(String userId) =>
      commissions.where((c) => c.beneficiaryUserId == userId).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  List<CallRecord> callsFor(String enquiryId) =>
      calls.where((c) => c.enquiryId == enquiryId).toList()
        ..sort((a, b) => b.at.compareTo(a.at));

  List<ChatMessage> threadMessages(String enquiryId, String thread) =>
      messages
          .where((m) => m.enquiryId == enquiryId && m.thread == thread)
          .toList()
        ..sort((a, b) => a.at.compareTo(b.at));

  /// Chat threads that exist or can exist for an enquiry.
  List<String> threadsFor(String enquiryId) => {
        for (final a in assignmentsFor(enquiryId))
          if (a.status != AssignmentStatus.withdrawn) a.vendorId,
        ChatMessage.customerThread,
      }.toList();

  static String readKey(String userId, String enquiryId, String thread) =>
      '$userId|$enquiryId|$thread';

  int unreadInThread(String userId, String enquiryId, String thread) {
    final last = chatReads[readKey(userId, enquiryId, thread)];
    return messages
        .where((m) =>
            m.enquiryId == enquiryId &&
            m.thread == thread &&
            m.senderUserId != userId &&
            (last == null || m.at.isAfter(last)))
        .length;
  }

  List<AuditEntry> activityFor(String enquiryId) =>
      audit.where((a) => a.enquiryId == enquiryId).toList()
        ..sort((a, b) => b.at.compareTo(a.at));

  // ── Per-user work ────────────────────────────────────────────────────────
  List<FollowUp> followUpsOf(String userId) =>
      followUps.where((f) => f.assignedUserId == userId).toList()
        ..sort((a, b) => a.dueAt.compareTo(b.dueAt));

  List<TaskItem> tasksOf(String userId) =>
      tasks.where((t) => t.assignedUserId == userId).toList()
        ..sort((a, b) => a.dueAt.compareTo(b.dueAt));

  List<AppNotification> notificationsOf(String userId) =>
      notifications.where((n) => n.userId == userId).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  int unreadNotifications(String userId) =>
      notifications.where((n) => n.userId == userId && !n.read).length;

  // ── People ───────────────────────────────────────────────────────────────
  List<AppUser> usersWithRole(UserRole role) =>
      users.where((u) => u.role == role && u.status == AccountStatus.active).toList();

  List<AppUser> vendorUsers(String vendorId) =>
      users.where((u) => u.vendorId == vendorId).toList();

  List<AppUser> customerUsers(String customerId) =>
      users.where((u) => u.customerId == customerId).toList();

  // ── Visibility (role permission table, spec section 40) ──────────────────
  bool canView(AppUser u, Enquiry e) => switch (u.role) {
        UserRole.admin => true,
        UserRole.sales =>
          e.salespersonId == u.id || e.createdByUserId == u.id,
        UserRole.backOffice => e.backOfficeId == u.id || e.backOfficeId == null,
        UserRole.vendor => assignments.any((a) =>
            a.enquiryId == e.id &&
            a.vendorId == u.vendorId &&
            a.status != AssignmentStatus.withdrawn),
        UserRole.customer => e.customerId == u.customerId,
        UserRole.franchise => e.franchiseId == u.franchiseId,
      };

  List<Enquiry> enquiriesFor(AppUser u) =>
      enquiries.where((e) => canView(u, e)).toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

  List<Vendor> vendorsInTerritory(String franchiseId) =>
      vendors.where((v) => v.franchiseId == franchiseId).toList();

  List<AppUser> salesInTerritory(String franchiseId) => users
      .where((u) => u.role == UserRole.sales && u.franchiseId == franchiseId)
      .toList();
}

String digitsOnly(String s) {
  final d = s.replaceAll(RegExp(r'\D'), '');
  return d.length > 10 ? d.substring(d.length - 10) : d;
}

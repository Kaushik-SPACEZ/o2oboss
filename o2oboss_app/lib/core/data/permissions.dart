import '../models/models.dart';

/// Action-based permissions (spec section 40). Config switches are applied
/// here too, so a disabled feature disappears for every role at once.
enum Perm {
  createEnquiry,
  verify,
  qualify,
  assignVendor,
  respondToReferral,
  chatWithVendor,
  chatWithCustomer,
  manageAppointments,
  proposeAppointment,
  createQuotation,
  reviewQuotation,
  respondToQuotation,
  manageProject,
  updateProject,
  recordPayment,
  approveCommission,
  seeMatchScore,
  seeInternalNotes,
  manageUsers,
  manageConfig,
  manageMasterData,
  approveVendors,
  viewAudit,
  reopenEnquiry,
  call,
}

bool can(UserRole role, Perm p, AppConfig c) {
  const ops = {UserRole.backOffice, UserRole.admin};
  return switch (p) {
    Perm.createEnquiry => role != UserRole.vendor && role != UserRole.franchise,
    Perm.verify ||
    Perm.qualify ||
    Perm.assignVendor ||
    Perm.reviewQuotation ||
    Perm.manageAppointments ||
    Perm.manageProject ||
    Perm.seeMatchScore ||
    Perm.chatWithCustomer =>
      ops.contains(role),
    Perm.seeInternalNotes => ops.contains(role) || role == UserRole.franchise,
    Perm.respondToReferral ||
    Perm.createQuotation ||
    Perm.proposeAppointment ||
    Perm.updateProject =>
      role == UserRole.vendor,
    Perm.chatWithVendor => ops.contains(role) || role == UserRole.vendor,
    Perm.respondToQuotation => role == UserRole.customer,
    Perm.recordPayment => c.paymentTrackingEnabled &&
        (ops.contains(role) || role == UserRole.vendor),
    Perm.approveCommission ||
    Perm.manageUsers ||
    Perm.manageConfig ||
    Perm.manageMasterData ||
    Perm.approveVendors ||
    Perm.viewAudit ||
    Perm.reopenEnquiry =>
      role == UserRole.admin,
    Perm.call => c.callingEnabled && ops.contains(role),
  };
}

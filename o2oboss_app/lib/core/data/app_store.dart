import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mock/seed.dart';
import '../models/models.dart';
import '../storage/demo_storage.dart';
import 'db_queries.dart';
import 'drafts.dart';
import 'system_text.dart';

// ── Providers ──────────────────────────────────────────────────────────────

final prefsProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('prefsProvider is overridden in main()'),
);

final storageProvider =
    Provider<DemoStorage>((ref) => DemoStorage(ref.watch(prefsProvider)));

/// ID of the signed-in user, or null.
final sessionProvider =
    NotifierProvider<SessionController, String?>(SessionController.new);

class SessionController extends Notifier<String?> {
  @override
  String? build() => ref.read(storageProvider).sessionUserId;

  void signIn(String userId) {
    state = userId;
    unawaited(ref.read(storageProvider).setSessionUserId(userId));
  }

  void signOut() {
    state = null;
    unawaited(ref.read(storageProvider).setSessionUserId(null));
  }
}

/// The one shared demo database every role reads from.
final dbProvider = NotifierProvider<AppStore, DbState>(AppStore.new);

final currentUserProvider = Provider<AppUser?>((ref) {
  final id = ref.watch(sessionProvider);
  if (id == null) return null;
  return ref.watch(dbProvider).userById(id);
});

final configProvider =
    Provider<AppConfig>((ref) => ref.watch(dbProvider.select((db) => db.config)));

// ── Store ──────────────────────────────────────────────────────────────────

/// All state changes go through here. Each action updates the shared data,
/// moves the enquiry along the status machine, notifies the right people and
/// writes the audit trail — the mock stand-in for a real backend.
class AppStore extends Notifier<DbState> {
  @override
  DbState build() {
    final saved = ref.read(storageProvider).loadDb();
    if (saved != null && saved.schemaVersion == DbState.currentSchema) {
      return saved;
    }
    return buildSeed(DateTime.now());
  }

  AppUser? get _actor {
    final id = ref.read(sessionProvider);
    return id == null ? null : state.userById(id);
  }

  T _run<T>(T Function(_Tx tx) body) {
    final tx = _Tx(state, _actor, DateTime.now());
    final result = body(tx);
    state = tx.db;
    unawaited(ref.read(storageProvider).saveDb(state));
    return result;
  }

  void resetDemo() {
    state = buildSeed(DateTime.now());
    unawaited(ref.read(storageProvider).saveDb(state));
  }

  // ── Accounts ─────────────────────────────────────────────────────────────

  AppUser? findLogin(String loginId, String password) {
    final u = state.userByLogin(loginId);
    if (u == null || u.password != password) return null;
    return u;
  }

  bool isLoginIdTaken(String loginId) => state.userByLogin(loginId) != null;

  String suggestLoginId(String name) => _Tx.uniqueLoginId(state, name);

  /// Public sign-up. Vendors wait for admin approval when that is configured.
  String registerUser(SignUpData d) => _run((tx) {
        final now = tx.now;
        final franchise = tx.db.franchiseForCity(d.city);
        final userId = 'u_new${tx.next('user')}';
        String? vendorId;
        String? customerId;
        var status = AccountStatus.active;

        if (d.role == UserRole.vendor) {
          vendorId = 'v_new${tx.next('vendor')}';
          status = tx.config.vendorApprovalRequired
              ? AccountStatus.pending
              : AccountStatus.active;
          final company = d.companyName?.trim() ?? '';
          tx.putVendor(Vendor(
            id: vendorId,
            companyName: company.isEmpty ? d.name.trim() : company,
            contactPerson: d.name.trim(),
            phone: d.phone,
            email: d.email,
            address: d.address ?? '',
            city: d.city,
            area: d.area,
            categoryIds: d.categoryIds,
            brandIds: d.brandIds,
            serviceCities: d.serviceCities.isEmpty ? [d.city] : d.serviceCities,
            status: status,
            franchiseId: franchise?.id,
            joinedAt: now,
            gstin: d.gstin,
          ));
        } else if (d.role == UserRole.customer) {
          final existing = tx.db.customerByPhone(d.phone);
          customerId = existing?.id ?? 'c_new${tx.next('customer')}';
          if (existing == null) {
            tx.putCustomer(Customer(
              id: customerId,
              name: d.name.trim(),
              phone: d.phone,
              email: d.email,
              city: d.city,
              area: d.area,
              pincode: d.pincode,
              createdAt: now,
            ));
          }
        }

        final user = AppUser(
          id: userId,
          loginId: d.loginId.trim(),
          password: d.password,
          name: d.name.trim(),
          phone: d.phone,
          email: d.email,
          role: d.role,
          salesType: d.role == UserRole.sales ? SalesType.independent : null,
          occupation: d.role == UserRole.sales ? d.occupation : null,
          age: d.role == UserRole.sales ? d.age : null,
          city: d.city,
          area: d.area,
          franchiseId: franchise?.id,
          status: status,
          createdAt: now,
          vendorId: vendorId,
          customerId: customerId,
        );
        tx.putUser(user);
        tx.consent(userId, ConsentAction.terms);
        tx.consent(userId, ConsentAction.privacy);
        tx.audit(AuditAction.userCreated,
            entityType: 'user', entityId: userId, note: d.role.name, by: user);

        if (vendorId != null && status != AccountStatus.active) {
          final name = tx.db.vendorName(vendorId);
          for (final a in tx.admins()) {
            tx.notify(a, NotificationEvent.vendorRegistered,
                params: {'vendor': name}, route: '/vendors/$vendorId');
            tx.addTask(TaskKind.approveVendor,
                refId: vendorId,
                assignedUserId: a,
                dueAt: now.add(const Duration(days: 1)));
          }
        }
        return userId;
      });

  /// Someone from a city we do not serve yet. Nothing else is created; admin
  /// sees the waitlist grouped by city.
  void joinWaitlist(SignUpData d) => _run((tx) {
        tx.db = tx.db.copyWith(waitlist: [
          ...tx.db.waitlist,
          WaitlistEntry(
            id: 'W-${tx.next('waitlist')}',
            name: d.name.trim(),
            phone: d.phone,
            role: d.role,
            occupation: d.role == UserRole.sales ? d.occupation : null,
            age: d.role == UserRole.sales ? d.age : null,
            city: d.city.trim(),
            area: d.area.trim(),
            createdAt: tx.now,
          ),
        ]);
      });

  /// Admin creates any user and gets a generated login to hand over.
  GeneratedLogin adminCreateUser(NewUserData d) => _run((tx) {
        final now = tx.now;
        final userId = 'u_new${tx.next('user')}';
        final loginId = _Tx.uniqueLoginId(tx.db, d.name);
        final password = _Tx.generatePassword();
        final franchiseId = d.franchiseId ?? tx.db.franchiseForCity(d.city)?.id;
        String? vendorId;
        String? customerId;

        if (d.role == UserRole.vendor) {
          vendorId = 'v_new${tx.next('vendor')}';
          final company = d.companyName?.trim() ?? '';
          tx.putVendor(Vendor(
            id: vendorId,
            companyName: company.isEmpty ? d.name.trim() : company,
            contactPerson: d.name.trim(),
            phone: d.phone,
            email: d.email,
            address: '',
            city: d.city,
            area: d.area ?? '',
            categoryIds: d.categoryIds,
            serviceCities: [d.city],
            status: AccountStatus.active,
            franchiseId: franchiseId,
            joinedAt: now,
          ));
        } else if (d.role == UserRole.customer) {
          customerId = 'c_new${tx.next('customer')}';
          tx.putCustomer(Customer(
            id: customerId,
            name: d.name.trim(),
            phone: d.phone,
            email: d.email,
            city: d.city,
            area: d.area ?? '',
            createdAt: now,
          ));
        }

        tx.putUser(AppUser(
          id: userId,
          loginId: loginId,
          password: password,
          name: d.name.trim(),
          phone: d.phone,
          email: d.email,
          role: d.role,
          salesType: d.role == UserRole.sales ? d.salesType : null,
          city: d.city,
          area: d.area,
          franchiseId: franchiseId,
          createdAt: now,
          vendorId: vendorId,
          customerId: customerId,
          mustChangePassword: true,
        ));
        if (d.role == UserRole.franchise && franchiseId != null) {
          final f = tx.db.franchiseById(franchiseId);
          if (f != null) tx.putFranchise(f.copyWith(headUserId: userId));
        }
        tx.audit(AuditAction.userCreated,
            entityType: 'user', entityId: userId, note: d.role.name);
        return GeneratedLogin(userId: userId, loginId: loginId, password: password);
      });

  /// Admin issues a new temporary password.
  String adminResetPassword(String userId) => _run((tx) {
        final u = tx.db.userById(userId)!;
        final password = _Tx.generatePassword();
        tx.putUser(u.copyWith(password: password, mustChangePassword: true));
        tx.audit(AuditAction.passwordReset, entityType: 'user', entityId: userId);
        return password;
      });

  /// Used by "Change password" and by the forgot-password flow.
  void setPassword(String userId, String newPassword) => _run((tx) {
        final u = tx.db.userById(userId)!;
        tx.putUser(u.copyWith(password: newPassword, mustChangePassword: false));
        tx.audit(AuditAction.passwordReset,
            entityType: 'user', entityId: userId, by: u);
      });

  void updateUser(AppUser u) => _run((tx) {
        tx.putUser(u);
        tx.audit(AuditAction.userUpdated, entityType: 'user', entityId: u.id);
      });

  void setUserStatus(String userId, AccountStatus status) => _run((tx) {
        final u = tx.db.userById(userId)!;
        tx.putUser(u.copyWith(status: status));
        if (u.vendorId != null) {
          final v = tx.db.vendorById(u.vendorId);
          if (v != null) tx.putVendor(v.copyWith(status: status));
        }
        tx.audit(AuditAction.userUpdated,
            entityType: 'user',
            entityId: userId,
            field: 'status',
            from: u.status.name,
            to: status.name);
      });

  void updateMyProfile({
    String? name,
    String? phone,
    String? email,
    String? city,
    String? area,
    String? upiId,
    String? bankAccount,
    String? ifsc,
  }) =>
      _run((tx) {
        final u = tx.actor!;
        tx.putUser(u.copyWith(
          name: name,
          phone: phone,
          email: email,
          city: city,
          area: area,
          upiId: upiId,
          bankAccount: bankAccount,
          ifsc: ifsc,
        ));
        tx.audit(AuditAction.userUpdated, entityType: 'user', entityId: u.id);
      });

  void setMyNotificationPrefs({bool? push, bool? email, bool? sms, bool? whatsapp}) =>
      _run((tx) {
        final u = tx.actor!;
        tx.putUser(u.copyWith(
            pushOn: push, emailOn: email, smsOn: sms, whatsappOn: whatsapp));
      });

  void recordConsent(ConsentAction action, {String? enquiryId}) => _run((tx) {
        tx.consent(tx.actor!.id, action, enquiryId: enquiryId);
      });

  // ── Enquiry: create, verify, qualify ─────────────────────────────────────

  /// Open enquiries for the same phone number in the last 60 days.
  List<Enquiry> findDuplicates(String phone, {String? categoryId}) {
    final customer = state.customerByPhone(phone);
    if (customer == null) return const [];
    final since = DateTime.now().subtract(const Duration(days: 60));
    return state.enquiries
        .where((e) =>
            e.customerId == customer.id &&
            !e.status.isClosed &&
            e.createdAt.isAfter(since) &&
            (categoryId == null || e.categoryId == categoryId))
        .toList();
  }

  String createEnquiry(EnquiryDraft d) => _run((tx) {
        final actor = tx.actor!;
        final now = tx.now;
        Customer? customer = actor.role == UserRole.customer
            ? tx.db.customerById(actor.customerId)
            : tx.db.customerById(d.existingCustomerId) ??
                tx.db.customerByPhone(d.customerPhone);
        if (customer == null) {
          customer = Customer(
            id: 'c_new${tx.next('customer')}',
            name: d.customerName.trim(),
            phone: d.customerPhone,
            email: d.customerEmail,
            city: d.city,
            area: d.area,
            pincode: d.pincode,
            address: d.address ?? '',
            createdAt: now,
          );
          tx.putCustomer(customer);
        }

        final id = 'ENQ-${tx.next('enquiry')}';
        final franchise = tx.db.franchiseForCity(d.city);
        final e = Enquiry(
          id: id,
          customerId: customer.id,
          categoryId: d.categoryId!,
          productId: d.productId,
          preferredVendorId: d.preferredVendorId,
          brandId: d.brandId,
          city: d.city,
          area: d.area,
          pincode: d.pincode,
          address: d.address,
          requirement: d.requirement.trim(),
          contactPreference: d.contactPreference,
          preferredTime: d.preferredTime,
          source: switch (actor.role) {
            UserRole.customer => EnquirySource.customer,
            UserRole.backOffice => EnquirySource.backOffice,
            UserRole.admin => EnquirySource.admin,
            _ => EnquirySource.sales,
          },
          createdByUserId: actor.id,
          salespersonId: actor.role == UserRole.sales ? actor.id : null,
          backOfficeId: actor.role == UserRole.backOffice ? actor.id : null,
          franchiseId: franchise?.id,
          status: EnquiryStatus.newEnquiry,
          priority: tx.config.defaultPriority,
          createdAt: now,
          updatedAt: now,
          answers: d.answers,
          otpVerified: d.otpVerified,
          potentialValue: d.potentialValue,
        );
        tx.db = tx.db.copyWith(enquiries: [...tx.db.enquiries, e]);
        tx.audit(AuditAction.created,
            entityType: 'enquiry', entityId: id, enquiryId: id);
        tx.notifyAll(tx.backOfficeFor(e), NotificationEvent.newEnquiry,
            enquiryId: id);
        tx.notifyAll(tx.customerUsersOf(e), NotificationEvent.enquirySubmitted,
            enquiryId: id);
        tx.addTask(TaskKind.verify,
            enquiryId: id,
            assignedUserId: tx.pickBackOffice(e),
            dueAt: now.add(const Duration(hours: 4)));
        return id;
      });

  /// Back office picks up a new enquiry and starts verifying it.
  void startVerification(String id) => _run((tx) {
        final actor = tx.actor!;
        final e = tx.enquiry(id);
        if (e.backOfficeId == null && actor.role == UserRole.backOffice) {
          tx.updateEnquiry(id, (x) => x.copyWith(backOfficeId: actor.id));
        }
        tx.advance(id, EnquiryStatus.verificationPending);
      });

  /// Logs the verification call and applies its outcome.
  void recordVerification(
    String id,
    CallOutcome outcome, {
    String notes = '',
    int durationSec = 0,
    DateTime? callbackAt,
  }) =>
      _run((tx) {
        final actor = tx.actor!;
        if (tx.enquiry(id).backOfficeId == null &&
            actor.role == UserRole.backOffice) {
          tx.updateEnquiry(id, (x) => x.copyWith(backOfficeId: actor.id));
        }
        final e = tx.enquiry(id);
        tx.logCall(id, UserRole.customer, tx.db.customerName(e.customerId),
            durationSec,
            outcome: outcome, notes: notes);
        final info = VerificationInfo(
            outcome: outcome, notes: notes, at: tx.now, byUserId: actor.id);

        if (outcome == CallOutcome.genuine) {
          tx.updateEnquiry(id, (x) => x.copyWith(verification: info));
          tx.setStatus(id, EnquiryStatus.verified);
          tx.closeTasks(TaskKind.verify, enquiryId: id);
          tx.addTask(TaskKind.qualify,
              enquiryId: id,
              assignedUserId: tx.pickBackOffice(tx.enquiry(id)),
              dueAt: tx.now.add(const Duration(hours: 8)));
          tx.notifyAll(tx.salesOf(e), NotificationEvent.enquiryVerified,
              enquiryId: id);
          tx.notifyAll(tx.customerUsersOf(e), NotificationEvent.enquiryVerified,
              enquiryId: id);
        } else if (outcome.rejects) {
          tx.updateEnquiry(id,
              (x) => x.copyWith(verification: info, rejectReason: outcome.name));
          tx.setStatus(id, EnquiryStatus.rejected);
          tx.closeTasks(TaskKind.verify, enquiryId: id);
          tx.notifyAll(tx.salesOf(e), NotificationEvent.enquiryRejected,
              enquiryId: id, params: {'reason': outcome.name});
        } else {
          tx.advance(id, EnquiryStatus.verificationPending);
          tx.addFollowUp(FollowUpType.customerCall,
              enquiryId: id,
              dueAt: callbackAt ?? tx.now.add(const Duration(hours: 2)),
              notes: notes);
        }
      });

  /// A plain call log (e.g. back office calling a vendor).
  void logCall(String enquiryId, UserRole toRole, String toName,
          {int durationSec = 0, String notes = ''}) =>
      _run((tx) => tx.logCall(enquiryId, toRole, toName, durationSec, notes: notes));

  void saveQualification(
    String id,
    Map<String, String> answers, {
    required bool complete,
    double? potentialValue,
    EnquiryPriority? priority,
    String? brandId,
    String? productId,
  }) =>
      _run((tx) {
        tx.updateEnquiry(
            id,
            (x) => x.copyWith(
                  answers: {...x.answers, ...answers},
                  potentialValue: potentialValue,
                  priority: priority,
                  brandId: brandId,
                  productId: productId,
                ));
        tx.audit(AuditAction.qualificationSaved,
            entityType: 'enquiry', entityId: id, enquiryId: id);
        if (complete) {
          tx.advance(id, EnquiryStatus.qualified);
          tx.closeTasks(TaskKind.qualify, enquiryId: id);
          tx.addTask(TaskKind.assignVendor,
              enquiryId: id,
              assignedUserId: tx.pickBackOffice(tx.enquiry(id)),
              dueAt: tx.now.add(const Duration(hours: 4)));
          tx.notifyAll(tx.salesOf(tx.enquiry(id)), NotificationEvent.enquiryQualified,
              enquiryId: id);
        } else {
          tx.advance(id, EnquiryStatus.qualificationPending);
        }
      });

  // ── Vendors on an enquiry ────────────────────────────────────────────────

  /// Sends a qualified referral to one or more vendors (spec 50.1).
  void assignVendors(
    String id,
    List<({String vendorId, int score})> picks, {
    int? deadlineHours,
    String note = '',
    bool? showMultipleQuotes,
  }) =>
      _run((tx) {
        final e = tx.enquiry(id);
        // Business rule 1: nothing goes to a vendor before qualification.
        if (!e.status.isQualified || picks.isEmpty) return;
        final hours = deadlineHours ?? tx.config.vendorResponseHours;
        for (final p in picks) {
          final existing = tx.db.assignmentFor(id, p.vendorId);
          if (existing != null &&
              (existing.status == AssignmentStatus.pending ||
                  existing.status == AssignmentStatus.accepted)) {
            continue;
          }
          final a = VendorAssignment(
            id: 'asg_${tx.next('assign')}',
            enquiryId: id,
            vendorId: p.vendorId,
            assignedAt: tx.now,
            deadline: tx.now.add(Duration(hours: hours)),
            matchScore: p.score,
            note: note,
            assignedByUserId: tx.actor!.id,
          );
          tx.putAssignment(a);
          tx.system(id, p.vendorId,
              SystemText.encode(SystemText.newReferral, [id, '$hours']));
          tx.notifyAll(tx.vendorUsersOf(p.vendorId), NotificationEvent.newReferral,
              enquiryId: id, params: {'hours': '$hours'});
          tx.audit(AuditAction.assigned,
              entityType: 'assignment',
              entityId: a.id,
              enquiryId: id,
              note: tx.db.vendorName(p.vendorId));
        }
        final actor = tx.actor!;
        tx.updateEnquiry(
            id,
            (x) => x.copyWith(
                  multipleQuotesVisible: picks.length > 1
                      ? (showMultipleQuotes ?? tx.config.multipleQuotationsDefault)
                      : null,
                  backOfficeId: x.backOfficeId ??
                      (actor.role == UserRole.backOffice ? actor.id : null),
                ));
        tx.advance(id, EnquiryStatus.vendorAssigned);
        tx.closeTasks(TaskKind.assignVendor, enquiryId: id);
        tx.notifyAll(tx.salesOf(e), NotificationEvent.vendorAssigned,
            enquiryId: id,
            params: {
              'vendor': picks.map((p) => tx.db.vendorName(p.vendorId)).join(', ')
            });
      });

  /// Vendor's answer to a referral: accept (with price and time) or reject
  /// (reason is mandatory).
  void respondToReferral(
    String assignmentId, {
    required bool accept,
    double? expectedPrice,
    int? expectedDays,
    String? reason,
    String note = '',
  }) =>
      _run((tx) {
        final a = tx.db.assignmentById(assignmentId)!;
        final vendor = tx.db.vendorName(a.vendorId);
        tx.putAssignment(a.copyWith(
          status: accept ? AssignmentStatus.accepted : AssignmentStatus.rejected,
          respondedAt: tx.now,
          expectedPrice: expectedPrice,
          expectedDays: expectedDays,
          rejectReason: reason,
          note: note.isEmpty ? null : note,
        ));
        final e = tx.enquiry(a.enquiryId);
        if (accept) {
          tx.advance(e.id, EnquiryStatus.vendorAccepted);
          tx.audit(AuditAction.vendorAccepted,
              entityType: 'assignment', entityId: a.id, enquiryId: e.id, note: vendor);
          tx.system(e.id, a.vendorId,
              SystemText.encode(SystemText.referralAccepted, [vendor]));
          tx.notifyAll(tx.backOfficeFor(e), NotificationEvent.referralAccepted,
              enquiryId: e.id, params: {'vendor': vendor});
        } else {
          tx.audit(AuditAction.vendorRejected,
              entityType: 'assignment', entityId: a.id, enquiryId: e.id, note: reason);
          tx.system(e.id, a.vendorId,
              SystemText.encode(SystemText.referralRejected, [vendor]));
          tx.notifyAll(tx.backOfficeFor(e), NotificationEvent.referralRejected,
              enquiryId: e.id, params: {'vendor': vendor});
          if (tx.db.activeAssignmentsFor(e.id).isEmpty && !e.status.isEnded) {
            tx.setStatus(e.id, EnquiryStatus.vendorMatching);
            tx.addTask(TaskKind.assignVendor,
                enquiryId: e.id,
                assignedUserId: tx.pickBackOffice(e),
                dueAt: tx.now.add(const Duration(hours: 2)));
          }
        }
      });

  void withdrawAssignment(String assignmentId) => _run((tx) {
        final a = tx.db.assignmentById(assignmentId)!;
        tx.putAssignment(a.copyWith(status: AssignmentStatus.withdrawn));
        tx.audit(AuditAction.reassigned,
            entityType: 'assignment',
            entityId: a.id,
            enquiryId: a.enquiryId,
            note: tx.db.vendorName(a.vendorId));
        final e = tx.enquiry(a.enquiryId);
        if (tx.db.activeAssignmentsFor(e.id).isEmpty && !e.status.isEnded) {
          tx.setStatus(e.id, EnquiryStatus.vendorMatching);
        }
      });

  /// Back office connects customer and vendor through O2O Boss. Phone numbers
  /// stay private (spec 50.3).
  void introduceVendor(String enquiryId, String vendorId) => _run((tx) {
        final vendor = tx.db.vendorName(vendorId);
        tx.advance(enquiryId, EnquiryStatus.customerContact);
        tx.system(enquiryId, vendorId, SystemText.encode(SystemText.connected, [vendor]));
        tx.system(enquiryId, ChatMessage.customerThread,
            SystemText.encode(SystemText.connected, [vendor]));
        tx.notifyAll(tx.customerUsersOf(tx.enquiry(enquiryId)),
            NotificationEvent.vendorConnected,
            enquiryId: enquiryId, params: {'vendor': vendor});
      });

  // ── Chat ─────────────────────────────────────────────────────────────────

  void sendMessage(String enquiryId, String thread, String text,
          {ChatKind kind = ChatKind.text, String? fileName}) =>
      _run((tx) {
        final actor = tx.actor!;
        tx.db = tx.db.copyWith(messages: [
          ...tx.db.messages,
          ChatMessage(
            id: 'm${tx.next('msg')}',
            enquiryId: enquiryId,
            thread: thread,
            senderUserId: actor.id,
            senderRole: actor.role,
            kind: kind,
            text: text,
            fileName: fileName,
            at: tx.now,
          ),
        ]);
        tx.markRead(enquiryId, thread);
        final e = tx.enquiry(enquiryId);
        final targets = switch (actor.role) {
          UserRole.vendor || UserRole.customer => tx.backOfficeFor(e),
          _ => thread == ChatMessage.customerThread
              ? tx.customerUsersOf(e)
              : tx.vendorUsersOf(thread),
        };
        final from = actor.role == UserRole.vendor
            ? tx.db.vendorName(actor.vendorId)
            : actor.role == UserRole.customer
                ? actor.name
                : tx.config.companyName;
        tx.notifyAll(targets, NotificationEvent.chatMessage,
            enquiryId: enquiryId,
            params: {'from': from},
            route: '/enquiry/$enquiryId/chat/$thread',
            dedupe: true);
      });

  void markThreadRead(String enquiryId, String thread) {
    final actor = _actor;
    if (actor == null) return;
    if (state.unreadInThread(actor.id, enquiryId, thread) == 0) return;
    _run((tx) => tx.markRead(enquiryId, thread));
  }

  // ── Appointments ─────────────────────────────────────────────────────────

  /// Vendor proposals wait for back office; back office bookings are confirmed.
  String proposeAppointment({
    required String enquiryId,
    required String vendorId,
    required DateTime at,
    required String location,
    String purpose = '',
    String notes = '',
  }) =>
      _run((tx) {
        final actor = tx.actor!;
        final byVendor = actor.role == UserRole.vendor;
        final apt = Appointment(
          id: 'APT-${tx.next('appointment')}',
          enquiryId: enquiryId,
          vendorId: vendorId,
          at: at,
          location: location,
          purpose: purpose,
          notes: notes,
          status: byVendor
              ? AppointmentStatus.pendingConfirmation
              : AppointmentStatus.confirmed,
          proposedByRole: actor.role,
          createdAt: tx.now,
        );
        tx.putAppointment(apt);
        tx.audit(AuditAction.appointmentCreated,
            entityType: 'appointment',
            entityId: apt.id,
            enquiryId: enquiryId,
            to: at.toIso8601String());
        if (byVendor) {
          tx.system(enquiryId, vendorId,
              SystemText.encode(SystemText.appointmentProposed, [at.toIso8601String()]));
          tx.notifyAll(tx.backOfficeFor(tx.enquiry(enquiryId)),
              NotificationEvent.appointmentProposed,
              enquiryId: enquiryId, params: {'date': at.toIso8601String()});
        } else {
          _afterConfirm(tx, apt);
        }
        return apt.id;
      });

  void confirmAppointment(String id) => _run((tx) {
        final apt = tx.db.appointmentById(id)!.copyWith(status: AppointmentStatus.confirmed);
        tx.putAppointment(apt);
        tx.audit(AuditAction.appointmentChanged,
            entityType: 'appointment',
            entityId: id,
            enquiryId: apt.enquiryId,
            field: 'status',
            to: AppointmentStatus.confirmed.name);
        _afterConfirm(tx, apt);
      });

  void _afterConfirm(_Tx tx, Appointment apt) {
    final e = tx.enquiry(apt.enquiryId);
    final iso = apt.at.toIso8601String();
    tx.advance(e.id, EnquiryStatus.appointmentScheduled);
    tx.system(e.id, apt.vendorId,
        SystemText.encode(SystemText.appointmentConfirmed, [iso]));
    final params = {'date': iso};
    tx.notifyAll(tx.vendorUsersOf(apt.vendorId), NotificationEvent.appointmentConfirmed,
        enquiryId: e.id, params: params);
    tx.notifyAll(tx.customerUsersOf(e), NotificationEvent.appointmentConfirmed,
        enquiryId: e.id, params: params);
    tx.notifyAll(tx.salesOf(e), NotificationEvent.appointmentConfirmed,
        enquiryId: e.id, params: params);
    tx.addFollowUp(FollowUpType.appointment,
        enquiryId: e.id, dueAt: apt.at.add(const Duration(hours: 2)));
  }

  void rescheduleAppointment(String id, DateTime at) => _run((tx) {
        final old = tx.db.appointmentById(id)!;
        final byVendor = tx.actor?.role == UserRole.vendor;
        final apt = old.copyWith(
          at: at,
          status: byVendor
              ? AppointmentStatus.pendingConfirmation
              : AppointmentStatus.rescheduled,
        );
        tx.putAppointment(apt);
        tx.audit(AuditAction.appointmentChanged,
            entityType: 'appointment',
            entityId: id,
            enquiryId: apt.enquiryId,
            from: old.at.toIso8601String(),
            to: at.toIso8601String());
        tx.system(apt.enquiryId, apt.vendorId,
            SystemText.encode(SystemText.appointmentRescheduled, [at.toIso8601String()]));
        final e = tx.enquiry(apt.enquiryId);
        final params = {'date': at.toIso8601String()};
        for (final ids in [
          tx.backOfficeFor(e),
          tx.vendorUsersOf(apt.vendorId),
          tx.customerUsersOf(e),
        ]) {
          tx.notifyAll(ids, NotificationEvent.appointmentChanged,
              enquiryId: e.id, params: params);
        }
      });

  void cancelAppointment(String id, String reason) => _run((tx) {
        final apt = tx.db.appointmentById(id)!
            .copyWith(status: AppointmentStatus.cancelled, notes: reason);
        tx.putAppointment(apt);
        tx.audit(AuditAction.appointmentChanged,
            entityType: 'appointment',
            entityId: id,
            enquiryId: apt.enquiryId,
            field: 'status',
            to: AppointmentStatus.cancelled.name,
            note: reason);
        tx.system(apt.enquiryId, apt.vendorId,
            SystemText.encode(SystemText.appointmentCancelled));
        final e = tx.enquiry(apt.enquiryId);
        for (final ids in [
          tx.backOfficeFor(e),
          tx.vendorUsersOf(apt.vendorId),
          tx.customerUsersOf(e),
        ]) {
          tx.notifyAll(ids, NotificationEvent.appointmentChanged, enquiryId: e.id);
        }
        _stepBackIfNoVisit(tx, e.id);
      });

  void completeAppointment(String id) => _run((tx) {
        final apt = tx.db.appointmentById(id)!.copyWith(status: AppointmentStatus.completed);
        tx.putAppointment(apt);
        tx.audit(AuditAction.appointmentChanged,
            entityType: 'appointment',
            entityId: id,
            enquiryId: apt.enquiryId,
            field: 'status',
            to: AppointmentStatus.completed.name);
        tx.system(apt.enquiryId, apt.vendorId,
            SystemText.encode(SystemText.appointmentCompleted));
        tx.advance(apt.enquiryId, EnquiryStatus.appointmentCompleted);
        final e = tx.enquiry(apt.enquiryId);
        tx.notifyAll(tx.backOfficeFor(e), NotificationEvent.appointmentChanged,
            enquiryId: e.id);
        tx.closeFollowUps(e.id, FollowUpType.appointment);
        tx.addFollowUp(FollowUpType.quotation,
            enquiryId: e.id, dueAt: tx.now.add(const Duration(days: 1)));
      });

  void markNoShow(String id) => _run((tx) {
        final apt = tx.db.appointmentById(id)!.copyWith(status: AppointmentStatus.noShow);
        tx.putAppointment(apt);
        tx.audit(AuditAction.appointmentChanged,
            entityType: 'appointment',
            entityId: id,
            enquiryId: apt.enquiryId,
            field: 'status',
            to: AppointmentStatus.noShow.name);
        tx.addFollowUp(FollowUpType.customerCall,
            enquiryId: apt.enquiryId, dueAt: tx.now.add(const Duration(hours: 2)));
        _stepBackIfNoVisit(tx, apt.enquiryId);
      });

  void _stepBackIfNoVisit(_Tx tx, String enquiryId) {
    final e = tx.enquiry(enquiryId);
    final open = tx.db.appointmentsFor(enquiryId).any((a) => a.status.isOpen);
    if (!open && e.status == EnquiryStatus.appointmentScheduled) {
      tx.setStatus(enquiryId, EnquiryStatus.vendorAccepted);
    }
  }

  /// Customer confirms the vendor visited — part of referral protection.
  void customerConfirmVisit(String appointmentId) => _run((tx) {
        final apt = tx.db.appointmentById(appointmentId)!;
        tx.putAppointment(apt.copyWith(customerConfirmed: true));
        tx.updateEnquiry(apt.enquiryId, (x) => x.copyWith(customerConfirmedVisit: true));
        tx.audit(AuditAction.edited,
            entityType: 'appointment',
            entityId: apt.id,
            enquiryId: apt.enquiryId,
            field: 'customerConfirmed',
            to: 'true');
      });

  // ── Quotations ───────────────────────────────────────────────────────────

  /// Creates or updates a quotation. With [revisesId] a new version is made;
  /// older versions are kept and marked superseded when the new one is sent.
  String saveQuotation(QuotationDraft d,
          {String? draftId, String? revisesId, bool submit = false}) =>
      _run((tx) {
        Quotation q;
        if (draftId != null) {
          q = _applyDraft(tx.db.quotationById(draftId)!, d);
        } else if (revisesId != null) {
          final old = tx.db.quotationById(revisesId)!;
          q = _applyDraft(
            Quotation(
              id: 'q_${tx.next('quotationId')}_${old.number}',
              number: old.number,
              version: tx.db.versionsOf(old.number).first.version + 1,
              enquiryId: old.enquiryId,
              vendorId: old.vendorId,
              createdAt: tx.now,
            ),
            d,
          );
        } else {
          final n = tx.next('quotation');
          q = _applyDraft(
            Quotation(
              id: 'q_$n',
              number: 'QT-$n',
              enquiryId: d.enquiryId,
              vendorId: d.vendorId,
              createdAt: tx.now,
            ),
            d,
          );
        }
        tx.putQuotation(q);
        if (submit) _submitQuotation(tx, q.id);
        return q.id;
      });

  Quotation _applyDraft(Quotation q, QuotationDraft d) => q.copyWith(
        items: d.items,
        discount: d.discount,
        taxPercent: d.taxPercent,
        installation: d.installation,
        delivery: d.delivery,
        validityDays: d.validityDays,
        terms: d.terms,
        timelineDays: d.timelineDays,
        notes: d.notes,
        attachments: d.attachments,
      );

  void _submitQuotation(_Tx tx, String id) {
    var q = tx.db.quotationById(id)!;
    for (final old in tx.db.versionsOf(q.number)) {
      if (old.id != q.id &&
          old.version < q.version &&
          old.status != QuotationStatus.accepted &&
          old.status != QuotationStatus.superseded) {
        tx.putQuotation(old.copyWith(status: QuotationStatus.superseded));
      }
    }
    final vendor = tx.db.vendorName(q.vendorId);
    q = q.copyWith(status: QuotationStatus.submitted, submittedAt: tx.now);
    // Mandatory rule: O2O Boss gets a copy of every quotation.
    if (tx.config.adminQuotationCopy) {
      q = q.copyWith(adminCopySent: true);
      tx.audit(AuditAction.emailCopySent,
          entityType: 'quotation',
          entityId: q.id,
          enquiryId: q.enquiryId,
          note: tx.config.adminCopyEmail);
      tx.notifyAll(tx.admins(), NotificationEvent.quotationCopy,
          enquiryId: q.enquiryId,
          params: {'number': q.number, 'vendor': vendor},
          route: '/quotation/${q.id}');
    }
    tx.putQuotation(q);
    tx.audit(
        q.version > 1 ? AuditAction.quotationRevised : AuditAction.quotationSubmitted,
        entityType: 'quotation',
        entityId: q.id,
        enquiryId: q.enquiryId,
        note: '${q.number} v${q.version}');
    tx.system(q.enquiryId, q.vendorId,
        SystemText.encode(SystemText.quotationSubmitted, [q.number, '${q.version}']));
    tx.advance(q.enquiryId,
        q.version > 1 ? EnquiryStatus.negotiation : EnquiryStatus.quotationSubmitted);
    final e = tx.enquiry(q.enquiryId);
    if (tx.config.quotationReviewRequired) {
      tx.notifyAll(tx.backOfficeFor(e), NotificationEvent.quotationSubmitted,
          enquiryId: e.id,
          params: {'number': q.number, 'vendor': vendor},
          route: '/quotation/${q.id}');
      tx.addTask(TaskKind.reviewQuotation,
          enquiryId: e.id,
          refId: q.id,
          assignedUserId: tx.pickBackOffice(e),
          dueAt: tx.now.add(const Duration(hours: 4)));
    } else {
      _sendToCustomer(tx, q.id);
    }
  }

  /// Back office verifies the quotation and releases it to the customer.
  void approveQuotation(String id) => _run((tx) => _sendToCustomer(tx, id));

  void _sendToCustomer(_Tx tx, String id) {
    final q = tx.db.quotationById(id)!.copyWith(
          status: QuotationStatus.sent,
          sentAt: tx.now,
          approvedByUserId: tx.actor?.id,
        );
    tx.putQuotation(q);
    tx.closeTasks(TaskKind.reviewQuotation, enquiryId: q.enquiryId, refId: q.id);
    tx.audit(AuditAction.quotationSent,
        entityType: 'quotation', entityId: q.id, enquiryId: q.enquiryId);
    tx.system(q.enquiryId, q.vendorId,
        SystemText.encode(SystemText.quotationSent, [q.number, '${q.version}']));
    final e = tx.enquiry(q.enquiryId);
    final vendor = tx.db.vendorName(q.vendorId);
    tx.notifyAll(tx.customerUsersOf(e), NotificationEvent.quotationReceived,
        enquiryId: e.id, params: {'vendor': vendor}, route: '/quotation/${q.id}');
    tx.notifyAll(tx.vendorUsersOf(q.vendorId), NotificationEvent.quotationApproved,
        enquiryId: e.id, params: {'number': q.number}, route: '/quotation/${q.id}');
    tx.notifyAll(tx.salesOf(e), NotificationEvent.quotationReceived,
        enquiryId: e.id, params: {'vendor': vendor});
    tx.addFollowUp(FollowUpType.quotation,
        enquiryId: e.id, dueAt: tx.now.add(const Duration(days: 2)));
  }

  void requestRevision(String id, String note) => _run((tx) {
        final q = tx.db.quotationById(id)!.copyWith(
              status: QuotationStatus.revisionRequested,
              revisionNote: note,
              respondedAt: tx.now,
            );
        tx.putQuotation(q);
        tx.advance(q.enquiryId, EnquiryStatus.negotiation);
        tx.closeTasks(TaskKind.reviewQuotation, enquiryId: q.enquiryId, refId: q.id);
        tx.audit(AuditAction.revisionRequested,
            entityType: 'quotation', entityId: q.id, enquiryId: q.enquiryId, note: note);
        tx.system(q.enquiryId, q.vendorId,
            SystemText.encode(SystemText.revisionRequested, [q.number]));
        tx.notifyAll(tx.vendorUsersOf(q.vendorId), NotificationEvent.revisionRequested,
            enquiryId: q.enquiryId,
            params: {'number': q.number},
            route: '/quotation/${q.id}');
        if (tx.actor?.role == UserRole.customer) {
          tx.notifyAll(tx.backOfficeFor(tx.enquiry(q.enquiryId)),
              NotificationEvent.revisionRequested,
              enquiryId: q.enquiryId,
              params: {'number': q.number},
              route: '/quotation/${q.id}');
        }
      });

  /// Customer opened a quotation — tracked as "Viewed".
  void markQuotationViewed(String id) {
    final q = state.quotationById(id);
    if (q == null || q.status != QuotationStatus.sent) return;
    if (_actor?.role != UserRole.customer) return;
    _run((tx) => tx.putQuotation(
        q.copyWith(status: QuotationStatus.viewed, viewedAt: tx.now)));
  }

  void acceptQuotation(String id, {String? signedName}) => _run((tx) {
        final q = tx.db.quotationById(id)!.copyWith(
              status: QuotationStatus.accepted,
              respondedAt: tx.now,
              signedName: signedName,
            );
        tx.putQuotation(q);
        for (final other in tx.db.currentQuotations(q.enquiryId)) {
          if (other.id != q.id && other.status.isOpen) {
            tx.putQuotation(other.copyWith(
                status: QuotationStatus.rejected,
                respondedAt: tx.now,
                responseNote: SystemText.encode(SystemText.otherAccepted)));
          }
        }
        tx.updateEnquiry(q.enquiryId, (x) => x.copyWith(finalValue: q.total));
        tx.advance(q.enquiryId, EnquiryStatus.won);
        tx.closeTasks(TaskKind.reviewQuotation, enquiryId: q.enquiryId);
        tx.closeFollowUps(q.enquiryId, FollowUpType.quotation);
        tx.audit(AuditAction.quotationAccepted,
            entityType: 'quotation',
            entityId: q.id,
            enquiryId: q.enquiryId,
            note: signedName);
        tx.system(q.enquiryId, q.vendorId,
            SystemText.encode(SystemText.quotationAccepted, [q.number]));
        final e = tx.enquiry(q.enquiryId);
        final params = {'number': q.number};
        tx.notifyAll(tx.backOfficeFor(e), NotificationEvent.quotationAccepted,
            enquiryId: e.id, params: params);
        tx.notifyAll(tx.vendorUsersOf(q.vendorId), NotificationEvent.quotationAccepted,
            enquiryId: e.id, params: params);
        for (final ids in [tx.salesOf(e), tx.admins(), tx.franchiseOf(e)]) {
          tx.notifyAll(ids, NotificationEvent.enquiryWon, enquiryId: e.id);
        }
        tx.addTask(TaskKind.createProject,
            enquiryId: e.id,
            assignedUserId: tx.pickBackOffice(e),
            dueAt: tx.now.add(const Duration(days: 1)));
        _trigger(tx, e.id, CommissionTrigger.quotationAccepted);
      });

  void rejectQuotation(String id, String reason) => _run((tx) {
        final q = tx.db.quotationById(id)!.copyWith(
              status: QuotationStatus.rejected,
              respondedAt: tx.now,
              responseNote: reason,
            );
        tx.putQuotation(q);
        tx.advance(q.enquiryId, EnquiryStatus.negotiation);
        tx.audit(AuditAction.quotationRejected,
            entityType: 'quotation', entityId: q.id, enquiryId: q.enquiryId, note: reason);
        tx.system(q.enquiryId, q.vendorId,
            SystemText.encode(SystemText.quotationRejected, [q.number]));
        final e = tx.enquiry(q.enquiryId);
        for (final ids in [tx.backOfficeFor(e), tx.vendorUsersOf(q.vendorId)]) {
          tx.notifyAll(ids, NotificationEvent.quotationRejected,
              enquiryId: e.id, params: {'number': q.number});
        }
        tx.addFollowUp(FollowUpType.quotation,
            enquiryId: e.id, dueAt: tx.now.add(const Duration(days: 1)));
      });

  // ── Outcome and admin controls on an enquiry ─────────────────────────────

  void markLost(String enquiryId, String reason) => _run((tx) {
        tx.updateEnquiry(enquiryId, (x) => x.copyWith(lossReason: reason));
        tx.setStatus(enquiryId, EnquiryStatus.lost);
        for (final q in tx.db.currentQuotations(enquiryId)) {
          if (q.status.isOpen) tx.putQuotation(q.copyWith(status: QuotationStatus.expired));
        }
        final e = tx.enquiry(enquiryId);
        for (final a in tx.db.activeAssignmentsFor(enquiryId)) {
          tx.system(enquiryId, a.vendorId, SystemText.encode(SystemText.enquiryLost));
          tx.notifyAll(tx.vendorUsersOf(a.vendorId), NotificationEvent.enquiryLost,
              enquiryId: enquiryId);
        }
        tx.notifyAll(tx.salesOf(e), NotificationEvent.enquiryLost,
            enquiryId: enquiryId, params: {'reason': reason});
        tx.closeAllWork(enquiryId);
      });

  void reopenEnquiry(String enquiryId) => _run((tx) {
        final e = tx.enquiry(enquiryId);
        if (e.status == EnquiryStatus.rejected) {
          tx.setStatus(enquiryId, EnquiryStatus.verificationPending);
          tx.addTask(TaskKind.verify,
              enquiryId: enquiryId,
              assignedUserId: tx.pickBackOffice(e),
              dueAt: tx.now.add(const Duration(hours: 4)));
        } else if (e.status == EnquiryStatus.lost) {
          final hasQuotes = tx.db.quotationsFor(enquiryId).isNotEmpty;
          tx.setStatus(enquiryId,
              hasQuotes ? EnquiryStatus.negotiation : EnquiryStatus.vendorMatching);
        }
        tx.audit(AuditAction.edited,
            entityType: 'enquiry', entityId: enquiryId, enquiryId: enquiryId, note: 'reopened');
      });

  void assignBackOffice(String enquiryId, String userId) => _run((tx) {
        final e = tx.enquiry(enquiryId);
        tx.updateEnquiry(enquiryId, (x) => x.copyWith(backOfficeId: userId));
        tx.db = tx.db.copyWith(tasks: [
          for (final t in tx.db.tasks)
            if (!t.done && t.enquiryId == enquiryId && t.assignedUserId == e.backOfficeId)
              TaskItem(
                id: t.id,
                kind: t.kind,
                enquiryId: t.enquiryId,
                refId: t.refId,
                title: t.title,
                assignedUserId: userId,
                dueAt: t.dueAt,
                createdAt: t.createdAt,
              )
            else
              t,
        ]);
        tx.audit(AuditAction.reassigned,
            entityType: 'enquiry',
            entityId: enquiryId,
            enquiryId: enquiryId,
            field: 'backOffice',
            from: tx.db.userName(e.backOfficeId),
            to: tx.db.userName(userId));
        tx.notify(userId, NotificationEvent.taskAssigned, enquiryId: enquiryId);
      });

  void setPriority(String enquiryId, EnquiryPriority p) => _run((tx) {
        final old = tx.enquiry(enquiryId).priority;
        tx.updateEnquiry(enquiryId, (x) => x.copyWith(priority: p));
        tx.audit(AuditAction.edited,
            entityType: 'enquiry',
            entityId: enquiryId,
            enquiryId: enquiryId,
            field: 'priority',
            from: old.name,
            to: p.name);
      });

  void saveInternalNote(String enquiryId, String note) => _run((tx) {
        tx.updateEnquiry(enquiryId, (x) => x.copyWith(internalNote: note));
        tx.audit(AuditAction.edited,
            entityType: 'enquiry', entityId: enquiryId, enquiryId: enquiryId, field: 'note');
      });

  void setMultipleQuotesVisible(String enquiryId, bool visible) => _run((tx) {
        tx.updateEnquiry(enquiryId, (x) => x.copyWith(multipleQuotesVisible: visible));
        tx.audit(AuditAction.edited,
            entityType: 'enquiry',
            entityId: enquiryId,
            enquiryId: enquiryId,
            field: 'multipleQuotes',
            to: '$visible');
      });

  /// Customer confirms the purchase — referral protection evidence.
  void confirmPurchase(String enquiryId) => _run((tx) {
        tx.updateEnquiry(enquiryId, (x) => x.copyWith(customerConfirmedPurchase: true));
        tx.audit(AuditAction.edited,
            entityType: 'enquiry',
            entityId: enquiryId,
            enquiryId: enquiryId,
            field: 'customerConfirmedPurchase',
            to: 'true');
      });

  // ── Projects and payments ────────────────────────────────────────────────

  String createProject(String enquiryId,
          {DateTime? startDate, DateTime? expectedCompletion, DateTime? paymentDueDate}) =>
      _run((tx) {
        final e = tx.enquiry(enquiryId);
        final q = tx.db.acceptedQuotation(enquiryId);
        final vendorId =
            q?.vendorId ?? tx.db.activeAssignmentsFor(enquiryId).firstOrNull?.vendorId ?? '';
        final value = q?.total ?? e.finalValue ?? e.potentialValue ?? 0;
        final start = startDate ?? tx.now;
        final p = Project(
          id: 'PRJ-${tx.next('project')}',
          enquiryId: enquiryId,
          vendorId: vendorId,
          quotationId: q?.id,
          finalValue: value,
          startDate: start,
          expectedCompletion:
              expectedCompletion ?? start.add(Duration(days: q?.timelineDays ?? 7)),
          milestones: [
            for (final k in MilestoneKey.values)
              Milestone(
                key: k,
                done: k == MilestoneKey.orderConfirmed,
                doneAt: k == MilestoneKey.orderConfirmed ? tx.now : null,
              ),
          ],
          createdAt: tx.now,
          paymentDueDate: paymentDueDate ?? start.add(const Duration(days: 7)),
        );
        tx.putProject(p);
        tx.updateEnquiry(enquiryId, (x) => x.copyWith(finalValue: value));
        tx.advance(enquiryId, EnquiryStatus.projectCreated);
        tx.closeTasks(TaskKind.createProject, enquiryId: enquiryId);
        tx.audit(AuditAction.projectCreated,
            entityType: 'project', entityId: p.id, enquiryId: enquiryId);
        if (vendorId.isNotEmpty) {
          tx.system(enquiryId, vendorId,
              SystemText.encode(SystemText.projectCreated, [p.id]));
        }
        for (final ids in [
          tx.vendorUsersOf(vendorId),
          tx.customerUsersOf(e),
          tx.salesOf(e),
          tx.franchiseOf(e),
        ]) {
          tx.notifyAll(ids, NotificationEvent.projectCreated,
              enquiryId: enquiryId, params: {'project': p.id});
        }
        tx.addFollowUp(FollowUpType.project,
            enquiryId: enquiryId, dueAt: tx.now.add(const Duration(days: 2)));
        if (tx.config.paymentTrackingEnabled) {
          tx.addFollowUp(FollowUpType.payment,
              enquiryId: enquiryId, dueAt: p.paymentDueDate!);
        }
        _trigger(tx, enquiryId, CommissionTrigger.orderConfirmed);
        return p.id;
      });

  void toggleMilestone(String projectId, MilestoneKey key, bool done) => _run((tx) {
        final p = tx.db.projectById(projectId)!;
        final milestones = [
          for (final m in p.milestones)
            m.key == key ? Milestone(key: key, done: done, doneAt: done ? tx.now : null) : m,
        ];
        var status = p.status;
        final completedNow = key == MilestoneKey.projectCompleted && done;
        final wasNotStarted = status == ProjectStatus.notStarted;
        if (completedNow) {
          status = ProjectStatus.completed;
        } else if (wasNotStarted && done) {
          status = ProjectStatus.inProgress;
        } else if (key == MilestoneKey.projectCompleted &&
            !done &&
            status == ProjectStatus.completed) {
          status = ProjectStatus.inProgress;
        }
        tx.putProject(p.copyWith(
          milestones: milestones,
          status: status,
          actualCompletion: completedNow ? tx.now : null,
        ));
        tx.audit(AuditAction.milestoneUpdated,
            entityType: 'project',
            entityId: projectId,
            enquiryId: p.enquiryId,
            field: key.name,
            to: '$done');

        final e = tx.enquiry(p.enquiryId);
        if (status == ProjectStatus.inProgress) {
          tx.advance(e.id, EnquiryStatus.projectInProgress);
          if (wasNotStarted) _trigger(tx, e.id, CommissionTrigger.projectStarted);
        }
        if (completedNow) {
          tx.advance(e.id, EnquiryStatus.projectCompleted);
          _trigger(tx, e.id, CommissionTrigger.projectCompleted);
          final paid = tx.db.paidFor(projectId) >= p.finalValue - 0.5;
          tx.advance(e.id,
              paid ? EnquiryStatus.paymentCollected : EnquiryStatus.paymentPending);
          _syncCommissionStage(tx, e.id);
          for (final ids in [tx.customerUsersOf(e), tx.salesOf(e), tx.backOfficeFor(e)]) {
            tx.notifyAll(ids, NotificationEvent.projectCompleted,
                enquiryId: e.id, params: {'project': projectId});
          }
          if (tx.config.feedbackEnabled) {
            tx.notifyAll(tx.customerUsersOf(e), NotificationEvent.feedbackRequest,
                enquiryId: e.id);
          }
          tx.closeFollowUps(e.id, FollowUpType.project);
        } else {
          tx.notifyAll(tx.customerUsersOf(e), NotificationEvent.projectUpdated,
              enquiryId: e.id, params: {'project': projectId}, dedupe: true);
        }
      });

  void setProjectStatus(String projectId, ProjectStatus status, {String? reason}) =>
      _run((tx) {
        final p = tx.db.projectById(projectId)!;
        tx.putProject(p.copyWith(status: status, holdReason: reason));
        tx.audit(AuditAction.edited,
            entityType: 'project',
            entityId: projectId,
            enquiryId: p.enquiryId,
            field: 'status',
            from: p.status.name,
            to: status.name,
            note: reason);
        if (status == ProjectStatus.cancelled) {
          // Spec 50.22: a cancellation puts unpaid commission on hold for an
          // admin decision instead of silently reversing it.
          for (final c in tx.db.commissionsFor(p.enquiryId)) {
            if (c.status != CommissionStatus.paid &&
                c.status != CommissionStatus.cancelled) {
              tx.putCommission(c.copyWith(status: CommissionStatus.onHold, note: reason));
            }
          }
        }
        final e = tx.enquiry(p.enquiryId);
        for (final ids in [tx.customerUsersOf(e), tx.vendorUsersOf(p.vendorId)]) {
          tx.notifyAll(ids, NotificationEvent.projectUpdated,
              enquiryId: e.id, params: {'project': projectId});
        }
      });

  void recordPayment(
    String projectId, {
    required double amount,
    required PaymentMethod method,
    String reference = '',
    String notes = '',
    DateTime? at,
    String? proofName,
  }) =>
      _run((tx) {
        final p = tx.db.projectById(projectId)!;
        final rec = PaymentRecord(
          id: 'PAY-${tx.next('payment')}',
          projectId: projectId,
          amount: amount,
          at: at ?? tx.now,
          method: method,
          reference: reference,
          notes: notes,
          recordedByUserId: tx.actor!.id,
          proofName: proofName,
        );
        tx.db = tx.db.copyWith(payments: [...tx.db.payments, rec]);
        tx.audit(AuditAction.paymentRecorded,
            entityType: 'payment',
            entityId: rec.id,
            enquiryId: p.enquiryId,
            to: amount.toStringAsFixed(0));
        final e = tx.enquiry(p.enquiryId);
        final params = {'amount': amount.toStringAsFixed(0)};
        tx.notifyAll(tx.customerUsersOf(e), NotificationEvent.paymentRecorded,
            enquiryId: e.id, params: params);
        if (tx.actor!.role == UserRole.vendor) {
          tx.notifyAll(tx.backOfficeFor(e), NotificationEvent.paymentRecorded,
              enquiryId: e.id, params: params);
        }
        _trigger(tx, e.id, CommissionTrigger.paymentReceived);

        if (tx.db.paidFor(projectId) >= p.finalValue - 0.5) {
          final current = tx.db.projectById(projectId)!;
          tx.putProject(current.copyWith(milestones: [
            for (final m in current.milestones)
              m.key == MilestoneKey.finalPayment
                  ? Milestone(key: m.key, done: true, doneAt: tx.now)
                  : m,
          ]));
          tx.closeFollowUps(e.id, FollowUpType.payment);
          tx.closeTasks(TaskKind.collectPayment, enquiryId: e.id);
          _trigger(tx, e.id, CommissionTrigger.fullPaymentCollected);
          if (current.status == ProjectStatus.completed) {
            tx.advance(e.id, EnquiryStatus.paymentCollected);
          }
        }
        _syncCommissionStage(tx, e.id);
      });

  // ── Commissions ──────────────────────────────────────────────────────────

  /// Creates commissions when the configured trigger milestone is reached.
  /// The trigger and percentages are admin settings, never hard-coded.
  void _trigger(_Tx tx, String enquiryId, CommissionTrigger event) {
    if (tx.config.commissionTrigger != event) return;
    if (tx.db.commissionsFor(enquiryId).isNotEmpty) return;
    final e = tx.enquiry(enquiryId);
    final project = tx.db.projectFor(enquiryId);
    final value = e.finalValue ?? project?.finalValue ?? 0;
    if (value <= 0) return;

    void add(String userId, UserRole role, double pct) {
      if (pct <= 0) return;
      final c = Commission(
        id: 'COM-${tx.next('commission')}',
        enquiryId: enquiryId,
        projectId: project?.id,
        beneficiaryUserId: userId,
        role: role,
        businessValue: value,
        percent: pct,
        amount: (value * pct / 100).roundToDouble(),
        trigger: event,
        createdAt: tx.now,
      );
      tx.putCommission(c);
      tx.notify(userId, NotificationEvent.commissionUpdated,
          enquiryId: enquiryId,
          params: {'amount': c.amount.toStringAsFixed(0)},
          route: _earningsRoute(role));
    }

    if (e.salespersonId != null) {
      add(e.salespersonId!, UserRole.sales, tx.config.salesCommissionPercent);
    }
    if (e.backOfficeId != null) {
      add(e.backOfficeId!, UserRole.backOffice, tx.config.backOfficeCommissionPercent);
    }
    final f = tx.db.franchiseById(e.franchiseId);
    if (f?.headUserId != null) {
      add(f!.headUserId!, UserRole.franchise, f.sharePercent ?? tx.config.franchiseSharePercent);
    }
    tx.audit(AuditAction.commissionCreated,
        entityType: 'enquiry', entityId: enquiryId, enquiryId: enquiryId, note: event.name);
    for (final a in tx.admins()) {
      tx.addTask(TaskKind.approveCommission,
          enquiryId: enquiryId,
          assignedUserId: a,
          dueAt: tx.now.add(const Duration(days: 2)));
    }
  }

  static String _earningsRoute(UserRole role) => switch (role) {
        UserRole.sales => '/sales/earnings',
        UserRole.franchise => '/franchise/earnings',
        _ => '/commissions',
      };

  void _syncCommissionStage(_Tx tx, String enquiryId) {
    final list = tx.db.commissionsFor(enquiryId);
    if (list.isEmpty) return;
    if (tx.enquiry(enquiryId).status == EnquiryStatus.paymentCollected) {
      tx.setStatus(enquiryId, EnquiryStatus.commissionCalculated);
    }
    final settled = list.every((c) =>
        c.status == CommissionStatus.paid || c.status == CommissionStatus.cancelled);
    if (settled && tx.enquiry(enquiryId).status == EnquiryStatus.commissionCalculated) {
      tx.setStatus(enquiryId, EnquiryStatus.commissionSettled);
    }
  }

  /// Moves a commission one step: pending → approved → payable → paid.
  void advanceCommission(String id, {String? reference}) => _run((tx) {
        final c = tx.db.commissionById(id)!;
        final next = switch (c.status) {
          CommissionStatus.pending => tx.config.payoutApprovalRequired
              ? CommissionStatus.approved
              : CommissionStatus.payable,
          CommissionStatus.approved => CommissionStatus.payable,
          CommissionStatus.payable => CommissionStatus.paid,
          CommissionStatus.onHold => CommissionStatus.pending,
          _ => c.status,
        };
        if (next == c.status) return;
        final paid = next == CommissionStatus.paid;
        tx.putCommission(c.copyWith(
          status: next,
          approvedAt: next == CommissionStatus.approved || next == CommissionStatus.payable
              ? (c.approvedAt ?? tx.now)
              : null,
          paidAt: paid ? tx.now : null,
          reference: paid
              ? (reference ?? 'UPI ${tx.now.millisecondsSinceEpoch % 10000000000}')
              : null,
        ));
        tx.audit(paid ? AuditAction.commissionPaid : AuditAction.commissionApproved,
            entityType: 'commission',
            entityId: id,
            enquiryId: c.enquiryId,
            field: 'status',
            from: c.status.name,
            to: next.name);
        tx.notify(c.beneficiaryUserId,
            paid ? NotificationEvent.commissionPaid : NotificationEvent.commissionUpdated,
            enquiryId: c.enquiryId,
            params: {'amount': c.amount.toStringAsFixed(0)},
            route: _earningsRoute(c.role));
        final pendingLeft = tx.db
            .commissionsFor(c.enquiryId)
            .any((x) => x.status == CommissionStatus.pending);
        if (!pendingLeft) tx.closeTasks(TaskKind.approveCommission, enquiryId: c.enquiryId);
        _syncCommissionStage(tx, c.enquiryId);
      });

  void holdCommission(String id, String note) => _run((tx) {
        final c = tx.db.commissionById(id)!;
        tx.putCommission(c.copyWith(status: CommissionStatus.onHold, note: note));
        tx.audit(AuditAction.edited,
            entityType: 'commission',
            entityId: id,
            enquiryId: c.enquiryId,
            field: 'status',
            from: c.status.name,
            to: CommissionStatus.onHold.name,
            note: note);
      });

  void cancelCommission(String id, String note) => _run((tx) {
        final c = tx.db.commissionById(id)!;
        tx.putCommission(c.copyWith(status: CommissionStatus.cancelled, note: note));
        tx.audit(AuditAction.edited,
            entityType: 'commission',
            entityId: id,
            enquiryId: c.enquiryId,
            field: 'status',
            from: c.status.name,
            to: CommissionStatus.cancelled.name,
            note: note);
        tx.notify(c.beneficiaryUserId, NotificationEvent.commissionUpdated,
            enquiryId: c.enquiryId,
            params: {'amount': c.amount.toStringAsFixed(0)},
            route: _earningsRoute(c.role));
        _syncCommissionStage(tx, c.enquiryId);
      });

  // ── Follow-ups, tasks, notifications ─────────────────────────────────────

  void addFollowUp({
    String? enquiryId,
    required FollowUpType type,
    required DateTime dueAt,
    String notes = '',
  }) =>
      _run((tx) => tx.addFollowUp(type,
          enquiryId: enquiryId, dueAt: dueAt, notes: notes, userId: tx.actor!.id));

  void completeFollowUp(String id, {String outcome = '', DateTime? nextAt, String nextNotes = ''}) =>
      _run((tx) {
        final f = tx.db.followUps.firstWhere((x) => x.id == id);
        tx.putFollowUp(f.copyWith(done: true, doneAt: tx.now, outcome: outcome));
        if (nextAt != null) {
          tx.addFollowUp(f.type,
              enquiryId: f.enquiryId, dueAt: nextAt, notes: nextNotes, userId: f.assignedUserId);
        }
      });

  void rescheduleFollowUp(String id, DateTime at) => _run((tx) {
        final f = tx.db.followUps.firstWhere((x) => x.id == id);
        tx.putFollowUp(f.copyWith(dueAt: at));
      });

  void completeTask(String id) => _run((tx) {
        final t = tx.db.tasks.firstWhere((x) => x.id == id);
        tx.putTask(t.copyWith(done: true, doneAt: tx.now));
      });

  void addTask(String title, DateTime dueAt, {String? enquiryId}) => _run((tx) {
        tx.addTask(TaskKind.general,
            title: title, enquiryId: enquiryId, assignedUserId: tx.actor!.id, dueAt: dueAt);
      });

  void markNotificationRead(String id) {
    final n = state.notifications.where((x) => x.id == id).firstOrNull;
    if (n == null || n.read) return;
    _run((tx) => tx.db = tx.db.copyWith(notifications: [
          for (final x in tx.db.notifications) x.id == id ? x.copyWith(read: true) : x,
        ]));
  }

  void markAllNotificationsRead() => _run((tx) {
        final me = tx.actor!.id;
        tx.db = tx.db.copyWith(notifications: [
          for (final x in tx.db.notifications)
            x.userId == me && !x.read ? x.copyWith(read: true) : x,
        ]);
      });

  // ── Configuration and master data (admin) ────────────────────────────────

  /// Every changed setting is written to the audit log (spec 53.6).
  void updateConfig(AppConfig next, {String? reason}) => _run((tx) {
        final before = tx.config.toJson();
        final after = next.toJson();
        for (final key in after.keys) {
          if ('${before[key]}' != '${after[key]}') {
            tx.audit(AuditAction.configChanged,
                entityType: 'config',
                entityId: key,
                field: key,
                from: '${before[key]}',
                to: '${after[key]}',
                note: reason);
          }
        }
        tx.db = tx.db.copyWith(config: next);
      });

  String saveCategory(ServiceCategory c) => _run((tx) {
        final id = c.id.isEmpty ? 'cat_new${tx.next('master')}' : c.id;
        final item = ServiceCategory(
          id: id,
          name: c.name,
          icon: c.icon,
          description: c.description,
          active: c.active,
          questions: c.questions,
        );
        tx.db = tx.db.copyWith(categories: _put(tx.db.categories, item, (x) => x.id));
        tx.audit(c.id.isEmpty ? AuditAction.created : AuditAction.edited,
            entityType: 'category', entityId: id, note: c.name);
        return id;
      });

  String saveProduct(Product p) => _run((tx) {
        final id = p.id.isEmpty ? 'p_new${tx.next('master')}' : p.id;
        final item = Product(
            id: id,
            categoryId: p.categoryId,
            name: p.name,
            description: p.description,
            active: p.active);
        tx.db = tx.db.copyWith(products: _put(tx.db.products, item, (x) => x.id));
        tx.audit(p.id.isEmpty ? AuditAction.created : AuditAction.edited,
            entityType: 'product', entityId: id, note: p.name);
        return id;
      });

  String saveBrand(Brand b) => _run((tx) {
        final id = b.id.isEmpty ? 'b_new${tx.next('master')}' : b.id;
        final item = Brand(id: id, name: b.name, categoryIds: b.categoryIds, active: b.active);
        tx.db = tx.db.copyWith(brands: _put(tx.db.brands, item, (x) => x.id));
        tx.audit(b.id.isEmpty ? AuditAction.created : AuditAction.edited,
            entityType: 'brand', entityId: id, note: b.name);
        return id;
      });

  String saveCity(City c) => _run((tx) {
        final id = c.id.isEmpty ? 'city_new${tx.next('master')}' : c.id;
        final item = City(id: id, name: c.name, state: c.state, country: c.country, areas: c.areas);
        tx.db = tx.db.copyWith(cities: _put(tx.db.cities, item, (x) => x.id));
        tx.audit(c.id.isEmpty ? AuditAction.created : AuditAction.edited,
            entityType: 'location', entityId: id, note: c.name);
        return id;
      });

  String saveFranchise(Franchise f) => _run((tx) {
        final id = f.id.isEmpty ? 'f_new${tx.next('master')}' : f.id;
        final item = Franchise(
          id: id,
          name: f.name,
          cities: f.cities,
          headUserId: f.headUserId,
          active: f.active,
          sharePercent: f.sharePercent,
          createdAt: f.id.isEmpty ? tx.now : f.createdAt,
        );
        tx.putFranchise(item);
        if (f.headUserId != null) {
          final head = tx.db.userById(f.headUserId);
          if (head != null && head.franchiseId != id) {
            tx.putUser(head.copyWith(franchiseId: id));
          }
        }
        tx.audit(f.id.isEmpty ? AuditAction.created : AuditAction.edited,
            entityType: 'franchise', entityId: id, note: f.name);
        return id;
      });

  void setUserFranchise(String userId, String? franchiseId) => _run((tx) {
        final u = tx.db.userById(userId)!;
        tx.putUser(AppUser.fromJson({...u.toJson(), 'franchiseId': franchiseId}));
        if (u.vendorId != null) {
          final v = tx.db.vendorById(u.vendorId)!;
          tx.putVendor(Vendor.fromJson({...v.toJson(), 'franchiseId': franchiseId}));
        }
        tx.audit(AuditAction.userUpdated,
            entityType: 'user', entityId: userId, field: 'franchise', to: franchiseId);
      });

  // ── Vendor accounts ──────────────────────────────────────────────────────

  void approveVendor(String vendorId) => _setVendorStatus(vendorId, AccountStatus.active);

  void rejectVendor(String vendorId, String reason) =>
      _setVendorStatus(vendorId, AccountStatus.rejected, note: reason);

  void suspendVendor(String vendorId, String reason) =>
      _setVendorStatus(vendorId, AccountStatus.suspended, note: reason);

  void markVendorUnderReview(String vendorId) =>
      _setVendorStatus(vendorId, AccountStatus.underReview);

  void _setVendorStatus(String vendorId, AccountStatus status, {String? note}) => _run((tx) {
        final v = tx.db.vendorById(vendorId)!;
        tx.putVendor(v.copyWith(status: status));
        for (final u in tx.db.vendorUsers(vendorId)) {
          tx.putUser(u.copyWith(status: status));
        }
        tx.audit(
            status == AccountStatus.active
                ? AuditAction.vendorApproved
                : AuditAction.vendorSuspended,
            entityType: 'vendor',
            entityId: vendorId,
            field: 'status',
            from: v.status.name,
            to: status.name,
            note: note);
        if (status == AccountStatus.active) {
          tx.closeTasks(TaskKind.approveVendor, refId: vendorId);
          tx.notifyAll(tx.vendorUsersOf(vendorId), NotificationEvent.vendorApproved);
        }
      });

  void updateVendor(Vendor v) => _run((tx) {
        tx.putVendor(v);
        tx.audit(AuditAction.edited, entityType: 'vendor', entityId: v.id);
      });

  void addVendorDocument(String vendorId, String name, DocKind kind) => _run((tx) {
        final v = tx.db.vendorById(vendorId)!;
        tx.putVendor(v.copyWith(documents: [
          ...v.documents,
          VendorDocument(name: name, kind: kind, uploadedAt: tx.now),
        ]));
        tx.audit(AuditAction.edited,
            entityType: 'vendor', entityId: vendorId, field: 'document', to: name);
      });

  void verifyVendorDocument(String vendorId, int index) => _run((tx) {
        final v = tx.db.vendorById(vendorId)!;
        final docs = [...v.documents];
        docs[index] = docs[index].copyWith(verified: true);
        tx.putVendor(v.copyWith(documents: docs));
        tx.audit(AuditAction.edited,
            entityType: 'vendor', entityId: vendorId, field: 'document', to: docs[index].name);
      });

  // ── Feedback ─────────────────────────────────────────────────────────────

  void submitFeedback(String enquiryId, int rating, String review) => _run((tx) {
        final e = tx.enquiry(enquiryId);
        tx.db = tx.db.copyWith(feedback: [
          ...tx.db.feedback,
          CustomerFeedback(
            id: 'fb${tx.next('feedback')}',
            enquiryId: enquiryId,
            projectId: tx.db.projectFor(enquiryId)?.id,
            customerId: e.customerId,
            rating: rating,
            review: review,
            at: tx.now,
          ),
        ]);
        tx.audit(AuditAction.feedbackGiven,
            entityType: 'enquiry', entityId: enquiryId, enquiryId: enquiryId, to: '$rating');
      });
}

List<T> _put<T>(List<T> list, T item, String Function(T) id) {
  final key = id(item);
  var found = false;
  final out = [
    for (final x in list)
      if (id(x) == key) ...[item] else x,
  ];
  for (final x in list) {
    if (id(x) == key) found = true;
  }
  return found ? out : [...list, item];
}

/// One unit of change. Collects edits to [db] and side effects (audit,
/// notifications, tasks) so an action reads as a straight list of steps.
class _Tx {
  _Tx(this.db, this.actor, this.now);

  DbState db;
  final AppUser? actor;
  final DateTime now;

  AppConfig get config => db.config;

  int next(String key) {
    final n = (db.seq[key] ?? 0) + 1;
    db = db.copyWith(seq: {...db.seq, key: n});
    return n;
  }

  Enquiry enquiry(String id) => db.enquiryById(id)!;

  // Upserts
  void putEnquiry(Enquiry e) => db = db.copyWith(enquiries: _put(db.enquiries, e, (x) => x.id));
  void putAssignment(VendorAssignment a) =>
      db = db.copyWith(assignments: _put(db.assignments, a, (x) => x.id));
  void putAppointment(Appointment a) =>
      db = db.copyWith(appointments: _put(db.appointments, a, (x) => x.id));
  void putQuotation(Quotation q) =>
      db = db.copyWith(quotations: _put(db.quotations, q, (x) => x.id));
  void putProject(Project p) => db = db.copyWith(projects: _put(db.projects, p, (x) => x.id));
  void putCommission(Commission c) =>
      db = db.copyWith(commissions: _put(db.commissions, c, (x) => x.id));
  void putFollowUp(FollowUp f) =>
      db = db.copyWith(followUps: _put(db.followUps, f, (x) => x.id));
  void putTask(TaskItem t) => db = db.copyWith(tasks: _put(db.tasks, t, (x) => x.id));
  void putUser(AppUser u) => db = db.copyWith(users: _put(db.users, u, (x) => x.id));
  void putVendor(Vendor v) => db = db.copyWith(vendors: _put(db.vendors, v, (x) => x.id));
  void putCustomer(Customer c) =>
      db = db.copyWith(customers: _put(db.customers, c, (x) => x.id));
  void putFranchise(Franchise f) =>
      db = db.copyWith(franchises: _put(db.franchises, f, (x) => x.id));

  void updateEnquiry(String id, Enquiry Function(Enquiry e) change) =>
      putEnquiry(change(enquiry(id)).copyWith(updatedAt: now));

  void setStatus(String enquiryId, EnquiryStatus to) {
    final e = enquiry(enquiryId);
    if (e.status == to) return;
    putEnquiry(e.copyWith(status: to, updatedAt: now));
    audit(AuditAction.statusChanged,
        entityType: 'enquiry',
        entityId: enquiryId,
        enquiryId: enquiryId,
        field: 'status',
        from: e.status.name,
        to: to.name);
  }

  /// Moves forward only; closed enquiries are never moved.
  void advance(String enquiryId, EnquiryStatus to) {
    final e = enquiry(enquiryId);
    if (e.status.isEnded) return;
    if (to.index > e.status.index) setStatus(enquiryId, to);
  }

  void audit(
    AuditAction action, {
    required String entityType,
    required String entityId,
    String? enquiryId,
    String? field,
    String? from,
    String? to,
    String? note,
    AppUser? by,
  }) {
    final who = by ?? actor;
    db = db.copyWith(audit: [
      ...db.audit,
      AuditEntry(
        id: 'a${next('audit')}',
        at: now,
        userId: who?.id,
        role: who?.role,
        action: action,
        entityType: entityType,
        entityId: entityId,
        enquiryId: enquiryId,
        field: field,
        oldValue: from,
        newValue: to,
        note: note,
      ),
    ]);
  }

  void notify(
    String userId,
    NotificationEvent event, {
    String? enquiryId,
    Map<String, String> params = const {},
    String? route,
    bool dedupe = false,
  }) {
    if (userId == actor?.id) return;
    final target = route ?? (enquiryId == null ? null : '/enquiry/$enquiryId');
    if (dedupe &&
        db.notifications.any((n) =>
            n.userId == userId && !n.read && n.event == event && n.route == target)) {
      return;
    }
    db = db.copyWith(notifications: [
      ...db.notifications,
      AppNotification(
        id: 'n${next('notif')}',
        userId: userId,
        event: event,
        enquiryId: enquiryId,
        params: {'id': ?enquiryId, ...params},
        createdAt: now,
        route: target,
      ),
    ]);
  }

  void notifyAll(
    Iterable<String> userIds,
    NotificationEvent event, {
    String? enquiryId,
    Map<String, String> params = const {},
    String? route,
    bool dedupe = false,
  }) {
    for (final id in userIds.toSet()) {
      notify(id, event, enquiryId: enquiryId, params: params, route: route, dedupe: dedupe);
    }
  }

  // Recipients
  Iterable<String> backOfficeFor(Enquiry e) => e.backOfficeId != null
      ? [e.backOfficeId!]
      : db.usersWithRole(UserRole.backOffice).map((u) => u.id);
  Iterable<String> vendorUsersOf(String vendorId) =>
      db.vendorUsers(vendorId).map((u) => u.id);
  Iterable<String> customerUsersOf(Enquiry e) =>
      db.customerUsers(e.customerId).map((u) => u.id);
  Iterable<String> salesOf(Enquiry e) =>
      e.salespersonId == null ? const [] : [e.salespersonId!];
  Iterable<String> franchiseOf(Enquiry e) {
    final head = db.franchiseById(e.franchiseId)?.headUserId;
    return head == null ? const [] : [head];
  }

  Iterable<String> admins() => db.usersWithRole(UserRole.admin).map((u) => u.id);

  /// The back-office owner, or the best available executive for the city.
  String pickBackOffice(Enquiry e) {
    if (e.backOfficeId != null) return e.backOfficeId!;
    final team = db.usersWithRole(UserRole.backOffice);
    return (team.where((u) => u.city == e.city).firstOrNull ?? team.first).id;
  }

  void addTask(
    TaskKind kind, {
    String? enquiryId,
    String? refId,
    String? title,
    required String assignedUserId,
    required DateTime dueAt,
  }) {
    db = db.copyWith(tasks: [
      ...db.tasks,
      TaskItem(
        id: 't${next('task')}',
        kind: kind,
        enquiryId: enquiryId,
        refId: refId,
        title: title,
        assignedUserId: assignedUserId,
        dueAt: dueAt,
        createdAt: now,
      ),
    ]);
  }

  void closeTasks(TaskKind kind, {String? enquiryId, String? refId}) {
    db = db.copyWith(tasks: [
      for (final t in db.tasks)
        if (!t.done &&
            t.kind == kind &&
            (enquiryId == null || t.enquiryId == enquiryId) &&
            (refId == null || t.refId == refId))
          t.copyWith(done: true, doneAt: now)
        else
          t,
    ]);
  }

  void closeAllWork(String enquiryId) {
    db = db.copyWith(
      tasks: [
        for (final t in db.tasks)
          if (!t.done && t.enquiryId == enquiryId) t.copyWith(done: true, doneAt: now) else t,
      ],
      followUps: [
        for (final f in db.followUps)
          if (!f.done && f.enquiryId == enquiryId) f.copyWith(done: true, doneAt: now) else f,
      ],
    );
  }

  void addFollowUp(
    FollowUpType type, {
    String? enquiryId,
    required DateTime dueAt,
    String notes = '',
    String? userId,
  }) {
    final owner = userId ??
        (enquiryId != null ? pickBackOffice(enquiry(enquiryId)) : actor!.id);
    db = db.copyWith(followUps: [
      ...db.followUps,
      FollowUp(
        id: 'fu${next('followup')}',
        enquiryId: enquiryId,
        type: type,
        assignedUserId: owner,
        dueAt: dueAt,
        notes: notes,
        createdAt: now,
      ),
    ]);
  }

  void closeFollowUps(String enquiryId, FollowUpType type) {
    db = db.copyWith(followUps: [
      for (final f in db.followUps)
        if (!f.done && f.enquiryId == enquiryId && f.type == type)
          f.copyWith(done: true, doneAt: now)
        else
          f,
    ]);
  }

  void system(String enquiryId, String thread, String text) {
    db = db.copyWith(messages: [
      ...db.messages,
      ChatMessage(
        id: 'm${next('msg')}',
        enquiryId: enquiryId,
        thread: thread,
        kind: ChatKind.system,
        text: text,
        at: now,
      ),
    ]);
  }

  void markRead(String enquiryId, String thread) {
    final me = actor;
    if (me == null) return;
    db = db.copyWith(chatReads: {
      ...db.chatReads,
      DbQueries.readKey(me.id, enquiryId, thread): now,
    });
  }

  void logCall(String enquiryId, UserRole toRole, String toName, int durationSec,
      {CallOutcome? outcome, String notes = ''}) {
    db = db.copyWith(calls: [
      ...db.calls,
      CallRecord(
        id: 'CALL-${next('call')}',
        enquiryId: enquiryId,
        byUserId: actor!.id,
        toName: toName,
        toRole: toRole,
        at: now,
        durationSec: durationSec,
        outcome: outcome,
        notes: notes,
        recorded: config.callRecordingEnabled,
      ),
    ]);
    audit(AuditAction.callLogged,
        entityType: 'call', entityId: enquiryId, enquiryId: enquiryId, note: outcome?.name);
  }

  void consent(String userId, ConsentAction action, {String? enquiryId}) {
    db = db.copyWith(consents: [
      ...db.consents,
      ConsentRecord(
        id: 'cs${next('consent')}',
        userId: userId,
        action: action,
        policyVersion: config.termsVersion,
        at: now,
        enquiryId: enquiryId,
      ),
    ]);
  }

  // ── Credential helpers ───────────────────────────────────────────────────

  static String uniqueLoginId(DbState db, String name) {
    final words = name
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z\s]'), '')
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();
    var base = words.isEmpty
        ? 'user'
        : words.length == 1
            ? words.first
            : '${words.first}.${words.last[0]}';
    if (base.length > 16) base = base.substring(0, 16);
    var candidate = base;
    var n = 2;
    while (db.userByLogin(candidate) != null) {
      candidate = '$base$n';
      n++;
    }
    return candidate;
  }

  static final _rng = Random();

  static String generatePassword() {
    const letters = 'abcdefghjkmnpqrstuvwxyz';
    const digits = '23456789';
    final b = StringBuffer();
    for (var i = 0; i < 5; i++) {
      b.write(letters[_rng.nextInt(letters.length)]);
    }
    for (var i = 0; i < 3; i++) {
      b.write(digits[_rng.nextInt(digits.length)]);
    }
    return b.toString();
  }
}

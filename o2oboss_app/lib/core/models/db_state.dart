import 'activity.dart';
import 'business.dart';
import 'catalog.dart';
import 'commerce.dart';
import 'config.dart';
import 'enquiry.dart';
import 'json.dart';
import 'user.dart';
import 'waitlist.dart';

/// The whole demo "database". One shared copy is read by all six roles, so a
/// change made in one login is immediately visible in the others.
class DbState {
  const DbState({
    this.schemaVersion = currentSchema,
    this.config = const AppConfig(),
    this.users = const [],
    this.vendors = const [],
    this.customers = const [],
    this.categories = const [],
    this.products = const [],
    this.brands = const [],
    this.cities = const [],
    this.franchises = const [],
    this.enquiries = const [],
    this.assignments = const [],
    this.calls = const [],
    this.messages = const [],
    this.appointments = const [],
    this.quotations = const [],
    this.projects = const [],
    this.payments = const [],
    this.commissions = const [],
    this.followUps = const [],
    this.tasks = const [],
    this.notifications = const [],
    this.audit = const [],
    this.feedback = const [],
    this.consents = const [],
    this.waitlist = const [],
    this.seq = const {},
    this.chatReads = const {},
  });

  /// Bump when the seed or model shape changes so stale saved data is replaced.
  static const currentSchema = 3;

  final int schemaVersion;
  final AppConfig config;
  final List<AppUser> users;
  final List<Vendor> vendors;
  final List<Customer> customers;
  final List<ServiceCategory> categories;
  final List<Product> products;
  final List<Brand> brands;
  final List<City> cities;
  final List<Franchise> franchises;
  final List<Enquiry> enquiries;
  final List<VendorAssignment> assignments;
  final List<CallRecord> calls;
  final List<ChatMessage> messages;
  final List<Appointment> appointments;
  final List<Quotation> quotations;
  final List<Project> projects;
  final List<PaymentRecord> payments;
  final List<Commission> commissions;
  final List<FollowUp> followUps;
  final List<TaskItem> tasks;
  final List<AppNotification> notifications;
  final List<AuditEntry> audit;
  final List<CustomerFeedback> feedback;
  final List<ConsentRecord> consents;

  /// People from places O2O Boss does not serve yet.
  final List<WaitlistEntry> waitlist;

  /// Running counters used to create readable IDs such as ENQ-1031.
  final Map<String, int> seq;

  /// Last time a user opened a chat thread: key is `userId|enquiryId|thread`.
  final Map<String, DateTime> chatReads;

  DbState copyWith({
    AppConfig? config,
    List<AppUser>? users,
    List<Vendor>? vendors,
    List<Customer>? customers,
    List<ServiceCategory>? categories,
    List<Product>? products,
    List<Brand>? brands,
    List<City>? cities,
    List<Franchise>? franchises,
    List<Enquiry>? enquiries,
    List<VendorAssignment>? assignments,
    List<CallRecord>? calls,
    List<ChatMessage>? messages,
    List<Appointment>? appointments,
    List<Quotation>? quotations,
    List<Project>? projects,
    List<PaymentRecord>? payments,
    List<Commission>? commissions,
    List<FollowUp>? followUps,
    List<TaskItem>? tasks,
    List<AppNotification>? notifications,
    List<AuditEntry>? audit,
    List<CustomerFeedback>? feedback,
    List<ConsentRecord>? consents,
    List<WaitlistEntry>? waitlist,
    Map<String, int>? seq,
    Map<String, DateTime>? chatReads,
  }) =>
      DbState(
        schemaVersion: schemaVersion,
        config: config ?? this.config,
        users: users ?? this.users,
        vendors: vendors ?? this.vendors,
        customers: customers ?? this.customers,
        categories: categories ?? this.categories,
        products: products ?? this.products,
        brands: brands ?? this.brands,
        cities: cities ?? this.cities,
        franchises: franchises ?? this.franchises,
        enquiries: enquiries ?? this.enquiries,
        assignments: assignments ?? this.assignments,
        calls: calls ?? this.calls,
        messages: messages ?? this.messages,
        appointments: appointments ?? this.appointments,
        quotations: quotations ?? this.quotations,
        projects: projects ?? this.projects,
        payments: payments ?? this.payments,
        commissions: commissions ?? this.commissions,
        followUps: followUps ?? this.followUps,
        tasks: tasks ?? this.tasks,
        notifications: notifications ?? this.notifications,
        audit: audit ?? this.audit,
        feedback: feedback ?? this.feedback,
        consents: consents ?? this.consents,
        waitlist: waitlist ?? this.waitlist,
        seq: seq ?? this.seq,
        chatReads: chatReads ?? this.chatReads,
      );

  Map<String, dynamic> toJson() => {
        'schemaVersion': schemaVersion,
        'config': config.toJson(),
        'users': listToJson(users, (e) => e.toJson()),
        'vendors': listToJson(vendors, (e) => e.toJson()),
        'customers': listToJson(customers, (e) => e.toJson()),
        'categories': listToJson(categories, (e) => e.toJson()),
        'products': listToJson(products, (e) => e.toJson()),
        'brands': listToJson(brands, (e) => e.toJson()),
        'cities': listToJson(cities, (e) => e.toJson()),
        'franchises': listToJson(franchises, (e) => e.toJson()),
        'enquiries': listToJson(enquiries, (e) => e.toJson()),
        'assignments': listToJson(assignments, (e) => e.toJson()),
        'calls': listToJson(calls, (e) => e.toJson()),
        'messages': listToJson(messages, (e) => e.toJson()),
        'appointments': listToJson(appointments, (e) => e.toJson()),
        'quotations': listToJson(quotations, (e) => e.toJson()),
        'projects': listToJson(projects, (e) => e.toJson()),
        'payments': listToJson(payments, (e) => e.toJson()),
        'commissions': listToJson(commissions, (e) => e.toJson()),
        'followUps': listToJson(followUps, (e) => e.toJson()),
        'tasks': listToJson(tasks, (e) => e.toJson()),
        'notifications': listToJson(notifications, (e) => e.toJson()),
        'audit': listToJson(audit, (e) => e.toJson()),
        'feedback': listToJson(feedback, (e) => e.toJson()),
        'consents': listToJson(consents, (e) => e.toJson()),
        'waitlist': listToJson(waitlist, (e) => e.toJson()),
        'seq': seq,
        'chatReads':
            chatReads.map((k, v) => MapEntry(k, v.toIso8601String())),
      };

  factory DbState.fromJson(Map<String, dynamic> j) => DbState(
        schemaVersion: numToInt(j['schemaVersion']),
        config: j['config'] == null
            ? const AppConfig()
            : AppConfig.fromJson(Map<String, dynamic>.from(j['config'] as Map)),
        users: listOf(j['users'], AppUser.fromJson),
        vendors: listOf(j['vendors'], Vendor.fromJson),
        customers: listOf(j['customers'], Customer.fromJson),
        categories: listOf(j['categories'], ServiceCategory.fromJson),
        products: listOf(j['products'], Product.fromJson),
        brands: listOf(j['brands'], Brand.fromJson),
        cities: listOf(j['cities'], City.fromJson),
        franchises: listOf(j['franchises'], Franchise.fromJson),
        enquiries: listOf(j['enquiries'], Enquiry.fromJson),
        assignments: listOf(j['assignments'], VendorAssignment.fromJson),
        calls: listOf(j['calls'], CallRecord.fromJson),
        messages: listOf(j['messages'], ChatMessage.fromJson),
        appointments: listOf(j['appointments'], Appointment.fromJson),
        quotations: listOf(j['quotations'], Quotation.fromJson),
        projects: listOf(j['projects'], Project.fromJson),
        payments: listOf(j['payments'], PaymentRecord.fromJson),
        commissions: listOf(j['commissions'], Commission.fromJson),
        followUps: listOf(j['followUps'], FollowUp.fromJson),
        tasks: listOf(j['tasks'], TaskItem.fromJson),
        notifications: listOf(j['notifications'], AppNotification.fromJson),
        audit: listOf(j['audit'], AuditEntry.fromJson),
        feedback: listOf(j['feedback'], CustomerFeedback.fromJson),
        consents: listOf(j['consents'], ConsentRecord.fromJson),
        waitlist: listOf(j['waitlist'], WaitlistEntry.fromJson),
        seq: j['seq'] == null
            ? <String, int>{}
            : Map<String, int>.from(
                (j['seq'] as Map).map((k, v) => MapEntry(k as String, (v as num).toInt()))),
        chatReads: j['chatReads'] == null
            ? <String, DateTime>{}
            : (j['chatReads'] as Map).map(
                (k, v) => MapEntry(k as String, DateTime.parse(v as String))),
      );
}

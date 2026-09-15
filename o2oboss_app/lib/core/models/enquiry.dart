import 'enums.dart';
import 'json.dart';

class VerificationInfo {
  const VerificationInfo({
    required this.outcome,
    this.notes = '',
    required this.at,
    required this.byUserId,
  });

  final CallOutcome outcome;
  final String notes;
  final DateTime at;
  final String byUserId;

  Map<String, dynamic> toJson() => {
        'outcome': outcome.name,
        'notes': notes,
        'at': at.toIso8601String(),
        'byUserId': byUserId,
      };

  factory VerificationInfo.fromJson(Map<String, dynamic> j) => VerificationInfo(
        outcome: enumByName(CallOutcome.values, j['outcome'], CallOutcome.genuine),
        notes: j['notes'] as String? ?? '',
        at: DateTime.parse(j['at'] as String),
        byUserId: j['byUserId'] as String,
      );
}

/// The central business object. Every other record hangs off an enquiry.
class Enquiry {
  const Enquiry({
    required this.id,
    required this.customerId,
    required this.categoryId,
    this.productId,
    this.brandId,
    this.preferredVendorId,
    required this.city,
    required this.area,
    this.pincode,
    this.address,
    required this.requirement,
    this.contactPreference = ContactPreference.callAnytime,
    this.preferredTime,
    required this.source,
    required this.createdByUserId,
    this.salespersonId,
    this.backOfficeId,
    this.franchiseId,
    required this.status,
    this.priority = EnquiryPriority.normal,
    required this.createdAt,
    required this.updatedAt,
    this.answers = const {},
    this.verification,
    this.potentialValue,
    this.finalValue,
    this.lossReason,
    this.rejectReason,
    this.multipleQuotesVisible = false,
    this.internalNote = '',
    this.otpVerified = false,
    this.customerConfirmedVisit = false,
    this.customerConfirmedPurchase = false,
  });

  /// Permanent ID shown everywhere, e.g. ENQ-1024.
  final String id;
  final String customerId;
  final String categoryId;
  final String? productId;
  final String? brandId;

  /// Seller the customer picked on a product page. Only back office sees who
  /// it is; it is a hint for matching, not an assignment.
  final String? preferredVendorId;
  final String city;
  final String area;
  final String? pincode;
  final String? address;
  final String requirement;
  final ContactPreference contactPreference;
  final String? preferredTime;
  final EnquirySource source;
  final String createdByUserId;
  final String? salespersonId;
  final String? backOfficeId;
  final String? franchiseId;
  final EnquiryStatus status;
  final EnquiryPriority priority;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Qualification answers keyed by question ID.
  final Map<String, String> answers;
  final VerificationInfo? verification;
  final double? potentialValue;
  final double? finalValue;
  final String? lossReason;
  final String? rejectReason;

  /// Back office decides whether the customer may see more than one quotation.
  final bool multipleQuotesVisible;

  /// Back-office only. Never shown to sales, vendor or customer.
  final String internalNote;
  final bool otpVerified;
  final bool customerConfirmedVisit;
  final bool customerConfirmedPurchase;

  Enquiry copyWith({
    String? categoryId,
    String? productId,
    String? brandId,
    String? city,
    String? area,
    String? pincode,
    String? address,
    String? requirement,
    ContactPreference? contactPreference,
    String? preferredTime,
    String? salespersonId,
    String? backOfficeId,
    String? franchiseId,
    EnquiryStatus? status,
    EnquiryPriority? priority,
    DateTime? updatedAt,
    Map<String, String>? answers,
    VerificationInfo? verification,
    double? potentialValue,
    double? finalValue,
    String? lossReason,
    String? rejectReason,
    bool? multipleQuotesVisible,
    String? internalNote,
    bool? otpVerified,
    bool? customerConfirmedVisit,
    bool? customerConfirmedPurchase,
  }) =>
      Enquiry(
        id: id,
        customerId: customerId,
        categoryId: categoryId ?? this.categoryId,
        productId: productId ?? this.productId,
        brandId: brandId ?? this.brandId,
        preferredVendorId: preferredVendorId,
        city: city ?? this.city,
        area: area ?? this.area,
        pincode: pincode ?? this.pincode,
        address: address ?? this.address,
        requirement: requirement ?? this.requirement,
        contactPreference: contactPreference ?? this.contactPreference,
        preferredTime: preferredTime ?? this.preferredTime,
        source: source,
        createdByUserId: createdByUserId,
        salespersonId: salespersonId ?? this.salespersonId,
        backOfficeId: backOfficeId ?? this.backOfficeId,
        franchiseId: franchiseId ?? this.franchiseId,
        status: status ?? this.status,
        priority: priority ?? this.priority,
        createdAt: createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        answers: answers ?? this.answers,
        verification: verification ?? this.verification,
        potentialValue: potentialValue ?? this.potentialValue,
        finalValue: finalValue ?? this.finalValue,
        lossReason: lossReason ?? this.lossReason,
        rejectReason: rejectReason ?? this.rejectReason,
        multipleQuotesVisible: multipleQuotesVisible ?? this.multipleQuotesVisible,
        internalNote: internalNote ?? this.internalNote,
        otpVerified: otpVerified ?? this.otpVerified,
        customerConfirmedVisit:
            customerConfirmedVisit ?? this.customerConfirmedVisit,
        customerConfirmedPurchase:
            customerConfirmedPurchase ?? this.customerConfirmedPurchase,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'customerId': customerId,
        'categoryId': categoryId,
        'productId': productId,
        'brandId': brandId,
        'preferredVendorId': preferredVendorId,
        'city': city,
        'area': area,
        'pincode': pincode,
        'address': address,
        'requirement': requirement,
        'contactPreference': contactPreference.name,
        'preferredTime': preferredTime,
        'source': source.name,
        'createdByUserId': createdByUserId,
        'salespersonId': salespersonId,
        'backOfficeId': backOfficeId,
        'franchiseId': franchiseId,
        'status': status.name,
        'priority': priority.name,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'answers': answers,
        'verification': verification?.toJson(),
        'potentialValue': potentialValue,
        'finalValue': finalValue,
        'lossReason': lossReason,
        'rejectReason': rejectReason,
        'multipleQuotesVisible': multipleQuotesVisible,
        'internalNote': internalNote,
        'otpVerified': otpVerified,
        'customerConfirmedVisit': customerConfirmedVisit,
        'customerConfirmedPurchase': customerConfirmedPurchase,
      };

  factory Enquiry.fromJson(Map<String, dynamic> j) => Enquiry(
        id: j['id'] as String,
        customerId: j['customerId'] as String,
        categoryId: j['categoryId'] as String,
        productId: j['productId'] as String?,
        brandId: j['brandId'] as String?,
        preferredVendorId: j['preferredVendorId'] as String?,
        city: j['city'] as String,
        area: j['area'] as String? ?? '',
        pincode: j['pincode'] as String?,
        address: j['address'] as String?,
        requirement: j['requirement'] as String? ?? '',
        contactPreference: enumByName(ContactPreference.values,
            j['contactPreference'], ContactPreference.callAnytime),
        preferredTime: j['preferredTime'] as String?,
        source: enumByName(EnquirySource.values, j['source'], EnquirySource.sales),
        createdByUserId: j['createdByUserId'] as String,
        salespersonId: j['salespersonId'] as String?,
        backOfficeId: j['backOfficeId'] as String?,
        franchiseId: j['franchiseId'] as String?,
        status: enumByName(
            EnquiryStatus.values, j['status'], EnquiryStatus.newEnquiry),
        priority: enumByName(
            EnquiryPriority.values, j['priority'], EnquiryPriority.normal),
        createdAt: DateTime.parse(j['createdAt'] as String),
        updatedAt: DateTime.parse(j['updatedAt'] as String),
        answers: stringMap(j['answers']),
        verification: j['verification'] == null
            ? null
            : VerificationInfo.fromJson(
                Map<String, dynamic>.from(j['verification'] as Map)),
        potentialValue: numToDoubleOrNull(j['potentialValue']),
        finalValue: numToDoubleOrNull(j['finalValue']),
        lossReason: j['lossReason'] as String?,
        rejectReason: j['rejectReason'] as String?,
        multipleQuotesVisible: j['multipleQuotesVisible'] as bool? ?? false,
        internalNote: j['internalNote'] as String? ?? '',
        otpVerified: j['otpVerified'] as bool? ?? false,
        customerConfirmedVisit: j['customerConfirmedVisit'] as bool? ?? false,
        customerConfirmedPurchase:
            j['customerConfirmedPurchase'] as bool? ?? false,
      );
}

/// One vendor chosen for one enquiry. An enquiry may have several.
class VendorAssignment {
  const VendorAssignment({
    required this.id,
    required this.enquiryId,
    required this.vendorId,
    required this.assignedAt,
    required this.deadline,
    this.status = AssignmentStatus.pending,
    this.respondedAt,
    this.expectedPrice,
    this.expectedDays,
    this.rejectReason,
    this.note = '',
    this.matchScore = 0,
    required this.assignedByUserId,
  });

  final String id;
  final String enquiryId;
  final String vendorId;
  final DateTime assignedAt;
  final DateTime deadline;
  final AssignmentStatus status;
  final DateTime? respondedAt;
  final double? expectedPrice;
  final int? expectedDays;
  final String? rejectReason;
  final String note;

  /// Internal decision support — only back office and admin see it.
  final int matchScore;
  final String assignedByUserId;

  VendorAssignment copyWith({
    AssignmentStatus? status,
    DateTime? respondedAt,
    DateTime? deadline,
    double? expectedPrice,
    int? expectedDays,
    String? rejectReason,
    String? note,
  }) =>
      VendorAssignment(
        id: id,
        enquiryId: enquiryId,
        vendorId: vendorId,
        assignedAt: assignedAt,
        deadline: deadline ?? this.deadline,
        status: status ?? this.status,
        respondedAt: respondedAt ?? this.respondedAt,
        expectedPrice: expectedPrice ?? this.expectedPrice,
        expectedDays: expectedDays ?? this.expectedDays,
        rejectReason: rejectReason ?? this.rejectReason,
        note: note ?? this.note,
        matchScore: matchScore,
        assignedByUserId: assignedByUserId,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'enquiryId': enquiryId,
        'vendorId': vendorId,
        'assignedAt': assignedAt.toIso8601String(),
        'deadline': deadline.toIso8601String(),
        'status': status.name,
        'respondedAt': respondedAt?.toIso8601String(),
        'expectedPrice': expectedPrice,
        'expectedDays': expectedDays,
        'rejectReason': rejectReason,
        'note': note,
        'matchScore': matchScore,
        'assignedByUserId': assignedByUserId,
      };

  factory VendorAssignment.fromJson(Map<String, dynamic> j) => VendorAssignment(
        id: j['id'] as String,
        enquiryId: j['enquiryId'] as String,
        vendorId: j['vendorId'] as String,
        assignedAt: DateTime.parse(j['assignedAt'] as String),
        deadline: DateTime.parse(j['deadline'] as String),
        status: enumByName(
            AssignmentStatus.values, j['status'], AssignmentStatus.pending),
        respondedAt: parseDate(j['respondedAt']),
        expectedPrice: numToDoubleOrNull(j['expectedPrice']),
        expectedDays: j['expectedDays'] as int?,
        rejectReason: j['rejectReason'] as String?,
        note: j['note'] as String? ?? '',
        matchScore: numToInt(j['matchScore']),
        assignedByUserId: j['assignedByUserId'] as String,
      );
}

class CallRecord {
  const CallRecord({
    required this.id,
    this.enquiryId,
    required this.byUserId,
    required this.toName,
    required this.toRole,
    required this.at,
    required this.durationSec,
    this.direction = CallDirection.outgoing,
    this.outcome,
    this.notes = '',
    this.recorded = false,
  });

  final String id;
  final String? enquiryId;
  final String byUserId;
  final String toName;
  final UserRole toRole;
  final DateTime at;
  final int durationSec;
  final CallDirection direction;
  final CallOutcome? outcome;
  final String notes;
  final bool recorded;

  Map<String, dynamic> toJson() => {
        'id': id,
        'enquiryId': enquiryId,
        'byUserId': byUserId,
        'toName': toName,
        'toRole': toRole.name,
        'at': at.toIso8601String(),
        'durationSec': durationSec,
        'direction': direction.name,
        'outcome': outcome?.name,
        'notes': notes,
        'recorded': recorded,
      };

  factory CallRecord.fromJson(Map<String, dynamic> j) => CallRecord(
        id: j['id'] as String,
        enquiryId: j['enquiryId'] as String?,
        byUserId: j['byUserId'] as String,
        toName: j['toName'] as String,
        toRole: enumByName(UserRole.values, j['toRole'], UserRole.customer),
        at: DateTime.parse(j['at'] as String),
        durationSec: numToInt(j['durationSec']),
        direction: enumByName(
            CallDirection.values, j['direction'], CallDirection.outgoing),
        outcome: enumByNameOrNull(CallOutcome.values, j['outcome']),
        notes: j['notes'] as String? ?? '',
        recorded: j['recorded'] as bool? ?? false,
      );
}

/// A chat message inside an enquiry. [thread] is the vendor ID for
/// back office ↔ vendor chats, or `customer` for back office ↔ customer.
class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.enquiryId,
    required this.thread,
    this.senderUserId,
    this.senderRole,
    this.kind = ChatKind.text,
    required this.text,
    this.fileName,
    required this.at,
  });

  static const customerThread = 'customer';

  final String id;
  final String enquiryId;
  final String thread;

  /// Null for system messages.
  final String? senderUserId;
  final UserRole? senderRole;
  final ChatKind kind;
  final String text;
  final String? fileName;
  final DateTime at;

  Map<String, dynamic> toJson() => {
        'id': id,
        'enquiryId': enquiryId,
        'thread': thread,
        'senderUserId': senderUserId,
        'senderRole': senderRole?.name,
        'kind': kind.name,
        'text': text,
        'fileName': fileName,
        'at': at.toIso8601String(),
      };

  factory ChatMessage.fromJson(Map<String, dynamic> j) => ChatMessage(
        id: j['id'] as String,
        enquiryId: j['enquiryId'] as String,
        thread: j['thread'] as String,
        senderUserId: j['senderUserId'] as String?,
        senderRole: enumByNameOrNull(UserRole.values, j['senderRole']),
        kind: enumByName(ChatKind.values, j['kind'], ChatKind.text),
        text: j['text'] as String? ?? '',
        fileName: j['fileName'] as String?,
        at: DateTime.parse(j['at'] as String),
      );
}

class Appointment {
  const Appointment({
    required this.id,
    required this.enquiryId,
    required this.vendorId,
    required this.at,
    required this.location,
    this.purpose = '',
    this.notes = '',
    this.status = AppointmentStatus.proposed,
    required this.proposedByRole,
    required this.createdAt,
    this.customerConfirmed = false,
  });

  final String id;
  final String enquiryId;
  final String vendorId;
  final DateTime at;
  final String location;
  final String purpose;
  final String notes;
  final AppointmentStatus status;
  final UserRole proposedByRole;
  final DateTime createdAt;
  final bool customerConfirmed;

  Appointment copyWith({
    DateTime? at,
    String? location,
    String? purpose,
    String? notes,
    AppointmentStatus? status,
    bool? customerConfirmed,
  }) =>
      Appointment(
        id: id,
        enquiryId: enquiryId,
        vendorId: vendorId,
        at: at ?? this.at,
        location: location ?? this.location,
        purpose: purpose ?? this.purpose,
        notes: notes ?? this.notes,
        status: status ?? this.status,
        proposedByRole: proposedByRole,
        createdAt: createdAt,
        customerConfirmed: customerConfirmed ?? this.customerConfirmed,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'enquiryId': enquiryId,
        'vendorId': vendorId,
        'at': at.toIso8601String(),
        'location': location,
        'purpose': purpose,
        'notes': notes,
        'status': status.name,
        'proposedByRole': proposedByRole.name,
        'createdAt': createdAt.toIso8601String(),
        'customerConfirmed': customerConfirmed,
      };

  factory Appointment.fromJson(Map<String, dynamic> j) => Appointment(
        id: j['id'] as String,
        enquiryId: j['enquiryId'] as String,
        vendorId: j['vendorId'] as String,
        at: DateTime.parse(j['at'] as String),
        location: j['location'] as String? ?? '',
        purpose: j['purpose'] as String? ?? '',
        notes: j['notes'] as String? ?? '',
        status: enumByName(
            AppointmentStatus.values, j['status'], AppointmentStatus.proposed),
        proposedByRole:
            enumByName(UserRole.values, j['proposedByRole'], UserRole.vendor),
        createdAt: DateTime.parse(j['createdAt'] as String),
        customerConfirmed: j['customerConfirmed'] as bool? ?? false,
      );
}

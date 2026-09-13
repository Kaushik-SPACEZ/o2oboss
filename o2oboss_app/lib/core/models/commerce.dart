import 'enums.dart';
import 'json.dart';

class QuotationItem {
  const QuotationItem({
    required this.description,
    this.qty = 1,
    required this.unitPrice,
  });

  final String description;
  final double qty;
  final double unitPrice;

  double get total => qty * unitPrice;

  Map<String, dynamic> toJson() =>
      {'description': description, 'qty': qty, 'unitPrice': unitPrice};

  factory QuotationItem.fromJson(Map<String, dynamic> j) => QuotationItem(
        description: j['description'] as String,
        qty: numToDouble(j['qty'], 1),
        unitPrice: numToDouble(j['unitPrice']),
      );
}

/// One version of a vendor's quotation. Revisions are new records that share
/// the same [number] with a higher [version]; history is never overwritten.
class Quotation {
  const Quotation({
    required this.id,
    required this.number,
    this.version = 1,
    required this.enquiryId,
    required this.vendorId,
    this.items = const [],
    this.discount = 0,
    this.taxPercent = 18,
    this.installation = 0,
    this.delivery = 0,
    this.validityDays = 15,
    this.terms = '',
    this.timelineDays = 7,
    this.notes = '',
    this.attachments = const [],
    this.status = QuotationStatus.draft,
    required this.createdAt,
    this.submittedAt,
    this.sentAt,
    this.viewedAt,
    this.respondedAt,
    this.responseNote,
    this.revisionNote,
    this.signedName,
    this.approvedByUserId,
    this.adminCopySent = false,
  });

  final String id;
  final String number;
  final int version;
  final String enquiryId;
  final String vendorId;
  final List<QuotationItem> items;
  final double discount;
  final double taxPercent;
  final double installation;
  final double delivery;
  final int validityDays;
  final String terms;
  final int timelineDays;
  final String notes;
  final List<String> attachments;
  final QuotationStatus status;
  final DateTime createdAt;
  final DateTime? submittedAt;
  final DateTime? sentAt;
  final DateTime? viewedAt;
  final DateTime? respondedAt;

  /// Customer's reason when rejecting.
  final String? responseNote;

  /// What was asked for when a revision was requested.
  final String? revisionNote;

  /// Name typed by the customer as their e-signature when accepting.
  final String? signedName;
  final String? approvedByUserId;
  final bool adminCopySent;

  double get subtotal => items.fold(0, (sum, i) => sum + i.total);
  double get taxable => subtotal - discount + installation + delivery;
  double get taxAmount => taxable * taxPercent / 100;
  double get total => taxable + taxAmount;

  DateTime get validUntil =>
      (sentAt ?? submittedAt ?? createdAt).add(Duration(days: validityDays));

  Quotation copyWith({
    List<QuotationItem>? items,
    double? discount,
    double? taxPercent,
    double? installation,
    double? delivery,
    int? validityDays,
    String? terms,
    int? timelineDays,
    String? notes,
    List<String>? attachments,
    QuotationStatus? status,
    DateTime? submittedAt,
    DateTime? sentAt,
    DateTime? viewedAt,
    DateTime? respondedAt,
    String? responseNote,
    String? revisionNote,
    String? signedName,
    String? approvedByUserId,
    bool? adminCopySent,
  }) =>
      Quotation(
        id: id,
        number: number,
        version: version,
        enquiryId: enquiryId,
        vendorId: vendorId,
        items: items ?? this.items,
        discount: discount ?? this.discount,
        taxPercent: taxPercent ?? this.taxPercent,
        installation: installation ?? this.installation,
        delivery: delivery ?? this.delivery,
        validityDays: validityDays ?? this.validityDays,
        terms: terms ?? this.terms,
        timelineDays: timelineDays ?? this.timelineDays,
        notes: notes ?? this.notes,
        attachments: attachments ?? this.attachments,
        status: status ?? this.status,
        createdAt: createdAt,
        submittedAt: submittedAt ?? this.submittedAt,
        sentAt: sentAt ?? this.sentAt,
        viewedAt: viewedAt ?? this.viewedAt,
        respondedAt: respondedAt ?? this.respondedAt,
        responseNote: responseNote ?? this.responseNote,
        revisionNote: revisionNote ?? this.revisionNote,
        signedName: signedName ?? this.signedName,
        approvedByUserId: approvedByUserId ?? this.approvedByUserId,
        adminCopySent: adminCopySent ?? this.adminCopySent,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'number': number,
        'version': version,
        'enquiryId': enquiryId,
        'vendorId': vendorId,
        'items': items.map((i) => i.toJson()).toList(),
        'discount': discount,
        'taxPercent': taxPercent,
        'installation': installation,
        'delivery': delivery,
        'validityDays': validityDays,
        'terms': terms,
        'timelineDays': timelineDays,
        'notes': notes,
        'attachments': attachments,
        'status': status.name,
        'createdAt': createdAt.toIso8601String(),
        'submittedAt': submittedAt?.toIso8601String(),
        'sentAt': sentAt?.toIso8601String(),
        'viewedAt': viewedAt?.toIso8601String(),
        'respondedAt': respondedAt?.toIso8601String(),
        'responseNote': responseNote,
        'revisionNote': revisionNote,
        'signedName': signedName,
        'approvedByUserId': approvedByUserId,
        'adminCopySent': adminCopySent,
      };

  factory Quotation.fromJson(Map<String, dynamic> j) => Quotation(
        id: j['id'] as String,
        number: j['number'] as String,
        version: numToInt(j['version'], 1),
        enquiryId: j['enquiryId'] as String,
        vendorId: j['vendorId'] as String,
        items: listOf(j['items'], QuotationItem.fromJson),
        discount: numToDouble(j['discount']),
        taxPercent: numToDouble(j['taxPercent'], 18),
        installation: numToDouble(j['installation']),
        delivery: numToDouble(j['delivery']),
        validityDays: numToInt(j['validityDays'], 15),
        terms: j['terms'] as String? ?? '',
        timelineDays: numToInt(j['timelineDays'], 7),
        notes: j['notes'] as String? ?? '',
        attachments: stringList(j['attachments']),
        status: enumByName(
            QuotationStatus.values, j['status'], QuotationStatus.draft),
        createdAt: DateTime.parse(j['createdAt'] as String),
        submittedAt: parseDate(j['submittedAt']),
        sentAt: parseDate(j['sentAt']),
        viewedAt: parseDate(j['viewedAt']),
        respondedAt: parseDate(j['respondedAt']),
        responseNote: j['responseNote'] as String?,
        revisionNote: j['revisionNote'] as String?,
        signedName: j['signedName'] as String?,
        approvedByUserId: j['approvedByUserId'] as String?,
        adminCopySent: j['adminCopySent'] as bool? ?? false,
      );
}

class Milestone {
  const Milestone({required this.key, this.done = false, this.doneAt});

  final MilestoneKey key;
  final bool done;
  final DateTime? doneAt;

  Map<String, dynamic> toJson() =>
      {'key': key.name, 'done': done, 'doneAt': doneAt?.toIso8601String()};

  factory Milestone.fromJson(Map<String, dynamic> j) => Milestone(
        key: enumByName(MilestoneKey.values, j['key'], MilestoneKey.orderConfirmed),
        done: j['done'] as bool? ?? false,
        doneAt: parseDate(j['doneAt']),
      );
}

/// Created when an enquiry is won. Back office follows it until paid.
class Project {
  const Project({
    required this.id,
    required this.enquiryId,
    required this.vendorId,
    this.quotationId,
    required this.finalValue,
    required this.startDate,
    required this.expectedCompletion,
    this.actualCompletion,
    this.status = ProjectStatus.notStarted,
    this.milestones = const [],
    required this.createdAt,
    this.paymentDueDate,
    this.documents = const [],
    this.holdReason,
  });

  final String id;
  final String enquiryId;
  final String vendorId;
  final String? quotationId;
  final double finalValue;
  final DateTime startDate;
  final DateTime expectedCompletion;
  final DateTime? actualCompletion;
  final ProjectStatus status;
  final List<Milestone> milestones;
  final DateTime createdAt;
  final DateTime? paymentDueDate;
  final List<String> documents;
  final String? holdReason;

  int get doneCount => milestones.where((m) => m.done).length;

  double get progress =>
      milestones.isEmpty ? 0 : doneCount / milestones.length;

  Project copyWith({
    double? finalValue,
    DateTime? startDate,
    DateTime? expectedCompletion,
    DateTime? actualCompletion,
    ProjectStatus? status,
    List<Milestone>? milestones,
    DateTime? paymentDueDate,
    List<String>? documents,
    String? holdReason,
  }) =>
      Project(
        id: id,
        enquiryId: enquiryId,
        vendorId: vendorId,
        quotationId: quotationId,
        finalValue: finalValue ?? this.finalValue,
        startDate: startDate ?? this.startDate,
        expectedCompletion: expectedCompletion ?? this.expectedCompletion,
        actualCompletion: actualCompletion ?? this.actualCompletion,
        status: status ?? this.status,
        milestones: milestones ?? this.milestones,
        createdAt: createdAt,
        paymentDueDate: paymentDueDate ?? this.paymentDueDate,
        documents: documents ?? this.documents,
        holdReason: holdReason ?? this.holdReason,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'enquiryId': enquiryId,
        'vendorId': vendorId,
        'quotationId': quotationId,
        'finalValue': finalValue,
        'startDate': startDate.toIso8601String(),
        'expectedCompletion': expectedCompletion.toIso8601String(),
        'actualCompletion': actualCompletion?.toIso8601String(),
        'status': status.name,
        'milestones': milestones.map((m) => m.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
        'paymentDueDate': paymentDueDate?.toIso8601String(),
        'documents': documents,
        'holdReason': holdReason,
      };

  factory Project.fromJson(Map<String, dynamic> j) => Project(
        id: j['id'] as String,
        enquiryId: j['enquiryId'] as String,
        vendorId: j['vendorId'] as String,
        quotationId: j['quotationId'] as String?,
        finalValue: numToDouble(j['finalValue']),
        startDate: DateTime.parse(j['startDate'] as String),
        expectedCompletion: DateTime.parse(j['expectedCompletion'] as String),
        actualCompletion: parseDate(j['actualCompletion']),
        status: enumByName(
            ProjectStatus.values, j['status'], ProjectStatus.notStarted),
        milestones: listOf(j['milestones'], Milestone.fromJson),
        createdAt: DateTime.parse(j['createdAt'] as String),
        paymentDueDate: parseDate(j['paymentDueDate']),
        documents: stringList(j['documents']),
        holdReason: j['holdReason'] as String?,
      );
}

class PaymentRecord {
  const PaymentRecord({
    required this.id,
    required this.projectId,
    required this.amount,
    required this.at,
    this.method = PaymentMethod.upi,
    this.reference = '',
    this.notes = '',
    required this.recordedByUserId,
    this.proofName,
  });

  final String id;
  final String projectId;
  final double amount;
  final DateTime at;
  final PaymentMethod method;
  final String reference;
  final String notes;
  final String recordedByUserId;
  final String? proofName;

  Map<String, dynamic> toJson() => {
        'id': id,
        'projectId': projectId,
        'amount': amount,
        'at': at.toIso8601String(),
        'method': method.name,
        'reference': reference,
        'notes': notes,
        'recordedByUserId': recordedByUserId,
        'proofName': proofName,
      };

  factory PaymentRecord.fromJson(Map<String, dynamic> j) => PaymentRecord(
        id: j['id'] as String,
        projectId: j['projectId'] as String,
        amount: numToDouble(j['amount']),
        at: DateTime.parse(j['at'] as String),
        method: enumByName(PaymentMethod.values, j['method'], PaymentMethod.upi),
        reference: j['reference'] as String? ?? '',
        notes: j['notes'] as String? ?? '',
        recordedByUserId: j['recordedByUserId'] as String,
        proofName: j['proofName'] as String?,
      );
}

class Commission {
  const Commission({
    required this.id,
    required this.enquiryId,
    this.projectId,
    required this.beneficiaryUserId,
    required this.role,
    required this.businessValue,
    required this.percent,
    required this.amount,
    required this.trigger,
    this.status = CommissionStatus.pending,
    required this.createdAt,
    this.approvedAt,
    this.paidAt,
    this.reference,
    this.note,
  });

  final String id;
  final String enquiryId;
  final String? projectId;
  final String beneficiaryUserId;
  final UserRole role;
  final double businessValue;
  final double percent;
  final double amount;
  final CommissionTrigger trigger;
  final CommissionStatus status;
  final DateTime createdAt;
  final DateTime? approvedAt;
  final DateTime? paidAt;
  final String? reference;
  final String? note;

  Commission copyWith({
    CommissionStatus? status,
    DateTime? approvedAt,
    DateTime? paidAt,
    String? reference,
    String? note,
  }) =>
      Commission(
        id: id,
        enquiryId: enquiryId,
        projectId: projectId,
        beneficiaryUserId: beneficiaryUserId,
        role: role,
        businessValue: businessValue,
        percent: percent,
        amount: amount,
        trigger: trigger,
        status: status ?? this.status,
        createdAt: createdAt,
        approvedAt: approvedAt ?? this.approvedAt,
        paidAt: paidAt ?? this.paidAt,
        reference: reference ?? this.reference,
        note: note ?? this.note,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'enquiryId': enquiryId,
        'projectId': projectId,
        'beneficiaryUserId': beneficiaryUserId,
        'role': role.name,
        'businessValue': businessValue,
        'percent': percent,
        'amount': amount,
        'trigger': trigger.name,
        'status': status.name,
        'createdAt': createdAt.toIso8601String(),
        'approvedAt': approvedAt?.toIso8601String(),
        'paidAt': paidAt?.toIso8601String(),
        'reference': reference,
        'note': note,
      };

  factory Commission.fromJson(Map<String, dynamic> j) => Commission(
        id: j['id'] as String,
        enquiryId: j['enquiryId'] as String,
        projectId: j['projectId'] as String?,
        beneficiaryUserId: j['beneficiaryUserId'] as String,
        role: enumByName(UserRole.values, j['role'], UserRole.sales),
        businessValue: numToDouble(j['businessValue']),
        percent: numToDouble(j['percent']),
        amount: numToDouble(j['amount']),
        trigger: enumByName(CommissionTrigger.values, j['trigger'],
            CommissionTrigger.fullPaymentCollected),
        status: enumByName(
            CommissionStatus.values, j['status'], CommissionStatus.pending),
        createdAt: DateTime.parse(j['createdAt'] as String),
        approvedAt: parseDate(j['approvedAt']),
        paidAt: parseDate(j['paidAt']),
        reference: j['reference'] as String?,
        note: j['note'] as String?,
      );
}

class CustomerFeedback {
  const CustomerFeedback({
    required this.id,
    required this.enquiryId,
    this.projectId,
    required this.customerId,
    required this.rating,
    this.review = '',
    required this.at,
  });

  final String id;
  final String enquiryId;
  final String? projectId;
  final String customerId;
  final int rating;
  final String review;
  final DateTime at;

  Map<String, dynamic> toJson() => {
        'id': id,
        'enquiryId': enquiryId,
        'projectId': projectId,
        'customerId': customerId,
        'rating': rating,
        'review': review,
        'at': at.toIso8601String(),
      };

  factory CustomerFeedback.fromJson(Map<String, dynamic> j) => CustomerFeedback(
        id: j['id'] as String,
        enquiryId: j['enquiryId'] as String,
        projectId: j['projectId'] as String?,
        customerId: j['customerId'] as String,
        rating: numToInt(j['rating']),
        review: j['review'] as String? ?? '',
        at: DateTime.parse(j['at'] as String),
      );
}

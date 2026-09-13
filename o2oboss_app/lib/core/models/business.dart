import 'enums.dart';
import 'json.dart';

class VendorDocument {
  const VendorDocument({
    required this.name,
    required this.kind,
    required this.uploadedAt,
    this.verified = false,
  });

  final String name;
  final DocKind kind;
  final DateTime uploadedAt;
  final bool verified;

  VendorDocument copyWith({bool? verified}) => VendorDocument(
        name: name,
        kind: kind,
        uploadedAt: uploadedAt,
        verified: verified ?? this.verified,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'kind': kind.name,
        'uploadedAt': uploadedAt.toIso8601String(),
        'verified': verified,
      };

  factory VendorDocument.fromJson(Map<String, dynamic> j) => VendorDocument(
        name: j['name'] as String,
        kind: enumByName(DocKind.values, j['kind'], DocKind.other),
        uploadedAt: DateTime.parse(j['uploadedAt'] as String),
        verified: j['verified'] as bool? ?? false,
      );
}

/// A registered business that receives qualified referrals.
class Vendor {
  const Vendor({
    required this.id,
    required this.companyName,
    required this.contactPerson,
    required this.phone,
    this.email,
    required this.address,
    required this.city,
    required this.area,
    this.categoryIds = const [],
    this.productIds = const [],
    this.brandIds = const [],
    this.serviceCities = const [],
    this.serviceAreas = const [],
    this.status = AccountStatus.pending,
    this.rating = 0,
    this.responseRate = 0,
    this.franchiseId,
    this.commercialNote = '',
    this.commissionPercent,
    this.documents = const [],
    required this.joinedAt,
    this.gstin,
    this.about = '',
    this.available = true,
  });

  final String id;
  final String companyName;
  final String contactPerson;
  final String phone;
  final String? email;
  final String address;
  final String city;
  final String area;
  final List<String> categoryIds;
  final List<String> productIds;
  final List<String> brandIds;
  final List<String> serviceCities;
  final List<String> serviceAreas;
  final AccountStatus status;
  final double rating;

  /// Percent of referrals answered before the deadline.
  final int responseRate;
  final String? franchiseId;

  /// Admin-configured commercial terms, e.g. "Referral fee 2% of order value".
  final String commercialNote;
  final double? commissionPercent;
  final List<VendorDocument> documents;
  final DateTime joinedAt;
  final String? gstin;
  final String about;
  final bool available;

  bool get isActive => status == AccountStatus.active;

  Vendor copyWith({
    String? companyName,
    String? contactPerson,
    String? phone,
    String? email,
    String? address,
    String? city,
    String? area,
    List<String>? categoryIds,
    List<String>? productIds,
    List<String>? brandIds,
    List<String>? serviceCities,
    List<String>? serviceAreas,
    AccountStatus? status,
    double? rating,
    int? responseRate,
    String? franchiseId,
    String? commercialNote,
    double? commissionPercent,
    List<VendorDocument>? documents,
    String? gstin,
    String? about,
    bool? available,
  }) =>
      Vendor(
        id: id,
        companyName: companyName ?? this.companyName,
        contactPerson: contactPerson ?? this.contactPerson,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        address: address ?? this.address,
        city: city ?? this.city,
        area: area ?? this.area,
        categoryIds: categoryIds ?? this.categoryIds,
        productIds: productIds ?? this.productIds,
        brandIds: brandIds ?? this.brandIds,
        serviceCities: serviceCities ?? this.serviceCities,
        serviceAreas: serviceAreas ?? this.serviceAreas,
        status: status ?? this.status,
        rating: rating ?? this.rating,
        responseRate: responseRate ?? this.responseRate,
        franchiseId: franchiseId ?? this.franchiseId,
        commercialNote: commercialNote ?? this.commercialNote,
        commissionPercent: commissionPercent ?? this.commissionPercent,
        documents: documents ?? this.documents,
        joinedAt: joinedAt,
        gstin: gstin ?? this.gstin,
        about: about ?? this.about,
        available: available ?? this.available,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'companyName': companyName,
        'contactPerson': contactPerson,
        'phone': phone,
        'email': email,
        'address': address,
        'city': city,
        'area': area,
        'categoryIds': categoryIds,
        'productIds': productIds,
        'brandIds': brandIds,
        'serviceCities': serviceCities,
        'serviceAreas': serviceAreas,
        'status': status.name,
        'rating': rating,
        'responseRate': responseRate,
        'franchiseId': franchiseId,
        'commercialNote': commercialNote,
        'commissionPercent': commissionPercent,
        'documents': documents.map((d) => d.toJson()).toList(),
        'joinedAt': joinedAt.toIso8601String(),
        'gstin': gstin,
        'about': about,
        'available': available,
      };

  factory Vendor.fromJson(Map<String, dynamic> j) => Vendor(
        id: j['id'] as String,
        companyName: j['companyName'] as String,
        contactPerson: j['contactPerson'] as String,
        phone: j['phone'] as String,
        email: j['email'] as String?,
        address: j['address'] as String? ?? '',
        city: j['city'] as String,
        area: j['area'] as String? ?? '',
        categoryIds: stringList(j['categoryIds']),
        productIds: stringList(j['productIds']),
        brandIds: stringList(j['brandIds']),
        serviceCities: stringList(j['serviceCities']),
        serviceAreas: stringList(j['serviceAreas']),
        status: enumByName(AccountStatus.values, j['status'], AccountStatus.pending),
        rating: numToDouble(j['rating']),
        responseRate: numToInt(j['responseRate']),
        franchiseId: j['franchiseId'] as String?,
        commercialNote: j['commercialNote'] as String? ?? '',
        commissionPercent: numToDoubleOrNull(j['commissionPercent']),
        documents: listOf(j['documents'], VendorDocument.fromJson),
        joinedAt: DateTime.parse(j['joinedAt'] as String),
        gstin: j['gstin'] as String?,
        about: j['about'] as String? ?? '',
        available: j['available'] as bool? ?? true,
      );
}

/// The person or business who needs a product or service.
class Customer {
  const Customer({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.address = '',
    required this.city,
    required this.area,
    this.pincode,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String phone;
  final String? email;
  final String address;
  final String city;
  final String area;
  final String? pincode;
  final DateTime createdAt;

  Customer copyWith({
    String? name,
    String? phone,
    String? email,
    String? address,
    String? city,
    String? area,
    String? pincode,
  }) =>
      Customer(
        id: id,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        address: address ?? this.address,
        city: city ?? this.city,
        area: area ?? this.area,
        pincode: pincode ?? this.pincode,
        createdAt: createdAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'email': email,
        'address': address,
        'city': city,
        'area': area,
        'pincode': pincode,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Customer.fromJson(Map<String, dynamic> j) => Customer(
        id: j['id'] as String,
        name: j['name'] as String,
        phone: j['phone'] as String,
        email: j['email'] as String?,
        address: j['address'] as String? ?? '',
        city: j['city'] as String,
        area: j['area'] as String? ?? '',
        pincode: j['pincode'] as String?,
        createdAt: DateTime.parse(j['createdAt'] as String),
      );
}

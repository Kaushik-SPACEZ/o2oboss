import 'enums.dart';
import 'json.dart';

/// Category for requests about things O2O Boss does not list yet.
const kSourcingCategoryId = 'cat_other';

/// A question back office asks while qualifying an enquiry in this category.
class QualificationQuestion {
  const QualificationQuestion({
    required this.id,
    required this.label,
    this.type = QuestionType.text,
    this.options = const [],
    this.required = false,
  });

  final String id;
  final String label;
  final QuestionType type;
  final List<String> options;
  final bool required;

  QualificationQuestion copyWith({
    String? label,
    QuestionType? type,
    List<String>? options,
    bool? required,
  }) =>
      QualificationQuestion(
        id: id,
        label: label ?? this.label,
        type: type ?? this.type,
        options: options ?? this.options,
        required: required ?? this.required,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'type': type.name,
        'options': options,
        'required': required,
      };

  factory QualificationQuestion.fromJson(Map<String, dynamic> j) =>
      QualificationQuestion(
        id: j['id'] as String,
        label: j['label'] as String,
        type: enumByName(QuestionType.values, j['type'], QuestionType.text),
        options: stringList(j['options']),
        required: j['required'] as bool? ?? false,
      );
}

class ServiceCategory {
  const ServiceCategory({
    required this.id,
    required this.name,
    required this.icon,
    this.description = '',
    this.active = true,
    this.questions = const [],
  });

  final String id;
  final String name;

  /// Key into the app's icon map, e.g. `cctv`, `ac`, `solar`.
  final String icon;
  final String description;
  final bool active;
  final List<QualificationQuestion> questions;

  ServiceCategory copyWith({
    String? name,
    String? icon,
    String? description,
    bool? active,
    List<QualificationQuestion>? questions,
  }) =>
      ServiceCategory(
        id: id,
        name: name ?? this.name,
        icon: icon ?? this.icon,
        description: description ?? this.description,
        active: active ?? this.active,
        questions: questions ?? this.questions,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'icon': icon,
        'description': description,
        'active': active,
        'questions': questions.map((q) => q.toJson()).toList(),
      };

  factory ServiceCategory.fromJson(Map<String, dynamic> j) => ServiceCategory(
        id: j['id'] as String,
        name: j['name'] as String,
        icon: j['icon'] as String? ?? 'other',
        description: j['description'] as String? ?? '',
        active: j['active'] as bool? ?? true,
        questions: listOf(j['questions'], QualificationQuestion.fromJson),
      );
}

class Product {
  const Product({
    required this.id,
    required this.categoryId,
    required this.name,
    this.description = '',
    this.active = true,
    this.priceFrom,
    this.priceTo,
    this.unit = PriceUnit.job,
    this.highlights = const [],
    this.popularity = 0,
    this.photos = const [],
  });

  final String id;
  final String categoryId;
  final String name;
  final String description;
  final bool active;

  /// Indicative price range shown to customers. The real price always comes
  /// in a vendor's quotation. Null means "price on quotation".
  final double? priceFrom;
  final double? priceTo;
  final PriceUnit unit;

  /// Short "what you get" lines on the product page.
  final List<String> highlights;

  /// Higher shows first when sorting by popular.
  final int popularity;

  /// Photo links added by admin. Until there are photos, the app shows
  /// drawn picture tiles for the category instead.
  final List<String> photos;

  Product copyWith({
    String? name,
    String? description,
    bool? active,
    double? priceFrom,
    double? priceTo,
    PriceUnit? unit,
    List<String>? highlights,
    int? popularity,
    List<String>? photos,
  }) =>
      Product(
        id: id,
        categoryId: categoryId,
        name: name ?? this.name,
        description: description ?? this.description,
        active: active ?? this.active,
        priceFrom: priceFrom ?? this.priceFrom,
        priceTo: priceTo ?? this.priceTo,
        unit: unit ?? this.unit,
        highlights: highlights ?? this.highlights,
        popularity: popularity ?? this.popularity,
        photos: photos ?? this.photos,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'categoryId': categoryId,
        'name': name,
        'description': description,
        'active': active,
        'priceFrom': priceFrom,
        'priceTo': priceTo,
        'unit': unit.name,
        'highlights': highlights,
        'popularity': popularity,
        'photos': photos,
      };

  factory Product.fromJson(Map<String, dynamic> j) => Product(
        id: j['id'] as String,
        categoryId: j['categoryId'] as String,
        name: j['name'] as String,
        description: j['description'] as String? ?? '',
        active: j['active'] as bool? ?? true,
        priceFrom: numToDoubleOrNull(j['priceFrom']),
        priceTo: numToDoubleOrNull(j['priceTo']),
        unit: enumByName(PriceUnit.values, j['unit'], PriceUnit.job),
        highlights: stringList(j['highlights']),
        popularity: numToInt(j['popularity']),
        photos: stringList(j['photos']),
      );
}

class Brand {
  const Brand({
    required this.id,
    required this.name,
    this.categoryIds = const [],
    this.active = true,
  });

  final String id;
  final String name;
  final List<String> categoryIds;
  final bool active;

  Brand copyWith({String? name, List<String>? categoryIds, bool? active}) =>
      Brand(
        id: id,
        name: name ?? this.name,
        categoryIds: categoryIds ?? this.categoryIds,
        active: active ?? this.active,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'categoryIds': categoryIds,
        'active': active,
      };

  factory Brand.fromJson(Map<String, dynamic> j) => Brand(
        id: j['id'] as String,
        name: j['name'] as String,
        categoryIds: stringList(j['categoryIds']),
        active: j['active'] as bool? ?? true,
      );
}

class Area {
  const Area({required this.name, required this.pincode});

  final String name;
  final String pincode;

  Map<String, dynamic> toJson() => {'name': name, 'pincode': pincode};

  factory Area.fromJson(Map<String, dynamic> j) =>
      Area(name: j['name'] as String, pincode: j['pincode'] as String);
}

/// Location hierarchy: country → state → city/district → area → pincode.
class City {
  const City({
    required this.id,
    required this.name,
    required this.state,
    this.country = 'India',
    this.areas = const [],
  });

  final String id;
  final String name;
  final String state;
  final String country;
  final List<Area> areas;

  City copyWith({String? name, String? state, List<Area>? areas}) => City(
        id: id,
        name: name ?? this.name,
        state: state ?? this.state,
        country: country,
        areas: areas ?? this.areas,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'state': state,
        'country': country,
        'areas': areas.map((a) => a.toJson()).toList(),
      };

  factory City.fromJson(Map<String, dynamic> j) => City(
        id: j['id'] as String,
        name: j['name'] as String,
        state: j['state'] as String,
        country: j['country'] as String? ?? 'India',
        areas: listOf(j['areas'], Area.fromJson),
      );
}

/// A territory run by a franchise head, e.g. Vellore or Chennai.
class Franchise {
  const Franchise({
    required this.id,
    required this.name,
    this.cities = const [],
    this.headUserId,
    this.active = true,
    this.sharePercent,
    required this.createdAt,
  });

  final String id;
  final String name;

  /// City names covered by this territory.
  final List<String> cities;
  final String? headUserId;
  final bool active;

  /// Overrides the global franchise share when set.
  final double? sharePercent;
  final DateTime createdAt;

  Franchise copyWith({
    String? name,
    List<String>? cities,
    String? headUserId,
    bool? active,
    double? sharePercent,
  }) =>
      Franchise(
        id: id,
        name: name ?? this.name,
        cities: cities ?? this.cities,
        headUserId: headUserId ?? this.headUserId,
        active: active ?? this.active,
        sharePercent: sharePercent ?? this.sharePercent,
        createdAt: createdAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'cities': cities,
        'headUserId': headUserId,
        'active': active,
        'sharePercent': sharePercent,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Franchise.fromJson(Map<String, dynamic> j) => Franchise(
        id: j['id'] as String,
        name: j['name'] as String,
        cities: stringList(j['cities']),
        headUserId: j['headUserId'] as String?,
        active: j['active'] as bool? ?? true,
        sharePercent: numToDoubleOrNull(j['sharePercent']),
        createdAt: DateTime.parse(j['createdAt'] as String),
      );
}

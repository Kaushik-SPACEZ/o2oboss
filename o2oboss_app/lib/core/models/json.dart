/// Small helpers for hand-written JSON conversion of the demo models.
library;

DateTime? parseDate(Object? value) =>
    value == null ? null : DateTime.parse(value as String);

DateTime parseDateOr(Object? value, DateTime fallback) =>
    value == null ? fallback : DateTime.parse(value as String);

T enumByName<T extends Enum>(List<T> values, Object? name, T fallback) {
  for (final v in values) {
    if (v.name == name) return v;
  }
  return fallback;
}

T? enumByNameOrNull<T extends Enum>(List<T> values, Object? name) {
  if (name == null) return null;
  for (final v in values) {
    if (v.name == name) return v;
  }
  return null;
}

List<String> stringList(Object? value) =>
    value == null ? <String>[] : List<String>.from(value as List);

Map<String, String> stringMap(Object? value) =>
    value == null ? <String, String>{} : Map<String, String>.from(value as Map);

double numToDouble(Object? value, [double fallback = 0]) =>
    value == null ? fallback : (value as num).toDouble();

double? numToDoubleOrNull(Object? value) =>
    value == null ? null : (value as num).toDouble();

int numToInt(Object? value, [int fallback = 0]) =>
    value == null ? fallback : (value as num).toInt();

List<T> listOf<T>(Object? value, T Function(Map<String, dynamic>) fromJson) {
  if (value == null) return <T>[];
  return (value as List)
      .map((e) => fromJson(Map<String, dynamic>.from(e as Map)))
      .toList();
}

List<Map<String, dynamic>> listToJson<T>(
  List<T> items,
  Map<String, dynamic> Function(T) toJson,
) =>
    items.map(toJson).toList();

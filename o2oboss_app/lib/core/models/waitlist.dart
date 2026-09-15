import 'enums.dart';
import 'json.dart';

/// Someone from a place O2O Boss does not serve yet. They are told we will
/// start there soon; admin sees these grouped by city to plan where to go
/// next.
class WaitlistEntry {
  const WaitlistEntry({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
    this.occupation,
    this.age,
    required this.city,
    this.area = '',
    required this.createdAt,
  });

  final String id;
  final String name;
  final String phone;
  final UserRole role;
  final Occupation? occupation;
  final int? age;
  final String city;
  final String area;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'role': role.name,
        'occupation': occupation?.name,
        'age': age,
        'city': city,
        'area': area,
        'createdAt': createdAt.toIso8601String(),
      };

  factory WaitlistEntry.fromJson(Map<String, dynamic> j) => WaitlistEntry(
        id: j['id'] as String,
        name: j['name'] as String? ?? '',
        phone: j['phone'] as String? ?? '',
        role: enumByName(UserRole.values, j['role'], UserRole.customer),
        occupation: enumByNameOrNull(Occupation.values, j['occupation']),
        age: j['age'] == null ? null : numToInt(j['age']),
        city: j['city'] as String? ?? '',
        area: j['area'] as String? ?? '',
        createdAt: DateTime.parse(j['createdAt'] as String),
      );
}

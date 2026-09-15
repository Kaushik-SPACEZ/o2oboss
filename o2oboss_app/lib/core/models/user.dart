import 'enums.dart';
import 'json.dart';

/// A person who can sign in. Passwords are demo values only — never real security.
class AppUser {
  const AppUser({
    required this.id,
    required this.loginId,
    required this.password,
    required this.name,
    required this.phone,
    this.email,
    required this.role,
    this.salesType,
    this.occupation,
    this.age,
    required this.city,
    this.area,
    this.franchiseId,
    this.status = AccountStatus.active,
    required this.createdAt,
    this.vendorId,
    this.customerId,
    this.upiId,
    this.bankAccount,
    this.ifsc,
    this.mustChangePassword = false,
    this.pushOn = true,
    this.emailOn = true,
    this.smsOn = true,
    this.whatsappOn = true,
  });

  final String id;
  final String loginId;
  final String password;
  final String name;
  final String phone;
  final String? email;
  final UserRole role;
  final SalesType? salesType;

  /// Filled in when someone signs up to earn.
  final Occupation? occupation;
  final int? age;
  final String city;
  final String? area;
  final String? franchiseId;
  final AccountStatus status;
  final DateTime createdAt;

  /// Set for vendor accounts.
  final String? vendorId;

  /// Set for customer accounts.
  final String? customerId;

  final String? upiId;
  final String? bankAccount;
  final String? ifsc;

  /// True when admin generated the password and the user should replace it.
  final bool mustChangePassword;

  final bool pushOn;
  final bool emailOn;
  final bool smsOn;
  final bool whatsappOn;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  AppUser copyWith({
    String? loginId,
    String? password,
    String? name,
    String? phone,
    String? email,
    UserRole? role,
    SalesType? salesType,
    String? city,
    String? area,
    String? franchiseId,
    AccountStatus? status,
    String? vendorId,
    String? customerId,
    String? upiId,
    String? bankAccount,
    String? ifsc,
    bool? mustChangePassword,
    bool? pushOn,
    bool? emailOn,
    bool? smsOn,
    bool? whatsappOn,
  }) =>
      AppUser(
        id: id,
        loginId: loginId ?? this.loginId,
        password: password ?? this.password,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        role: role ?? this.role,
        salesType: salesType ?? this.salesType,
        occupation: occupation,
        age: age,
        city: city ?? this.city,
        area: area ?? this.area,
        franchiseId: franchiseId ?? this.franchiseId,
        status: status ?? this.status,
        createdAt: createdAt,
        vendorId: vendorId ?? this.vendorId,
        customerId: customerId ?? this.customerId,
        upiId: upiId ?? this.upiId,
        bankAccount: bankAccount ?? this.bankAccount,
        ifsc: ifsc ?? this.ifsc,
        mustChangePassword: mustChangePassword ?? this.mustChangePassword,
        pushOn: pushOn ?? this.pushOn,
        emailOn: emailOn ?? this.emailOn,
        smsOn: smsOn ?? this.smsOn,
        whatsappOn: whatsappOn ?? this.whatsappOn,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'loginId': loginId,
        'password': password,
        'name': name,
        'phone': phone,
        'email': email,
        'role': role.name,
        'salesType': salesType?.name,
        'occupation': occupation?.name,
        'age': age,
        'city': city,
        'area': area,
        'franchiseId': franchiseId,
        'status': status.name,
        'createdAt': createdAt.toIso8601String(),
        'vendorId': vendorId,
        'customerId': customerId,
        'upiId': upiId,
        'bankAccount': bankAccount,
        'ifsc': ifsc,
        'mustChangePassword': mustChangePassword,
        'pushOn': pushOn,
        'emailOn': emailOn,
        'smsOn': smsOn,
        'whatsappOn': whatsappOn,
      };

  factory AppUser.fromJson(Map<String, dynamic> j) => AppUser(
        id: j['id'] as String,
        loginId: j['loginId'] as String,
        password: j['password'] as String,
        name: j['name'] as String,
        phone: j['phone'] as String,
        email: j['email'] as String?,
        role: enumByName(UserRole.values, j['role'], UserRole.sales),
        salesType: enumByNameOrNull(SalesType.values, j['salesType']),
        occupation: enumByNameOrNull(Occupation.values, j['occupation']),
        age: j['age'] == null ? null : numToInt(j['age']),
        city: j['city'] as String,
        area: j['area'] as String?,
        franchiseId: j['franchiseId'] as String?,
        status: enumByName(AccountStatus.values, j['status'], AccountStatus.active),
        createdAt: DateTime.parse(j['createdAt'] as String),
        vendorId: j['vendorId'] as String?,
        customerId: j['customerId'] as String?,
        upiId: j['upiId'] as String?,
        bankAccount: j['bankAccount'] as String?,
        ifsc: j['ifsc'] as String?,
        mustChangePassword: j['mustChangePassword'] as bool? ?? false,
        pushOn: j['pushOn'] as bool? ?? true,
        emailOn: j['emailOn'] as bool? ?? true,
        smsOn: j['smsOn'] as bool? ?? true,
        whatsappOn: j['whatsappOn'] as bool? ?? true,
      );
}

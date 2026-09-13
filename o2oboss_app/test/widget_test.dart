import 'package:flutter_test/flutter_test.dart';
import 'package:o2oboss_app/core/mock/seed.dart';
import 'package:o2oboss_app/core/models/models.dart';

void main() {
  test('demo seed builds and round-trips through JSON', () {
    final db = buildSeed(DateTime(2026, 9, 12, 10));
    expect(db.enquiries, isNotEmpty);
    final copy = DbState.fromJson(db.toJson());
    expect(copy.enquiries.length, db.enquiries.length);
    expect(copy.users.length, db.users.length);
  });
}

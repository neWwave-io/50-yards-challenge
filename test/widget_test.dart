import 'package:flutter_test/flutter_test.dart';

import 'package:the_50_yard_challenge/backend/supabase_compat/compat_types.dart';

void main() {
  test('DocumentReference keeps the v1 path format', () {
    const ref = DocumentReference('v1_users', 'abc123');
    expect(ref.path, 'v1_users/abc123');
    expect(ref.id, 'abc123');
  });

  test('Query is immutable as the v1 queryBuilder lambdas assume', () {
    const base = Query('v1_lawns');
    final filtered = base.where('status', isEqualTo: 'approved');
    expect(base.filters, isEmpty);
    expect(filtered.filters.length, 1);
  });

  test('FieldValue.increment carries its amount', () {
    final fv = FieldValue.increment(3);
    expect(fv.kind, 'increment');
    expect(fv.value, 3);
  });
}

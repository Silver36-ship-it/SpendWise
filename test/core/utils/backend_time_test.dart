import 'package:flutter_test/flutter_test.dart';
import 'package:spend_wise/core/utils/backend_time.dart';

void main() {
  test('parses timestamp with Z', () {
    final result = BackendTime.parse(
      '2026-09-28T14:30:00Z',
    );

    expect(
      result,
      DateTime.utc(2026, 9, 28, 14, 30),
    );
  });

  test('parses timestamp without Z', () {
    final result = BackendTime.parse(
      '2026-09-28T14:30:00',
    );

    expect(
      result,
      DateTime.utc(2026, 9, 28, 14, 30),
    );
  });
}
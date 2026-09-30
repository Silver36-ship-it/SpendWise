import 'package:flutter_test/flutter_test.dart';
import 'package:spend_wise/core/utils/json_parser.dart';

void main() {
  test('parses a number', () {
    expect(
      JsonParser.toDouble(2500.50),
      2500.50,
    );
  });

  test('parses a string number', () {
    expect(
      JsonParser.toDouble('2500.50'),
      2500.50,
    );
  });

  test('throws when value is not a number', () {
    expect(
          () => JsonParser.toDouble('hello'),
      throwsA(isA<FormatException>()),
    );
  });
}
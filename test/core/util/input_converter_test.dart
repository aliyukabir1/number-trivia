import 'package:clean_architecture/core/util/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InputConverter inputConverter;
  setUp(() {
    inputConverter = InputConverter();
  });
  group('string to unsigned number', () {
    test(
        'Should return an integer when the string represents an unsigned integer',
        () {
      const str = '123';
      final result = inputConverter.stringToUnsignedNumber(str);

      expect(result, const Right(123));
    });

    test('should return failure when string is not an integer', () {
      const str = '12.5';
      final result = inputConverter.stringToUnsignedNumber(str);

      expect(result, Left(InvalidInputFailure()));
    });
  });
}

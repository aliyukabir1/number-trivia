import 'dart:convert';

import 'package:clean_architecture/features/data/model/number_trivia_model.dart';
import 'package:clean_architecture/features/domain/entity/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../core/fixture/fixture_reader.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test Text');
  test('should be a submodel of tNumber trivia entity', () {
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });
  group('from jsom', () {
    test('should return a valid model when number is an integer', () {
      final jsonMap = jsonDecode(fixture('trivia.json'));
      final result = NumberTriviaModel.fromJson(jsonMap);
      expect(result, tNumberTriviaModel);
    });

    test('should return a valid model when number is a double', () {
      final jsonMap = jsonDecode(fixture('double.json'));
      final result = NumberTriviaModel.fromJson(jsonMap);
      expect(result, tNumberTriviaModel);
    });
  });

  group('toJson', () {
    final Map<String, dynamic> jsonMap = {"number": 1, "text": "Test Text"};
    test('should return json', () {
      final result = tNumberTriviaModel.toJson();

      expect(result, jsonMap);
    });
  });
}

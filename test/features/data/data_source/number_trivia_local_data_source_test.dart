import 'dart:convert';

import 'package:clean_architecture/core/error/cached.dart';
import 'package:clean_architecture/features/data/data_source/number_trivia_local_data_source.dart';
import 'package:clean_architecture/features/data/model/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../core/fixture/fixture_reader.dart';
import '../../../helper/mocks.mocks.dart';

void main() {
  late NumberTriviaLocalDataSourceImpl localDataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    localDataSource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group('get last number', () {
    test(
        'should return a number trivia from sharedpreferences when there is one in the cache',
        () async {
      final tNumberTriviaModel =
          NumberTriviaModel.fromJson(jsonDecode(fixture('trivia.json')));
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture('trivia.json'));

      final result = await localDataSource.getLastNumberTrivia();

      expect(result, tNumberTriviaModel);
      verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      verifyNoMoreInteractions(mockSharedPreferences);
    });

    test('should return a Cache Exception  when there is no data in the cache',
        () async {
      when(mockSharedPreferences.getString(any)).thenThrow(Exception());
      final call = localDataSource.getLastNumberTrivia();
      expect(call, throwsA(const TypeMatcher<CachedException>()));
    });
  });

  group(' cache a number trivia', () {
    const tNumberTrivialModel = NumberTriviaModel(number: 1, text: 'test text');
    test('should cache a number trivia model', () async {
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => true);
      localDataSource.cacheNumberTrivia(tNumberTrivialModel);
      final jsonString = jsonEncode(tNumberTrivialModel.toJson());
      verify(mockSharedPreferences.setString(CACHED_NUMBER_TRIVIA, jsonString));
    });
  });
}

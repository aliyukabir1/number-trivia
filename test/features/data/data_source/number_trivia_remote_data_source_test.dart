import 'package:clean_architecture/core/error/exception.dart';
import 'package:clean_architecture/features/data/data_source/number_trivia_remote_data_source.dart';
import 'package:clean_architecture/features/data/model/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:mockito/mockito.dart';
import 'dart:convert';
import '../../../core/fixture/fixture_reader.dart';
import '../../../helper/mocks.mocks.dart';

void main() {
  late NumberTrivialRemoteDataSourceImpl remoteDataSource;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    remoteDataSource = NumberTrivialRemoteDataSourceImpl(client: mockClient);
  });

  void setUpMockClientSuccess200() {
    when(mockClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockClientFailure400() {
    when(mockClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('something went wrong', 404));
  }

  group('get concrete remote', () {
    const tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    // test(
    //     '''should perfeorm a Get request on a URL with number
    //  being the endpoint and with application/json header''',
    //     () async {
    //   setUpMockClientSuccess200();
    //   remoteDataSource.getConcreteNumberTrivia(tNumber);
    //   verify(mockClient
    //       .get(url), headers: {'Content-Type': 'application/json'}));
    // });

    test('should return number trivia when the status code is 200 (Success)',
        () async {
      // arrange
      setUpMockClientSuccess200();
      // act
      final result = await remoteDataSource.getConcreteNumberTrivia(tNumber);
      // assert

      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw a server exception when the response code is not 200',
        () async {
      // arrange
      setUpMockClientFailure400();
      // act
      final call = remoteDataSource.getConcreteNumberTrivia;
      // assert
      expect(
          () => call(tNumber), throwsA(const TypeMatcher<ServerExceptions>()));
    });
  });

  group('getRandomNumberTrvia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    // test(
    //     '''should perfeorm a Get request on a URL with random
    //  being the endpoint and with application/json header''',
    //     () async {
    //   // arrange
    //   setUpMockClientSuccess200();
    //   // act
    //   remoteDataSource.getRandomNumberTrivia();
    //   // assert

    //   verify(mockClient
    //       .get(url('random'), headers: {'Content-Type': 'application/json'}));
    // });

    test('should return number trivia when the status code is 200 (Success)',
        () async {
      // arrange
      setUpMockClientSuccess200();
      // act
      final result = await remoteDataSource.getRandomNumberTrivia();
      // assert

      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw a server exception when the response code is not 200',
        () async {
      // arrange
      setUpMockClientFailure400();
      // act
      final call = remoteDataSource.getRandomNumberTrivia;
      // assert
      expect(() => call(), throwsA(const TypeMatcher<ServerExceptions>()));
    });
  });
}

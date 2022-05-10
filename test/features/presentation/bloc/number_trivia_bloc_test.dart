import 'package:clean_architecture/core/usecase/usecase.dart';
import 'package:clean_architecture/core/util/input_converter.dart';
import 'package:clean_architecture/features/domain/entity/number_trivia.dart';
import 'package:clean_architecture/features/domain/usecase/get_concrete_number_trivia.dart';
import 'package:clean_architecture/features/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helper/mocks.mocks.dart';

void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockInputConverter = MockInputConverter();
    mockRandomNumberTrivia = MockGetRandomNumberTrivia();
    bloc = NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRandomNumberTrivia: mockRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });
  test('initial state should be empty', () {
    expect(bloc.state, equals(Empty()));
  });

  group('get trivia for concrete number', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    const tNumberTrivia = NumberTrivia(number: 1, text: 'test text');
    void setUpMockInputConverterSucces() =>
        when(mockInputConverter.stringToUnsignedNumber(any))
            .thenReturn(const Right(tNumberParsed));
    // test(
    //     'should call the input converter to validate and convert the string to an unsigned integer',
    //     () async {
    //   // arrange
    //   // setUpMockInputConverterSucces();

    //   // // act
    //   // bloc.add(const GetNumberConcreteTrivia(tNumberString));
    //   // await untilCalled(mockInputConverter.stringToUnsignedNumber(any));
    //   // // assert
    //   // verify(mockInputConverter.stringToUnsignedNumber(tNumberString));
    // });

    test('should emmit [Error] when the input is invalid ', () async {
      // arrange
      when(mockInputConverter.stringToUnsignedNumber(any))
          .thenReturn(Left(InvalidInputFailure()));
      // act
      bloc.add(const GetNumberConcreteTrivia(tNumberString));
      // assert
      final expected = [
        //Empty(),
        const Error(message: invalidInputFailureMessage)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
    });

    test('should get data from concrete usecase', () async {
      setUpMockInputConverterSucces();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));

      bloc.add(const GetNumberConcreteTrivia(tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(any));
      verify(mockGetConcreteNumberTrivia(const Params(tNumberParsed)));
    });

    test('should emit [Loading Loaded] when called when successfully gotten',
        () async {
      setUpMockInputConverterSucces();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      final expected = [Loading(), const Loaded(numberTrivia: tNumberTrivia)];
      expectLater(bloc.stream, emitsInOrder(expected));
      bloc.add(const GetNumberConcreteTrivia(tNumberString));
    });
  });

  group('get trivia for random number', () {
    const tNumberTrivia = NumberTrivia(number: 1, text: 'test text');

    // test(
    //     'should call the input converter to validate and convert the string to an unsigned integer',
    //     () async {
    //   // arrange
    //   // setUpMockInputConverterSucces();

    //   // // act
    //   // bloc.add(const GetNumberConcreteTrivia(tNumberString));
    //   // await untilCalled(mockInputConverter.stringToUnsignedNumber(any));
    //   // // assert
    //   // verify(mockInputConverter.stringToUnsignedNumber(tNumberString));
    // });

    test('should get data from random usecase', () async {
      when(mockRandomNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));

      bloc.add(const GetNumberRandomTrivia());
      await untilCalled(mockRandomNumberTrivia(any));
      verify(mockRandomNumberTrivia(NoParams()));
    });

    test('should emit [Loading Loaded] when called when successfully gotten',
        () async {
      when(mockRandomNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      final expected = [Loading(), const Loaded(numberTrivia: tNumberTrivia)];
      expectLater(bloc.stream, emitsInOrder(expected));
      bloc.add(const GetNumberRandomTrivia());
    });
  });
}

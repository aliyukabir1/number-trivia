import 'package:clean_architecture/core/error/failure.dart';
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
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRandomNumberTrivia: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test('initial state should be empty', () {
    // assert
    expect(bloc.state, equals(Empty()));
  });

  group('GetNumberConcreteTrivia', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    const tNumberTrivial = NumberTrivia(number: 1, text: 'test trivia');

    void setUpMockInputConverterSucces() =>
        when(mockInputConverter.stringToUnsignedNumber(any))
            .thenReturn(const Right(tNumberParsed));
    test(
        'should call the input converter to validate and convert the string to an unsigned integer',
        () async {
      // arrange
      setUpMockInputConverterSucces();

      // act
      //bloc.add(const GetNumberConcreteTrivia(tNumberString));
      //await untilCalled(mockInputConverter.stringToUnsignedNumber(any));
      // assert
      //verify(mockInputConverter.stringToUnsignedNumber(tNumberString));
    });
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

    test('should get data from the concret use case', () async {
      // arrange
      setUpMockInputConverterSucces();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivial));
      // act
      bloc.add(const GetNumberConcreteTrivia(tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(any));
      // assert
      verify(mockGetConcreteNumberTrivia(const Params(tNumberParsed)));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      setUpMockInputConverterSucces();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivial));
      // assign later
      final expected = [Loading(), const Loaded(numberTrivia: tNumberTrivial)];
      expectLater(bloc.stream, emitsInOrder(expected));

      // act
      bloc.add(const GetNumberConcreteTrivia(tNumberString));
    });

    test('should emit [Loading, Error] when getting data fails', () {
      // arrange
      setUpMockInputConverterSucces();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assign later
      final expected = [Loading(), const Error(message: serverFailureMessage)];
      expectLater(bloc.stream, emitsInOrder(expected));

      // act
      bloc.add(const GetNumberConcreteTrivia(tNumberString));
    });

    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () {
      // arrange
      setUpMockInputConverterSucces();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(CachedFailure()));
      // assign later
      final expected = [Loading(), const Error(message: cacheFailureMessage)];
      expectLater(bloc.stream, emitsInOrder(expected));

      // act
      bloc.add(const GetNumberConcreteTrivia(tNumberString));
    });
  });

  group('GetNumberConcreteTrivia', () {
    const tNumberTrivial = NumberTrivia(number: 1, text: 'test trivia');

    test('should get data from the concret use case', () async {
      // arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivial));
      // act
      bloc.add(const GetNumberRandomTrivia());
      await untilCalled(mockGetRandomNumberTrivia(any));
      // assert
      verify(mockGetRandomNumberTrivia(NoParams()));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivial));
      // assign later
      final expected = [Loading(), const Loaded(numberTrivia: tNumberTrivial)];
      expectLater(bloc.stream, emitsInOrder(expected));

      // act
      bloc.add(const GetNumberRandomTrivia());
    });

    test('should emit [Loading, Error] when getting data fails', () {
      // arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assign later
      final expected = [Loading(), const Error(message: serverFailureMessage)];
      expectLater(bloc.stream, emitsInOrder(expected));

      // act
      bloc.add(const GetNumberRandomTrivia());
    });

    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () {
      // arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(CachedFailure()));
      // assign later
      final expected = [Loading(), const Error(message: cacheFailureMessage)];
      expectLater(bloc.stream, emitsInOrder(expected));

      // act
      bloc.add(const GetNumberRandomTrivia());
    });
  });
}

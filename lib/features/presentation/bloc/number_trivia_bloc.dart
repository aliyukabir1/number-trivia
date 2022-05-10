import 'package:bloc/bloc.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/core/usecase/usecase.dart';
import 'package:clean_architecture/core/util/input_converter.dart';
import 'package:clean_architecture/features/domain/entity/number_trivia.dart';
import 'package:clean_architecture/features/domain/usecase/get_concrete_number_trivia.dart';
import 'package:clean_architecture/features/domain/usecase/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String serverFailureMessage = 'Server Failure';
const String cacheFailureMessage = 'Cahce Failure';
const String invalidInputFailureMessage =
    'Invalid Input - The number must be a positive integer or zero';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc(
      {required this.getConcreteNumberTrivia,
      required this.getRandomNumberTrivia,
      required this.inputConverter})
      : super(Empty()) {
    on<NumberTriviaEvent>((event, emit) async {
      if (event is GetNumberConcreteTrivia) {
        final inputEither =
            inputConverter.stringToUnsignedNumber(event.numberString);

        await inputEither.fold((failure) {
          emit(const Error(message: invalidInputFailureMessage));
        }, (integer) async {
          emit(Loading());
          final failureOrTrivia =
              await getConcreteNumberTrivia(Params(integer));

          _eitherLoadedOrErrorState(emit, failureOrTrivia);
        });
      } else if (event is GetNumberRandomTrivia) {
        emit(Loading());
        final failureOrTrivia = await getRandomNumberTrivia(NoParams());
        _eitherLoadedOrErrorState(emit, failureOrTrivia);
      }
    });
  }

  void _eitherLoadedOrErrorState(Emitter<NumberTriviaState> emit,
      Either<Failure, NumberTrivia> failureOrTrivia) async {
    emit(failureOrTrivia.fold(
        (failure) => Error(message: _mapFailureToMessage(failure)),
        (trivial) => Loaded(numberTrivia: trivial)));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return serverFailureMessage;
      case CachedFailure:
        return cacheFailureMessage;
      default:
        return 'Unexpected error';
    }
  }
}

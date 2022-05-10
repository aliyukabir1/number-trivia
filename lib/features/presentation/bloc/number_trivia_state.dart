part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState() : super();

  @override
  List<Object> get props => [];
}

class Empty extends NumberTriviaState {}

class Loading extends NumberTriviaState {}

class Loaded extends NumberTriviaState {
  final NumberTrivia numberTrivia;

  const Loaded({required this.numberTrivia}) : super();
}

class Error extends NumberTriviaState {
  final String message;

  const Error({required this.message}) : super();
}

part of 'number_trivia_bloc.dart';

abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent(props) : super();
  @override
  List<Object> get props => [];
}

class GetNumberConcreteTrivia extends NumberTriviaEvent {
  final String numberString;

  const GetNumberConcreteTrivia(this.numberString) : super(numberString);
}

class GetNumberRandomTrivia extends NumberTriviaEvent {
  const GetNumberRandomTrivia() : super(null);
}

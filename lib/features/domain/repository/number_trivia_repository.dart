import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/features/domain/entity/number_trivia.dart';
import 'package:dartz/dartz.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int num);
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}

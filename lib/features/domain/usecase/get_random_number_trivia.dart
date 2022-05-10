import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/core/usecase/usecase.dart';
import 'package:clean_architecture/features/domain/entity/number_trivia.dart';
import 'package:clean_architecture/features/domain/repository/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';

class GetRandomNumberTrivia implements Usecase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;

  GetRandomNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async {
    return await repository.getRandomNumberTrivia();
  }
}

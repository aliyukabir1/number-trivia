import 'package:clean_architecture/core/error/cached.dart';
import 'package:clean_architecture/core/error/exception.dart';
import 'package:clean_architecture/core/network/network_info.dart';
import 'package:clean_architecture/features/data/data_source/number_trivia_local_data_source.dart';
import 'package:clean_architecture/features/data/data_source/number_trivia_remote_data_source.dart';
import 'package:clean_architecture/features/data/model/number_trivia_model.dart';
import 'package:clean_architecture/features/domain/entity/number_trivia.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/features/domain/repository/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';

typedef _ConcreteOrRandomChooser = Future<NumberTriviaModel> Function();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  NumberTriviaRepositoryImpl(
      {required this.localDataSource,
      required this.remoteDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return await _getTrivial(
        () => remoteDataSource.getConcreteNumberTrivia(number));
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivial(() => remoteDataSource.getRandomNumberTrivia());
  }

  Future<Either<Failure, NumberTrivia>> _getTrivial(
      _ConcreteOrRandomChooser getConcreteOrRandom) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getConcreteOrRandom();
        localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerExceptions {
        return Left(ServerFailure());
      }
    } else {
      try {
        return Right(await localDataSource.getLastNumberTrivia());
      } on CachedException {
        return Left(CachedFailure());
      }
    }
  }
}

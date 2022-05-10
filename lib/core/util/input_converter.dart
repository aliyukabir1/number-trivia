import 'package:clean_architecture/core/error/failure.dart';
import 'package:dartz/dartz.dart';

class InputConverter {
  Either<InvalidInputFailure, int> stringToUnsignedNumber(String str) {
    try {
      final val = int.parse(str);
      if (val < 0) throw const FormatException();
      return Right(val);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}

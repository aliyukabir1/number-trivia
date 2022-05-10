import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure {}

class SocketFailure extends Failure {}

class CachedFailure extends Failure {}

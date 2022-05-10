import 'package:clean_architecture/core/network/network_info.dart';
import 'package:clean_architecture/core/util/input_converter.dart';
import 'package:clean_architecture/features/data/data_source/number_trivia_local_data_source.dart';
import 'package:clean_architecture/features/data/data_source/number_trivia_remote_data_source.dart';
import 'package:clean_architecture/features/domain/repository/number_trivia_repository.dart';
import 'package:clean_architecture/features/domain/usecase/get_concrete_number_trivia.dart';
import 'package:clean_architecture/features/domain/usecase/get_random_number_trivia.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';

import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([
  NumberTriviaRepository,
  NumberTriviaRemoteDataSource,
  NumberTriviaLocalDataSource,
  NetworkInfo,
  DataConnectionChecker,
  SharedPreferences,
  http.Client,
  GetConcreteNumberTrivia,
  GetRandomNumberTrivia,
  InputConverter
])
void main() {}

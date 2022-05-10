import 'package:clean_architecture/core/network/network_info.dart';
import 'package:clean_architecture/core/util/input_converter.dart';
import 'package:clean_architecture/features/data/data_source/number_trivia_local_data_source.dart';
import 'package:clean_architecture/features/data/data_source/number_trivia_remote_data_source.dart';
import 'package:clean_architecture/features/data/repository/number_trivia_repository_impl.dart';
import 'package:clean_architecture/features/domain/repository/number_trivia_repository.dart';
import 'package:clean_architecture/features/domain/usecase/get_concrete_number_trivia.dart';
import 'package:clean_architecture/features/domain/usecase/get_random_number_trivia.dart';
import 'package:clean_architecture/features/presentation/bloc/number_trivia_bloc.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  // features -number trivia
  sl.registerFactory(() => NumberTriviaBloc(
      getConcreteNumberTrivia: sl(),
      getRandomNumberTrivia: sl(),
      inputConverter: sl()));

  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  sl.registerLazySingleton<NumberTriviaRepository>(() =>
      NumberTriviaRepositoryImpl(
          localDataSource: sl(), remoteDataSource: sl(), networkInfo: sl()));
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()));
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTrivialRemoteDataSourceImpl(client: sl()));

  //core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => InputConverter());
  // externals
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}

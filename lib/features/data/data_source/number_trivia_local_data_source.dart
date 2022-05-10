import 'dart:convert';

import 'package:clean_architecture/core/error/cached.dart';
import 'package:clean_architecture/features/data/model/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NumberTriviaLocalDataSource {
  Future<NumberTriviaModel> getLastNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

// ignore: non_constant_identifier_names
String CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() async {
    try {
      final String? jsonString =
          sharedPreferences.getString(CACHED_NUMBER_TRIVIA);
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString!)));
    } on Exception {
      throw CachedException();
    }
  }

  @override
  Future<bool> cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    return sharedPreferences.setString(
        CACHED_NUMBER_TRIVIA, json.encode(triviaToCache.toJson()));
  }
}

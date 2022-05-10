import 'dart:convert';
import 'package:clean_architecture/core/error/exception.dart';
import 'package:clean_architecture/features/data/model/number_trivia_model.dart';
import 'package:http/http.dart' as http;

abstract class NumberTriviaRemoteDataSource {
  /// should throw [ServerException] or [SocketExceptions]
  Future<NumberTriviaModel> getConcreteNumberTrivia(int num);
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTrivialRemoteDataSourceImpl
    implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTrivialRemoteDataSourceImpl({required this.client});
  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int num) {
    return _getTriviaFromUrl('$num');
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() {
    return _getTriviaFromUrl('random');
  }

  Future<NumberTriviaModel> _getTriviaFromUrl(String extension) async {
    final headers = {'Content-Type': 'application/json', 'Charset': 'utf-8'};
    final url = 'http://numbersapi.com/$extension';
    final response = await client.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    }
    throw ServerExceptions();
  }
}

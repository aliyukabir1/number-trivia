import 'package:clean_architecture/features/domain/entity/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  const NumberTriviaModel({required int number, required String text})
      : super(number: number, text: text);

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) =>
      NumberTriviaModel(
          number: (json['number'] as num).toInt(), text: json['text']);

  Map<String, dynamic> toJson() => {'number': number, 'text': text};
}

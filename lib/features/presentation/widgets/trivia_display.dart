import 'package:clean_architecture/features/domain/entity/number_trivia.dart';
import 'package:flutter/material.dart';

class TriviaDisplay extends StatelessWidget {
  final NumberTrivia trivia;
  const TriviaDisplay({Key? key, required this.trivia}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '${trivia.number}',
          style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
        ),
        Text(
          trivia.text,
          style: const TextStyle(fontSize: 25),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

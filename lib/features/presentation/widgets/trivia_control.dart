import 'package:clean_architecture/features/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TriviaControl extends StatefulWidget {
  const TriviaControl({Key? key}) : super(key: key);

  @override
  _TrivialControlState createState() => _TrivialControlState();
}

class _TrivialControlState extends State<TriviaControl> {
  late String inputStr;
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
            keyboardType: TextInputType.number,
            controller: controller,
            onChanged: (value) {
              inputStr = value;
            },
            onSubmitted: (_) {
              dispatchConcret();
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Input a number',
            )),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
                child: ElevatedButton(
              onPressed: dispatchConcret,
              child: const Text('Search'),
            )),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: ElevatedButton(
              onPressed: dispatchRandom,
              child: const Text('Get random trivia'),
            )),
          ],
        )
      ],
    );
  }

  void dispatchConcret() {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetNumberConcreteTrivia(inputStr));
  }

  void dispatchRandom() {
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(const GetNumberRandomTrivia());
  }
}

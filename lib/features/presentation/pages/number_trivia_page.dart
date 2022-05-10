import 'package:clean_architecture/features/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../injection_container.dart';
import '../widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: BlocProvider(
        create: (_) => sl<NumberTriviaBloc>(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                // Top Half
                SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                  child: Center(
                    child: SingleChildScrollView(
                      child: BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                        builder: (context, state) {
                          if (state is Empty) {
                            return const MessageDisplay(
                              message: 'Start Searching',
                            );
                          } else if (state is Loading) {
                            return const CircularProgressIndicator();
                          } else if (state is Loaded) {
                            return TriviaDisplay(trivia: state.numberTrivia);
                          } else if (state is Error) {
                            return MessageDisplay(
                              message: state.message,
                            );
                          }
                          return Container();
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // Bottom Half
                const TriviaControl()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:clean_architecture/features/domain/entity/number_trivia.dart';
import 'package:clean_architecture/features/domain/usecase/get_concrete_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helper/mocks.mocks.dart';

void main() {
  late MockNumberTriviaRepository repository;
  late GetConcreteNumberTrivia usecase;

  setUp(() {
    repository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(repository);
  });

  test('should return a number trivia entity', () async {
    const tNumber = 1;
    const tNumberTrivia = NumberTrivia(number: tNumber, text: 'test');
    when(repository.getConcreteNumberTrivia(any))
        .thenAnswer((_) async => const Right(tNumberTrivia));

    final result = await usecase.call(const Params(tNumber));

    verify(repository.getConcreteNumberTrivia(tNumber));
    verifyNoMoreInteractions(repository);
    expect(result, const Right(tNumberTrivia));
  });
}

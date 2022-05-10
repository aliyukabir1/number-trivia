import 'package:clean_architecture/core/usecase/usecase.dart';
import 'package:clean_architecture/features/domain/entity/number_trivia.dart';
import 'package:clean_architecture/features/domain/usecase/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helper/mocks.mocks.dart';

void main() {
  late MockNumberTriviaRepository mockRepository;
  late GetRandomNumberTrivia usecase;

  setUp(() {
    mockRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockRepository);
  });

  test('should return a Number trivia entity', () async {
    const tNumber = 1;
    const tNumberTrivia = NumberTrivia(number: tNumber, text: 'test');
    when(mockRepository.getRandomNumberTrivia())
        .thenAnswer((realInvocation) async => const Right(tNumberTrivia));

    final result = await usecase.call(NoParams());

    expect(result, const Right(tNumberTrivia));
    verify(mockRepository.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockRepository);
  });
}

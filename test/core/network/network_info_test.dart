import 'package:clean_architecture/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helper/mocks.mocks.dart';

void main() {
  late NetworkInfoImpl networkInfoImpl;
  late MockDataConnectionChecker mockDataConnectionChecker;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockDataConnectionChecker);
  });

  group('isConnected', () {
    final tHasConnectionFuture = Future.value(true);
    test('should forward the DataConnection.hasConnection', () async {
      when(mockDataConnectionChecker.hasConnection)
          .thenAnswer((realInvocation) => tHasConnectionFuture);

      final result = networkInfoImpl.isConnected;
      expect(result, tHasConnectionFuture);
      verify(mockDataConnectionChecker.hasConnection);
      verifyNoMoreInteractions(mockDataConnectionChecker);
    });
  });

  group('isNotConnected', () {
    final tHasConnectionFuture = Future.value(false);
    test('should forward the DataConnection.hasConnection', () async {
      when(mockDataConnectionChecker.hasConnection)
          .thenAnswer((realInvocation) => tHasConnectionFuture);

      final result = networkInfoImpl.isConnected;
      expect(result, tHasConnectionFuture);
      verify(mockDataConnectionChecker.hasConnection);
      verifyNoMoreInteractions(mockDataConnectionChecker);
    });
  });
}

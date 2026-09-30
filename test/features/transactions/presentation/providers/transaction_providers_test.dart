import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:spend_wise/features/transactions/domain/entities/transaction.dart';
import 'package:spend_wise/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:spend_wise/features/transactions/presentation/providers/transaction_providers.dart';
import 'package:spend_wise/features/transactions/presentation/providers/transaction_riverpod_provider.dart';

class MockTransactionRepository extends Mock
    implements TransactionRepository {}

void main() {
  late MockTransactionRepository repository;

  setUp(() {
    repository = MockTransactionRepository();
  });

  test(
    'transactionsProvider returns transactions from repository',
        () async {
      final transactions = <Transaction>[];

      when(
            () => repository.getTransactions(1),
      ).thenAnswer(
            (_) async => transactions,
      );

      final container = ProviderContainer(
        overrides: [
          transactionRepositoryProvider.overrideWith(
                (ref) async => repository,
          ),
        ],
      );

      addTearDown(container.dispose);

      final result = await container.read(
        transactionsProvider(1).future,
      );

      expect(result, transactions);

      verify(
            () => repository.getTransactions(1),
      ).called(1);
    },
  );
}
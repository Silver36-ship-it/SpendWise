import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:spend_wise/features/transactions/domain/entities/transaction.dart';
import 'package:spend_wise/features/transactions/domain/entities/transaction_category.dart';
import 'package:spend_wise/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:spend_wise/features/transactions/presentation/providers/transaction_providers.dart';
import 'package:spend_wise/features/transactions/presentation/providers/transaction_riverpod_provider.dart';

class MockTransactionRepository extends Mock
    implements TransactionRepository {}

void main() {
  late MockTransactionRepository repository;
  late ProviderContainer container;

  final transaction = Transaction(
    id: 'transaction-1',
    userId: 1,
    title: 'Test transaction',
    amount: 5000,
    type: TransactionType.expense,
    typeValue: TransactionType.expense.name,
    category: TransactionCategory.food,
    categoryValue: TransactionCategory.food.name,
    date: DateTime(2026, 9, 29),
  );

  setUp(() {
    repository = MockTransactionRepository();

    when(
          () => repository.getTransactions(any()),
    ).thenAnswer((_) async => []);

    container = ProviderContainer(
      overrides: [
        transactionRepositoryProvider.overrideWith(
              (ref) async => repository,
        ),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test(
    'addTransaction adds transaction and refreshes transactions',
        () async {
      when(
            () => repository.addTransaction(transaction),
      ).thenAnswer((_) async {});

      await container
          .read(transactionActionProvider(1).future);

      await container
          .read(transactionActionProvider(1).notifier)
          .addTransaction(transaction);

      verify(
            () => repository.addTransaction(transaction),
      ).called(1);

      verify(
            () => repository.getTransactions(1),
      ).called(1);
    },
  );

  test(
    'updateTransaction updates transaction and refreshes transactions',
        () async {
      when(
            () => repository.updateTransaction(transaction),
      ).thenAnswer((_) async {});

      await container
          .read(transactionActionProvider(1).future);

      await container
          .read(transactionActionProvider(1).notifier)
          .updateTransaction(transaction);

      verify(
            () => repository.updateTransaction(transaction),
      ).called(1);

      verify(
            () => repository.getTransactions(1),
      ).called(1);
    },
  );

  test(
    'deleteTransaction deletes transaction and refreshes transactions',
        () async {
      when(
            () => repository.deleteTransaction(
          transaction.id,
          transaction.userId,
        ),
      ).thenAnswer((_) async {});

      await container
          .read(transactionActionProvider(1).future);

      await container
          .read(transactionActionProvider(1).notifier)
          .deleteTransaction(
        transaction.id,
        transaction.userId,
      );

      verify(
            () => repository.deleteTransaction(
          transaction.id,
          transaction.userId,
        ),
      ).called(1);

      verify(
            () => repository.getTransactions(1),
      ).called(1);
    },
  );

  test(
    'deleteTransaction sets error state when repository fails',
        () async {
      final exception = Exception(
        'Failed to delete transaction',
      );

      when(
            () => repository.deleteTransaction(
          transaction.id,
          transaction.userId,
        ),
      ).thenThrow(exception);

      await container
          .read(transactionActionProvider(1).future);

      await container
          .read(transactionActionProvider(1).notifier)
          .deleteTransaction(
        transaction.id,
        transaction.userId,
      );

      final state =
      container.read(transactionActionProvider(1));

      expect(state.hasError, true);
      expect(state.error, exception);
    },
  );
}
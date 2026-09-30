import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spend_wise/features/transactions/presentation/providers/transaction_riverpod_provider.dart';

import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';

import 'transaction_busy_id_provider.dart';
import 'transaction_providers.dart';

class TransactionActionNotifier
extends FamilyAsyncNotifier<void, int> {
  late final TransactionRepository repository;

  @override
  Future<void> build(int userId) async {
    repository =
    await ref.watch(transactionRepositoryProvider.future);
  }

  Future<void> addTransaction(Transaction transaction,) async {
    final busyIdNotifier =
    ref.read(
      transactionBusyIdProvider(transaction.userId).notifier,
    );

    busyIdNotifier.state = 'add';

    state = const AsyncLoading();

    try {
      await repository.addTransaction(transaction);

      await ref.refresh(
        transactionsProvider(transaction.userId).future,
      );

      state = const AsyncData(null);
    } catch (e, stackTrace) {
      state = AsyncError(
        e,
        stackTrace,
      );
    } finally {
      busyIdNotifier.state = null;
    }
  }

  Future<void> updateTransaction(Transaction transaction,) async {
    final busyIdNotifier =
    ref.read(
      transactionBusyIdProvider(transaction.userId).notifier,
    );

    busyIdNotifier.state = transaction.id;

    state = const AsyncLoading();

    try {
      await repository.updateTransaction(transaction);

      await ref.refresh(
        transactionsProvider(transaction.userId).future,
      );

      state = const AsyncData(null);
    } catch (e, stackTrace) {
      state = AsyncError(
        e,
        stackTrace,
      );
    } finally {
      busyIdNotifier.state = null;
    }
  }

  Future<void> deleteTransaction(String id,
      int userId,) async {
    final busyIdNotifier =
    ref.read(
      transactionBusyIdProvider(userId).notifier,
    );

    busyIdNotifier.state = id;

    state = const AsyncLoading();

    try {
      await repository.deleteTransaction(
        id,
        userId,
      );

      await ref.refresh(
        transactionsProvider(userId).future,
      );

      state = const AsyncData(null);
    } catch (e, stackTrace) {
      state = AsyncError(
        e,
        stackTrace,
      );
    } finally {
      busyIdNotifier.state = null;
    }
  }
}

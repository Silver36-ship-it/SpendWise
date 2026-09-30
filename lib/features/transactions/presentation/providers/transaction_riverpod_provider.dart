import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spend_wise/features/transactions/presentation/providers/transaction_providers.dart';

import '../../domain/entities/transaction.dart';
import 'transaction_action_notifier.dart';

final transactionActionProvider = AsyncNotifierProviderFamily<TransactionActionNotifier, void, int>(
  TransactionActionNotifier.new,
);


final transactionsProvider = FutureProvider.autoDispose.family<List<Transaction>, int>(
      (ref, userId) async {
    final repository =
    await ref.watch(transactionRepositoryProvider.future);

    return repository.getTransactions(userId);
  },
);
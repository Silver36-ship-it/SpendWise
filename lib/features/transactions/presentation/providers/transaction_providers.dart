
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/shared_preferences_provider.dart';

import '../../data/datasources/transaction_local_data_source.dart';
import '../../data/repositories/transaction_repository_impl.dart';

import '../../domain/repositories/transaction_repository.dart';

final transactionLocalDataSourceProvider = FutureProvider<TransactionLocalDataSource>((ref) async {
  final preferences =
  await ref.watch(sharedPreferencesProvider.future);

  return TransactionLocalDataSource(
    preferences: preferences,
  );
});

final transactionRepositoryProvider = FutureProvider<TransactionRepository>((ref) async {
  final dataSource =
  await ref.watch(transactionLocalDataSourceProvider.future);

  return TransactionRepositoryImpl(
    dataSource: dataSource,
  );
});


import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_local_data_source.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource dataSource;

  const TransactionRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<List<Transaction>> getTransactions(
      int userId,
      ) {
    return dataSource.getTransactions(userId);
  }

  @override
  Future<void> addTransaction(Transaction transaction) {
    return dataSource.addTransaction(transaction);
  }

  @override
  Future<void> deleteTransaction(
      String id,
      int userId,
      ) {
    return dataSource.deleteTransaction(id, userId);
  }

  @override
  Future<void> updateTransaction(
      Transaction transaction,
      ) {
    return dataSource.updateTransaction(transaction);
  }
}
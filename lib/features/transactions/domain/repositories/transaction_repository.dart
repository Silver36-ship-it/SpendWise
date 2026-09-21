import '../entities/transaction.dart';

abstract class TransactionRepository {
  Future<List<Transaction>> getTransactions(int userId);

  Future<void> addTransaction(Transaction transaction);

  Future<void> updateTransaction(Transaction transaction);

  Future<void> deleteTransaction(
      String id,
      int userId,
      );
}
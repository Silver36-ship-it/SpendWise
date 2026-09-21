import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/transaction.dart';
import '../models/transaction_model.dart';

class TransactionLocalDataSource {
  static const String _storageKey = 'transactions';

  final SharedPreferences preferences;

  const TransactionLocalDataSource({
    required this.preferences,
  });

  Future<List<Transaction>> getTransactions(
      int userId,
      ) async {
    final storedData = preferences.getString(
      _storageKey,
    );

    if (storedData == null) {
      return [];
    }

    final decoded = jsonDecode(storedData) as List;

    final transactions = decoded
        .map(
          (json) => TransactionModel.fromJson(
        Map<String, dynamic>.from(json),
      ),
    )
        .where(
          (transaction) => transaction.userId == userId,
    )
        .toList();

    return transactions;
  }

  Future<void> addTransaction(
      Transaction transaction,
      ) async {
    final transactions = await _getAllTransactions();

    transactions.add(
      TransactionModel.fromEntity(transaction),
    );

    await _saveAllTransactions(transactions);
  }

  Future<void> updateTransaction(
      Transaction updatedTransaction,
      ) async {
    final transactions = await _getAllTransactions();

    final index = transactions.indexWhere(
          (transaction) =>
      transaction.id == updatedTransaction.id,
    );

    if (index == -1) {
      return;
    }

    transactions[index] =
        TransactionModel.fromEntity(updatedTransaction);

    await _saveAllTransactions(transactions);
  }

  Future<void> deleteTransaction(
      String id,
      int userId,
      ) async {
    final transactions = await _getAllTransactions();

    transactions.removeWhere(
          (transaction) =>
      transaction.id == id &&
          transaction.userId == userId,
    );

    await _saveAllTransactions(transactions);
  }


  Future<List<TransactionModel>> _getAllTransactions() async {
    final storedData = preferences.getString(
      _storageKey,
    );

    if (storedData == null) {
      return [];
    }

    final decoded = jsonDecode(storedData) as List;

    return decoded
        .map(
          (json) => TransactionModel.fromJson(
        Map<String, dynamic>.from(json),
      ),
    )
        .toList();
  }

  Future<void> _saveAllTransactions(
      List<Transaction> transactions,
      ) async {
    final jsonList = transactions
        .map(
          (transaction) =>
          TransactionModel.fromEntity(transaction).toJson(),
    )
        .toList();

    final encoded = jsonEncode(jsonList);

    await preferences.setString(
      _storageKey,
      encoded,
    );
  }


}
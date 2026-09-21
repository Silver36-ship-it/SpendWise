import 'package:flutter/foundation.dart';

import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';

class TransactionProvider extends ChangeNotifier {
  final TransactionRepository repository;

  TransactionProvider({
    required this.repository,
  });

  List<Transaction> _transactions = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadTransactions(int userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _transactions = await repository.getTransactions(userId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTransaction(Transaction transaction) async {
    try {
      await repository.addTransaction(transaction);

      _transactions = await repository.getTransactions(transaction.userId);

      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteTransaction(String id, int userId) async {
    try {
      await repository.deleteTransaction(id, userId);

      _transactions = await repository.getTransactions(userId);

      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateTransaction(
      Transaction transaction,
      ) async {
    try {
      await repository.updateTransaction(transaction);

      _transactions = await repository.getTransactions(transaction.userId);

      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
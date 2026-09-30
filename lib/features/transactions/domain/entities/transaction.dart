import 'package:spend_wise/features/transactions/domain/entities/transaction_category.dart';

enum TransactionType {
  income,
  expense,
  unknown;

  static TransactionType fromWire(String? value) {
    if (value == null) {
      return TransactionType.unknown;
    }

    switch (value.toLowerCase()) {
      case 'income':
        return TransactionType.income;
      case 'expense':
        return TransactionType.expense;
      default:
        return TransactionType.unknown;
    }
  }
}

class Transaction {
  final String id;
  final int userId;
  final String title;
  final double amount;

  final TransactionType type;
  final String typeValue;

  final TransactionCategory category;
  final String categoryValue;

  final DateTime date;

  const Transaction({
    required this.id,
    required this.userId,
    required this.title,
    required this.amount,
    required this.type,
    required this.typeValue,
    required this.category,
    required this.categoryValue,
    required this.date,
  });
}
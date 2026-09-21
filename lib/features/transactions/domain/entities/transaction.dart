import 'package:spend_wise/features/transactions/domain/entities/transaction_category.dart';

enum TransactionType {
  income,
  expense
}

class Transaction {
  final String id;
  final int userId;
  final String title;
  final double amount;
  final TransactionType type;
  final TransactionCategory category;
  final DateTime date;

  const Transaction({
    required this.id,
    required this.userId,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
  });


}
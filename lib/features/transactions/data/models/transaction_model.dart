import '../../../../core/utils/backend_time.dart';
import '../../../../core/utils/json_parser.dart';

import '../../domain/entities/transaction.dart';
import '../../domain/entities/transaction_category.dart';

class TransactionModel extends Transaction {
  const TransactionModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.amount,
    required super.type,
    required super.typeValue,
    required super.category,
    required super.categoryValue,
    required super.date,
  });

  factory TransactionModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final typeValue = json['type']?.toString() ?? '';
    final categoryValue = json['category']?.toString() ?? '';

    return TransactionModel(
      id: json['id'] as String,
      userId: json['userId'] as int,
      title: json['title'] as String,

      // Handles both 2500.50 and "2500.50"
      amount: JsonParser.toDouble(json['amount']),

      // Converts the value into a safe enum.
      type: TransactionType.fromWire(typeValue),

      // Keeps the original backend value.
      typeValue: typeValue,

      category: TransactionCategory.fromWire(categoryValue),

      // Keeps the original backend value.
      categoryValue: categoryValue,

      // Centralized timestamp parsing.
      date: BackendTime.parse(
        json['date'] as String,
      ),
    );
  }

  factory TransactionModel.fromEntity(
      Transaction transaction,
      ) {
    return TransactionModel(
      id: transaction.id,
      userId: transaction.userId,
      title: transaction.title,
      amount: transaction.amount,
      type: transaction.type,
      typeValue: transaction.typeValue,
      category: transaction.category,
      categoryValue: transaction.categoryValue,
      date: transaction.date,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'amount': amount,

      // Use the original value rather than "unknown".
      'type': typeValue,

      'category': categoryValue,

      'date': date.toIso8601String(),
    };
  }
}
import '../../domain/entities/transaction.dart';
import '../../domain/entities/transaction_category.dart';

class TransactionModel extends Transaction {
  const TransactionModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.amount,
    required super.type,
    required super.category,
    required super.date,
  });

  factory TransactionModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return TransactionModel(
      id: json['id'] as String,
      userId: json['userId'] as int,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: TransactionType.values.firstWhere(
            (type) => type.name == json['type'],
      ),
      category: TransactionCategory.values.firstWhere(
            (category) => category.name == json['category'],
      ),
      date: DateTime.parse(json['date'] as String),
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
      category: transaction.category,
      date: transaction.date,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'amount': amount,
      'type': type.name,
      'category': category.name,
      'date': date.toIso8601String(),
    };
  }
}
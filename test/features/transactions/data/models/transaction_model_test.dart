import 'package:flutter_test/flutter_test.dart';
import 'package:spend_wise/features/transactions/data/models/transaction_model.dart';
import 'package:spend_wise/features/transactions/domain/entities/transaction.dart';
import 'package:spend_wise/features/transactions/domain/entities/transaction_category.dart';

void main() {
  test('keeps unknown type and category values', () {
    final model = TransactionModel.fromJson({
      'id': 'transaction-1',
      'userId': 1,
      'title': 'Refund',
      'amount': '2500.50',
      'type': 'refund',
      'category': 'crypto',
      'date': '2026-09-28T14:30:00',
    });

    expect(model.type, TransactionType.unknown);
    expect(model.typeValue, 'refund');

    expect(model.category, TransactionCategory.unknown);
    expect(model.categoryValue, 'crypto');
  });
}
enum TransactionCategory {
  food('Food'),
  transport('Transport'),
  bills('Bills'),
  shopping('Shopping'),
  salary('Salary'),
  entertainment('Entertainment'),
  health('Health'),
  other('Other'),
  unknown('Unknown');

  const TransactionCategory(this.label);

  final String label;

  static TransactionCategory fromWire(String? value) {
    if (value == null) {
      return TransactionCategory.unknown;
    }

    switch (value.toLowerCase()) {
      case 'food':
        return TransactionCategory.food;
      case 'transport':
        return TransactionCategory.transport;
      case 'bills':
        return TransactionCategory.bills;
      case 'shopping':
        return TransactionCategory.shopping;
      case 'salary':
        return TransactionCategory.salary;
      case 'entertainment':
        return TransactionCategory.entertainment;
      case 'health':
        return TransactionCategory.health;
      case 'other':
        return TransactionCategory.other;
      default:
        return TransactionCategory.unknown;
    }
  }
}
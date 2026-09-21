enum TransactionCategory {
  food('Food'),
  transport('Transport'),
  bills('Bills'),
  shopping('Shopping'),
  salary('Salary'),
  entertainment('Entertainment'),
  health('Health'),
  other('Other');

  const TransactionCategory(this.label);

  final String label;
}
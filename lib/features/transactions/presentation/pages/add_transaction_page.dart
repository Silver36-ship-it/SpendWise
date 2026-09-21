import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/transaction.dart';
import '../providers/transaction_provider.dart';

import '../../domain/entities/transaction_category.dart';

import '../../../auth/presentation/providers/auth_provider.dart';

class AddTransactionPage extends StatefulWidget {


  final Transaction? transaction;

  const AddTransactionPage({
    super.key,
    this.transaction,
  });

  @override
  State<AddTransactionPage> createState() =>
      _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  TransactionCategory selectedCategory = TransactionCategory.other;
  TransactionType selectedType = TransactionType.expense;


  @override
  void initState() {
    super.initState();

    final transaction = widget.transaction;

    if (transaction != null) {
      titleController.text = transaction.title;
      amountController.text = transaction.amount.toString();
      selectedCategory = transaction.category;
      selectedType = transaction.type;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  Future<void> _addTransaction() async {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.user;

    final title = titleController.text.trim();
    final amount = double.tryParse(amountController.text.trim());

    if (title.isEmpty) {
      _showError('Please enter a title.');
      return;
    }

    if (amount == null || amount <= 0) {
      _showError('Please enter a valid amount.');
      return;
    }

    if (user == null) {
      _showError('You are not logged in.');
      return;
    }


    final existingTransaction = widget.transaction;

    final transaction = Transaction(
      id: existingTransaction?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      userId: user.id,
      amount: amount,
      type: selectedType,
      category: selectedCategory,
      date: existingTransaction?.date ??
          DateTime.now(),
    );

    final provider = context.read<TransactionProvider>();

    if (existingTransaction == null) {
      await provider.addTransaction(transaction);
    } else {
      await provider.updateTransaction(transaction);
    }

    if (!mounted) return;

    Navigator.pop(context);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    final transactionProvider = context.watch<TransactionProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
              ),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<TransactionCategory>(
              initialValue : selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
              ),
              items: TransactionCategory.values.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(
                    category.label,
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  selectedCategory = value;
                });
              },
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<TransactionType>(
              initialValue: selectedType,
              decoration: const InputDecoration(
                labelText: 'Type',
              ),
              items: TransactionType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(
                    type == TransactionType.income
                        ? 'Income'
                        : 'Expense',
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  selectedType = value;
                });
              },
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: transactionProvider.isLoading
                  ? null
                  : _addTransaction,
              child: transactionProvider.isLoading
                  ? const Text('Saving...')
                  : Text(
                widget.transaction == null
                    ? 'Add Transaction'
                    : 'Save Changes',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
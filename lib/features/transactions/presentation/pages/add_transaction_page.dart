import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/context_extensions.dart';
import '../../../../core/utils/size_utils.dart';
import '../../../../core/widgets/app_dropdown_field.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/custom_app_loader.dart';
import '../../../../core/widgets/purple_background.dart';
import '../../../auth/presentation/providers/riverpod_auth_provider.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/transaction_category.dart';
import '../providers/transaction_riverpod_provider.dart';

class AddTransactionPage extends ConsumerStatefulWidget {
  final Transaction? transaction;

  const AddTransactionPage({
    super.key,
    this.transaction,
  });

  @override
  ConsumerState<AddTransactionPage> createState() =>
      _AddTransactionPageState();
}

class _AddTransactionPageState
    extends ConsumerState<AddTransactionPage> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  TransactionCategory? selectedCategory;
  TransactionType? selectedType;

  bool get isEditing => widget.transaction != null;

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
    final authState = ref.read(authProvider);
    final auth = authState.valueOrNull;
    final user = auth?.user;

    final title = titleController.text.trim();

    final amount = double.tryParse(
      amountController.text.trim(),
    );

    if (title.isEmpty) {
      _showError('Please enter a title.');
      return;
    }

    if (amount == null || amount <= 0) {
      _showError('Please enter a valid amount.');
      return;
    }

    if (selectedCategory == null) {
      _showError('Please select a category.');
      return;
    }

    if (selectedType == null) {
      _showError('Please select a type.');
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

      type: selectedType!,
      typeValue: selectedType!.name,

      category: selectedCategory!,
      categoryValue: selectedCategory!.name,

      date: existingTransaction?.date ?? DateTime.now(),
    );

    final notifier =
    ref.read(transactionActionProvider(user.id).notifier);

    if (existingTransaction == null) {
      await notifier.addTransaction(transaction);
    } else {
      await notifier.updateTransaction(transaction);
    }

    if (!mounted) {
      return;
    }

    context.pop();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontSize: getFontSize(14, context),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final auth = authState.valueOrNull;
    final user = auth?.user;

    final transactionState = user == null
        ? null
        : ref.watch(transactionsProvider(user.id));

    final actionState = user == null
        ? null
        : ref.watch(transactionActionProvider(user.id));

    final textTheme = Theme.of(context).textTheme;

    final isLoading = actionState?.isLoading ?? false;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: PurpleBackground(
        child: SafeArea(
          child: Column(
            children: [
              // App bar area
              Padding(
                padding: getPadding(
                  context: context,
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: isLoading
                          ? null
                          : () {
                        context.pop();
                      },
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: context.textPrimary,
                      ),
                    ),

                    SizedBox(
                      width: getHorizontalSize(8, context),
                    ),

                    Expanded(
                      child: Text(
                        isEditing
                            ? 'Edit Transaction'
                            : 'Add Transaction',
                        style: textTheme.titleLarge?.copyWith(
                          fontSize: getFontSize(20, context),
                          color: context.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              // Page content
              Expanded(
                child: SingleChildScrollView(
                  padding: getPadding(
                    context: context,
                    all: 16,
                  ),
                  child: Column(
                    children: [
                      AppTextField(
                        controller: titleController,
                        hintText: 'Title',
                      ),

                      SizedBox(
                        height: getVerticalSize(16, context),
                      ),

                      AppTextField(
                        controller: amountController,
                        hintText: 'Amount',
                        keyboardType:
                        const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),

                      SizedBox(
                        height: getVerticalSize(16, context),
                      ),

                      AppDropdownField<TransactionCategory>(
                        value: selectedCategory,
                        hintText: 'Category',
                        items: TransactionCategory.values
                            .where(
                              (category) => category != TransactionCategory.unknown,
                        )
                            .map(
                              (category) => DropdownMenuItem(
                            value: category,
                            child: Text(category.label),
                          ),
                        )
                            .toList(),
                        onChanged: isLoading
                            ? null
                            : (value) {
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                      ),

                      SizedBox(
                        height: getVerticalSize(16, context),
                      ),

                      AppDropdownField<TransactionType>(
                        value: selectedType,
                        hintText: 'Type',
                        items: TransactionType.values
                            .where(
                              (type) => type != TransactionType.unknown,
                        )
                            .map(
                              (type) => DropdownMenuItem(
                            value: type,
                            child: Text(type.name),
                          ),
                        )
                            .toList(),
                        onChanged: isLoading
                            ? null
                            : (value) {
                          setState(() {
                            selectedType = value;
                          });
                        },
                      ),

                      SizedBox(
                        height: getVerticalSize(24, context),
                      ),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : _addTransaction,
                          child: isLoading
                              ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppLoader(
                                size: getSize(20, context),
                                color: context.accent,
                              ),
                              SizedBox(
                                width: getHorizontalSize(
                                  8,
                                  context,
                                ),
                              ),
                              Text(
                                'Saving...',
                                style: TextStyle(
                                  fontSize: getFontSize(
                                    14,
                                    context,
                                  ),
                                ),
                              ),
                            ],
                          )
                              : Text(
                            isEditing
                                ? 'Save Changes'
                                : 'Add Transaction',
                            style: TextStyle(
                              fontSize: getFontSize(
                                14,
                                context,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
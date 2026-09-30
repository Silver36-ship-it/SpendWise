import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/context_extensions.dart';
import '../../../../core/utils/size_utils.dart';
import '../../../../core/widgets/custom_app_loader.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/purple_background.dart';

import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/providers/riverpod_auth_provider.dart';

import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/presentation/providers/transaction_busy_id_provider.dart';
import '../../../transactions/presentation/providers/transaction_riverpod_provider.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({
    super.key,
  });

  @override
  ConsumerState<DashboardPage> createState() =>
      _DashboardPageState();
}

class _DashboardPageState
    extends ConsumerState<DashboardPage> {
  XFile? _profileImage;

  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();

    final image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) return;

    setState(() {
      _profileImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    final user = authState.value?.user;

    if (user == null) {
      return const Center(
        child: AppLoader(),
      );
    }

    final transactionsAsync =
    ref.watch(transactionsProvider(user.id));

    return Scaffold(
      backgroundColor:
      context.surfaceCard.withValues(alpha: 0),
      body: PurpleBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: getPadding(
              context: context,
              horizontal: 20,
              vertical: 20,
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                _buildHeader(
                  context,
                  user,
                ),

                SizedBox(
                  height: getVerticalSize(
                    24,
                    context,
                  ),
                ),

                _buildBalanceCard(
                  context,
                  transactionsAsync,
                ),

                SizedBox(
                  height: getVerticalSize(
                    24,
                    context,
                  ),
                ),

                _buildQuickActions(
                  context,
                  user,
                ),

                SizedBox(
                  height: getVerticalSize(
                    24,
                    context,
                  ),
                ),

                _buildRecentTransactions(
                  context,
                  transactionsAsync,
                  user,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context,
      User user,
      ) {
    return Row(
      children: [
        GestureDetector(
          onTap: _pickProfileImage,
          child: CircleAvatar(
            radius: getSize(
              26,
              context,
            ),
            backgroundColor: context.surfaceCard,
            backgroundImage: _profileImage != null
                ? FileImage(
              File(_profileImage!.path),
            )
                : null,
            child: _profileImage == null
                ? Icon(
              Icons.person_rounded,
              size: getSize(
                28,
                context,
              ),
              color: context.textPrimary,
            )
                : null,
          ),
        ),

        SizedBox(
          width: getHorizontalSize(
            12,
            context,
          ),
        ),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back,',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: getFontSize(
                    14,
                    context,
                  ),
                  color: context.mutedText,
                ),
              ),

              SizedBox(
                height: getVerticalSize(
                  2,
                  context,
                ),
              ),

              Text(
                user.firstName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: getFontSize(
                    20,
                    context,
                  ),
                  fontWeight: FontWeight.bold,
                  color: context.textPrimary,
                ),
              ),
            ],
          ),
        ),

        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.notifications_none_rounded,
            size: getSize(
              26,
              context,
            ),
            color: context.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceCard(
      BuildContext context,
      AsyncValue<List<Transaction>> transactionsAsync,
      ) {
    return transactionsAsync.when(
      loading: () => SizedBox(
        height: getVerticalSize(
          190,
          context,
        ),
        child: const Center(
          child: AppLoader(),
        ),
      ),
      error: (error, stackTrace) => GlassCard(
        child: SizedBox(
          width: double.infinity,
          child: Text(
            error.toString(),
            style: TextStyle(
              fontSize: getFontSize(
                14,
                context,
              ),
              color: context.mutedText,
            ),
          ),
        ),
      ),
      data: (transactions) {
        double income = 0;
        double expenses = 0;

        for (final transaction in transactions) {
          if (transaction.type ==
              TransactionType.income) {
            income += transaction.amount;
          } else {
            expenses += transaction.amount;
          }
        }

        final balance = income - expenses;

        return GlassCard(
          padding: getPadding(
            context: context,
            all: 20,
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                'Total Balance',
                style: TextStyle(
                  fontSize: getFontSize(
                    14,
                    context,
                  ),
                  color: context.mutedText,
                ),
              ),

              SizedBox(
                height: getVerticalSize(
                  8,
                  context,
                ),
              ),

              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  '₦${balance.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: getFontSize(
                      32,
                      context,
                    ),
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary,
                  ),
                ),
              ),

              SizedBox(
                height: getVerticalSize(
                  20,
                  context,
                ),
              ),

              Row(
                children: [
                  Expanded(
                    child: _buildAmountInfo(
                      context,
                      label: 'Income',
                      amount: income,
                      icon: Icons.arrow_downward_rounded,
                      color: context.income,
                    ),
                  ),

                  SizedBox(
                    width: getHorizontalSize(
                      12,
                      context,
                    ),
                  ),

                  Expanded(
                    child: _buildAmountInfo(
                      context,
                      label: 'Expenses',
                      amount: expenses,
                      icon: Icons.arrow_upward_rounded,
                      color: context.expense,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAmountInfo(
      BuildContext context, {
        required String label,
        required double amount,
        required IconData icon,
        required Color color,
      }) {
    return Row(
      children: [
        Container(
          padding: getPadding(
            context: context,
            all: 8,
          ),
          decoration: BoxDecoration(
            color: color.withValues(
              alpha: 0.15,
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: getSize(
              16,
              context,
            ),
            color: color,
          ),
        ),

        SizedBox(
          width: getHorizontalSize(
            8,
            context,
          ),
        ),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: getFontSize(
                    12,
                    context,
                  ),
                  color: context.mutedText,
                ),
              ),

              SizedBox(
                height: getVerticalSize(
                  2,
                  context,
                ),
              ),

              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  '₦${amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: getFontSize(
                      15,
                      context,
                    ),
                    fontWeight: FontWeight.w600,
                    color: context.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(
      BuildContext context,
      User user,
      ) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: getFontSize(
              18,
              context,
            ),
            fontWeight: FontWeight.bold,
            color: context.textPrimary,
          ),
        ),

        SizedBox(
          height: getVerticalSize(
            12,
            context,
          ),
        ),

        Row(
          children: [
            Expanded(
              child: _buildQuickAction(
                context,
                icon: Icons.add_rounded,
                label: 'Add',
                onTap: () {
                  context.push('/transaction');
                },
              ),
            ),

            SizedBox(
              width: getHorizontalSize(
                12,
                context,
              ),
            ),

            Expanded(
              child: _buildQuickAction(
                context,
                icon: Icons.list_alt_rounded,
                label: 'View All',
                onTap: () {
                  context.go('/transactions');
                },
              ),
            ),

            SizedBox(
              width: getHorizontalSize(
                12,
                context,
              ),
            ),

            Expanded(
              child: _buildQuickAction(
                context,
                icon: Icons.logout_rounded,
                label: 'Logout',
                onTap: () async {
                  await ref
                      .read(
                    authProvider.notifier,
                  )
                      .logout();

                  if (context.mounted) {
                    context.go('/login');
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickAction(
      BuildContext context, {
        required IconData icon,
        required String label,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: getPadding(
          context: context,
          vertical: 16,
          horizontal: 8,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: getSize(
                24,
                context,
              ),
              color: context.textPrimary,
            ),

            SizedBox(
              height: getVerticalSize(
                8,
                context,
              ),
            ),

            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: getFontSize(
                  12,
                  context,
                ),
                color: context.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactions(
      BuildContext context,
      AsyncValue<List<Transaction>> transactionsAsync,
      User user,
      ) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Recent Transactions',
                style: TextStyle(
                  fontSize: getFontSize(
                    18,
                    context,
                  ),
                  fontWeight: FontWeight.bold,
                  color: context.textPrimary,
                ),
              ),
            ),

            TextButton(
              onPressed: () {
                context.go('/transactions');
              },
              child: Text(
                'View All',
                style: TextStyle(
                  fontSize: getFontSize(
                    13,
                    context,
                  ),
                  color: context.textPrimary,
                ),
              ),
            ),
          ],
        ),

        SizedBox(
          height: getVerticalSize(
            8,
            context,
          ),
        ),

        transactionsAsync.when(
          loading: () => const Center(
            child: AppLoader(),
          ),
          error: (error, stackTrace) => GlassCard(
            child: Text(
              error.toString(),
              style: TextStyle(
                fontSize: getFontSize(
                  14,
                  context,
                ),
                color: context.mutedText,
              ),
            ),
          ),
          data: (transactions) {
            if (transactions.isEmpty) {
              return GlassCard(
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    'No transactions yet.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: getFontSize(
                        14,
                        context,
                      ),
                      color: context.mutedText,
                    ),
                  ),
                ),
              );
            }

            final recentTransactions =
            transactions.take(5).toList();

            return Column(
              children: recentTransactions.map(
                    (transaction) {
                  return Padding(
                    padding: getPadding(
                      context: context,
                      bottom: 10,
                    ),
                    child: _buildTransactionItem(
                      context,
                      transaction,
                      user,
                    ),
                  );
                },
              ).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTransactionItem(
      BuildContext context,
      Transaction transaction,
      User user,
      ) {
    final isIncome =
        transaction.type == TransactionType.income;

    final busyId =
    ref.watch(
      transactionBusyIdProvider(user.id),
    );

    final isBusy =
        busyId == transaction.id;

    return GlassCard(
      padding: getPadding(
        context: context,
        horizontal: 14,
        vertical: 12,
      ),
      child: Row(
        children: [
          Container(
            width: getSize(
              42,
              context,
            ),
            height: getSize(
              42,
              context,
            ),
            decoration: BoxDecoration(
              color: (isIncome
                  ? context.income
                  : context.expense)
                  .withValues(
                alpha: 0.15,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isIncome
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
              size: getSize(
                20,
                context,
              ),
              color: isIncome
                  ? context.income
                  : context.expense,
            ),
          ),

          SizedBox(
            width: getHorizontalSize(
              12,
              context,
            ),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: getFontSize(
                      14,
                      context,
                    ),
                    fontWeight: FontWeight.w600,
                    color: context.textPrimary,
                  ),
                ),

                SizedBox(
                  height: getVerticalSize(
                    3,
                    context,
                  ),
                ),

                Text(
                  transaction.category.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: getFontSize(
                      12,
                      context,
                    ),
                    color: context.mutedText,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            width: getHorizontalSize(
              8,
              context,
            ),
          ),

          Column(
            crossAxisAlignment:
            CrossAxisAlignment.end,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Text(
                  '${isIncome ? '+' : '-'}₦${transaction.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: getFontSize(
                      14,
                      context,
                    ),
                    fontWeight: FontWeight.w600,
                    color: isIncome
                        ? context.income
                        : context.expense,
                  ),
                ),
              ),

              SizedBox(
                height: getVerticalSize(
                  6,
                  context,
                ),
              ),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    visualDensity:
                    VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(
                      minWidth: getSize(
                        32,
                        context,
                      ),
                      minHeight: getSize(
                        32,
                        context,
                      ),
                    ),
                    onPressed: isBusy
                        ? null
                        : () {
                      context.push(
                        '/transaction/edit',
                        extra: transaction,
                      );
                    },
                    icon: Icon(
                      Icons.edit_rounded,
                      size: getSize(
                        18,
                        context,
                      ),
                      color: context.textPrimary,
                    ),
                  ),

                  IconButton(
                    visualDensity:
                    VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(
                      minWidth: getSize(
                        32,
                        context,
                      ),
                      minHeight: getSize(
                        32,
                        context,
                      ),
                    ),
                    onPressed: isBusy
                        ? null
                        : () async {
                      await ref
                          .read(
                        transactionActionProvider(
                          user.id,
                        ).notifier,
                      )
                          .deleteTransaction(
                        transaction.id,
                        user.id,
                      );
                    },
                    icon: isBusy
                        ? AppLoader(
                      size: getSize(
                        18,
                        context,
                      ),
                    )
                        : Icon(
                      Icons.delete_outline_rounded,
                      size: getSize(
                        18,
                        context,
                      ),
                      color: context.expense,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/domain/entities/user.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/presentation/pages/add_transaction_page.dart';
import '../../../transactions/presentation/providers/transaction_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

import '../../../auth/presentation/pages/login_page.dart';

import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/purple_background.dart';

import 'package:image_picker/image_picker.dart';

import '../../../transactions/domain/entities/transaction_category.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int selectedIndex = 0;

  XFile? _profileImage;



  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context
          .read<AuthProvider>()
          .user;

      if (user == null) {
        return;
      }

      context
          .read<TransactionProvider>()
          .loadTransactions(user.id);
    });
  }

  double get totalIncome {
    final transactions =
        context.read<TransactionProvider>().transactions;

    return transactions
        .where((transaction) => transaction.type == TransactionType.income)
        .fold(0.0, (total, transaction) => total + transaction.amount);
  }

  double get totalExpenses {
    final transactions =
        context.read<TransactionProvider>().transactions;

    return transactions
        .where((transaction) => transaction.type == TransactionType.expense)
        .fold(0.0, (total, transaction) => total + transaction.amount);
  }

  double get balance {
    return totalIncome - totalExpenses;
  }

  Future<void> _logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text(
            'Are you sure you want to logout?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true) {
      return;
    }

    await context.read<AuthProvider>().logout();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginPage(),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _showTransactionOptions(
      Transaction transaction,
      ) async {
    final action = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(transaction.title),
          content: const Text(
            'What would you like to do with this transaction?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'edit');
              },
              child: const Text('Edit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'delete');
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'cancel');
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    if (action == 'edit') {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AddTransactionPage(
            transaction: transaction,
          ),
        ),
      );

      return;
    }

    if (action == 'delete') {
      await context
          .read<TransactionProvider>()
          .deleteTransaction(transaction.id, transaction.userId);
    }
  }

  Future<void> _pickProfileImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedImage == null) return;

    setState(() {
      _profileImage = pickedImage;
    });
  }


  @override
  Widget build(BuildContext context) {

    final authProvider = context.watch<AuthProvider>();
    final transactionProvider = context.watch<TransactionProvider>();

    final user = authProvider.user;

    return Scaffold(
      backgroundColor: Colors.transparent,

      body: PurpleBackground(
        child: Column(
          children: [
            Expanded(
              child: transactionProvider.isLoading
                  ? const Center(
                child: Text(
                  'Loading...',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
                  : _buildCurrentPage(user),
            ),

            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

Widget _buildCurrentPage(User? user) {
  switch (selectedIndex) {
    case 0:
      return _buildHomePage(user);

    case 1:
      return _buildTransactionsPage();

    case 2:
      return _buildCategoriesPage();

    case 3:
      return _buildMorePage();

    default:
      return _buildHomePage(user);
  }
}

  Widget _buildTransactionsPage() {
    return const Center(
      child: Text(
        'Transactions',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
      ),
    );
  }

  Widget _buildCategoriesPage() {
    return const Center(
      child: Text(
        'Categories',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
      ),
    );
  }

  Widget _buildMorePage() {
    return const Center(
      child: Text(
        'More',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
      ),
    );
  }

  Widget _buildHomePage(User? user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(user),

          const SizedBox(height: 24),

          _buildBalanceCard(),

          const SizedBox(height: 20),

          _buildQuickActions(),

          const SizedBox(height: 24),

          _buildRecentTransactions(),
        ],
      ),
    );
  }

  Widget _buildHeader(User? user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'SpendWise',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              'Welcome, ${user?.firstName ?? 'User'}!',
              style: TextStyle(
                color: Colors.white.withOpacity(0.65),
                fontSize: 14,
              ),
            ),
          ],
        ),

        GestureDetector(
          onTap: _pickProfileImage,
          child: CircleAvatar(
            radius: 30,
            backgroundImage: _profileImage != null
                ? NetworkImage(_profileImage!.path)
                : null,
            child: _profileImage == null
                ? const Icon(Icons.person)
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceCard() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Balance',
            style: TextStyle(
              color: Colors.white.withOpacity(0.70),
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            '₦${balance.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(
                Icons.account_balance_wallet_outlined,
                color: Colors.white70,
                size: 18,
              ),

              const SizedBox(width: 6),

              Text(
                'Income - Expenses',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.65),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _buildQuickAction(
            icon: Icons.add_rounded,
            label: 'Add',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddTransactionPage(),
                ),
              );
            },
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _buildQuickAction(
            icon: Icons.list_rounded,
            label: 'View All',
            onTap: () {
              setState(() {
                selectedIndex = 1;
              });
            },
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _buildQuickAction(
            icon: Icons.logout_rounded,
            label: 'Logout',
            onTap: _logout,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 8,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),

            const SizedBox(height: 8),

            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactions() {
    final transactionProvider =
    context.watch<TransactionProvider>();

    final transactions = transactionProvider.transactions;

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Transactions',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = 1;
                  });
                },
                child: Text(
                  'See All →',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.70),
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          if (transactions.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
              ),
              child: Center(
                child: Text(
                  'No transactions yet.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.60),
                  ),
                ),
              ),
            )
          else
            ...transactions.take(5).map(
                  (transaction) {
                return _buildTransactionItem(
                  transaction,
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(
      Transaction transaction,
      ) {
    final isIncome =
        transaction.type == TransactionType.income;

    return GestureDetector(
      onTap: () {
        _showTransactionOptions(transaction);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isIncome
                    ? Icons.arrow_downward_rounded
                    : Icons.arrow_upward_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    '${transaction.category.label} • '
                        '${_formatDate(transaction.date)}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.55),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            Text(
              '${isIncome ? '+' : '-'}'
                  '₦${transaction.amount.toStringAsFixed(2)}',
              style: TextStyle(
                color: isIncome
                    ? Colors.greenAccent
                    : Colors.pinkAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        8,
        16,
        16,
      ),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              icon: Icons.home_rounded,
              label: 'Home',
              index: 0,
            ),

            _buildNavItem(
              icon: Icons.swap_horiz_rounded,
              label: 'Transactions',
              index: 1,
            ),

            _buildNavItem(
              icon: Icons.pie_chart_rounded,
              label: 'Categories',
              index: 2,
            ),

            _buildNavItem(
              icon: Icons.more_horiz_rounded,
              label: 'More',
              index: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 200,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.18)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 22,
            ),

            const SizedBox(height: 4),

            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(
                  isSelected ? 1.0 : 0.60,
                ),
                fontSize: 10,
                fontWeight: isSelected
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
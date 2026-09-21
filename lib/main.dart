import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/network/api_client.dart';
import 'core/storage/token_storage.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'features/transactions/data/datasources/transaction_local_data_source.dart';
import 'features/transactions/data/repositories/transaction_repository_impl.dart';
import 'features/transactions/presentation/providers/transaction_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await SharedPreferences.getInstance();

  final tokenStorage = TokenStorage(
    preferences: preferences,
  );

  final apiClient = ApiClient(
    tokenStorage: tokenStorage,
  );

  final dataSource = AuthRemoteDataSource(
    apiClient: apiClient,
  );

  final repository = AuthRepositoryImpl(
    dataSource: dataSource,
    tokenStorage: tokenStorage,
  );

  final transactionDataSource = TransactionLocalDataSource(preferences: preferences);

  final transactionRepository = TransactionRepositoryImpl(
    dataSource: transactionDataSource,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            repository: repository,
            tokenStorage: tokenStorage
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => TransactionProvider(
            repository: transactionRepository,
          ),
        ),
      ],
      child: const SpendWiseApp(),
    ),
  );
}

class SpendWiseApp extends StatefulWidget {
  const SpendWiseApp({super.key});

  @override
  State<SpendWiseApp> createState() =>
      _SpendWiseAppState();
}

class _SpendWiseAppState extends State<SpendWiseApp> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().restoreSession();
    });
  }
  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    if (authProvider.isInitializing) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Checking saved login...'),
          ),
        ),
      );
    }

    return MaterialApp(
      home: authProvider.user == null
          ? const LoginPage()
          : const DashboardPage(),
    );
  }
}
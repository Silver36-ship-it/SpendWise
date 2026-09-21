import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../../../dashboard/presentation/pages/dashboard_page.dart';
import 'registration_page.dart';
import '../../../../core/widgets/purple_background.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    await context.read<AuthProvider>().login(
      username: usernameController.text.trim(),
      password: passwordController.text,
    );

    if (!mounted) return;

    final authProvider = context.read<AuthProvider>();

    if (authProvider.user != null) {
      await authProvider.verifyAuthentication();

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const DashboardPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: PurpleBackground(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 40),

              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
              ),

              const SizedBox(height: 24),

              if (authProvider.errorMessage != null)
                Text(
                  authProvider.errorMessage!,
                ),

              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: authProvider.isLoading ? null : _login,
                child: authProvider.isLoading
                    ? const Text('Logging in...')
                    : const Text('Login'),
              ),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RegisterPage(),
                    ),
                  );
                },
                child: const Text('Create an account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
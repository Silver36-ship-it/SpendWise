import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

import '../../../dashboard/presentation/pages/dashboard_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (passwordController.text != confirmPasswordController.text) {
      return;
    }

    final authProvider = context.read<AuthProvider>();

    final user = await authProvider.register(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      username: usernameController.text.trim(),
      password: passwordController.text,
    );

    if (!mounted) return;

    if (user != null) {
      await authProvider.loginAfterRegistration(
        user: user,
      );

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
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(
                labelText: 'First name',
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(
                labelText: 'Last name',
              ),
            ),

            const SizedBox(height: 16),

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

            const SizedBox(height: 16),

            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm password',
              ),
            ),

            const SizedBox(height: 24),

            if (authProvider.errorMessage != null)
              Text(
                authProvider.errorMessage!,
              ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: authProvider.isLoading ? null : _register,
              child: authProvider.isLoading
                  ? const Text('Creating account...')
                  : const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
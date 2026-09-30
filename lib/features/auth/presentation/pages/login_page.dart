import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/context_extensions.dart';
import '../../../../core/utils/size_utils.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/custom_app_loader.dart';
import '../../../../core/widgets/purple_background.dart';

import '../providers/riverpod_auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  String? _validationError;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _validationError = null;
    });

    final username = usernameController.text.trim();
    final password = passwordController.text;

    // Local validation
    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _validationError = 'Please enter your username and password.';
      });
      return;
    }

    await ref.read(authProvider.notifier).login(
      username: username,
      password: password,
    );

    if (!mounted) return;

    final authState = ref.read(authProvider);

    if (authState.hasError) {
      return;
    }

    final auth = authState.valueOrNull;

    if (auth?.user != null) {
      await ref
          .read(authProvider.notifier)
          .verifyAuthentication();

      if (!mounted) return;

      context.go('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final auth = authState.valueOrNull;

    final textTheme = Theme.of(context).textTheme;

    final isLoading = auth?.isLoading ?? false;

    final errorMessage = _validationError ??
        (authState.hasError ? authState.error.toString() : null);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: PurpleBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: getPadding(
              context: context,
              all: 16,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: getVerticalSize(40, context),
                ),

                Text(
                  'Login',
                  style: textTheme.headlineMedium?.copyWith(
                    fontSize: getFontSize(28, context),
                    color: context.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(
                  height: getVerticalSize(40, context),
                ),

                AppTextField(
                  controller: usernameController,
                  hintText: 'Username',
                ),

                SizedBox(
                  height: getVerticalSize(16, context),
                ),

                AppTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                SizedBox(
                  height: getVerticalSize(24, context),
                ),

                if (errorMessage != null)
                  Padding(
                    padding: getPadding(
                      context: context,
                      horizontal: 8,
                    ),
                    child: Text(
                      errorMessage,
                      style: textTheme.bodyMedium?.copyWith(
                        fontSize: getFontSize(14, context),
                        color: context.expense,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                if (errorMessage != null)
                  SizedBox(
                    height: getVerticalSize(16, context),
                  ),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _login,
                    child: isLoading
                        ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppLoader(
                          size: getSize(20, context),
                          color: context.accent,
                        ),
                        SizedBox(
                          width: getHorizontalSize(8, context),
                        ),
                        Text(
                          'Logging in...',
                          style: TextStyle(
                            fontSize: getFontSize(14, context),
                          ),
                        ),
                      ],
                    )
                        : Text(
                      'Login',
                      style: TextStyle(
                        fontSize: getFontSize(14, context),
                      ),
                    ),
                  ),
                ),

                TextButton(
                  onPressed: () {
                    context.push('/register');
                  },
                  child: Text(
                    'Create an account',
                    style: textTheme.labelLarge?.copyWith(
                      fontSize: getFontSize(14, context),
                      color: context.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/context_extensions.dart';
import '../../../../core/utils/size_utils.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/custom_app_loader.dart';
import '../../../../core/widgets/purple_background.dart';

import '../providers/riverpod_auth_provider.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({
    super.key,
  });

  @override
  ConsumerState<RegisterPage> createState() =>
      _RegisterPageState();
}

class _RegisterPageState
    extends ConsumerState<RegisterPage> {
  final firstNameController =
  TextEditingController();

  final lastNameController =
  TextEditingController();

  final usernameController =
  TextEditingController();

  final passwordController =
  TextEditingController();

  final confirmPasswordController =
  TextEditingController();

  String? _validationError;

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
    setState(() {
      _validationError = null;
    });

    final firstName =
    firstNameController.text.trim();

    final lastName =
    lastNameController.text.trim();

    final username =
    usernameController.text.trim();

    final password =
        passwordController.text;

    final confirmPassword =
        confirmPasswordController.text;

    // Check for empty fields.
    if (firstName.isEmpty ||
        lastName.isEmpty ||
        username.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      setState(() {
        _validationError =
        'Please fill in all fields.';
      });

      return;
    }

    // Check password match.
    if (password != confirmPassword) {
      setState(() {
        _validationError =
        'Passwords do not match.';
      });

      return;
    }

    final user = await ref
        .read(authProvider.notifier)
        .register(
      firstName: firstName,
      lastName: lastName,
      username: username,
      password: password,
    );

    if (!mounted) return;

    if (user != null) {
      await ref
          .read(authProvider.notifier)
          .loginAfterRegistration(
        user: user,
      );

      if (!mounted) return;

      context.go('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    final auth = authState.valueOrNull;

    final isLoading =
        auth?.isLoading ?? false;

    final errorMessage =
        _validationError ??
            (authState.hasError
                ? authState.error.toString()
                : null);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: PurpleBackground(
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                foregroundColor:
                context.textPrimary,
                title: Text(
                  'Register',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                    color:
                    context.textPrimary,
                    fontSize: getFontSize(
                      22,
                      context,
                    ),
                  ),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: getPadding(
                    context: context,
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Column(
                    children: [
                      AppTextField(
                        controller:
                        firstNameController,
                        hintText: 'First name',
                      ),

                      SizedBox(
                        height: getVerticalSize(
                          16,
                          context,
                        ),
                      ),

                      AppTextField(
                        controller:
                        lastNameController,
                        hintText: 'Last name',
                      ),

                      SizedBox(
                        height: getVerticalSize(
                          16,
                          context,
                        ),
                      ),

                      AppTextField(
                        controller:
                        usernameController,
                        hintText: 'Username',
                      ),

                      SizedBox(
                        height: getVerticalSize(
                          16,
                          context,
                        ),
                      ),

                      AppTextField(
                        controller:
                        passwordController,
                        obscureText: true,
                        hintText: 'Password',
                      ),

                      SizedBox(
                        height: getVerticalSize(
                          16,
                          context,
                        ),
                      ),

                      AppTextField(
                        controller:
                        confirmPasswordController,
                        obscureText: true,
                        hintText:
                        'Confirm password',
                      ),

                      SizedBox(
                        height: getVerticalSize(
                          24,
                          context,
                        ),
                      ),

                      if (errorMessage != null) ...[
                        Text(
                          errorMessage,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                            color:
                            context.expense,
                            fontSize:
                            getFontSize(
                              14,
                              context,
                            ),
                          ),
                        ),

                        SizedBox(
                          height: getVerticalSize(
                            16,
                            context,
                          ),
                        ),
                      ],

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                          isLoading
                              ? null
                              : _register,
                          child: isLoading
                              ? Row(
                            mainAxisAlignment:
                            MainAxisAlignment
                                .center,
                            children: [
                              AppLoader(
                                size:
                                getSize(
                                  20,
                                  context,
                                ),
                              ),

                              SizedBox(
                                width:
                                getHorizontalSize(
                                  8,
                                  context,
                                ),
                              ),

                              Text(
                                'Creating account...',
                                style: TextStyle(
                                  fontSize:
                                  getFontSize(
                                    14,
                                    context,
                                  ),
                                ),
                              ),
                            ],
                          )
                              : Text(
                            'Register',
                            style: TextStyle(
                              fontSize:
                              getFontSize(
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
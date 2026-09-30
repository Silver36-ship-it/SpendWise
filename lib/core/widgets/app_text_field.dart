import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool obscureText;

  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.keyboardType,
    this.obscureText = false
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: AppColors.inputText,
      ),
      decoration: InputDecoration(
        hintText: hintText,
      ),
    );
  }
}
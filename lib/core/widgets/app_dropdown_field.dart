import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AppDropdownField<T> extends StatelessWidget {
  final T? value;
  final String hintText;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;

  const AppDropdownField({
    super.key,
    required this.value,
    required this.hintText,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme
        .of(context)
        .textTheme;

    return DropdownButtonFormField<T>(
      initialValue: value,

      style: textTheme.bodyMedium?.copyWith(
        color: AppColors.inputText,
      ),

      decoration: InputDecoration(
        hintText: hintText,
      ),

      items: items,

      onChanged: onChanged,
    );
  }
}
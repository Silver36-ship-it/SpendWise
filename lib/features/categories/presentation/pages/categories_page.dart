import 'package:flutter/material.dart';

import '../../../../core/theme/context_extensions.dart';
import '../../../../core/widgets/purple_background.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: PurpleBackground(
        child: Center(
          child: Text(
            'Categories',
            style: Theme
                .of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(
              color: context.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/theme/context_extensions.dart';
import '../../../../core/widgets/purple_background.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: PurpleBackground(
        child: Center(
          child: Text(
            'Transactions',
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

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:spend_wise/features/transactions/presentation/providers/transaction_busy_id_provider.dart';

void main() {
  test(
    'transactionBusyIdProvider starts with null',
        () {
      final container = ProviderContainer();

      addTearDown(container.dispose);

      final busyId = container.read(
        transactionBusyIdProvider(1),
      );

      expect(busyId, isNull);
    },
  );

  test(
    'transactionBusyIdProvider stores the busy transaction ID',
        () {
      final container = ProviderContainer();

      addTearDown(container.dispose);

      container
          .read(
        transactionBusyIdProvider(1).notifier,
      )
          .state = 'transaction-123';

      final busyId = container.read(
        transactionBusyIdProvider(1),
      );

      expect(busyId, 'transaction-123');
    },
  );

  test(
    'transactionBusyIdProvider can be cleared',
        () {
      final container = ProviderContainer();

      addTearDown(container.dispose);

      final notifier = container.read(
        transactionBusyIdProvider(1).notifier,
      );

      notifier.state = 'transaction-123';
      expect(
        container.read(
          transactionBusyIdProvider(1),
        ),
        'transaction-123',
      );

      notifier.state = null;

      expect(
        container.read(
          transactionBusyIdProvider(1),
        ),
        isNull,
      );
    },
  );
}
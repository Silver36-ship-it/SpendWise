import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionBusyIdProvider = StateProvider.autoDispose.family<String?, int>((ref, userId) => null,
);

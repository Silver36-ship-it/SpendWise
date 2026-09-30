
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/api_client.dart';
import 'token_storage_provider.dart';

final apiClientProvider =
  FutureProvider<ApiClient>((ref) async {
    final tokenStorage =
      await ref.watch(tokenStorageProvider);

  return ApiClient(
    tokenStorage: tokenStorage,
  );
});

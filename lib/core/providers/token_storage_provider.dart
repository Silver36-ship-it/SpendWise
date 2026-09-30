import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../storage/token_storage.dart';

final tokenStorageProvider =
  Provider<TokenStorage>((ref)  {

  return TokenStorage(
    storage: const FlutterSecureStorage(),
  );
});

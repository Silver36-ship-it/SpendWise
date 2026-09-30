
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/api_client_provider.dart';
import '../../../../core/providers/token_storage_provider.dart';

import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';

final authRemoteDataSourceProvider =
    FutureProvider<AuthRemoteDataSource>((ref) async {
      final apiClient =
        await ref.watch(apiClientProvider.future);

    return AuthRemoteDataSource(
        apiClient: apiClient,
      );
    });

final authRepositoryProvider =
    FutureProvider<AuthRepository>((ref) async {
      final dataSource =
        await ref.watch(authRemoteDataSourceProvider.future);

  final tokenStorage =
  await ref.watch(tokenStorageProvider);

  return AuthRepositoryImpl(
    dataSource: dataSource,
    tokenStorage: tokenStorage,
  );
});

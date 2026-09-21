import 'package:dio/dio.dart';

import '../storage/token_storage.dart';

class ApiClient {
  final Dio _dio;
  final TokenStorage tokenStorage;

  ApiClient({
    required this.tokenStorage,
  }) : _dio = Dio(
    BaseOptions(
      baseUrl: 'https://dummyjson.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  Future<Response<dynamic>> post(
      String path, {
        Map<String, dynamic>? data,
        bool requiresToken = false,
      }) async {
    final headers = <String, dynamic>{};

    if (requiresToken) {
      final token = await tokenStorage.getAccessToken();

      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return _dio.post(
      path,
      data: data,
      options: Options(
        headers: headers,
      ),
    );
  }

  Future<Response<dynamic>> get(
      String path, {
        bool requiresToken = false,
      }) async {
    final headers = <String, dynamic>{};

    if (requiresToken) {
      final token = await tokenStorage.getAccessToken();

      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return _dio.get(
      path,
      options: Options(
        headers: headers,
      ),
    );
  }
}
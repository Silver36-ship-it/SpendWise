import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AuthRemoteDataSource {
  final ApiClient apiClient;

  const AuthRemoteDataSource({
    required this.apiClient,
  });

  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.login,
        data: {
          'username': username,
          'password': password,
        },
      );

      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      debugPrint('STATUS CODE: ${e.response?.statusCode}');
      debugPrint('RESPONSE DATA: ${e.response?.data}');
      debugPrint('REQUEST DATA: ${e.requestOptions.data}');

      rethrow;
    }
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    final response = await apiClient.get(
      ApiEndpoints.me,
      requiresToken: true,
    );

    return Map<String, dynamic>.from(response.data);
  }

  Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String username,
    required String password,
  }) async {
    final response = await apiClient.post(
      ApiEndpoints.register,
      data: {
        'firstName': firstName,
        'lastName': lastName,
        'username': username,
        'password': password,
      },
    );

    return Map<String, dynamic>.from(response.data);
  }
}
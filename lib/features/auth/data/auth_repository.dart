import 'dart:convert';
import 'package:dio/dio.dart';
import '../domain/auth_models.dart';
import '../../../core/storage/secure_storage.dart';

class AuthRepository {
  final Dio _dio;
  final _storage = SecureStorage();

  AuthRepository(this._dio);

  Future<Map<String, dynamic>> login({
    required String admissionNo,
    required String password,
    required String schoolCode,
  }) async {
    final response = await _dio.post('/auth/student/login', data: {
      'admission_no': admissionNo,
      'password': password,
      'school_code': schoolCode,
    });

    if (response.data['success'] == true) {
      final data = response.data['data'];
      final user = AuthUser.fromJson(data['user']);
      final token = data['token'];
      final refreshToken = data['refresh_token'] ?? '';

      await _storage.saveToken(token);
      await _storage.saveRefreshToken(refreshToken);
      await _storage.saveUser(jsonEncode(user.toJson()));

      return {
        'user': user,
        'token': token,
      };
    } else {
      throw Exception(response.data['message'] ?? 'Login failed');
    }
  }

  Future<void> logout() async {
    await _storage.clearAll();
  }

  Future<AuthUser?> getSavedUser() async {
    final userJson = await _storage.getUser();
    if (userJson != null) {
      return AuthUser.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  Future<String?> getSavedToken() async {
    return await _storage.getToken();
  }
}

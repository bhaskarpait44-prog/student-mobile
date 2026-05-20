import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/app_config.dart';
import '../storage/secure_storage.dart';

final apiClientProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: AppConfig.apiBaseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {'Content-Type': 'application/json'},
  ));

  dio.interceptors.add(AuthInterceptor(ref));
  dio.interceptors.add(LogInterceptor(
    requestHeader: true,
    requestBody: true,
    responseHeader: false,
    responseBody: true,
    error: true,
  ));

  return dio;
});

class AuthInterceptor extends Interceptor {
  final Ref _ref;
  final _storage = SecureStorage();
  bool _isRefreshing = false;

  AuthInterceptor(this._ref);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _storage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;
      try {
        final refreshToken = await _storage.getRefreshToken();
        if (refreshToken != null) {
          final dio = Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl));
          final response = await dio.post('/auth/refresh', data: {
            'refresh_token': refreshToken,
          });

          if (response.statusCode == 200) {
            final data = response.data['data'];
            final newToken = data['token'];
            final newRefreshToken = data['refresh_token'];

            await _storage.saveToken(newToken);
            await _storage.saveRefreshToken(newRefreshToken);

            // Retry the original request
            final options = err.requestOptions;
            options.headers['Authorization'] = 'Bearer $newToken';
            
            final retryResponse = await dio.fetch(options);
            _isRefreshing = false;
            return handler.resolve(retryResponse);
          }
        }
      } catch (e) {
        // Refresh failed, logout
        // We can't easily call ref.read(authProvider.notifier).logout() here
        // if it creates a circular dependency, but we can clear storage and navigate
        await _storage.clearAll();
        // Trigger a navigation or state change if possible
      } finally {
        _isRefreshing = false;
      }
    }
    return handler.next(err);
  }
}

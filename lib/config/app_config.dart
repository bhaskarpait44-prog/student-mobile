import 'package:flutter_riverpod/flutter_riverpod.dart';

final serverIpProvider = StateProvider<String>((ref) => AppConfig.serverIp);

class AppConfig {
  static const String appName = 'EduCore Student';
  static const String baseUrl = 'https://eduhard-backend.onrender.com';
  
  static String get apiBaseUrl => '$baseUrl/api';
  static String get uploadsUrl => '$baseUrl/uploads';

  // Legacy support for providers that might still look for serverIp
  static String get serverIp => 'eduhard-backend.onrender.com';
}

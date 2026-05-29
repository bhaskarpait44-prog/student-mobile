import 'package:flutter_riverpod/flutter_riverpod.dart';

final serverIpProvider = StateProvider<String>((ref) => AppConfig.serverIp);

class AppConfig {
  static const String appName = 'EduCore Student';
  static String _serverIp = '10.75.163.32';
  
  static String get serverIp => _serverIp;
  static String get baseUrl => 'http://$_serverIp:5000';
  static String get apiBaseUrl => '$baseUrl/api';
  static String get uploadsUrl => '$baseUrl/uploads';

  static void setServerIp(String ip) {
    _serverIp = ip;
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serverIpProvider = StateProvider<String>((ref) => AppConfig.serverIp);

class AppConfig {
  static const String appName = 'EduCore Student';
  static const String defaultServerIp = '10.226.18.216:5000';
  
  static String _currentServerIp = defaultServerIp;

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _currentServerIp = prefs.getString('custom_server_ip') ?? defaultServerIp;
  }

  static Future<void> setServerIp(String ip) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('custom_server_ip', ip);
    _currentServerIp = ip;
  }

  static String get serverIp => _currentServerIp;

  static String get baseUrl {
    if (_currentServerIp.contains('onrender.com')) {
      return 'https://$_currentServerIp';
    }
    if (!_currentServerIp.startsWith('http://') && !_currentServerIp.startsWith('https://')) {
      return 'http://$_currentServerIp';
    }
    return _currentServerIp;
  }
  
  static String get apiBaseUrl => '$baseUrl/api';
  static String get uploadsUrl => '$baseUrl/uploads';
}

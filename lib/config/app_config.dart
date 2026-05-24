class AppConfig {
  static const String appName = 'EduCore Student';
  static String _serverIp = '10.75.163.32';
  
  static String get serverIp => _serverIp;
  static String get apiBaseUrl => 'http://$_serverIp:5000/api';
  static String get uploadsUrl => 'http://$_serverIp:5000/uploads';

  static void setServerIp(String ip) {
    _serverIp = ip;
  }
}

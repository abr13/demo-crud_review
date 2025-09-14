class Environment {
  static const String _baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://192.168.1.16:3000/v1',
  );

  static const String _environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );

  static const bool _isProduction =
      String.fromEnvironment('ENVIRONMENT', defaultValue: 'development') ==
      'production';

  static String get baseUrl => _baseUrl;
  static String get environment => _environment;
  static bool get isProduction => _isProduction;

  // Development URLs
  static const String devBaseUrl = 'http://192.168.1.16:3000/v1';
  static const String localBaseUrl = 'http://localhost:3000/v1';

  // Production URLs (example)
  static const String prodBaseUrl = 'https://api.crudreview.com/v1';

  static String getCurrentBaseUrl() {
    switch (_environment) {
      case 'production':
        return prodBaseUrl;
      case 'development':
        return devBaseUrl;
      case 'local':
        return localBaseUrl;
      default:
        return _baseUrl;
    }
  }
}



import '../config/environment.dart';

class ApiConstants {
  static String get baseUrl => Environment.getCurrentBaseUrl();
  static const String searchEndpoint = '/search';
  static const String placeEndpoint = '/place';
  static const String deeplinkEndpoint = '/deeplink';
  static const String healthEndpoint = '/health';

  // Default values
  static const int defaultRadius = 1500; // meters
  static const int defaultLimit = 10;
  static const int maxLimit = 20;
  static const int maxRadius = 5000; // meters

  // Timeouts
  static const int connectTimeout = 5000; // milliseconds
  static const int receiveTimeout = 5000; // milliseconds

  // Default location (Bangalore)
  static const double defaultLat = 12.9716;
  static const double defaultLng = 77.5946;
}

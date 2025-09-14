import 'package:url_launcher/url_launcher.dart';

class DeeplinkService {
  /// Open Google Maps using business name and address
  /// This is the most reliable approach for finding locations
  static Future<void> openRestaurantInMaps(
    String businessName,
    String address,
  ) async {
    try {
      final encodedName = Uri.encodeComponent(businessName);
      final encodedAddress = Uri.encodeComponent(address);
      final url =
          'https://www.google.com/maps/place/?q=$encodedName+$encodedAddress';

      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('Could not launch Google Maps');
      }
    } catch (e) {
      throw Exception('Could not launch maps: $e');
    }
  }

  /// Open Google Maps with business information
  /// Constructs URL locally without any API calls
  Future<void> openGoogleMaps({
    String? businessName,
    String? address,
    double? latitude,
    double? longitude,
  }) async {
    try {
      String url;

      // If we have coordinates, use them directly
      if (latitude != null && longitude != null) {
        url = 'https://www.google.com/maps/place/?q=$latitude,$longitude';
      } else if (businessName != null && address != null) {
        // Use business name and address
        final encodedName = Uri.encodeComponent(businessName);
        final encodedAddress = Uri.encodeComponent(address);
        url =
            'https://www.google.com/maps/place/?q=$encodedName+$encodedAddress';
      } else if (businessName != null) {
        // Use only business name
        final encodedName = Uri.encodeComponent(businessName);
        url = 'https://www.google.com/maps/place/?q=$encodedName';
      } else {
        throw Exception('No location information available');
      }

      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('Could not launch Google Maps');
      }
    } catch (e) {
      throw Exception('Could not launch Google Maps: $e');
    }
  }
}

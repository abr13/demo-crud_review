import 'package:json_annotation/json_annotation.dart';
import '../../search/models/search_result.dart';

part 'business.g.dart';

@JsonSerializable()
class Business {
  final String placeId;
  final String name;
  final double rating;
  final int userRatingsTotal;
  final String category;
  final String locality;
  final int distanceMeters;

  const Business({
    required this.placeId,
    required this.name,
    required this.rating,
    required this.userRatingsTotal,
    required this.category,
    required this.locality,
    required this.distanceMeters,
  });

  factory Business.fromJson(Map<String, dynamic> json) =>
      _$BusinessFromJson(json);

  Map<String, dynamic> toJson() => _$BusinessToJson(this);

  factory Business.fromSearchResult(SearchResult searchResult) {
    return Business(
      placeId: searchResult.placeId,
      name: searchResult.name,
      rating: searchResult.rating,
      userRatingsTotal: searchResult.userRatingsTotal,
      category: searchResult.category,
      locality: searchResult.locality,
      distanceMeters: searchResult.distanceMeters,
    );
  }

  /// Generate Google Maps URL using business name and address (more reliable than place_id)
  String getGoogleMapsUrl() {
    final encodedName = Uri.encodeComponent(name);
    final encodedLocality = Uri.encodeComponent(locality);
    return 'https://www.google.com/maps/place/?q=$encodedName+$encodedLocality';
  }
}

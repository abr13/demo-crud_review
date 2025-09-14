import 'package:json_annotation/json_annotation.dart';

part 'search_result.g.dart';

@JsonSerializable()
class SearchResult {
  final String placeId;
  final String name;
  final double rating;
  final int userRatingsTotal;
  final String category;
  final String locality;
  final int distanceMeters;

  const SearchResult({
    required this.placeId,
    required this.name,
    required this.rating,
    required this.userRatingsTotal,
    required this.category,
    required this.locality,
    required this.distanceMeters,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    // Handle null or empty locality
    final locality = json['locality'] as String?;
    final processedJson = Map<String, dynamic>.from(json);
    processedJson['locality'] = locality?.isNotEmpty == true
        ? locality
        : 'Location not available';

    return _$SearchResultFromJson(processedJson);
  }

  Map<String, dynamic> toJson() => _$SearchResultToJson(this);
}

@JsonSerializable()
class SearchResponse {
  final List<SearchResult> results;
  final String? nextPageToken;

  const SearchResponse({required this.results, this.nextPageToken});

  factory SearchResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResponseToJson(this);
}

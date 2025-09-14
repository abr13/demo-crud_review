import 'package:json_annotation/json_annotation.dart';

part 'business_detail.g.dart';

@JsonSerializable()
class BusinessDetail {
  final String placeId;
  final String name;
  final double rating;
  final int userRatingsTotal;
  final String category;
  final String locality;
  final OpeningHours? openingHours;
  final List<Review> reviews;

  const BusinessDetail({
    required this.placeId,
    required this.name,
    required this.rating,
    required this.userRatingsTotal,
    required this.category,
    required this.locality,
    this.openingHours,
    required this.reviews,
  });

  factory BusinessDetail.fromJson(Map<String, dynamic> json) {
    // Handle null or empty locality
    final locality = json['locality'] as String?;
    final processedJson = Map<String, dynamic>.from(json);
    processedJson['locality'] = locality?.isNotEmpty == true
        ? locality
        : 'Location not available';

    return _$BusinessDetailFromJson(processedJson);
  }

  Map<String, dynamic> toJson() => _$BusinessDetailToJson(this);

  /// Generate Google Maps URL using business name and address (more reliable than place_id)
  String getGoogleMapsUrl() {
    final encodedName = Uri.encodeComponent(name);
    final encodedLocality = Uri.encodeComponent(locality);
    return 'https://www.google.com/maps/place/?q=$encodedName+$encodedLocality';
  }
}

@JsonSerializable()
class OpeningHours {
  final bool isOpenNow;

  const OpeningHours({required this.isOpenNow});

  factory OpeningHours.fromJson(Map<String, dynamic> json) =>
      _$OpeningHoursFromJson(json);

  Map<String, dynamic> toJson() => _$OpeningHoursToJson(this);
}

@JsonSerializable()
class Review {
  final int rating;
  final String author;
  final String relativeTime;
  final String text;

  const Review({
    required this.rating,
    required this.author,
    required this.relativeTime,
    required this.text,
  });

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewToJson(this);
}

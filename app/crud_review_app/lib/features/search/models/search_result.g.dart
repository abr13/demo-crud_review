// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResult _$SearchResultFromJson(Map<String, dynamic> json) => SearchResult(
  placeId: json['placeId'] as String,
  name: json['name'] as String,
  rating: (json['rating'] as num).toDouble(),
  userRatingsTotal: (json['userRatingsTotal'] as num).toInt(),
  category: json['category'] as String,
  locality: json['locality'] as String,
  distanceMeters: (json['distanceMeters'] as num).toInt(),
);

Map<String, dynamic> _$SearchResultToJson(SearchResult instance) =>
    <String, dynamic>{
      'placeId': instance.placeId,
      'name': instance.name,
      'rating': instance.rating,
      'userRatingsTotal': instance.userRatingsTotal,
      'category': instance.category,
      'locality': instance.locality,
      'distanceMeters': instance.distanceMeters,
    };

SearchResponse _$SearchResponseFromJson(Map<String, dynamic> json) =>
    SearchResponse(
      results: (json['results'] as List<dynamic>)
          .map((e) => SearchResult.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextPageToken: json['nextPageToken'] as String?,
    );

Map<String, dynamic> _$SearchResponseToJson(SearchResponse instance) =>
    <String, dynamic>{
      'results': instance.results,
      'nextPageToken': instance.nextPageToken,
    };

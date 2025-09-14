// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessDetail _$BusinessDetailFromJson(Map<String, dynamic> json) =>
    BusinessDetail(
      placeId: json['placeId'] as String,
      name: json['name'] as String,
      rating: (json['rating'] as num).toDouble(),
      userRatingsTotal: (json['userRatingsTotal'] as num).toInt(),
      category: json['category'] as String,
      locality: json['locality'] as String,
      openingHours: json['openingHours'] == null
          ? null
          : OpeningHours.fromJson(json['openingHours'] as Map<String, dynamic>),
      reviews: (json['reviews'] as List<dynamic>)
          .map((e) => Review.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BusinessDetailToJson(BusinessDetail instance) =>
    <String, dynamic>{
      'placeId': instance.placeId,
      'name': instance.name,
      'rating': instance.rating,
      'userRatingsTotal': instance.userRatingsTotal,
      'category': instance.category,
      'locality': instance.locality,
      'openingHours': instance.openingHours,
      'reviews': instance.reviews,
    };

OpeningHours _$OpeningHoursFromJson(Map<String, dynamic> json) =>
    OpeningHours(isOpenNow: json['isOpenNow'] as bool);

Map<String, dynamic> _$OpeningHoursToJson(OpeningHours instance) =>
    <String, dynamic>{'isOpenNow': instance.isOpenNow};

Review _$ReviewFromJson(Map<String, dynamic> json) => Review(
  rating: (json['rating'] as num).toInt(),
  author: json['author'] as String,
  relativeTime: json['relativeTime'] as String,
  text: json['text'] as String,
);

Map<String, dynamic> _$ReviewToJson(Review instance) => <String, dynamic>{
  'rating': instance.rating,
  'author': instance.author,
  'relativeTime': instance.relativeTime,
  'text': instance.text,
};



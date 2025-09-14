// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Business _$BusinessFromJson(Map<String, dynamic> json) => Business(
  placeId: json['placeId'] as String,
  name: json['name'] as String,
  rating: (json['rating'] as num).toDouble(),
  userRatingsTotal: (json['userRatingsTotal'] as num).toInt(),
  category: json['category'] as String,
  locality: json['locality'] as String,
  distanceMeters: (json['distanceMeters'] as num).toInt(),
);

Map<String, dynamic> _$BusinessToJson(Business instance) => <String, dynamic>{
  'placeId': instance.placeId,
  'name': instance.name,
  'rating': instance.rating,
  'userRatingsTotal': instance.userRatingsTotal,
  'category': instance.category,
  'locality': instance.locality,
  'distanceMeters': instance.distanceMeters,
};



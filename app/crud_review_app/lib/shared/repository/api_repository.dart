import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../../features/search/models/search_result.dart';
import '../../features/business_detail/models/business_detail.dart';

class ApiRepository {
  final Dio _dio = ApiClient.instance;

  Future<List<SearchResult>> search({
    required String query,
    required double lat,
    required double lng,
    int radius = ApiConstants.defaultRadius,
    int limit = ApiConstants.defaultLimit,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.searchEndpoint,
        queryParameters: {
          'q': query,
          'lat': lat,
          'lng': lng,
          'radius': radius,
          'limit': limit,
        },
      );

      final searchResponse = SearchResponse.fromJson(response.data);
      return searchResponse.results;
    } on DioException catch (e) {
      if (e.response?.statusCode == 429) {
        throw Exception('Too many requests. Please try again later.');
      } else if (e.response?.statusCode == 400) {
        throw Exception('Invalid search parameters. Please check your input.');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception(
          'Connection timeout. Please check your internet connection.',
        );
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('No internet connection. Please check your network.');
      } else {
        throw Exception('Search failed: ${e.message ?? 'Unknown error'}');
      }
    }
  }

  Future<BusinessDetail> getPlaceDetails(String placeId) async {
    try {
      final response = await _dio.get('${ApiConstants.placeEndpoint}/$placeId');
      return BusinessDetail.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Business not found. Please try a different search.');
      } else if (e.response?.statusCode == 429) {
        throw Exception('Too many requests. Please try again later.');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception(
          'Connection timeout. Please check your internet connection.',
        );
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('No internet connection. Please check your network.');
      } else {
        throw Exception(
          'Failed to get place details: ${e.message ?? 'Unknown error'}',
        );
      }
    }
  }

  Future<String> getDeeplinkUrl(String placeId) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.deeplinkEndpoint}/$placeId',
      );
      return response.data['url'] as String;
    } on DioException catch (e) {
      throw Exception('Failed to get deeplink: ${e.message}');
    }
  }

  Future<Map<String, dynamic>> getHealth() async {
    try {
      final response = await _dio.get(ApiConstants.healthEndpoint);
      return response.data;
    } on DioException catch (e) {
      throw Exception('Health check failed: ${e.message}');
    }
  }
}

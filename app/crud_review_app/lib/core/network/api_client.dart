import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

class ApiClient {
  static final Dio _dio = Dio();

  static void init() {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(
      milliseconds: ApiConstants.connectTimeout,
    );
    _dio.options.receiveTimeout = const Duration(
      milliseconds: ApiConstants.receiveTimeout,
    );

    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: false,
        responseHeader: false,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          // Handle common errors
          if (error.response?.statusCode == 429) {
            error = DioException(
              requestOptions: error.requestOptions,
              error: 'Rate limit exceeded. Please try again later.',
              type: DioExceptionType.unknown,
            );
          }
          handler.next(error);
        },
      ),
    );
  }

  static Dio get instance => _dio;
}



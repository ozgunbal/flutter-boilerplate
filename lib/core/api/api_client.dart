import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:api_client/api_client.dart' as generated_api_client;

class ApiClient {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  
  late final Dio _dio;
  late final generated_api_client.ApiClient _apiClient;
  
  ApiClient._internal() {
    _dio = Dio();
    _configureInterceptors();
    
    _apiClient = generated_api_client.ApiClient(
      dio: _dio,
      basePathOverride: baseUrl,
    );
  }
  
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  
  generated_api_client.ApiClient get client => _apiClient;
  
  void _configureInterceptors() {
    // Request/Response logging
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: false,
        responseHeader: false,
        error: true,
        logPrint: (object) {
          // You can customize logging here
          debugPrint('[API] $object');
        },
      ),
    );
    
    // Error handling interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          // Global error handling can be added here
          handler.next(error);
        },
        onRequest: (options, handler) {
          // Add global headers or authentication here
          handler.next(options);
        },
      ),
    );
  }
}
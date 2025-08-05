import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? errorCode;
  final dynamic data;
  
  const ApiException({
    required this.message,
    this.statusCode,
    this.errorCode,
    this.data,
  });
  
  factory ApiException.fromDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: 'Connection timeout. Please check your internet connection.',
          statusCode: error.response?.statusCode,
        );
      
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final responseData = error.response?.data;
        
        String message;
        if (responseData is Map<String, dynamic>) {
          message = responseData['message'] ?? 'Server error';
        } else {
          message = 'Server error (${statusCode})';
        }
        
        return ApiException(
          message: message,
          statusCode: statusCode,
          data: responseData,
        );
      
      case DioExceptionType.cancel:
        return const ApiException(
          message: 'Request was cancelled',
        );
      
      case DioExceptionType.connectionError:
        return const ApiException(
          message: 'No internet connection. Please check your network settings.',
        );
      
      default:
        return ApiException(
          message: 'An unexpected error occurred: ${error.message}',
          statusCode: error.response?.statusCode,
        );
    }
  }
  
  bool get isNetworkError => 
      statusCode == null || 
      message.contains('connection') || 
      message.contains('network');
  
  bool get isServerError => 
      statusCode != null && statusCode! >= 500;
  
  bool get isClientError => 
      statusCode != null && statusCode! >= 400 && statusCode! < 500;
  
  @override
  String toString() {
    if (statusCode != null) {
      return 'ApiException: $message (Status: $statusCode)';
    }
    return 'ApiException: $message';
  }
}
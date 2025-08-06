import 'package:dio/dio.dart';
import 'api_exception.dart';

abstract class BaseRepository {
  /// Handles API calls with error handling
  Future<T> handleApiCall<T>(Future<T> Function() apiCall) async {
    try {
      return await apiCall();
    } on DioException catch (error) {
      throw ApiException.fromDioException(error);
    } catch (error) {
      throw ApiException(
        message: 'An unexpected error occurred: $error',
      );
    }
  }
  
  /// Extracts data from response with null safety
  T? extractData<T>(dynamic response) {
    if (response?.data != null) {
      return response.data as T;
    }
    return null;
  }
  
  /// Extracts list data from response with null safety
  List<T> extractListData<T>(dynamic response) {
    final data = response?.data;
    if (data is List) {
      return data.cast<T>();
    }
    return <T>[];
  }
}
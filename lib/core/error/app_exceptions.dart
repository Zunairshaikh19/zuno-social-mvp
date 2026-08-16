import 'package:dio/dio.dart';

class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, [this.code]);

  @override
  String toString() => message;
}

class ServerException extends AppException {
  ServerException(super.message, [super.code]);
}

class AuthException extends AppException {
  AuthException(super.message, [super.code]);
}

class NetworkException extends AppException {
  NetworkException(super.message, [super.code]);
}

class ApiException {
  static AppException fromDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Connection timed out. Please check your internet.');
      case DioExceptionType.badResponse:
        final data = error.response?.data;
        final message = (data is Map && data.containsKey('message')) 
            ? data['message'] 
            : 'Server error (Status: ${error.response?.statusCode})';
        return ServerException(message, error.response?.statusCode?.toString());
      case DioExceptionType.cancel:
        return AppException('Request cancelled.');
      case DioExceptionType.connectionError:
        return NetworkException('No internet connection.');
      default:
        return AppException('Something went wrong. Please try again.');
    }
  }
}

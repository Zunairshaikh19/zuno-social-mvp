import 'package:dio/dio.dart';
import 'package:zunosocial/core/config/app_config.dart';
import 'package:zunosocial/core/api/auth_interceptor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DioClient {
  final Dio dio;

  DioClient({required FlutterSecureStorage storage})
      : dio = Dio(
          BaseOptions(
            baseUrl: AppConfig.baseUrl,
            connectTimeout: AppConfig.connectTimeout,
            receiveTimeout: AppConfig.receiveTimeout,
            contentType: 'application/json',
          ),
        ) {
    dio.interceptors.add(AuthInterceptor(storage: storage));
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:appmanga/core/constants/api_constants.dart';
import 'package:appmanga/core/network/auth_interceptor.dart';
import 'package:appmanga/core/storage/token_manager.dart';

class DioClient {
  late final Dio dio;

  DioClient(TokenManager tokenManager) {
    dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Thêm interceptors
    dio.interceptors.add(AuthInterceptor(tokenManager, dio));

    // Thêm logger trong môi trường Debug
    if (kDebugMode) {
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
      ));
    }
  }
}

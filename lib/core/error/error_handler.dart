import 'package:dio/dio.dart';
import 'package:appmanga/core/error/failures.dart';

class ErrorHandler {
  static Failure handle(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          return NetworkFailure('Kết nối quá chậm, vui lòng thử lại');

        case DioExceptionType.connectionError:
          return NetworkFailure('Không có kết nối mạng');

        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final responseData = error.response?.data;
          
          String message = 'Lỗi không xác định';
          if (responseData is Map) {
            message = responseData['error'] ?? responseData['message'] ?? message;
          }

          if (statusCode == 401 || statusCode == 403) {
            return AuthFailure(message, statusCode: statusCode);
          }
          return ServerFailure(message, statusCode: statusCode);

        case DioExceptionType.cancel:
          return ServerFailure('Yêu cầu đã bị hủy');
          
        default:
          return ServerFailure('Đã xảy ra lỗi server, vui lòng thử lại sau');
      }
    }
    return ServerFailure('Đã xảy ra lỗi không xác định');
  }
}

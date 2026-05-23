import 'package:dio/dio.dart';
import 'package:appmanga/core/constants/api_constants.dart';
import 'package:appmanga/core/storage/token_manager.dart';

class AuthInterceptor extends Interceptor {
  final TokenManager _tokenManager;
  final Dio _dio;
  bool _isRefreshing = false;
  final List<Map<String, dynamic>> _pendingRequests = [];

  AuthInterceptor(this._tokenManager, this._dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final authRoutes = [
      ApiConstants.login,
      ApiConstants.register,
      ApiConstants.loginGoogle,
      ApiConstants.refresh
    ];

    if (!authRoutes.any((route) => options.path.contains(route))) {
      final token = await _tokenManager.getAccessToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && !err.requestOptions.path.contains(ApiConstants.refresh)) {
      if (_isRefreshing) {
        _pendingRequests.add({'options': err.requestOptions, 'handler': handler});
        return;
      }

      _isRefreshing = true;
      try {
        final refreshToken = await _tokenManager.getRefreshToken();
        if (refreshToken == null) {
          await _tokenManager.clearTokens();
          return handler.next(err);
        }

        // Tạo một Dio instance mới để tránh loop interceptor
        final refreshDio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
        final response = await refreshDio.post(ApiConstants.refresh, data: {
          'refresh_token': refreshToken,
        });

        if (response.statusCode == 200) {
          final newAccessToken = response.data['data']['access_token'];
          await _tokenManager.saveTokens(
            accessToken: newAccessToken,
            refreshToken: refreshToken,
          );

          // Retry request hiện tại
          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer $newAccessToken';
          
          final retryResponse = await _dio.fetch(options);
          handler.resolve(retryResponse);

          // Retry các request đang xếp hàng
          for (var request in _pendingRequests) {
            final pendingOptions = request['options'] as RequestOptions;
            final pendingHandler = request['handler'] as ErrorInterceptorHandler;
            pendingOptions.headers['Authorization'] = 'Bearer $newAccessToken';
            
            _dio.fetch(pendingOptions).then(
              (res) => pendingHandler.resolve(res),
              onError: (e) => pendingHandler.next(e),
            );
          }
          _pendingRequests.clear();
          return;
        }
      } catch (e) {
        await _tokenManager.clearTokens();
      } finally {
        _isRefreshing = false;
      }
    }
    return handler.next(err);
  }
}

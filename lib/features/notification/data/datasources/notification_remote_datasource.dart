import 'package:appmanga/core/constants/api_constants.dart';
import 'package:appmanga/core/network/dio_client.dart';
import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications({int page = 1, int limit = 20});
  Future<int> getUnreadCount();
  Future<void> markAsRead(String id);
  Future<void> markAllAsRead();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final DioClient _dioClient;

  NotificationRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<NotificationModel>> getNotifications({int page = 1, int limit = 20}) async {
    final response = await _dioClient.dio.get(ApiConstants.notifications, queryParameters: {
      'page': page,
      'limit': limit,
    });
    return (response.data['data'] as List).map((e) => NotificationModel.fromJson(e)).toList();
  }

  @override
  Future<int> getUnreadCount() async {
    final response = await _dioClient.dio.get(ApiConstants.unreadCount);
    return response.data['data']['count'] ?? 0;
  }

  @override
  Future<void> markAsRead(String id) async {
    await _dioClient.dio.put('${ApiConstants.notifications}/$id/read');
  }

  @override
  Future<void> markAllAsRead() async {
    await _dioClient.dio.put(ApiConstants.readAll);
  }
}

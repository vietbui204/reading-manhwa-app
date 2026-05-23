import 'package:appmanga/core/constants/api_constants.dart';
import 'package:appmanga/core/network/dio_client.dart';
import '../models/task_model.dart';

abstract class PointsRemoteDataSource {
  Future<List<TaskModel>> getTasks();
  Future<Map<String, dynamic>> completeTask(
      String taskId, {
        Map<String, dynamic>? proof,
      });
  Future<List<Map<String, dynamic>>> getPointHistory({
    int page  = 1,
    int limit = 20,
  });
  // Thêm method còn thiếu
  Future<int> getPointBalance();
}

class PointsRemoteDataSourceImpl implements PointsRemoteDataSource {
  final DioClient _dioClient;

  PointsRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<TaskModel>> getTasks() async {
    final response = await _dioClient.dio.get(ApiConstants.tasks);
    return (response.data['data'] as List)
        .map((e) => TaskModel.fromJson(e))
        .toList();
  }

  @override
  Future<Map<String, dynamic>> completeTask(
      String taskId, {
        Map<String, dynamic>? proof,
      }) async {
    final response = await _dioClient.dio.post(
      '${ApiConstants.tasks}/$taskId/complete',
      data: proof != null ? {'proof': proof} : {},
    );
    return response.data['data'];
  }

  @override
  Future<List<Map<String, dynamic>>> getPointHistory({
    int page  = 1,
    int limit = 20,
  }) async {
    final response = await _dioClient.dio.get(
      ApiConstants.pointsHistory,
      queryParameters: {'page': page, 'limit': limit},
    );
    return List<Map<String, dynamic>>.from(response.data['data']);
  }

  // Thêm method còn thiếu
  @override
  Future<int> getPointBalance() async {
    final response = await _dioClient.dio.get(
      ApiConstants.pointsBalance,
    );
    return (response.data['data']['balance'] ?? 0) as int;
  }
}
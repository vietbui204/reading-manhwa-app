import 'package:dartz/dartz.dart';
import 'package:appmanga/core/error/failures.dart';
import '../entities/task_entity.dart';
import '../entities/point_transaction_entity.dart';

abstract class PointsRepository {
  Future<Either<Failure, List<TaskEntity>>> getTasks();
  Future<Either<Failure, CompleteTaskResponse>> completeTask(
      String taskId, {Map<String, dynamic>? proof}
      );
  Future<Either<Failure, List<PointTransactionEntity>>> getPointHistory({
    int page = 1, int limit = 20
  });
  // Thêm dòng này
  Future<Either<Failure, int>> getPointBalance();
}

class CompleteTaskResponse {
  final int pointsEarned;
  final int newBalance;
  final dynamic completion;

  CompleteTaskResponse({
    required this.pointsEarned,
    required this.newBalance,
    this.completion,
  });
}

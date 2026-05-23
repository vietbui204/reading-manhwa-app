import 'package:dartz/dartz.dart';
import 'package:appmanga/core/error/failures.dart';
import '../repositories/points_repository.dart';

class CompleteTaskUseCase {
  final PointsRepository repository;
  CompleteTaskUseCase(this.repository);

  Future<Either<Failure, CompleteTaskResponse>> call(String taskId, {Map<String, dynamic>? proof}) {
    return repository.completeTask(taskId, proof: proof);
  }
}

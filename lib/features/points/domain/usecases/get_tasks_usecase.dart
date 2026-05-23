import 'package:dartz/dartz.dart';
import 'package:appmanga/core/error/failures.dart';
import '../entities/task_entity.dart';
import '../repositories/points_repository.dart';

class GetTasksUseCase {
  final PointsRepository repository;
  GetTasksUseCase(this.repository);

  Future<Either<Failure, List<TaskEntity>>> call() {
    return repository.getTasks();
  }
}

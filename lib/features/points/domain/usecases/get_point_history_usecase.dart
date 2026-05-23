import 'package:dartz/dartz.dart';
import 'package:appmanga/core/error/failures.dart';
import '../entities/point_transaction_entity.dart';
import '../repositories/points_repository.dart';

class GetPointHistoryUseCase {
  final PointsRepository repository;
  GetPointHistoryUseCase(this.repository);

  Future<Either<Failure, List<PointTransactionEntity>>> call({int page = 1, int limit = 20}) {
    return repository.getPointHistory(page: page, limit: limit);
  }
}

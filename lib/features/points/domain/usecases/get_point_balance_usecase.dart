import 'package:dartz/dartz.dart';
import 'package:appmanga/core/error/failures.dart';
import '../repositories/points_repository.dart';

class GetPointBalanceUseCase {
  final PointsRepository repository;
  GetPointBalanceUseCase(this.repository);

  Future<Either<Failure, int>> call() {
    return repository.getPointBalance();
  }
}
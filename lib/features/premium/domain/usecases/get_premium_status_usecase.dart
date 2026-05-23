import 'package:dartz/dartz.dart';
import 'package:appmanga/core/error/failures.dart';
import '../repositories/premium_repository.dart';

class GetPremiumStatusUseCase {
  final PremiumRepository repository;
  GetPremiumStatusUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call() {
    return repository.getPremiumStatus();
  }
}

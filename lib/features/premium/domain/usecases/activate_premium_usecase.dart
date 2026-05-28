import 'package:dartz/dartz.dart';
import 'package:appmanga/core/error/failures.dart';
import '../repositories/premium_repository.dart';

class ActivatePremiumParams {
  final String userId;
  final int durationDays;
  ActivatePremiumParams({required this.userId, required this.durationDays});
}

class ActivatePremiumUseCase {
  final PremiumRepository repository;
  ActivatePremiumUseCase(this.repository);

  Future<Either<Failure, void>> call(ActivatePremiumParams params) {
    return repository.activatePremium(params.userId, params.durationDays);
  }
}

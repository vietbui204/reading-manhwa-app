import 'package:dartz/dartz.dart';
import 'package:appmanga/core/error/failures.dart';
import '../entities/premium_plan_entity.dart';
import '../repositories/premium_repository.dart';

class GetPremiumPlansUseCase {
  final PremiumRepository repository;
  GetPremiumPlansUseCase(this.repository);

  Future<Either<Failure, List<PremiumPlanEntity>>> call() {
    return repository.getPremiumPlans();
  }
}

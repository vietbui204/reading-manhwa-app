import 'package:dartz/dartz.dart';
import 'package:appmanga/core/error/failures.dart';
import '../entities/premium_plan_entity.dart';

abstract class PremiumRepository {
  Future<Either<Failure, Map<String, dynamic>>> getPremiumStatus();
  Future<Either<Failure, List<PremiumPlanEntity>>> getPremiumPlans();
}

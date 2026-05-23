import 'package:dartz/dartz.dart';
import 'package:appmanga/core/error/error_handler.dart';
import 'package:appmanga/core/error/failures.dart';
import 'package:appmanga/features/premium/domain/entities/premium_plan_entity.dart';
import 'package:appmanga/features/premium/domain/repositories/premium_repository.dart';
import '../datasources/premium_remote_datasource.dart';

class PremiumRepositoryImpl implements PremiumRepository {
  final PremiumRemoteDataSource _remote;

  PremiumRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, Map<String, dynamic>>> getPremiumStatus() async {
    try {
      final result = await _remote.getPremiumStatus();
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<PremiumPlanEntity>>> getPremiumPlans() async {
    try {
      final result = await _remote.getPremiumPlans();
      return Right(result.map((e) => PremiumPlanEntity(
        id: e['id']?.toString() ?? '',
        name: e['name']?.toString() ?? '',
        price: (e['price'] ?? 0).toDouble(),
        currency: e['currency']?.toString() ?? 'VND',
        duration: (e['duration'] ?? 0) as int,
        description: e['description']?.toString() ?? '',
        features: List<String>.from(e['features'] ?? []),
      )).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/explore_data.dart';
import '../repositories/explore_repository.dart';

class GetExploreDataUseCase {
  final ExploreRepository repository;

  GetExploreDataUseCase(this.repository);

  Future<Either<Failure, ExploreData>> call() => repository.getExploreData();
}

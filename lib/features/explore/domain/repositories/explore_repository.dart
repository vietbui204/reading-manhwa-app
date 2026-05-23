import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/explore_data.dart';

abstract class ExploreRepository {
  Future<Either<Failure, ExploreData>> getExploreData();
}

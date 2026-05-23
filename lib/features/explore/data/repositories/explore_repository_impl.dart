import 'package:dartz/dartz.dart';
import 'package:appmanga/core/error/failures.dart';
import 'package:appmanga/features/explore/data/datasources/explore_remote_data_source.dart';
import 'package:appmanga/features/explore/domain/entities/explore_data.dart';
import 'package:appmanga/features/explore/domain/repositories/explore_repository.dart';

class ExploreRepositoryImpl implements ExploreRepository {
  final ExploreRemoteDataSource remoteDataSource;

  ExploreRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ExploreData>> getExploreData() async {
    try {
      final result = await remoteDataSource.getExploreData();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure('Không thể tải dữ liệu khám phá'));
    }
  }
}

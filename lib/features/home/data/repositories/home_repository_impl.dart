import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/home_data.dart';
import '../../domain/entities/manga_card.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  HomeData? _cachedHomeData;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, HomeData>> getHomeData() async {
    try {
      final remoteData = await remoteDataSource.getHomeData();
      _cachedHomeData = remoteData;
      return Right(remoteData);
    } catch (e) {
      if (_cachedHomeData != null) return Right(_cachedHomeData!);
      return Left(ServerFailure('Không thể tải dữ liệu từ máy chủ'));
    }
  }

  @override
  Future<Either<Failure, List<MangaCard>>> filterByGenre(String genre) async {
    try {
      final result = await remoteDataSource.filterByGenre(genre);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure('Không thể lọc theo thể loại này'));
    }
  }
}

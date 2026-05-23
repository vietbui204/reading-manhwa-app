import 'package:dartz/dartz.dart';
import 'package:appmanga/core/error/failures.dart';
import '../entities/home_data_entity.dart';
import '../repositories/manga_repository.dart';

class GetHomeDataUseCase {
  final MangaRepository repository;

  GetHomeDataUseCase(this.repository);

  Future<Either<Failure, HomeDataEntity>> call() => repository.getHomeData();
}

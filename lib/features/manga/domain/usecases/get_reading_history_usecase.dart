import 'package:dartz/dartz.dart';
import 'package:appmanga/core/error/failures.dart';
import '../entities/history_entity.dart';
import '../repositories/manga_repository.dart';

class GetReadingHistoryUseCase {
  final MangaRepository repository;
  GetReadingHistoryUseCase(this.repository);

  Future<Either<Failure, List<HistoryEntity>>> call({int page = 1, int limit = 20}) {
    return repository.getReadingHistory(page: page, limit: limit);
  }
}

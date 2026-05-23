import 'package:dartz/dartz.dart';
import 'package:appmanga/core/error/failures.dart';
import '../repositories/manga_repository.dart';

class UpdateReadingHistoryParams {
  final String chapterId;
  UpdateReadingHistoryParams({required this.chapterId});
}

class UpdateReadingHistoryUseCase {
  final MangaRepository repository;
  UpdateReadingHistoryUseCase(this.repository);

  Future<Either<Failure, void>> call(UpdateReadingHistoryParams params) {
    return repository.updateReadingHistory(params.chapterId);
  }
}

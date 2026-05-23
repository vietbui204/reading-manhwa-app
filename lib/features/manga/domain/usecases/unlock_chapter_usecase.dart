import 'package:dartz/dartz.dart';
import 'package:appmanga/core/error/failures.dart';
import '../repositories/manga_repository.dart';

class UnlockChapterUseCase {
  final MangaRepository repository;
  UnlockChapterUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call(String chapterId) {
    return repository.unlockChapter(chapterId);
  }
}

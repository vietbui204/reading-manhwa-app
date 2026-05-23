import 'package:dartz/dartz.dart';
import 'package:appmanga/core/error/failures.dart';
import '../entities/chapter_pages_entity.dart';
import '../repositories/manga_repository.dart';

class GetChapterPagesUseCase {
  final MangaRepository repository;
  GetChapterPagesUseCase(this.repository);

  Future<Either<Failure, ChapterPagesEntity>> call(String chapterId) {
    return repository.getChapterPages(chapterId);
  }
}

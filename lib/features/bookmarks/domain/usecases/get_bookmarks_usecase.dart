import 'package:dartz/dartz.dart';
import 'package:appmanga/core/error/failures.dart';
import 'package:appmanga/features/bookmarks/domain/entities/bookmark_entity.dart';
import 'package:appmanga/features/manga/domain/repositories/manga_repository.dart';

class GetBookmarksUseCase {
  final MangaRepository repository;
  GetBookmarksUseCase(this.repository);

  Future<Either<Failure, List<BookmarkEntity>>> call({int page = 1, int limit = 20}) {
    return repository.getBookmarks(page: page, limit: limit);
  }
}

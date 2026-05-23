import 'package:dartz/dartz.dart';
import 'package:appmanga/core/error/failures.dart';
import '../entities/comment_entity.dart';
import '../../../manga/domain/repositories/manga_repository.dart';

class GetCommentsUseCase {
  final MangaRepository repository;
  GetCommentsUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call(String mangaId, {String? cursor, int limit = 20}) {
    return repository.getComments(mangaId, cursor: cursor, limit: limit);
  }
}

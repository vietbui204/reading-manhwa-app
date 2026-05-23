import 'package:dartz/dartz.dart';
import 'package:appmanga/core/error/failures.dart';
import '../../../manga/domain/repositories/manga_repository.dart';

class UnlikeCommentUseCase {
  final MangaRepository repository;
  UnlikeCommentUseCase(this.repository);

  Future<Either<Failure, void>> call(String commentId) {
    return repository.unlikeComment(commentId);
  }
}

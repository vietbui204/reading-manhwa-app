import 'package:dartz/dartz.dart';
import 'package:appmanga/core/error/failures.dart';
import 'package:appmanga/features/manga/domain/repositories/manga_repository.dart';

class DeleteCommentUseCase {
  final MangaRepository repository;
  DeleteCommentUseCase(this.repository);

  Future<Either<Failure, void>> call(String commentId) {
    return repository.deleteComment(commentId);
  }
}

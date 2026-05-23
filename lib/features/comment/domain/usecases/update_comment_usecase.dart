import 'package:dartz/dartz.dart';
import 'package:appmanga/core/error/failures.dart';
import 'package:appmanga/features/manga/domain/repositories/manga_repository.dart';

class UpdateCommentUseCase {
  final MangaRepository repository;
  UpdateCommentUseCase(this.repository);

  Future<Either<Failure, void>> call(String commentId, String content) {
    return repository.updateComment(commentId, content);
  }
}

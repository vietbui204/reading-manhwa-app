import 'package:dartz/dartz.dart';
import 'package:appmanga/core/error/failures.dart';
import 'package:appmanga/features/comment/domain/entities/comment_entity.dart';
import '../repositories/manga_repository.dart';

class GetCommentRepliesUseCase {
  final MangaRepository repository;
  GetCommentRepliesUseCase(this.repository);

  Future<Either<Failure, List<CommentEntity>>> call(String commentId) {
    return repository.getCommentReplies(commentId);
  }
}

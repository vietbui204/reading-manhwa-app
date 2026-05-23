import 'package:dartz/dartz.dart';
import 'package:appmanga/core/error/failures.dart';
import '../entities/comment_entity.dart';
import '../../../manga/domain/repositories/manga_repository.dart';

class CreateCommentParams {
  final String mangaId;
  final String content;
  final String? parentId;
  CreateCommentParams({required this.mangaId, required this.content, this.parentId});
}

class CreateCommentUseCase {
  final MangaRepository repository;
  CreateCommentUseCase(this.repository);

  Future<Either<Failure, CommentEntity>> call(CreateCommentParams params) {
    return repository.createComment(params.mangaId, content: params.content, parentId: params.parentId);
  }
}

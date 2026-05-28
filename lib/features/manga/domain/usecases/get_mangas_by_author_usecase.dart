import 'package:dartz/dartz.dart';
import 'package:appmanga/core/error/failures.dart';
import 'package:appmanga/features/manga/domain/entities/manga_entity.dart';
import 'package:appmanga/features/manga/domain/repositories/manga_repository.dart';

class GetMangasByAuthorUseCase {
  final MangaRepository repository;
  GetMangasByAuthorUseCase(this.repository);

  Future<Either<Failure, List<MangaEntity>>> call(String authorId) {
    return repository.getMangasByAuthor(authorId);
  }
}

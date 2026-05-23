import 'package:dartz/dartz.dart';
import 'package:appmanga/core/error/failures.dart';
import '../repositories/manga_repository.dart';

class LikeMangaUseCase {
  final MangaRepository repository;
  LikeMangaUseCase(this.repository);

  Future<Either<Failure, void>> call(String mangaId) {
    return repository.likeManga(mangaId);
  }
}

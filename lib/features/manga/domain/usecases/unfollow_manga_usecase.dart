import 'package:dartz/dartz.dart';
import 'package:appmanga/core/error/failures.dart';
import '../repositories/manga_repository.dart';

class UnfollowMangaUseCase {
  final MangaRepository repository;
  UnfollowMangaUseCase(this.repository);

  Future<Either<Failure, void>> call(String mangaId) {
    return repository.unfollowManga(mangaId);
  }
}

import 'package:dartz/dartz.dart';
import 'package:appmanga/core/error/failures.dart';
import '../repositories/manga_repository.dart';

class FollowMangaUseCase {
  final MangaRepository repository;
  FollowMangaUseCase(this.repository);

  Future<Either<Failure, void>> call(String mangaId) {
    return repository.followManga(mangaId);
  }
}

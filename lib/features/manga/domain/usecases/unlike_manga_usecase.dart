import 'package:dartz/dartz.dart';
import 'package:appmanga/core/error/failures.dart';
import '../repositories/manga_repository.dart';

class UnlikeMangaUseCase {
  final MangaRepository repository;
  UnlikeMangaUseCase(this.repository);

  Future<Either<Failure, void>> call(String mangaId) {
    return repository.unlikeManga(mangaId);
  }
}

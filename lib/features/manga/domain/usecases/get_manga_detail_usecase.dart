import 'package:dartz/dartz.dart';
import 'package:appmanga/core/error/failures.dart';
import '../entities/manga_detail_entity.dart';
import '../repositories/manga_repository.dart';

class GetMangaDetailUseCase {
  final MangaRepository repository;
  GetMangaDetailUseCase(this.repository);

  Future<Either<Failure, MangaDetailEntity>> call(String mangaId) {
    return repository.getMangaDetail(mangaId);
  }
}

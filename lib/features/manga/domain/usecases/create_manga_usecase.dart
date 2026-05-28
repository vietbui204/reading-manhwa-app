import 'package:dartz/dartz.dart';
import 'package:appmanga/core/error/failures.dart';
import '../entities/manga_entity.dart';
import '../repositories/manga_repository.dart';

class CreateMangaParams {
  final String title;
  final String? description;
  final String? coverUrl;
  final String status;
  final List<String> genres;

  CreateMangaParams({
    required this.title,
    this.description,
    this.coverUrl,
    this.status = 'ongoing',
    this.genres = const [],
  });
}

class CreateMangaUseCase {
  final MangaRepository repository;
  CreateMangaUseCase(this.repository);

  Future<Either<Failure, MangaEntity>> call(CreateMangaParams params) {
    return repository.createManga(params);
  }
}

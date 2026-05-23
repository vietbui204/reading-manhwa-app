import 'package:dartz/dartz.dart';
import 'package:appmanga/core/error/failures.dart';
import '../entities/manga_list_entity.dart';
import '../repositories/manga_repository.dart';

class MangaListParams {
  final int page;
  final int limit;
  final String? genre;
  final String? status;
  final String sort;
  final String? search;

  MangaListParams({
    this.page = 1,
    this.limit = 20,
    this.genre,
    this.status,
    this.sort = 'latest',
    this.search,
  });
}

class GetMangaListUseCase {
  final MangaRepository repository;

  GetMangaListUseCase(this.repository);

  Future<Either<Failure, MangaListEntity>> call(MangaListParams params) {
    return repository.getMangaList(
      page: params.page,
      limit: params.limit,
      genre: params.genre,
      status: params.status,
      sort: params.sort,
      search: params.search,
    );
  }
}

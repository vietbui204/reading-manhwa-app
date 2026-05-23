import 'manga_entity.dart';

class MangaListEntity {
  final List<MangaEntity> data;
  final PaginationEntity pagination;

  MangaListEntity({
    required this.data,
    required this.pagination,
  });
}

class PaginationEntity {
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  PaginationEntity({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });
}

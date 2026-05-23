import 'package:appmanga/features/manga/domain/entities/manga_list_entity.dart';
import 'manga_model.dart';
import 'pagination_model.dart';

class MangaListModel extends MangaListEntity {
  MangaListModel({
    required List<MangaModel> super.data,
    required PaginationModel super.pagination,
  });

  factory MangaListModel.fromJson(Map<String, dynamic> json) {
    return MangaListModel(
      data: (json['data'] as List)
          .map((e) => MangaModel.fromJson(e))
          .toList(),
      pagination: PaginationModel.fromJson(json['pagination']),
    );
  }
}

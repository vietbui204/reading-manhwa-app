import 'package:appmanga/features/manga/domain/entities/page_entity.dart';
import 'package:appmanga/features/manga/data/models/manga_model.dart';

class PageModel extends PageEntity {
  PageModel({
    required super.id,
    required super.pageNumber,
    required super.imageUrl,
  });

  factory PageModel.fromJson(Map<String, dynamic> json) {
    return PageModel(
      id: json['id']?.toString() ?? '',
      pageNumber: MangaModel.toInt(json['pageNumber'] ?? json['page_number']),
      imageUrl: (json['imageUrl'] ?? json['image_url'] ?? '').toString(),
    );
  }
}

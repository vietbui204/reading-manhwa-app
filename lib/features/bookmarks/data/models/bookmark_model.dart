import 'package:appmanga/features/bookmarks/domain/entities/bookmark_entity.dart';
import 'package:appmanga/features/manga/data/models/manga_model.dart';

class BookmarkModel extends BookmarkEntity {
  const BookmarkModel({
    required super.mangaId,
    required super.mangaTitle,
    super.coverUrl,
    required super.status,
    required super.latestChapter,
    required super.isNewChapter,
    required super.updatedAt,
    required super.followedAt,
  });

  factory BookmarkModel.fromJson(Map<String, dynamic> json) {
    return BookmarkModel(
      mangaId: json['id']?.toString() ?? '',
      mangaTitle: json['title']?.toString() ?? '',
      coverUrl: json['coverUrl'] ?? json['cover_url'],
      status: json['status']?.toString() ?? 'ongoing',
      latestChapter: MangaModel.toInt(json['latestChapter']?['chapterNumber'] ?? 0),
      isNewChapter: MangaModel.toBool(json['isNewChapter'], false),
      updatedAt: DateTime.parse(json['updatedAt'] ?? json['updated_at']),
      followedAt: DateTime.now(), // Usually this would come from junction table
    );
  }
}

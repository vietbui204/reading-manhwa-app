import 'package:appmanga/features/manga/domain/entities/chapter_entity.dart';
import 'package:appmanga/features/manga/data/models/manga_model.dart';

class ChapterModel extends ChapterEntity {
  ChapterModel({
    required super.id,
    required super.mangaId,
    required super.chapterNumber,
    super.title,
    required super.pageCount,
    required super.isLocked,
    required super.unlockCost,
    required super.isPremiumOnly,
    required super.publishedAt,
    super.hasAccess,
    super.isRead,
  });

  factory ChapterModel.fromJson(Map<String, dynamic> json) {
    return ChapterModel(
      id: json['id']?.toString() ?? '',
      mangaId: (json['mangaId'] ?? json['manga_id'])?.toString() ?? '',
      chapterNumber: MangaModel.toInt(json['chapterNumber'] ?? json['chapter_number']),
      title: json['title']?.toString(),
      pageCount: MangaModel.toInt(json['pageCount'] ?? json['page_count']),
      isLocked: MangaModel.toBool(json['isLocked'] ?? json['is_locked'], false),
      unlockCost: MangaModel.toInt(json['unlockCost'] ?? json['unlock_cost']),
      isPremiumOnly: MangaModel.toBool(json['isPremiumOnly'] ?? json['is_premium_only'], false),
      publishedAt: json['publishedAt'] != null 
          ? DateTime.parse(json['publishedAt']) 
          : (json['published_at'] != null ? DateTime.parse(json['published_at']) : DateTime.now()),
      hasAccess: MangaModel.toBool(json['hasAccess'] ?? json['has_access'], true),
      isRead: MangaModel.toBool(json['isRead'] ?? json['is_read'], false),
    );
  }
}

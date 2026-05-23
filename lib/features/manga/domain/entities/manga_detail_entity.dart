import 'manga_entity.dart';
import 'chapter_entity.dart';

class MangaDetailEntity extends MangaEntity {
  final List<ChapterEntity> chapters;

  MangaDetailEntity({
    required super.id,
    required super.title,
    super.description,
    super.coverUrl,
    required super.status,
    required super.genres,
    required super.viewCount,
    required super.likeCount,
    required super.followCount,
    required super.commentCount,
    required super.updatedAt,
    required super.author,
    super.badgeType,
    super.isNewChapter,
    super.latestChapter,
    super.isLiked,
    super.isFollowed,
    required this.chapters,
  });
}

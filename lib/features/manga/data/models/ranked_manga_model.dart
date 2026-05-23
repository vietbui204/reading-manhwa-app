import 'package:appmanga/features/manga/domain/entities/manga_entity.dart';
import 'author_model.dart';
import 'manga_model.dart';

class RankedMangaModel extends RankedMangaEntity {
  RankedMangaModel({
    required super.id,
    required super.title,
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
    required super.rank,
  });

  factory RankedMangaModel.fromJson(Map<String, dynamic> json, int index) {
    return RankedMangaModel(
      id: json['id'],
      title: json['title'],
      coverUrl: json['coverUrl'],
      status: json['status'],
      genres: List<String>.from(json['genres'] ?? []),
      viewCount: json['viewCount'] ?? 0,
      likeCount: json['likeCount'] ?? 0,
      followCount: json['followCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      updatedAt: DateTime.parse(json['updatedAt']),
      author: AuthorModel.fromJson(json['author'] ?? {}),
      badgeType: json['badgeType'],
      isNewChapter: json['isNewChapter'] ?? false,
      latestChapter: json['latestChapter'],
      isLiked: json['isLiked'] ?? false,
      isFollowed: json['isFollowed'] ?? false,
      rank: index + 1,
    );
  }
}

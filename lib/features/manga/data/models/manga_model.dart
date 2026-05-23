import 'package:appmanga/features/manga/domain/entities/manga_entity.dart';
import 'author_model.dart';

class MangaModel extends MangaEntity {
  MangaModel({
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
  });

  static int toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  static bool toBool(dynamic value, bool defaultValue) {
    if (value == null) return defaultValue;
    if (value is bool) return value;
    if (value is int) return value == 1;
    final str = value.toString().toLowerCase();
    return str == 'true' || str == '1';
  }

  static DateTime toDate(dynamic value) {
    if (value == null) return DateTime.now();
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return DateTime.now();
    }
  }

  factory MangaModel.fromJson(Map<String, dynamic> json) {
    return MangaModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Không tiêu đề',
      description: json['description']?.toString(),
      coverUrl: (json['coverUrl'] ?? json['cover_url'])?.toString(),
      status: json['status']?.toString() ?? 'ongoing',
      genres: json['genres'] != null ? List<String>.from(json['genres']) : [],
      viewCount: toInt(json['viewCount'] ?? json['view_count']),
      likeCount: toInt(json['likeCount'] ?? json['like_count']),
      followCount: toInt(json['followCount'] ?? json['follow_count']),
      commentCount: toInt(json['commentCount'] ?? json['comment_count']),
      updatedAt: toDate(json['updatedAt'] ?? json['updated_at'] ?? json['createdAt']),
      author: json['author'] != null 
          ? AuthorModel.fromJson(json['author']) 
          : AuthorModel(id: '', username: 'MangaX User'),
      badgeType: json['badgeType']?.toString(),
      isNewChapter: toBool(json['isNewChapter'] ?? json['is_new_chapter'], false),
      latestChapter: toInt(json['latestChapter'] ?? json['latest_chapter']),
      isLiked: toBool(json['isLiked'] ?? json['is_liked'], false),
      isFollowed: toBool(json['isFollowed'] ?? json['is_followed'], false),
    );
  }
}

import 'package:appmanga/features/manga/domain/entities/manga_detail_entity.dart';
import 'chapter_model.dart';
import 'author_model.dart';
import 'manga_model.dart';

class MangaDetailModel extends MangaDetailEntity {
  MangaDetailModel({
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
    required List<ChapterModel> super.chapters,
  });

  factory MangaDetailModel.fromJson(Map<String, dynamic> json) {
    return MangaDetailModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Không tiêu đề',
      description: json['description']?.toString(),
      coverUrl: (json['coverUrl'] ?? json['cover_url'])?.toString(),
      status: json['status']?.toString() ?? 'ongoing',
      genres: json['genres'] != null 
          ? (json['genres'] as List).map((e) => e.toString()).toList() 
          : [],
      viewCount: MangaModel.toInt(json['viewCount'] ?? json['view_count']),
      likeCount: MangaModel.toInt(json['likeCount'] ?? json['like_count']),
      followCount: MangaModel.toInt(json['followCount'] ?? json['follow_count']),
      commentCount: MangaModel.toInt(json['commentCount'] ?? json['comment_count']),
      updatedAt: MangaModel.toDate(json['updatedAt'] ?? json['updated_at'] ?? json['createdAt']),
      author: json['author'] != null 
          ? AuthorModel.fromJson(json['author']) 
          : AuthorModel(id: '', username: 'MangaX User'),
      badgeType: json['badgeType']?.toString(),
      isNewChapter: MangaModel.toBool(json['isNewChapter'] ?? json['is_new_chapter'], false),
      latestChapter: MangaModel.toInt(json['latestChapter'] ?? json['latest_chapter']),
      isLiked: MangaModel.toBool(json['isLiked'] ?? json['is_liked'], false),
      isFollowed: MangaModel.toBool(json['isFollowed'] ?? json['is_followed'], false),
      // FIX CỐT LÕI: Chỉ định kiểu rõ ràng <ChapterModel> cho hàm map
      chapters: (json['chapters'] as List? ?? [])
          .map<ChapterModel>((e) => ChapterModel.fromJson(e))
          .toList(),
    );
  }
}

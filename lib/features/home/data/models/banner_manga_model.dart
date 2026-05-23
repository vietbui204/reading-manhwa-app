import '../../domain/entities/banner_manga.dart';

class BannerMangaModel extends BannerManga {
  BannerMangaModel({
    required super.id,
    required super.title,
    required super.coverUrl,
    required super.latestChapter,
    required super.viewCount,
    required super.badgeType,
  });

  factory BannerMangaModel.fromJson(Map<String, dynamic> json) {
    return BannerMangaModel(
      id: json['id'],
      title: json['title'],
      coverUrl: json['cover_url'],
      latestChapter: json['latest_chapter'],
      viewCount: json['view_count'],
      badgeType: json['badge_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'cover_url': coverUrl,
      'latest_chapter': latestChapter,
      'view_count': viewCount,
      'badge_type': badgeType,
    };
  }
}

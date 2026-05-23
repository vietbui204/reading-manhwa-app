import '../../domain/entities/ranked_manga.dart';

class RankedMangaModel extends RankedManga {
  RankedMangaModel({
    required super.rank,
    required super.id,
    required super.title,
    required super.coverUrl,
    required super.genre,
    required super.status,
    required super.viewCount,
    required super.likeCount,
  });

  factory RankedMangaModel.fromJson(Map<String, dynamic> json) {
    return RankedMangaModel(
      rank: json['rank'],
      id: json['id'],
      title: json['title'],
      coverUrl: json['cover_url'],
      genre: json['genre'],
      status: json['status'],
      viewCount: json['view_count'],
      likeCount: json['like_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rank': rank,
      'id': id,
      'title': title,
      'cover_url': coverUrl,
      'genre': genre,
      'status': status,
      'view_count': viewCount,
      'like_count': likeCount,
    };
  }
}

class MangaEntity {
  final String id;
  final String title;
  final String? description; // Bổ sung trường mô tả
  final String? coverUrl;
  final String status; // ongoing/completed/hiatus
  final List<String> genres;
  final int viewCount;
  final int likeCount;
  final int followCount;
  final int commentCount;
  final DateTime updatedAt;
  final AuthorEntity author;
  final String? badgeType; // hot/new/trending (chỉ banner)
  final bool isNewChapter; // chapter < 24h
  final int? latestChapter; // số chapter mới nhất
  final bool isLiked;
  final bool isFollowed;

  MangaEntity({
    required this.id,
    required this.title,
    this.description,
    this.coverUrl,
    required this.status,
    required this.genres,
    required this.viewCount,
    required this.likeCount,
    required this.followCount,
    required this.commentCount,
    required this.updatedAt,
    required this.author,
    this.badgeType,
    this.isNewChapter = false,
    this.latestChapter,
    this.isLiked = false,
    this.isFollowed = false,
  });
}

class AuthorEntity {
  final String id;
  final String username;
  final String? avatarUrl;

  AuthorEntity({
    required this.id,
    required this.username,
    this.avatarUrl,
  });
}

class RankedMangaEntity extends MangaEntity {
  final int rank;

  RankedMangaEntity({
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
    required this.rank,
  });
}

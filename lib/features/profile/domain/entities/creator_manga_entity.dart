import 'package:equatable/equatable.dart';

class CreatorMangaEntity extends Equatable {
  final String id;
  final String title;
  final String? coverUrl;
  final String status;
  final List<String> genres;
  final int viewCount;
  final int likeCount;
  final int chapterCount;
  final DateTime updatedAt;

  const CreatorMangaEntity({
    required this.id,
    required this.title,
    this.coverUrl,
    required this.status,
    required this.genres,
    required this.viewCount,
    required this.likeCount,
    required this.chapterCount,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id, title, coverUrl, status, genres,
    viewCount, likeCount, chapterCount, updatedAt,
  ];
}
import 'package:equatable/equatable.dart';

class BookmarkEntity extends Equatable {
  final String mangaId;
  final String mangaTitle;
  final String? coverUrl;
  final String status;
  final int latestChapter;
  final bool isNewChapter;
  final DateTime updatedAt;
  final DateTime followedAt;

  const BookmarkEntity({
    required this.mangaId,
    required this.mangaTitle,
    this.coverUrl,
    required this.status,
    required this.latestChapter,
    required this.isNewChapter,
    required this.updatedAt,
    required this.followedAt,
  });

  @override
  List<Object?> get props => [
        mangaId,
        mangaTitle,
        coverUrl,
        status,
        latestChapter,
        isNewChapter,
        updatedAt,
        followedAt,
      ];
}

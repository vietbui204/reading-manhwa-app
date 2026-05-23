import 'package:equatable/equatable.dart';

class HistoryEntity extends Equatable {
  final String id;
  final DateTime readAt;
  final HistoryChapterEntity chapter;

  const HistoryEntity({
    required this.id,
    required this.readAt,
    required this.chapter,
  });

  @override
  List<Object?> get props => [id, readAt, chapter];
}

class HistoryChapterEntity extends Equatable {
  final String id;
  final int chapterNumber;
  final String? title;
  final HistoryMangaEntity manga;

  const HistoryChapterEntity({
    required this.id,
    required this.chapterNumber,
    this.title,
    required this.manga,
  });

  @override
  List<Object?> get props => [id, chapterNumber, title, manga];
}

class HistoryMangaEntity extends Equatable {
  final String id;
  final String title;
  final String? coverUrl;

  const HistoryMangaEntity({
    required this.id,
    required this.title,
    this.coverUrl,
  });

  @override
  List<Object?> get props => [id, title, coverUrl];
}

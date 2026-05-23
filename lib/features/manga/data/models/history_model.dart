import 'package:appmanga/features/manga/domain/entities/history_entity.dart';

class HistoryModel extends HistoryEntity {
  const HistoryModel({
    required super.id,
    required super.readAt,
    required super.chapter,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      id: json['id']?.toString() ?? '',
      readAt: DateTime.parse(json['readAt'] ?? json['read_at']),
      chapter: HistoryChapterModel.fromJson(json['chapter']),
    );
  }
}

class HistoryChapterModel extends HistoryChapterEntity {
  const HistoryChapterModel({
    required super.id,
    required super.chapterNumber,
    super.title,
    required super.manga,
  });

  factory HistoryChapterModel.fromJson(Map<String, dynamic> json) {
    return HistoryChapterModel(
      id: json['id']?.toString() ?? '',
      chapterNumber: json['chapterNumber'] ?? json['chapter_number'] ?? 0,
      title: json['title'],
      manga: HistoryMangaModel.fromJson(json['manga']),
    );
  }
}

class HistoryMangaModel extends HistoryMangaEntity {
  const HistoryMangaModel({
    required super.id,
    required super.title,
    super.coverUrl,
  });

  factory HistoryMangaModel.fromJson(Map<String, dynamic> json) {
    return HistoryMangaModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      coverUrl: json['coverUrl'] ?? json['cover_url'],
    );
  }
}

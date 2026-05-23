import '../../domain/entities/manga_card.dart';

class MangaCardModel extends MangaCard {
  MangaCardModel({
    required super.id,
    required super.title,
    required super.coverUrl,
    required super.latestChapter,
    required super.isLocked,
    super.unlockCost,
    required super.isNewChapter,
    super.lastUpdated,
    super.genre,
  });

  factory MangaCardModel.fromJson(Map<String, dynamic> json) {
    return MangaCardModel(
      id: json['id'],
      title: json['title'],
      coverUrl: json['cover_url'],
      latestChapter: json['latest_chapter'],
      isLocked: json['is_locked'],
      unlockCost: json['unlock_cost'],
      isNewChapter: json['is_new_chapter'],
      lastUpdated: json['last_updated'] != null 
          ? DateTime.parse(json['last_updated']) 
          : null,
      genre: json['genre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'cover_url': coverUrl,
      'latest_chapter': latestChapter,
      'is_locked': isLocked,
      'unlock_cost': unlockCost,
      'is_new_chapter': isNewChapter,
      'last_updated': lastUpdated?.toIso8601String(),
      'genre': genre,
    };
  }
}

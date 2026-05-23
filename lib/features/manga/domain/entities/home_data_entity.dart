import 'manga_entity.dart';

class HomeDataEntity {
  final List<MangaEntity> banners;
  final List<MangaEntity> recentlyUpdated;
  final List<MangaEntity> recommended;
  final List<RankedMangaEntity> rankings;

  HomeDataEntity({
    required this.banners,
    required this.recentlyUpdated,
    required this.recommended,
    required this.rankings,
  });
}

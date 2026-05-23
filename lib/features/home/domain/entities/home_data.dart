import 'banner_manga.dart';
import 'manga_card.dart';
import 'ranked_manga.dart';

class HomeData {
  final List<BannerManga> banners;
  final List<MangaCard> recentlyUpdated;
  final List<MangaCard> recommended;
  final List<RankedManga> rankings;

  HomeData({
    required this.banners,
    required this.recentlyUpdated,
    required this.recommended,
    required this.rankings,
  });
}

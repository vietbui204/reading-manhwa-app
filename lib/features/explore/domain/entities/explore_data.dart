import '../../../home/domain/entities/manga_card.dart';
import 'explore_banner.dart';
import 'explore_category.dart';

class ExploreData {
  final List<ExploreBanner> banners;
  final List<ExploreCategory> categories;
  final List<MangaCard> featuredMangas;

  ExploreData({
    required this.banners,
    required this.categories,
    required this.featuredMangas,
  });
}

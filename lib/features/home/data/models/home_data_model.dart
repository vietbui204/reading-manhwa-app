import '../../domain/entities/home_data.dart';
import 'banner_manga_model.dart';
import 'manga_card_model.dart';
import 'ranked_manga_model.dart';

class HomeDataModel extends HomeData {
  HomeDataModel({
    required List<BannerMangaModel> super.banners,
    required List<MangaCardModel> super.recentlyUpdated,
    required List<MangaCardModel> super.recommended,
    required List<RankedMangaModel> super.rankings,
  });

  factory HomeDataModel.fromJson(Map<String, dynamic> json) {
    return HomeDataModel(
      banners: (json['banners'] as List)
          .map((e) => BannerMangaModel.fromJson(e))
          .toList(),
      recentlyUpdated: (json['recently_updated'] as List)
          .map((e) => MangaCardModel.fromJson(e))
          .toList(),
      recommended: (json['recommended'] as List)
          .map((e) => MangaCardModel.fromJson(e))
          .toList(),
      rankings: (json['rankings'] as List)
          .map((e) => RankedMangaModel.fromJson(e))
          .toList(),
    );
  }
}

import 'package:appmanga/features/home/data/models/manga_card_model.dart';
import 'package:appmanga/features/explore/domain/entities/explore_data.dart';
import 'explore_banner_model.dart';
import 'explore_category_model.dart';

class ExploreDataModel extends ExploreData {
  ExploreDataModel({
    required List<ExploreBannerModel> super.banners,
    required List<ExploreCategoryModel> super.categories,
    required List<MangaCardModel> super.featuredMangas,
  });

  factory ExploreDataModel.fromJson(Map<String, dynamic> json) {
    return ExploreDataModel(
      banners: (json['banners'] as List)
          .map((e) => ExploreBannerModel.fromJson(e))
          .toList(),
      categories: (json['categories'] as List)
          .map((e) => ExploreCategoryModel.fromDefinition(
                e['id'],
                e['title'],
                _getIconData(e['icon']),
                _getColor(e['color']),
              ))
          .toList(),
      featuredMangas: (json['featured_mangas'] as List)
          .map((e) => MangaCardModel.fromJson(e))
          .toList(),
    );
  }

  static dynamic _getIconData(String name) => null;
  static dynamic _getColor(String color) => null;
}

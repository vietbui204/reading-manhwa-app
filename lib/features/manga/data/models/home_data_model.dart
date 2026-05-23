import 'package:appmanga/features/manga/domain/entities/home_data_entity.dart';
import 'manga_model.dart';
import 'ranked_manga_model.dart';

class HomeDataModel extends HomeDataEntity {
  HomeDataModel({
    required super.banners,
    required super.recentlyUpdated,
    required super.recommended,
    required super.rankings,
  });

  factory HomeDataModel.fromJson(Map<String, dynamic> json) {
    return HomeDataModel(
      banners: (json['banners'] as List)
          .map((e) => MangaModel.fromJson(e))
          .toList(),
      recentlyUpdated: (json['recentlyUpdated'] as List)
          .map((e) => MangaModel.fromJson(e))
          .toList(),
      recommended: (json['recommended'] as List)
          .map((e) => MangaModel.fromJson(e))
          .toList(),
      rankings: (json['rankings'] as List)
          .asMap()
          .entries
          .map((e) => RankedMangaModel.fromJson(e.value, e.key))
          .toList(),
    );
  }
}

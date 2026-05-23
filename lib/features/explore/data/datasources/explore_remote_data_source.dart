import 'package:flutter/material.dart';
import '../../../../features/home/data/models/manga_card_model.dart';
import '../models/explore_banner_model.dart';
import '../models/explore_category_model.dart';
import '../models/explore_data_model.dart';

abstract class ExploreRemoteDataSource {
  Future<ExploreDataModel> getExploreData();
}

class ExploreRemoteDataSourceMock implements ExploreRemoteDataSource {
  @override
  Future<ExploreDataModel> getExploreData() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return ExploreDataModel(
      banners: [
        ExploreBannerModel(
          id: 'b1',
          imageUrl: 'https://img.mangatoon.mobi/contents/832/902/f7743d2c6f.jpg',
        ),
        ExploreBannerModel(
          id: 'b2',
          imageUrl: 'https://img.mangatoon.mobi/contents/832/902/765089e083.jpg',
        ),
        ExploreBannerModel(
          id: 'b3',
          imageUrl: 'https://img.mangatoon.mobi/contents/832/902/5e4f738a1a.jpg',
        ),
      ],
      categories: [
        ExploreCategoryModel.fromDefinition('cat1', 'Hành động', Icons.bolt, Colors.orange),
        ExploreCategoryModel.fromDefinition('cat2', 'Tình cảm', Icons.favorite, Colors.pink),
        ExploreCategoryModel.fromDefinition('cat3', 'Hài hước', Icons.sentiment_very_satisfied, Colors.yellow),
        ExploreCategoryModel.fromDefinition('cat4', 'Kinh dị', Icons.warning_amber_rounded, Colors.purple), // Thay Icons.skull
        ExploreCategoryModel.fromDefinition('cat5', 'Đam mỹ', Icons.color_lens, Colors.indigo), // Thay Icons.rainbow
        ExploreCategoryModel.fromDefinition('cat6', 'Xuyên không', Icons.auto_awesome, Colors.blue),
        ExploreCategoryModel.fromDefinition('cat7', 'Học đường', Icons.school, Colors.green),
        ExploreCategoryModel.fromDefinition('cat8', 'Võ thuật', Icons.sports_martial_arts, Colors.red),
      ],
      featuredMangas: List.generate(
        10,
        (i) => MangaCardModel(
          id: 'exp$i',
          title: 'Explore Manga $i',
          coverUrl: 'https://picsum.photos/seed/explore$i/300/400',
          latestChapter: 100 + i,
          isLocked: i % 4 == 0,
          isNewChapter: i % 2 == 0,
        ),
      ),
    );
  }
}

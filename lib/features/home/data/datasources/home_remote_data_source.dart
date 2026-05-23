import 'package:dio/dio.dart';
import '../models/home_data_model.dart';
import '../models/manga_card_model.dart';
import '../models/banner_manga_model.dart';
import '../models/ranked_manga_model.dart';

abstract class HomeRemoteDataSource {
  Future<HomeDataModel> getHomeData();
  Future<List<MangaCardModel>> filterByGenre(String genre);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio;
  HomeRemoteDataSourceImpl(this.dio);

  @override
  Future<HomeDataModel> getHomeData() async {
    final response = await dio.get('/api/home');
    return HomeDataModel.fromJson(response.data['data']);
  }

  @override
  Future<List<MangaCardModel>> filterByGenre(String genre) async {
    final response = await dio.get('/api/manga', queryParameters: {'genre': genre});
    return (response.data['data'] as List)
        .map((e) => MangaCardModel.fromJson(e))
        .toList();
  }
}

class HomeRemoteDataSourceMock implements HomeRemoteDataSource {
  @override
  Future<HomeDataModel> getHomeData() async {
    await Future.delayed(const Duration(seconds: 1));
    return HomeDataModel(
      banners: [
        BannerMangaModel(
          id: '1',
          title: 'Solo Leveling: Arise',
          coverUrl: 'https://image.api.playstation.com/vulcan/ap/rnd/202403/2507/49a9f8b7f8c5b0b6c6f7b9f8b7f8c5b0b6c6f7b9f8.png',
          latestChapter: 180,
          viewCount: 2400000,
          badgeType: 'hot',
        ),
        BannerMangaModel(
          id: '2',
          title: 'One Piece',
          coverUrl: 'https://m.media-amazon.com/images/M/MV5BMTNjNGU4OTMtYjEwNC00OTI5LTg0M2MtYTRiMzRkYTFmY2FhXkEyXkFqcGdeQXVyNTAyODkwOQ@@._V1_.jpg',
          latestChapter: 1110,
          viewCount: 5000000,
          badgeType: 'trending',
        ),
      ],
      recentlyUpdated: List.generate(
        6,
        (i) => MangaCardModel(
          id: 'r$i',
          title: 'Manga Recently $i',
          coverUrl: 'https://picsum.photos/seed/manga$i/200/300',
          latestChapter: 10 + i,
          isLocked: i % 3 == 0,
          unlockCost: i % 3 == 0 ? 50 : null,
          isNewChapter: true,
          lastUpdated: DateTime.now().subtract(Duration(hours: i * 2)),
        ),
      ),
      recommended: List.generate(
        6,
        (i) => MangaCardModel(
          id: 'rec$i',
          title: 'Recommended Manga $i',
          coverUrl: 'https://picsum.photos/seed/rec$i/200/300',
          latestChapter: 50,
          isLocked: false,
          isNewChapter: false,
          genre: 'Action',
        ),
      ),
      rankings: List.generate(
        10,
        (i) => RankedMangaModel(
          rank: i + 1,
          id: 'rank$i',
          title: 'Top Manga Title $i',
          coverUrl: 'https://picsum.photos/seed/rank$i/100/150',
          genre: 'Fantasy',
          status: 'Đang ra',
          viewCount: 1000000 - (i * 50000),
          likeCount: 50000 - (i * 2000),
        ),
      ),
    );
  }

  @override
  Future<List<MangaCardModel>> filterByGenre(String genre) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.generate(
      10,
      (i) => MangaCardModel(
        id: 'f$i',
        title: '$genre Manga $i',
        coverUrl: 'https://picsum.photos/seed/f$genre$i/200/300',
        latestChapter: 10,
        isLocked: false,
        isNewChapter: true,
      ),
    );
  }
}

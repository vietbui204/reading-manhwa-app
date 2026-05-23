import 'package:appmanga/core/constants/api_constants.dart';
import 'package:appmanga/core/network/dio_client.dart';
import '../models/home_data_model.dart';
import '../models/manga_list_model.dart';
import '../models/manga_detail_model.dart';

abstract class MangaRemoteDataSource {
  Future<HomeDataModel> getHomeData();
  Future<MangaListModel> getMangaList({
    int page = 1,
    int limit = 20,
    String? genre,
    String? status,
    String sort = 'latest',
    String? search,
  });
  // Thêm vào abstract class
  Future<Map<String, dynamic>> createChapter(
      String mangaId, {
        required int chapterNumber,
        String? title,
        bool isLocked = false,
        int unlockCost = 0,
        bool isPremiumOnly = false,
      });
  Future<void> addPagesToChapter(
      String chapterId,
      List<String> imageUrls,
      );
  Future<List<dynamic>> getMangasByAuthor(String authorId);
  Future<MangaDetailModel> getMangaDetail(String id);
  Future<dynamic> getChapterPages(String id);
  Future<void> likeManga(String mangaId);
  Future<void> unlikeManga(String mangaId);
  Future<void> followManga(String mangaId);
  Future<void> unfollowManga(String mangaId);
  Future<void> updateReadingHistory(String chapterId);
  Future<List<dynamic>> getReadingHistory({int page = 1, int limit = 20});
  Future<List<dynamic>> getBookmarks({int page = 1, int limit = 20});
  Future<Map<String, dynamic>> unlockChapter(String chapterId);
  Future<int> getPointBalance();
  
  // Comments
  Future<Map<String, dynamic>> getComments(String mangaId, {String? cursor, int limit = 20});
  Future<Map<String, dynamic>> createComment(String mangaId, {required String content, String? parentId});
  Future<List<dynamic>> getCommentReplies(String commentId);
  Future<void> updateComment(String commentId, String content);
  Future<void> deleteComment(String commentId);
  Future<void> likeComment(String commentId);
  Future<void> unlikeComment(String commentId);
}

class MangaRemoteDataSourceImpl implements MangaRemoteDataSource {
  final DioClient _dioClient;

  MangaRemoteDataSourceImpl(this._dioClient);
  @override
  Future<Map<String, dynamic>> createChapter(
      String mangaId, {
        required int chapterNumber,
        String? title,
        bool isLocked = false,
        int unlockCost = 0,
        bool isPremiumOnly = false,
      }) async {
    final response = await _dioClient.dio.post(
      '${ApiConstants.manga}/$mangaId/chapters',
      data: {
        'chapter_number'  : chapterNumber,
        if (title != null) 'title': title,
        'is_locked'       : isLocked,
        'unlock_cost'     : unlockCost,
        'is_premium_only' : isPremiumOnly,
      },
    );
    return response.data['data'];
  }

  @override
  Future<void> addPagesToChapter(
      String chapterId,
      List<String> imageUrls,
      ) async {
    await _dioClient.dio.post(
      '${ApiConstants.chapters}/$chapterId/pages',
      data: {
        'pages': imageUrls.asMap().entries.map((e) => {
          'page_number': e.key + 1,
          'image_url'  : e.value,
        }).toList(),
      },
    );
  }

  @override
  Future<List<dynamic>> getMangasByAuthor(String authorId) async {
    final response = await _dioClient.dio.get(
      '/users/$authorId/manga',
      queryParameters: {'limit': 100},
    );
    return response.data['data'] ?? [];
  }

  @override
  Future<HomeDataModel> getHomeData() async {
    final response = await _dioClient.dio.get(ApiConstants.home);
    return HomeDataModel.fromJson(response.data['data']);
  }

  @override
  Future<MangaListModel> getMangaList({
    int page = 1,
    int limit = 20,
    String? genre,
    String? status,
    String sort = 'latest',
    String? search,
  }) async {
    final response = await _dioClient.dio.get(
      search != null ? ApiConstants.mangaSearch : ApiConstants.manga,
      queryParameters: {
        'page': page,
        'limit': limit,
        if (genre != null) 'genre': genre,
        if (status != null) 'status': status,
        'sort': sort,
        if (search != null) 'search': search,
      },
    );
    return MangaListModel.fromJson(response.data);
  }

  @override
  Future<MangaDetailModel> getMangaDetail(String id) async {
    final response = await _dioClient.dio.get('${ApiConstants.manga}/$id');
    return MangaDetailModel.fromJson(response.data['data']);
  }

  @override
  Future<dynamic> getChapterPages(String id) async {
    final response = await _dioClient.dio.get('/chapters/$id/pages');
    return response.data['data'];
  }

  @override
  Future<void> likeManga(String mangaId) async {
    await _dioClient.dio.post('${ApiConstants.manga}/$mangaId/like');
  }

  @override
  Future<void> unlikeManga(String mangaId) async {
    await _dioClient.dio.delete('${ApiConstants.manga}/$mangaId/like');
  }

  @override
  Future<void> followManga(String mangaId) async {
    await _dioClient.dio.post('${ApiConstants.manga}/$mangaId/follow');
  }

  @override
  Future<void> unfollowManga(String mangaId) async {
    await _dioClient.dio.delete('${ApiConstants.manga}/$mangaId/follow');
  }

  @override
  Future<void> updateReadingHistory(String chapterId) async {
    await _dioClient.dio.post(ApiConstants.readingHistory, data: {
      'chapter_id': chapterId,
    });
  }

  @override
  Future<List<dynamic>> getReadingHistory({int page = 1, int limit = 20}) async {
    final response = await _dioClient.dio.get('${ApiConstants.usersMe}/history', queryParameters: {
      'page': page,
      'limit': limit,
    });
    return response.data['data'];
  }

  @override
  Future<List<dynamic>> getBookmarks({int page = 1, int limit = 20}) async {
    final response = await _dioClient.dio.get('${ApiConstants.usersMe}/bookmarks', queryParameters: {
      'page': page,
      'limit': limit,
    });
    return response.data['data'];
  }

  @override
  Future<Map<String, dynamic>> unlockChapter(String chapterId) async {
    final response = await _dioClient.dio.post('/chapters/$chapterId/unlock');
    return response.data['data'];
  }

  @override
  Future<int> getPointBalance() async {
    final response = await _dioClient.dio.get(ApiConstants.pointsBalance);
    return response.data['data']['balance'];
  }

  @override
  Future<Map<String, dynamic>> getComments(String mangaId, {String? cursor, int limit = 20}) async {
    final response = await _dioClient.dio.get('${ApiConstants.manga}/$mangaId/comments', queryParameters: {
      if (cursor != null) 'cursor': cursor,
      'limit': limit,
    });
    return response.data['data'];
  }

  @override
  Future<Map<String, dynamic>> createComment(String mangaId, {required String content, String? parentId}) async {
    final response = await _dioClient.dio.post('${ApiConstants.manga}/$mangaId/comments', data: {
      'content': content,
      if (parentId != null) 'parent_id': parentId,
    });
    return response.data['data'];
  }

  @override
  Future<List<dynamic>> getCommentReplies(String commentId) async {
    final response = await _dioClient.dio.get('/comments/$commentId/replies');
    return response.data['data'];
  }

  @override
  Future<void> updateComment(String commentId, String content) async {
    await _dioClient.dio.put('/comments/$commentId', data: {'content': content});
  }

  @override
  Future<void> deleteComment(String commentId) async {
    await _dioClient.dio.delete('/comments/$commentId');
  }

  @override
  Future<void> likeComment(String commentId) async {
    await _dioClient.dio.post('/comments/$commentId/like');
  }

  @override
  Future<void> unlikeComment(String commentId) async {
    await _dioClient.dio.delete('/comments/$commentId/like');
  }
}

import 'package:appmanga/features/manga/domain/entities/manga_entity.dart';
import 'package:appmanga/features/manga/domain/usecases/create_chapter_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:appmanga/core/error/error_handler.dart';
import 'package:appmanga/core/error/failures.dart';
import 'package:appmanga/features/manga/domain/entities/home_data_entity.dart';
import 'package:appmanga/features/manga/domain/entities/manga_list_entity.dart';
import 'package:appmanga/features/manga/domain/entities/manga_detail_entity.dart';
import 'package:appmanga/features/manga/domain/entities/chapter_pages_entity.dart';
import 'package:appmanga/features/manga/domain/entities/chapter_entity.dart';
import 'package:appmanga/features/manga/domain/entities/page_entity.dart';
import 'package:appmanga/features/manga/domain/entities/history_entity.dart';
import 'package:appmanga/features/bookmarks/domain/entities/bookmark_entity.dart';
import 'package:appmanga/features/comment/domain/entities/comment_entity.dart';
import 'package:appmanga/features/manga/domain/repositories/manga_repository.dart';
import 'package:appmanga/features/manga/data/models/chapter_model.dart';
import 'package:appmanga/features/manga/data/models/manga_model.dart';
import 'package:appmanga/features/manga/data/models/history_model.dart';
import 'package:appmanga/features/bookmarks/data/models/bookmark_model.dart';
import 'package:appmanga/features/comment/data/models/comment_model.dart';
import '../datasources/manga_remote_datasource.dart';

class MangaRepositoryImpl implements MangaRepository {
  final MangaRemoteDataSource _remote;

  MangaRepositoryImpl(this._remote);

  // Helper để ép kiểu an toàn
  int _safeInt(dynamic value) => MangaModel.toInt(value);

  @override
  Future<Either<Failure, void>> createChapter(
      CreateChapterParams params,
      ) async {
    try {
      // Bước 1: Tạo chapter
      final chapter = await _remote.createChapter(
        params.mangaId,
        chapterNumber : params.chapterNumber,
        title         : params.title,
        isLocked      : params.isLocked,
        unlockCost    : params.unlockCost,
        isPremiumOnly : params.isPremiumOnly,
      );
      // Bước 2: Thêm pages vào chapter vừa tạo
      if (params.imageUrls.isNotEmpty) {
        await _remote.addPagesToChapter(
          chapter['id'],
          params.imageUrls,
        );
      }
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<MangaEntity>>> getMangasByAuthor(
      String authorId,
      ) async {
    try {
      final result = await _remote.getMangasByAuthor(authorId);
      return Right(result.map((e) =>
          MangaModel.fromJson(e as Map<String, dynamic>)
      ).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, HomeDataEntity>> getHomeData() async {
    try {
      final result = await _remote.getHomeData();
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, MangaListEntity>> getMangaList({
    int page = 1,
    int limit = 20,
    String? genre,
    String? status,
    String sort = 'latest',
    String? search,
  }) async {
    try {
      final result = await _remote.getMangaList(
        page: page,
        limit: limit,
        genre: genre,
        status: status,
        sort: sort,
        search: search,
      );
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, MangaListEntity>> searchManga({
    required String query,
    int page = 1,
    int limit = 20,
  }) {
    return getMangaList(page: page, limit: limit, search: query);
  }

  @override
  Future<Either<Failure, MangaDetailEntity>> getMangaDetail(String mangaId) async {
    try {
      final result = await _remote.getMangaDetail(mangaId);
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, ChapterPagesEntity>> getChapterPages(String chapterId) async {
    try {
      final dynamic response = await _remote.getChapterPages(chapterId);
      List<PageEntity> pages = [];
      
      if (response is List) {
        pages = response.map<PageEntity>((e) => PageEntity(
          id: e['id']?.toString() ?? '',
          pageNumber: _safeInt(e['pageNumber'] ?? e['page_number']),
          imageUrl: (e['imageUrl'] ?? e['image_url'] ?? '').toString(),
        )).toList();

        return Right(ChapterPagesEntity(
          chapter: ChapterEntity(
            id: chapterId,
            mangaId: '',
            chapterNumber: 0,
            pageCount: pages.length,
            isLocked: false,
            unlockCost: 0,
            isPremiumOnly: false,
            publishedAt: DateTime.now(),
          ),
          pages: pages,
        ));
      } 
      
      final chapter = ChapterModel.fromJson(Map<String, dynamic>.from(response['chapter']));
      final List pagesRaw = response['pages'] as List? ?? [];
      
      pages = pagesRaw.map<PageEntity>((e) => PageEntity(
        id: e['id']?.toString() ?? '',
        pageNumber: _safeInt(e['pageNumber'] ?? e['page_number']),
        imageUrl: (e['imageUrl'] ?? e['image_url'] ?? '').toString(),
      )).toList();
      
      final prevChapter = response['prevChapter'] != null 
          ? ChapterModel.fromJson(Map<String, dynamic>.from(response['prevChapter'])) 
          : null;
      final nextChapter = response['nextChapter'] != null 
          ? ChapterModel.fromJson(Map<String, dynamic>.from(response['nextChapter'])) 
          : null;

      return Right(ChapterPagesEntity(
        chapter: chapter,
        pages: pages,
        prevChapter: prevChapter,
        nextChapter: nextChapter,
      ));
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> likeManga(String mangaId) async {
    try {
      await _remote.likeManga(mangaId);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> unlikeManga(String mangaId) async {
    try {
      await _remote.unlikeManga(mangaId);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> followManga(String mangaId) async {
    try {
      await _remote.followManga(mangaId);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> unfollowManga(String mangaId) async {
    try {
      await _remote.unfollowManga(mangaId);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> updateReadingHistory(String chapterId) async {
    try {
      await _remote.updateReadingHistory(chapterId);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<HistoryEntity>>> getReadingHistory({int page = 1, int limit = 20}) async {
    try {
      final result = await _remote.getReadingHistory(page: page, limit: limit);
      return Right(result.map((e) => HistoryModel.fromJson(e)).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<BookmarkEntity>>> getBookmarks({int page = 1, int limit = 20}) async {
    try {
      final result = await _remote.getBookmarks(page: page, limit: limit);
      return Right(result.map((e) => BookmarkModel.fromJson(e)).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> unlockChapter(String chapterId) async {
    try {
      final result = await _remote.unlockChapter(chapterId);
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, int>> getPointBalance() async {
    try {
      final result = await _remote.getPointBalance();
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getComments(String mangaId, {String? cursor, int limit = 20}) async {
    try {
      final result = await _remote.getComments(mangaId, cursor: cursor, limit: limit);
      final List commentsRaw = result['comments'] as List? ?? [];
      final comments = commentsRaw.map((e) => CommentModel.fromJson(e)).toList();
      return Right({
        'comments': comments,
        'nextCursor': result['nextCursor'],
        'hasMore': result['hasMore'] ?? false,
      });
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, CommentEntity>> createComment(String mangaId, {required String content, String? parentId}) async {
    try {
      final result = await _remote.createComment(mangaId, content: content, parentId: parentId);
      return Right(CommentModel.fromJson(result));
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<CommentEntity>>> getCommentReplies(String commentId) async {
    try {
      final result = await _remote.getCommentReplies(commentId);
      return Right(result.map((e) => CommentModel.fromJson(e)).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> updateComment(String commentId, String content) async {
    try {
      await _remote.updateComment(commentId, content);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteComment(String commentId) async {
    try {
      await _remote.deleteComment(commentId);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> likeComment(String commentId) async {
    try {
      await _remote.likeComment(commentId);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> unlikeComment(String commentId) async {
    try {
      await _remote.unlikeComment(commentId);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}

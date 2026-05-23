import 'package:appmanga/features/manga/domain/entities/manga_entity.dart';
import 'package:appmanga/features/manga/domain/usecases/create_chapter_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:appmanga/core/error/failures.dart';
import '../entities/home_data_entity.dart';
import '../entities/manga_list_entity.dart';
import '../entities/manga_detail_entity.dart';
import '../entities/chapter_pages_entity.dart';
import '../entities/history_entity.dart';
import '../../../bookmarks/domain/entities/bookmark_entity.dart';
import '../../../comment/domain/entities/comment_entity.dart';

abstract class MangaRepository {
  Future<Either<Failure, HomeDataEntity>> getHomeData();

  
  Future<Either<Failure, MangaListEntity>> getMangaList({
    int page = 1,
    int limit = 20,
    String? genre,
    String? status,
    String sort = 'latest',
    String? search,
  });
  // Thêm vào abstract class MangaRepository
  Future<Either<Failure, void>> createChapter(
      CreateChapterParams params,
      );
  Future<Either<Failure, List<MangaEntity>>> getMangasByAuthor(
      String authorId,
      );

  Future<Either<Failure, MangaListEntity>> searchManga({
    required String query,
    int page = 1,
    int limit = 20,
  });

  Future<Either<Failure, MangaDetailEntity>> getMangaDetail(String mangaId);

  Future<Either<Failure, ChapterPagesEntity>> getChapterPages(String chapterId);

  Future<Either<Failure, void>> likeManga(String mangaId);

  Future<Either<Failure, void>> unlikeManga(String mangaId);

  Future<Either<Failure, void>> followManga(String mangaId);

  Future<Either<Failure, void>> unfollowManga(String mangaId);

  Future<Either<Failure, void>> updateReadingHistory(String chapterId);

  Future<Either<Failure, List<HistoryEntity>>> getReadingHistory({int page = 1, int limit = 20});

  Future<Either<Failure, List<BookmarkEntity>>> getBookmarks({int page = 1, int limit = 20});

  Future<Either<Failure, Map<String, dynamic>>> unlockChapter(String chapterId);

  Future<Either<Failure, int>> getPointBalance();

  // Comments
  Future<Either<Failure, Map<String, dynamic>>> getComments(String mangaId, {String? cursor, int limit = 20});
  Future<Either<Failure, CommentEntity>> createComment(String mangaId, {required String content, String? parentId});
  Future<Either<Failure, List<CommentEntity>>> getCommentReplies(String commentId);
  Future<Either<Failure, void>> updateComment(String commentId, String content);
  Future<Either<Failure, void>> deleteComment(String commentId);
  Future<Either<Failure, void>> likeComment(String commentId);
  Future<Either<Failure, void>> unlikeComment(String commentId);

}

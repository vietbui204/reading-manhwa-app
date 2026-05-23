import 'package:dartz/dartz.dart';
import 'package:appmanga/core/error/error_handler.dart';
import 'package:appmanga/core/error/failures.dart';
import 'package:appmanga/core/storage/local_storage.dart';
import 'package:appmanga/features/profile/domain/entities/profile_entity.dart';
import 'package:appmanga/features/profile/domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import 'package:appmanga/features/profile/domain/entities/creator_manga_entity.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remote;
  final LocalStorage _localStorage;

  ProfileRepositoryImpl(this._remote, this._localStorage);

  @override
  Future<Either<Failure, ProfileEntity>> getUserProfile(String userId) async {
    try {
      final currentUserId = _localStorage.getUserId() ?? '';
      final result = await _remote.getUserProfile(userId, currentUserId);
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> updateProfile({String? username, String? avatarUrl}) async {
    try {
      final currentUserId = _localStorage.getUserId() ?? '';
      final result = await _remote.updateProfile(currentUserId, username: username, avatarUrl: avatarUrl);
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> followUser(String userId) async {
    try {
      await _remote.followUser(userId);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> unfollowUser(String userId) async {
    try {
      await _remote.unfollowUser(userId);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
  @override
  Future<Either<Failure, List<CreatorMangaEntity>>> getUserMangas(
      String userId,
      ) async {
    try {
      final result = await _remote.getUserMangas(userId);
      return Right(result.map((e) => CreatorMangaEntity(
        id          : e['id']?.toString() ?? '',
        title       : e['title']?.toString() ?? '',
        coverUrl    : e['cover_url']?.toString(),
        status      : e['status']?.toString() ?? 'ongoing',
        genres      : List<String>.from(e['genres'] ?? []),
        viewCount   : (e['view_count']   ?? 0) as int,
        likeCount   : (e['like_count']   ?? 0) as int,
        chapterCount: (e['chapter_count'] ?? 0) as int,
        updatedAt   : DateTime.parse(
          e['updated_at'] ?? DateTime.now().toIso8601String(),
        ),
      )).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteManga(String mangaId) async {
    try {
      await _remote.deleteManga(mangaId);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }}

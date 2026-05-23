import 'package:dartz/dartz.dart';
import 'package:appmanga/core/error/failures.dart';
import '../entities/profile_entity.dart';
import '../entities/creator_manga_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileEntity>> getUserProfile(String userId);
  Future<Either<Failure, ProfileEntity>> updateProfile({
    String? username,
    String? avatarUrl,
  });
  Future<Either<Failure, void>> followUser(String userId);
  Future<Either<Failure, void>> unfollowUser(String userId);
  // Thêm mới
  Future<Either<Failure, List<CreatorMangaEntity>>> getUserMangas(
      String userId,
      );
  Future<Either<Failure, void>> deleteManga(String mangaId);
}
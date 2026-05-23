import 'package:appmanga/features/profile/domain/entities/profile_entity.dart';
import 'package:appmanga/features/manga/data/models/manga_model.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.username,
    super.avatarUrl,
    required super.role,
    required super.pointBalance,
    required super.isPremium,
    super.premiumUntil,
    required super.followerCount,
    required super.followingCount,
    super.mangaCount,
    required super.isFollowed,
    required super.isOwnProfile,
    required super.createdAt,
  });

  factory ProfileModel.fromJson(
    Map<String, dynamic> json,
    String currentUserId,
  ) {
    return ProfileModel(
      id: json['id']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      avatarUrl: json['avatarUrl'] ?? json['avatar_url'],
      role: json['role']?.toString() ?? 'user',
      pointBalance: MangaModel.toInt(json['pointBalance'] ?? json['point_balance']),
      isPremium: MangaModel.toBool(json['isPremium'] ?? json['is_premium'], false),
      premiumUntil: json['premiumUntil'] != null || json['premium_until'] != null
          ? DateTime.parse(json['premiumUntil'] ?? json['premium_until'])
          : null,
      followerCount: MangaModel.toInt(json['followerCount'] ?? json['follower_count']),
      followingCount: MangaModel.toInt(json['followingCount'] ?? json['following_count']),
      mangaCount: json['mangaCount'] != null || json['manga_count'] != null
          ? MangaModel.toInt(json['mangaCount'] ?? json['manga_count'])
          : null,
      isFollowed: MangaModel.toBool(json['isFollowed'] ?? json['is_followed'], false),
      isOwnProfile: json['id'] == currentUserId,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : (json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now()),
    );
  }
}

import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String id;
  final String username;
  final String? avatarUrl;
  final String role;
  final int pointBalance;
  final bool isPremium;
  final DateTime? premiumUntil;
  final int followerCount;
  final int followingCount;
  final int? mangaCount;
  final bool isFollowed;
  final bool isOwnProfile;
  final DateTime createdAt;

  const ProfileEntity({
    required this.id,
    required this.username,
    this.avatarUrl,
    required this.role,
    required this.pointBalance,
    required this.isPremium,
    this.premiumUntil,
    required this.followerCount,
    required this.followingCount,
    this.mangaCount,
    required this.isFollowed,
    required this.isOwnProfile,
    required this.createdAt,
  });

  ProfileEntity copyWith({
    String? id,
    String? username,
    String? avatarUrl,
    String? role,
    int? pointBalance,
    bool? isPremium,
    DateTime? premiumUntil,
    int? followerCount,
    int? followingCount,
    int? mangaCount,
    bool? isFollowed,
    bool? isOwnProfile,
    DateTime? createdAt,
  }) {
    return ProfileEntity(
      id: id ?? this.id,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      pointBalance: pointBalance ?? this.pointBalance,
      isPremium: isPremium ?? this.isPremium,
      premiumUntil: premiumUntil ?? this.premiumUntil,
      followerCount: followerCount ?? this.followerCount,
      followingCount: followingCount ?? this.followingCount,
      mangaCount: mangaCount ?? this.mangaCount,
      isFollowed: isFollowed ?? this.isFollowed,
      isOwnProfile: isOwnProfile ?? this.isOwnProfile,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        username,
        avatarUrl,
        role,
        pointBalance,
        isPremium,
        premiumUntil,
        followerCount,
        followingCount,
        mangaCount,
        isFollowed,
        isOwnProfile,
        createdAt,
      ];
}

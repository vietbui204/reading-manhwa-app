class UserEntity {
  final String id;
  final String email;
  final String username;
  final String? avatarUrl;
  final String role; // 'user' | 'creator' | 'admin'
  final int pointBalance;
  final bool isPremium;
  final DateTime? premiumUntil;
  final DateTime createdAt;

  UserEntity({
    required this.id,
    required this.email,
    required this.username,
    this.avatarUrl,
    required this.role,
    required this.pointBalance,
    required this.isPremium,
    this.premiumUntil,
    required this.createdAt,
  });
}

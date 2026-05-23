import 'package:appmanga/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.email,
    required super.username,
    super.avatarUrl,
    required super.role,
    required super.pointBalance,
    required super.isPremium,
    super.premiumUntil,
    required super.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      avatarUrl: json['avatarUrl'], // Đổi từ avatar_url sang avatarUrl
      role: json['role'] ?? 'user',
      pointBalance: json['pointBalance'] ?? 0, // Đổi sang camelCase
      isPremium: json['isPremium'] ?? false, // Đổi sang camelCase
      premiumUntil: json['premiumUntil'] != null 
          ? DateTime.parse(json['premiumUntil']) 
          : null,
      createdAt: DateTime.parse(json['createdAt']), // Đổi sang camelCase
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'avatarUrl': avatarUrl,
      'role': role,
      'pointBalance': pointBalance,
      'isPremium': isPremium,
      'premiumUntil': premiumUntil?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

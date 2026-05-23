import 'package:appmanga/features/auth/domain/entities/auth_token.dart';
import 'user_model.dart';

class AuthTokenModel extends AuthToken {
  AuthTokenModel({
    required super.accessToken,
    required super.refreshToken,
    required UserModel super.user,
  });

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) {
    return AuthTokenModel(
      accessToken: json['accessToken'], // Đổi từ access_token sang accessToken
      refreshToken: json['refreshToken'], // Đổi từ refresh_token sang refreshToken
      user: UserModel.fromJson(json['user']),
    );
  }
}

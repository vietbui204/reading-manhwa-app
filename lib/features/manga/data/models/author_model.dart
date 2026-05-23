import 'package:appmanga/features/manga/domain/entities/manga_entity.dart';

class AuthorModel extends AuthorEntity {
  AuthorModel({
    required super.id,
    required super.username,
    super.avatarUrl,
  });

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
      id: json['id']?.toString() ?? '',
      username: json['username']?.toString() ?? 'Ẩn danh',
      avatarUrl: json['avatarUrl']?.toString(),
    );
  }
}

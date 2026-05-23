import 'package:appmanga/features/comment/domain/entities/comment_entity.dart';
import 'package:appmanga/features/manga/data/models/manga_model.dart';
import 'package:appmanga/core/storage/local_storage.dart';
import 'package:appmanga/core/di/injection.dart';

class CommentModel extends CommentEntity {
  CommentModel({
    required super.id,
    required super.mangaId,
    super.parentId,
    required super.content,
    required super.likeCount,
    required super.isLiked,
    required super.isOwn,
    required super.createdAt,
    required super.user,
    required super.replyCount,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    final currentUserId = sl<LocalStorage>().getUserId();
    return CommentModel(
      id: json['id']?.toString() ?? '',
      mangaId: json['mangaId']?.toString() ?? '',
      parentId: json['parentId']?.toString(),
      content: json['content']?.toString() ?? '',
      likeCount: MangaModel.toInt(json['likeCount'] ?? 0),
      isLiked: MangaModel.toBool(json['isLiked'], false),
      isOwn: json['userId'] == currentUserId,
      createdAt: DateTime.parse(json['createdAt']),
      user: CommentUserModel.fromJson(json['user'] ?? {}),
      replyCount: MangaModel.toInt(json['_count']?['replies'] ?? 0),
    );
  }
}

class CommentUserModel extends CommentUserEntity {
  CommentUserModel({
    required super.id,
    required super.username,
    super.avatarUrl,
  });

  factory CommentUserModel.fromJson(Map<String, dynamic> json) {
    return CommentUserModel(
      id: json['id']?.toString() ?? '',
      username: json['username']?.toString() ?? 'Ẩn danh',
      avatarUrl: json['avatarUrl'],
    );
  }
}

class CommentEntity {
  final String id;
  final String mangaId;
  final String? parentId;
  final String content;
  final int likeCount;
  final bool isLiked;
  final bool isOwn;
  final DateTime createdAt;
  final CommentUserEntity user;
  final int replyCount;

  CommentEntity({
    required this.id,
    required this.mangaId,
    this.parentId,
    required this.content,
    required this.likeCount,
    required this.isLiked,
    required this.isOwn,
    required this.createdAt,
    required this.user,
    required this.replyCount,
  });
}

class CommentUserEntity {
  final String id;
  final String username;
  final String? avatarUrl;

  CommentUserEntity({
    required this.id,
    required this.username,
    this.avatarUrl,
  });
}

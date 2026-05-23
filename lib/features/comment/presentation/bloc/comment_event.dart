import 'package:equatable/equatable.dart';

abstract class CommentEvent extends Equatable {
  const CommentEvent();
  @override
  List<Object?> get props => [];
}

class CommentLoadRequested extends CommentEvent {
  final String mangaId;
  const CommentLoadRequested(this.mangaId);
  @override
  List<Object?> get props => [mangaId];
}

class CommentLoadMore extends CommentEvent {}

class CommentSubmitted extends CommentEvent {
  final String content;
  final String? parentId;
  const CommentSubmitted({required this.content, this.parentId});
  @override
  List<Object?> get props => [content, parentId];
}

class CommentLikeToggled extends CommentEvent {
  final String commentId;
  final bool isLiked;
  const CommentLikeToggled(this.commentId, this.isLiked);
  @override
  List<Object?> get props => [commentId, isLiked];
}

class CommentDeleted extends CommentEvent {
  final String commentId;
  const CommentDeleted(this.commentId);
  @override
  List<Object?> get props => [commentId];
}

class CommentReplyModeSet extends CommentEvent {
  final String? commentId;
  final String? username;
  const CommentReplyModeSet(this.commentId, this.username);
  @override
  List<Object?> get props => [commentId, username];
}

class CommentRepliesLoaded extends CommentEvent {
  final String commentId;
  const CommentRepliesLoaded(this.commentId);
  @override
  List<Object?> get props => [commentId];
}

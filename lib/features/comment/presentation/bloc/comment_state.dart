import 'package:equatable/equatable.dart';
import 'package:appmanga/features/comment/domain/entities/comment_entity.dart';

abstract class CommentState extends Equatable {
  const CommentState();
  @override
  List<Object?> get props => [];
}

class CommentInitial extends CommentState {}

class CommentLoading extends CommentState {}

class CommentLoaded extends CommentState {
  final List<CommentEntity> comments;
  final String? nextCursor;
  final bool hasMore;
  final bool isLoadingMore;
  final bool isSubmitting;
  final String? replyingToId;
  final String? replyingToUsername;
  final Map<String, List<CommentEntity>> replies;

  const CommentLoaded({
    required this.comments,
    this.nextCursor,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.isSubmitting = false,
    this.replyingToId,
    this.replyingToUsername,
    this.replies = const {},
  });

  CommentLoaded copyWith({
    List<CommentEntity>? comments,
    String? nextCursor,
    bool? hasMore,
    bool? isLoadingMore,
    bool? isSubmitting,
    String? replyingToId,
    String? replyingToUsername,
    Map<String, List<CommentEntity>>? replies,
  }) {
    return CommentLoaded(
      comments: comments ?? this.comments,
      nextCursor: nextCursor ?? this.nextCursor,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      replyingToId: replyingToId, // Can be null to clear
      replyingToUsername: replyingToUsername,
      replies: replies ?? this.replies,
    );
  }

  @override
  List<Object?> get props => [
        comments,
        nextCursor,
        hasMore,
        isLoadingMore,
        isSubmitting,
        replyingToId,
        replyingToUsername,
        replies,
      ];
}

class CommentError extends CommentState {
  final String message;
  const CommentError(this.message);
  @override
  List<Object?> get props => [message];
}

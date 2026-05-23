import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appmanga/features/manga/domain/repositories/manga_repository.dart';
import 'package:appmanga/features/comment/domain/entities/comment_entity.dart';
import 'comment_event.dart';
import 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final MangaRepository mangaRepository;

  CommentBloc({required this.mangaRepository}) : super(CommentInitial()) {
    on<CommentLoadRequested>(_onLoadRequested);
    on<CommentLoadMore>(_onLoadMore);
    on<CommentSubmitted>(_onSubmitted);
    on<CommentLikeToggled>(_onLikeToggled);
    on<CommentDeleted>(_onDeleted);
    on<CommentReplyModeSet>(_onReplyModeSet);
    on<CommentRepliesLoaded>(_onRepliesLoaded);
  }

  Future<void> _onLoadRequested(CommentLoadRequested event, Emitter<CommentState> emit) async {
    emit(CommentLoading());
    final result = await mangaRepository.getComments(event.mangaId);
    result.fold(
      (failure) => emit(CommentError(failure.message)),
      (data) {
        final List<CommentEntity> comments = List<CommentEntity>.from(data['comments']);
        emit(CommentLoaded(
          comments: comments,
          nextCursor: data['nextCursor'],
          hasMore: data['hasMore'] ?? false,
        ));
      },
    );
  }

  Future<void> _onLoadMore(CommentLoadMore event, Emitter<CommentState> emit) async {
    if (state is! CommentLoaded) return;
    final current = state as CommentLoaded;
    if (current.isLoadingMore || !current.hasMore) return;

    emit(current.copyWith(isLoadingMore: true));
    final result = await mangaRepository.getComments(
      current.comments.first.mangaId,
      cursor: current.nextCursor,
    );

    result.fold(
      (failure) => emit(current.copyWith(isLoadingMore: false)),
      (data) {
        final List<CommentEntity> newComments = List<CommentEntity>.from(data['comments']);
        emit(current.copyWith(
          comments: [...current.comments, ...newComments],
          nextCursor: data['nextCursor'],
          hasMore: data['hasMore'] ?? false,
          isLoadingMore: false,
        ));
      },
    );
  }

  Future<void> _onSubmitted(CommentSubmitted event, Emitter<CommentState> emit) async {
    if (state is! CommentLoaded) return;
    final current = state as CommentLoaded;
    emit(current.copyWith(isSubmitting: true));

    final result = await mangaRepository.createComment(
      current.comments.isNotEmpty ? current.comments.first.mangaId : '',
      content: event.content,
      parentId: event.parentId,
    );

    result.fold(
      (failure) => emit(current.copyWith(isSubmitting: false)),
      (newComment) {
        if (event.parentId == null) {
          emit(current.copyWith(
            comments: [newComment, ...current.comments],
            isSubmitting: false,
          ));
        } else {
          // Tạo bản sao của Map với kiểu dữ liệu tường minh (Strong Typing)
          final Map<String, List<CommentEntity>> updatedReplies = {};
          current.replies.forEach((key, value) {
            updatedReplies[key] = List<CommentEntity>.from(value);
          });
          
          final List<CommentEntity> existingList = updatedReplies[event.parentId] ?? [];
          updatedReplies[event.parentId!] = [...existingList, newComment];
          
          emit(current.copyWith(
            replies: updatedReplies,
            isSubmitting: false,
          ));
        }
      },
    );
  }

  Future<void> _onLikeToggled(CommentLikeToggled event, Emitter<CommentState> emit) async {
    if (state is! CommentLoaded) return;
    if (event.isLiked) {
      await mangaRepository.unlikeComment(event.commentId);
    } else {
      await mangaRepository.likeComment(event.commentId);
    }
  }

  Future<void> _onDeleted(CommentDeleted event, Emitter<CommentState> emit) async {
    if (state is! CommentLoaded) return;
    final current = state as CommentLoaded;

    final result = await mangaRepository.deleteComment(event.commentId);
    result.fold(
      (failure) => null,
      (_) {
        emit(current.copyWith(
          comments: current.comments.where((c) => c.id != event.commentId).toList(),
        ));
      },
    );
  }

  void _onReplyModeSet(CommentReplyModeSet event, Emitter<CommentState> emit) {
    if (state is! CommentLoaded) return;
    emit((state as CommentLoaded).copyWith(
      replyingToId: event.commentId,
      replyingToUsername: event.username,
    ));
  }

  Future<void> _onRepliesLoaded(CommentRepliesLoaded event, Emitter<CommentState> emit) async {
    if (state is! CommentLoaded) return;
    final current = state as CommentLoaded;

    final result = await mangaRepository.getCommentReplies(event.commentId);
    result.fold(
      (failure) => null,
      (replies) {
        // Sao chép và cập nhật Map an toàn
        final Map<String, List<CommentEntity>> updatedReplies = {};
        current.replies.forEach((key, value) {
          updatedReplies[key] = List<CommentEntity>.from(value);
        });
        
        updatedReplies[event.commentId] = List<CommentEntity>.from(replies);

        emit(current.copyWith(replies: updatedReplies));
      },
    );
  }
}

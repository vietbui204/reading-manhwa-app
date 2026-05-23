import 'package:appmanga/core/theme/app_colors.dart';
import 'package:appmanga/core/utils/format_helper.dart';
import 'package:appmanga/features/comment/domain/entities/comment_entity.dart';
import 'package:appmanga/features/comment/presentation/bloc/comment_bloc.dart';
import 'package:appmanga/features/comment/presentation/bloc/comment_event.dart';
import 'package:appmanga/features/comment/presentation/bloc/comment_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentSheet extends StatefulWidget {
  final String mangaId;
  final ScrollController scrollController;

  const CommentSheet({
    super.key,
    required this.mangaId,
    required this.scrollController,
  });

  @override
  State<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<CommentSheet> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _onSubmit(CommentBloc bloc, String? replyingToId) {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    bloc.add(CommentSubmitted(
      content: text,
      parentId: replyingToId,
    ));
    _commentController.clear();
    bloc.add(const CommentReplyModeSet(null, null));
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Handle bar
        Center(
          child: Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            decoration: BoxDecoration(
              color: AppColors.darkText3,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),

        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const Text(
                'Bình luận',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        ),
        const Divider(color: Colors.white10),

        // Comment list
        Expanded(
          child: BlocBuilder<CommentBloc, CommentState>(
            builder: (context, state) {
              if (state is CommentLoading) {
                return const Center(child: CircularProgressIndicator(color: AppColors.red));
              }
              if (state is CommentLoaded) {
                if (state.comments.isEmpty) {
                  return const Center(
                    child: Text('Chưa có bình luận nào. Hãy là người đầu tiên!',
                        style: TextStyle(color: AppColors.darkText3)),
                  );
                }
                return ListView.builder(
                  controller: widget.scrollController,
                  itemCount: state.comments.length + (state.hasMore ? 1 : 0),
                  itemBuilder: (_, index) {
                    if (index == state.comments.length) {
                      return state.isLoadingMore
                          ? const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()))
                          : TextButton(
                              onPressed: () => context.read<CommentBloc>().add(CommentLoadMore()),
                              child: const Text('Xem thêm bình luận', style: TextStyle(color: AppColors.red)),
                            );
                    }

                    final comment = state.comments[index];
                    return _CommentItem(
                      comment: comment,
                      replies: state.replies[comment.id] ?? [],
                      onLike: () => context.read<CommentBloc>().add(CommentLikeToggled(comment.id, comment.isLiked)),
                      onReply: () => context.read<CommentBloc>().add(CommentReplyModeSet(comment.id, comment.user.username)),
                      onDelete: comment.isOwn
                          ? () => context.read<CommentBloc>().add(CommentDeleted(comment.id))
                          : null,
                      onLoadReplies: () => context.read<CommentBloc>().add(CommentRepliesLoaded(comment.id)),
                    );
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ),

        // Input box
        _buildInputBox(context),
      ],
    );
  }

  Widget _buildInputBox(BuildContext context) {
    return BlocBuilder<CommentBloc, CommentState>(
      builder: (context, state) {
        final bloc = context.read<CommentBloc>();
        String? replyingToId;
        String? replyingToUsername;

        if (state is CommentLoaded) {
          replyingToId = state.replyingToId;
          replyingToUsername = state.replyingToUsername;
        }

        return Container(
          decoration: const BoxDecoration(
            color: AppColors.darkBg2,
            border: Border(top: BorderSide(color: Colors.white10)),
          ),
          padding: EdgeInsets.fromLTRB(12, 8, 12, MediaQuery.of(context).viewInsets.bottom + 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (replyingToId != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: AppColors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.reply, size: 14, color: AppColors.red),
                      const SizedBox(width: 6),
                      Text(
                        'Trả lời @$replyingToUsername',
                        style: const TextStyle(fontSize: 12, color: AppColors.red),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => bloc.add(const CommentReplyModeSet(null, null)),
                        child: const Icon(Icons.close, size: 14, color: AppColors.red),
                      )
                    ],
                  ),
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      maxLines: 4,
                      minLines: 1,
                      decoration: InputDecoration(
                        hintText: replyingToId != null ? 'Viết trả lời...' : 'Viết bình luận...',
                        hintStyle: const TextStyle(color: AppColors.darkText3),
                        filled: true,
                        fillColor: AppColors.darkBg3,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _onSubmit(bloc, replyingToId),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(color: AppColors.red, shape: BoxShape.circle),
                      child: state is CommentLoaded && state.isSubmitting
                          ? const Padding(padding: EdgeInsets.all(10), child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Icon(Icons.send, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CommentItem extends StatelessWidget {
  final CommentEntity comment;
  final List<CommentEntity> replies;
  final VoidCallback onLike;
  final VoidCallback onReply;
  final VoidCallback? onDelete;
  final VoidCallback onLoadReplies;

  const _CommentItem({
    required this.comment,
    required this.replies,
    required this.onLike,
    required this.onReply,
    this.onDelete,
    required this.onLoadReplies,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.darkBg3,
            backgroundImage: comment.user.avatarUrl != null ? CachedNetworkImageProvider(comment.user.avatarUrl!) : null,
            child: comment.user.avatarUrl == null ? const Icon(Icons.person, size: 18, color: AppColors.darkText3) : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(comment.user.username, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                    const SizedBox(width: 8),
                    Text(FormatHelper.timeAgo(comment.createdAt), style: const TextStyle(fontSize: 11, color: AppColors.darkText3)),
                    if (comment.isOwn) ...[
                      const Spacer(),
                      GestureDetector(
                        onTap: onDelete,
                        child: const Text('Xoá', style: TextStyle(fontSize: 11, color: AppColors.red)),
                      )
                    ]
                  ],
                ),
                const SizedBox(height: 4),
                Text(comment.content, style: const TextStyle(fontSize: 13, color: AppColors.darkText)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    GestureDetector(
                      onTap: onLike,
                      child: Row(
                        children: [
                          Icon(comment.isLiked ? Icons.favorite : Icons.favorite_border, size: 16, color: comment.isLiked ? AppColors.red : AppColors.darkText3),
                          const SizedBox(width: 4),
                          Text('${comment.likeCount}', style: const TextStyle(fontSize: 11, color: AppColors.darkText3)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    GestureDetector(
                      onTap: onReply,
                      child: const Row(
                        children: [
                          Icon(Icons.reply, size: 16, color: AppColors.darkText3),
                          const SizedBox(width: 4),
                          Text('Trả lời', style: TextStyle(fontSize: 11, color: AppColors.darkText3)),
                        ],
                      ),
                    ),
                  ],
                ),
                if (comment.replyCount > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: replies.isEmpty
                        ? GestureDetector(
                            onTap: onLoadReplies,
                            child: Text('Xem ${comment.replyCount} trả lời ▾',
                                style: const TextStyle(fontSize: 12, color: AppColors.red, fontWeight: FontWeight.w500)),
                          )
                        : Column(
                            children: replies.map((reply) => _ReplyItem(reply: reply)).toList(),
                          ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReplyItem extends StatelessWidget {
  final CommentEntity reply;
  const _ReplyItem({required this.reply});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: AppColors.darkBg3,
            backgroundImage: reply.user.avatarUrl != null ? CachedNetworkImageProvider(reply.user.avatarUrl!) : null,
            child: reply.user.avatarUrl == null ? const Icon(Icons.person, size: 14, color: AppColors.darkText3) : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(reply.user.username, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white)),
                    const SizedBox(width: 8),
                    Text(FormatHelper.timeAgo(reply.createdAt), style: const TextStyle(fontSize: 10, color: AppColors.darkText3)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(reply.content, style: const TextStyle(fontSize: 12, color: AppColors.darkText)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

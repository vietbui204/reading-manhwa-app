import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:appmanga/core/theme/app_colors.dart';
import 'package:appmanga/core/utils/format_helper.dart';
import 'package:appmanga/features/manga/domain/entities/chapter_entity.dart';
import 'package:appmanga/features/manga/domain/entities/manga_detail_entity.dart';
import 'package:appmanga/shared/widgets/manga_cover_image.dart';
import 'package:appmanga/features/manga/domain/usecases/get_point_balance_usecase.dart';
import 'package:appmanga/features/manga/domain/usecases/unlock_chapter_usecase.dart';
import 'package:appmanga/features/comment/presentation/widgets/comment_sheet.dart';
import 'package:appmanga/core/di/injection.dart';
import '../bloc/manga_detail_bloc.dart';
import '../bloc/manga_detail_event.dart';
import '../bloc/manga_detail_state.dart';

class MangaDetailPage extends StatelessWidget {
  final String mangaId;
  const MangaDetailPage({super.key, required this.mangaId});

  void _showCommentSheet(BuildContext context, MangaDetailEntity manga) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.darkBg2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (_, controller) => CommentSheet(
          mangaId: manga.id,
          scrollController: controller,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MangaDetailBloc, MangaDetailState>(
        builder: (context, state) {
          if (state is MangaDetailLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.red));
          }
          if (state is MangaDetailError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<MangaDetailBloc>().add(MangaDetailLoadRequested(mangaId)),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }
          if (state is MangaDetailLoaded) {
            return _buildContent(context, state);
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, MangaDetailLoaded state) {
    final manga = state.manga;
    return CustomScrollView(
      slivers: [
        _buildAppBar(context, manga),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoSection(context, manga),
                const SizedBox(height: 24),
                _buildActionButtons(context, state),
                const SizedBox(height: 24),
                _buildReadButton(context, manga),
                const SizedBox(height: 32),
                Text(
                  'DANH SÁCH CHƯƠNG',
                  style: GoogleFonts.bebasNeue(fontSize: 20, letterSpacing: 1.2),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
        _buildChapterList(context, manga.chapters),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context, MangaDetailEntity manga) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: AppColors.darkBg,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          manga.title,
          style: GoogleFonts.notoSans(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            MangaCoverImage(
              imageUrl: manga.coverUrl,
              width: double.infinity,
              height: 300,
              borderRadius: 0,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.darkBg.withOpacity(0.9),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, MangaDetailEntity manga) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildStatusBadge(manga.status),
            const SizedBox(width: 12),
            const Icon(Icons.person_outline, size: 14, color: AppColors.darkText2),
            const SizedBox(width: 4),
            Text(manga.author.username, style: const TextStyle(color: AppColors.darkText2, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatItem(Icons.visibility_outlined, manga.viewCount),
            _buildStatItem(Icons.favorite_outline, manga.likeCount),
            _buildStatItem(Icons.bookmark_outline, manga.followCount),
            _buildStatItem(Icons.chat_bubble_outline, manga.commentCount),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: manga.genres.map((g) => _buildGenreChip(g)).toList(),
        ),
        const SizedBox(height: 16),
        Text(
          manga.description ?? 'Chưa có mô tả cho bộ truyện này.',
          style: const TextStyle(color: AppColors.darkText2, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.red.withOpacity(0.5)),
      ),
      child: Text(
        status.toUpperCase(),
        style: const TextStyle(color: AppColors.red, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, int value) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppColors.darkText2),
        const SizedBox(height: 4),
        Text(FormatHelper.compactNumber(value), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildGenreChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.darkBg3,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: const TextStyle(fontSize: 11, color: AppColors.darkText2)),
    );
  }

  Widget _buildActionButtons(BuildContext context, MangaDetailLoaded state) {
    final manga = state.manga;
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: state.isFollowLoading ? null : () => context.read<MangaDetailBloc>().add(MangaDetailFollowToggled()),
            icon: Icon(state.isFollowed ? Icons.bookmark : Icons.bookmark_add_outlined),
            label: Text(state.isFollowed ? 'Đang theo dõi' : 'Theo dõi'),
            style: ElevatedButton.styleFrom(
              backgroundColor: state.isFollowed ? AppColors.red : Colors.transparent,
              foregroundColor: state.isFollowed ? Colors.white : AppColors.red,
              side: const BorderSide(color: AppColors.red),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 8),
        OutlinedButton.icon(
          onPressed: () => _showCommentSheet(context, manga),
          icon: const Icon(Icons.comment_outlined, size: 16),
          label: Text('${manga.commentCount}'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.darkText2,
            side: const BorderSide(color: AppColors.darkBg3),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        ),
        const SizedBox(width: 8),
        IconButton.filled(
          onPressed: state.isLikeLoading ? null : () => context.read<MangaDetailBloc>().add(MangaDetailLikeToggled()),
          icon: Icon(state.isLiked ? Icons.favorite : Icons.favorite_border),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.darkBg3,
            foregroundColor: state.isLiked ? AppColors.red : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  Widget _buildReadButton(BuildContext context, MangaDetailEntity manga) {
    if (manga.chapters.isEmpty) return const SizedBox();

    final firstChapter = (List<ChapterEntity>.from(manga.chapters)..sort((a, b) => a.chapterNumber.compareTo(b.chapterNumber))).first;

    return ElevatedButton(
      onPressed: () => context.push('/reader/${firstChapter.id}'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.red,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text('BẮT ĐẦU ĐỌC', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
    );
  }

  Widget _buildChapterList(BuildContext context, List<ChapterEntity> chapters) {
    final sortedChapters = List<ChapterEntity>.from(chapters)..sort((a, b) => b.chapterNumber.compareTo(a.chapterNumber));

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final chapter = sortedChapters[index];
          return ListTile(
            onTap: () {
              if (chapter.hasAccess || !chapter.isLocked) {
                context.push('/reader/${chapter.id}');
              } else {
                _showUnlockSheet(context, chapter);
              }
            },
            leading: Text(
              '${chapter.chapterNumber}',
              style: GoogleFonts.bebasNeue(fontSize: 18, color: chapter.isRead ? AppColors.darkText3 : AppColors.red),
            ),
            title: Text(
              chapter.title ?? 'Chương ${chapter.chapterNumber}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: chapter.isRead ? FontWeight.normal : FontWeight.bold,
                color: chapter.isRead ? AppColors.darkText3 : Colors.white,
              ),
            ),
            subtitle: Text(
              '${chapter.pageCount} trang • ${FormatHelper.timeAgo(chapter.publishedAt)}',
              style: const TextStyle(fontSize: 11, color: AppColors.darkText3),
            ),
            trailing: _buildChapterTrailing(chapter),
          );
        },
        childCount: sortedChapters.length,
      ),
    );
  }

  Widget _buildChapterTrailing(ChapterEntity chapter) {
    if (chapter.isLocked && !chapter.hasAccess) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${chapter.unlockCost}', style: const TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(width: 4),
          const Icon(Icons.lock, size: 14, color: Colors.amber),
        ],
      );
    }
    if (chapter.isPremiumOnly && !chapter.hasAccess) {
      return const Icon(Icons.star, color: Colors.amber, size: 18);
    }
    return const Icon(Icons.chevron_right, size: 16, color: AppColors.darkText3);
  }

  void _showUnlockSheet(BuildContext context, ChapterEntity chapter) async {
    final balanceResult = await sl<GetPointBalanceUseCase>().call();
    int currentBalance = 0;
    balanceResult.fold((_) => null, (b) => currentBalance = b);

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkBg2,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('MỞ KHÓA CHƯƠNG', style: GoogleFonts.bebasNeue(fontSize: 24, color: Colors.white)),
            const SizedBox(height: 16),
            Text('Bạn cần mở khóa Chapter ${chapter.chapterNumber} để tiếp tục đọc.', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.stars, color: Colors.amber),
                const SizedBox(width: 8),
                Text('Cần: ${chapter.unlockCost} điểm', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
            const SizedBox(height: 8),
            Text('Bạn đang có: $currentBalance điểm', style: TextStyle(color: currentBalance >= chapter.unlockCost ? Colors.green : AppColors.red)),
            const SizedBox(height: 32),
            if (currentBalance >= chapter.unlockCost)
              ElevatedButton(
                onPressed: () async {
                  final result = await sl<UnlockChapterUseCase>().call(chapter.id);
                  result.fold(
                    (f) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(f.message))),
                    (_) {
                      Navigator.pop(ctx);
                      context.push('/reader/${chapter.id}');
                    },
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.red, minimumSize: const Size(double.infinity, 50)),
                child: const Text('XÁC NHẬN MỞ KHÓA'),
              )
            else
              TextButton(
                onPressed: () => context.go('/rewards'),
                child: const Text('KIẾM THÊM ĐIỂM NGAY', style: TextStyle(color: AppColors.red)),
              ),
          ],
        ),
      ),
    );
  }
}

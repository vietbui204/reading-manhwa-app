import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:appmanga/core/theme/app_colors.dart';
import 'package:appmanga/core/utils/format_helper.dart';
import 'package:appmanga/shared/widgets/manga_cover_image.dart';
import '../bloc/bookmarks_bloc.dart';
import '../bloc/bookmarks_event.dart';
import '../bloc/bookmarks_state.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<BookmarksBloc>().add(BookmarksLoadMore());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Truyện đang theo dõi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocBuilder<BookmarksBloc, BookmarksState>(
        builder: (context, state) {
          if (state is BookmarksLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.red));
          }
          if (state is BookmarksEmpty) {
            return _buildEmptyState();
          }
          if (state is BookmarksError) {
            return Center(child: Text(state.message));
          }
          if (state is BookmarksLoaded) {
            return RefreshIndicator(
              onRefresh: () async => context.read<BookmarksBloc>().add(BookmarksRefreshRequested()),
              child: ListView.separated(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(vertical: 12),
                itemCount: state.bookmarks.length + (state.isLoadingMore ? 1 : 0),
                separatorBuilder: (_, __) => const Divider(color: Colors.white10, height: 1),
                itemBuilder: (context, index) {
                  if (index == state.bookmarks.length) {
                    return const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()));
                  }
                  final item = state.bookmarks[index];
                  return _buildBookmarkItem(context, item);
                },
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_border, size: 80, color: Colors.white.withOpacity(0.1)),
          const SizedBox(height: 16),
          const Text('Chưa theo dõi truyện nào', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Hãy follow những truyện bạn thích', style: TextStyle(fontSize: 13, color: AppColors.darkText3)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.go('/explore'),
            icon: const Icon(Icons.explore, size: 18),
            label: const Text('Khám phá truyện'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.red, foregroundColor: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildBookmarkItem(BuildContext context, dynamic item) {
    return InkWell(
      onTap: () => context.push('/manga/${item.mangaId}'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Stack(
              children: [
                MangaCoverImage(imageUrl: item.coverUrl, width: 70, height: 95, borderRadius: 8),
                if (item.isNewChapter)
                  Positioned(
                    top: 4, right: 4,
                    child: Container(
                      width: 10, height: 10,
                      decoration: BoxDecoration(
                        color: AppColors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.darkBg, width: 1.5),
                      ),
                    ),
                  )
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.mangaTitle,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    maxLines: 2, overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      item.status.toUpperCase(),
                      style: const TextStyle(fontSize: 10, color: AppColors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Chapter ${item.latestChapter}', style: const TextStyle(fontSize: 12, color: AppColors.darkText2)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 12, color: AppColors.darkText3),
                      const SizedBox(width: 4),
                      Text(FormatHelper.timeAgo(item.updatedAt), style: const TextStyle(fontSize: 11, color: AppColors.darkText3)),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.darkText3),
          ],
        ),
      ),
    );
  }
}

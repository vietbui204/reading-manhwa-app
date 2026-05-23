import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:appmanga/core/theme/app_colors.dart';
import 'package:appmanga/core/utils/format_helper.dart';
import 'package:appmanga/shared/widgets/manga_cover_image.dart';
import '../bloc/history_bloc.dart';
import '../bloc/history_event.dart';
import '../bloc/history_state.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<HistoryBloc>().add(HistoryLoadMore());
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
        title: const Text('Lịch sử đọc', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.red));
          }
          if (state is HistoryEmpty) {
            return _buildEmptyState();
          }
          if (state is HistoryError) {
            return Center(child: Text(state.message));
          }
          if (state is HistoryLoaded) {
            return RefreshIndicator(
              onRefresh: () async => context.read<HistoryBloc>().add(HistoryRefreshRequested()),
              child: ListView.separated(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(vertical: 12),
                itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
                separatorBuilder: (_, __) => const Divider(color: Colors.white10, height: 1),
                itemBuilder: (context, index) {
                  if (index == state.items.length) {
                    return const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()));
                  }
                  final item = state.items[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: MangaCoverImage(
                      imageUrl: item.chapter.manga.coverUrl,
                      width: 56,
                      height: 76,
                      borderRadius: 8,
                    ),
                    title: Text(
                      item.chapter.manga.title,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          'Chapter ${item.chapter.chapterNumber}${item.chapter.title != null ? ': ${item.chapter.title}' : ''}',
                          style: const TextStyle(fontSize: 12, color: AppColors.red, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 11, color: AppColors.darkText3),
                            const SizedBox(width: 4),
                            Text(
                              FormatHelper.timeAgo(item.readAt),
                              style: const TextStyle(fontSize: 11, color: AppColors.darkText3),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.play_circle_outline, color: AppColors.red, size: 32),
                      onPressed: () => context.push('/reader/${item.chapter.id}'),
                      tooltip: 'Đọc tiếp',
                    ),
                    onTap: () => context.push('/manga/${item.chapter.manga.id}'),
                  );
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
          Icon(Icons.history, size: 80, color: Colors.white.withOpacity(0.1)),
          const SizedBox(height: 16),
          const Text('Chưa đọc truyện nào', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Hãy bắt đầu đọc truyện yêu thích', style: TextStyle(fontSize: 13, color: AppColors.darkText3)),
        ],
      ),
    );
  }
}

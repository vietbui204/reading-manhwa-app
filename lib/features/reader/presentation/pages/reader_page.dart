import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:appmanga/core/theme/app_colors.dart';
import 'package:appmanga/features/manga/domain/entities/page_entity.dart';
import '../bloc/reader_bloc.dart';

class ReaderPage extends StatefulWidget {
  final String chapterId;
  const ReaderPage({super.key, required this.chapterId});

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<ReaderBloc, ReaderState>(
        builder: (context, state) {
          if (state is ReaderLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.red));
          }
          if (state is ReaderError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: AppColors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(state.message, style: const TextStyle(color: Colors.white)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
                    onPressed: () => context.read<ReaderBloc>().add(ReaderLoadRequested(widget.chapterId)),
                    child: const Text('Thử lại', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          }
          if (state is ReaderLoaded) {
            return _buildReaderContent(context, state);
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildReaderContent(BuildContext context, ReaderLoaded state) {
    return Stack(
      children: [
        // Nội dung trang truyện (Chỉ cuộn dọc)
        GestureDetector(
          onTap: () => context.read<ReaderBloc>().add(ReaderUIToggled()),
          behavior: HitTestBehavior.opaque,
          child: ColorFiltered(
            colorFilter: ColorFilter.matrix([
              state.brightness, 0, 0, 0, 0,
              0, state.brightness, 0, 0, 0,
              0, 0, state.brightness, 0, 0,
              0, 0, 0, 1, 0,
            ]),
            child: _VerticalReader(pages: state.data.pages),
          ),
        ),

        // TOP BAR
        AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          top: state.showUI ? 0 : -120,
          left: 0,
          right: 0,
          child: _buildTopBar(context, state),
        ),

        // BOTTOM NAVBAR
        AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          bottom: state.showUI ? 0 : -150,
          left: 0,
          right: 0,
          child: _buildBottomNavbar(context, state),
        ),
      ],
    );
  }

  Widget _buildTopBar(BuildContext context, ReaderLoaded state) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, bottom: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black.withOpacity(0.8), Colors.transparent],
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.white, size: 32),
            onPressed: () => context.pop(),
          ),
          Expanded(
            child: Text(
              'Chapter ${state.data.chapter.chapterNumber}',
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center, // Đã sửa từ Center thành TextAlign.center
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavbar(BuildContext context, ReaderLoaded state) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 16,
        left: 16,
        right: 16,
        top: 16,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A20).withOpacity(0.9),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Nút Lùi Chương (Góc trái)
          _buildChapterNavButton(
            icon: Icons.navigate_before,
            onTap: state.data.prevChapter != null 
                ? () => context.read<ReaderBloc>().add(ReaderPrevChapter()) 
                : null,
          ),

          // Nhóm chức năng chính (Giữa)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildNavIcon(Icons.format_list_bulleted, 'Danh sách', () {
                // TODO: Hiển thị danh sách chương
              }),
              const SizedBox(width: 32),
              _buildNavIcon(
                state.isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                'Thích',
                () => context.read<ReaderBloc>().add(ReaderLikeToggled()),
                color: state.isLiked ? AppColors.red : Colors.white,
              ),
              const SizedBox(width: 32),
              _buildNavIcon(Icons.settings_outlined, 'Cài đặt', () {
                _showSettingsSheet(context, state);
              }),
            ],
          ),

          // Nút Chuyển Chương (Góc phải)
          _buildChapterNavButton(
            icon: Icons.navigate_next,
            onTap: state.data.nextChapter != null 
                ? () => context.read<ReaderBloc>().add(ReaderNextChapter()) 
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildChapterNavButton({required IconData icon, VoidCallback? onTap}) {
    final bool isDisabled = onTap == null;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: isDisabled ? Colors.white10 : Colors.white24),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(icon, color: isDisabled ? Colors.white10 : Colors.white, size: 28),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, String label, VoidCallback onTap, {Color color = Colors.white}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(color: color.withOpacity(0.7), fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSettingsSheet(BuildContext context, ReaderLoaded state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A20),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('CÀI ĐẶT ĐỌC', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 32),
            Row(
              children: [
                const Icon(Icons.brightness_low, color: Colors.white70, size: 20),
                Expanded(
                  child: Slider(
                    value: state.brightness,
                    min: 0.2,
                    max: 1.0,
                    activeColor: Colors.amber,
                    onChanged: (v) {
                      context.read<ReaderBloc>().add(ReaderBrightnessChanged(v));
                    },
                  ),
                ),
                const Icon(Icons.brightness_high, color: Colors.white70, size: 20),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Độ sáng màn hình', style: TextStyle(color: Colors.white38, fontSize: 12)),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _VerticalReader extends StatelessWidget {
  final List<PageEntity> pages;
  const _VerticalReader({required this.pages});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pages.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return CachedNetworkImage(
          imageUrl: pages[index].imageUrl,
          width: double.infinity,
          fit: BoxFit.fitWidth,
          placeholder: (context, url) => AspectRatio(
            aspectRatio: 0.7,
            child: Shimmer.fromColors(
              baseColor: Colors.grey[900]!,
              highlightColor: Colors.grey[800]!,
              child: Container(color: Colors.black),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            height: 300,
            color: Colors.grey[900],
            child: const Icon(Icons.broken_image, color: Colors.white24, size: 48),
          ),
        );
      },
    );
  }
}

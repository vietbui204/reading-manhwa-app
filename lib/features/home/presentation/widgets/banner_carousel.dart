import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:appmanga/core/theme/app_colors.dart';
import 'package:appmanga/core/utils/format_helper.dart';
import 'package:appmanga/features/manga/domain/entities/manga_entity.dart';

class BannerCarousel extends StatefulWidget {
  final List<MangaEntity> banners;
  const BannerCarousel({super.key, required this.banners});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  late final PageController _pageController;
  int _currentPage = 0;
  Timer? _autoSlideTimer;

  @override
  void initState() {
    super.initState();
    // Dùng số lớn để cuộn vô hạn
    _pageController = PageController(
      initialPage: 1000,
      viewportFraction: 0.88,
    );
    _currentPage = 1000 % widget.banners.length;
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || widget.banners.isEmpty) return;
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) return const SizedBox();

    return Column(
      children: [
        SizedBox(
          height: 170,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index % widget.banners.length;
              });
            },
            itemBuilder: (context, index) {
              final banner =
              widget.banners[index % widget.banners.length];
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () => context.push('/manga/${banner.id}'),
                  child: _buildBannerCard(context, banner),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        // Dot indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.banners.length, (i) {
            final isActive = i == _currentPage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isActive ? 20 : 7,
              height: 4,
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.red
                    : Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildBannerCard(BuildContext context, MangaEntity banner) {
    final imageUrl = (banner.coverUrl != null &&
        banner.coverUrl!.isNotEmpty)
        ? banner.coverUrl!
        : 'https://via.placeholder.com/300x160.png?text=MangaX';

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Ảnh nền
          CachedNetworkImage(
            imageUrl: imageUrl,
            width: double.infinity,
            height: 170,
            fit: BoxFit.cover,
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: AppColors.darkBg3,
              highlightColor: AppColors.darkBg2,
              child: Container(color: Colors.white),
            ),
            errorWidget: (context, url, error) => Container(
              color: AppColors.darkBg3,
              child: const Icon(Icons.broken_image,
                  color: Colors.white54, size: 40),
            ),
          ),
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.black.withOpacity(0.85),
                  Colors.black.withOpacity(0.05),
                ],
              ),
            ),
          ),
          // Nội dung text
          Positioned(
            bottom: 14,
            left: 14,
            right: 14,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (banner.badgeType != null)
                  _buildBadge(banner.badgeType!),
                const SizedBox(height: 6),
                Text(
                  banner.title,
                  style: GoogleFonts.bebasNeue(
                    fontSize: 22,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Chapter ${banner.latestChapter ?? 0}'
                      ' • ${FormatHelper.compactNumber(banner.viewCount)}'
                      ' lượt xem',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String type) {
    Color color;
    String text;
    switch (type.toLowerCase()) {
      case 'new':
        color = const Color(0xFF1A7FE8);
        text = 'MỚI';
        break;
      case 'trending':
        color = const Color(0xFFD4530E);
        text = 'TRENDING';
        break;
      case 'hot':
      default:
        color = AppColors.red;
        text = 'HOT';
    }
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
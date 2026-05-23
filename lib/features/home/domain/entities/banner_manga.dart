class BannerManga {
  final String id;
  final String title;
  final String coverUrl;
  final int latestChapter;
  final int viewCount;
  final String badgeType; // 'hot' | 'new' | 'trending'

  BannerManga({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.latestChapter,
    required this.viewCount,
    required this.badgeType,
  });
}

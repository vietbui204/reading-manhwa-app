class MangaCard {
  final String id;
  final String title;
  final String coverUrl;
  final int latestChapter;
  final bool isLocked;
  final int? unlockCost;       // null nếu không khoá
  final bool isNewChapter;     // chapter < 24 giờ
  final DateTime? lastUpdated;
  final String? genre;         // dùng cho section Đề xuất

  MangaCard({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.latestChapter,
    required this.isLocked,
    this.unlockCost,
    required this.isNewChapter,
    this.lastUpdated,
    this.genre,
  });
}

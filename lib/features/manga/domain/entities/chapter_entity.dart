class ChapterEntity {
  final String id;
  final String mangaId;
  final int chapterNumber;
  final String? title;
  final int pageCount;
  final bool isLocked;
  final int unlockCost;
  final bool isPremiumOnly;
  final DateTime publishedAt;
  final bool hasAccess;
  final bool isRead;

  ChapterEntity({
    required this.id,
    required this.mangaId,
    required this.chapterNumber,
    this.title,
    required this.pageCount,
    required this.isLocked,
    required this.unlockCost,
    required this.isPremiumOnly,
    required this.publishedAt,
    this.hasAccess = true,
    this.isRead = false,
  });
}

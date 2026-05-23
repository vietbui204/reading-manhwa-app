class RankedManga {
  final int rank;
  final String id;
  final String title;
  final String coverUrl;
  final String genre;
  final String status;         // 'Đang ra' | 'Hoàn thành'
  final int viewCount;
  final int likeCount;

  RankedManga({
    required this.rank,
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.genre,
    required this.status,
    required this.viewCount,
    required this.likeCount,
  });
}

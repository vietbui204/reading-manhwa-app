import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:appmanga/core/utils/format_helper.dart';
import 'package:appmanga/features/manga/domain/entities/manga_entity.dart';

class RankItem extends StatelessWidget {
  final RankedMangaEntity manga;

  const RankItem({super.key, required this.manga});

  @override
  Widget build(BuildContext context) {
    final String imageUrl = (manga.coverUrl != null && manga.coverUrl!.isNotEmpty) 
        ? manga.coverUrl! 
        : 'https://via.placeholder.com/44x60.png?text=?';

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(
              '${manga.rank}',
              style: GoogleFonts.bebasNeue(
                fontSize: 22,
                color: _getRankColor(manga.rank, context),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              width: 44,
              height: 60,
              fit: BoxFit.cover,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Theme.of(context).colorScheme.surfaceVariant,
                highlightColor: Theme.of(context).colorScheme.surface,
                child: Container(color: Colors.white, width: 44, height: 60),
              ),
              errorWidget: (context, url, error) => Container(
                width: 44, height: 60, color: Theme.of(context).colorScheme.surfaceVariant,
                child: const Icon(Icons.broken_image, size: 20),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  manga.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${manga.genres.isNotEmpty ? manga.genres.first : ""} • ${manga.status}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.visibility_outlined, 
                      size: 11, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(
                      FormatHelper.compactNumber(manga.viewCount),
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.favorite_border, 
                      size: 11, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(
                      FormatHelper.compactNumber(manga.likeCount),
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            size: 14,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int rank, BuildContext context) {
    switch (rank) {
      case 1: return const Color(0xFFFFD700);
      case 2: return const Color(0xFFC0C0C0);
      case 3: return const Color(0xFFCD7F32);
      default: return Theme.of(context).colorScheme.onSurfaceVariant;
    }
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:appmanga/core/theme/app_colors.dart';
import 'package:appmanga/features/manga/domain/entities/manga_entity.dart';

class MangaCardItem extends StatelessWidget {
  final MangaEntity manga;
  final String? subtitle;

  const MangaCardItem({
    super.key,
    required this.manga,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final String imageUrl = (manga.coverUrl != null && manga.coverUrl!.isNotEmpty) 
        ? manga.coverUrl! 
        : 'https://via.placeholder.com/110x152.png?text=No+Cover';

    return InkWell(
      onTap: () => context.push('/manga/${manga.id}'),
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 110,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 110,
                    height: 152,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Theme.of(context).colorScheme.surfaceVariant,
                      highlightColor: Theme.of(context).colorScheme.surface,
                      child: Container(width: 110, height: 152, color: Colors.white),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 110, height: 152, 
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      child: const Icon(Icons.broken_image),
                    ),
                  ),
                ),
                if (manga.isNewChapter)
                  Positioned(
                    top: 0, left: 0,
                    child: _buildBadge('MỚI', AppColors.red),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              manga.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle ?? 'Ch.${manga.latestChapter ?? 0}',
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomRight: Radius.circular(6),
        ),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
    );
  }
}

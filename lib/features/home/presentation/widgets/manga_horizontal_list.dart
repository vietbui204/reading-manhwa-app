import 'package:flutter/material.dart';
import 'package:appmanga/features/manga/domain/entities/manga_entity.dart';
import 'manga_card_item.dart';

class MangaHorizontalList extends StatelessWidget {
  final List<MangaEntity> mangas;
  final String Function(MangaEntity)? subtitleBuilder;

  const MangaHorizontalList({
    super.key,
    required this.mangas,
    this.subtitleBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: mangas.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final manga = mangas[index];
          return MangaCardItem(
            manga: manga,
            subtitle: subtitleBuilder?.call(manga),
          );
        },
      ),
    );
  }
}

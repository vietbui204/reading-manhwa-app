import 'chapter_entity.dart';
import 'page_entity.dart';

class ChapterPagesEntity {
  final ChapterEntity chapter;
  final List<PageEntity> pages;
  final ChapterEntity? prevChapter;
  final ChapterEntity? nextChapter;

  ChapterPagesEntity({
    required this.chapter,
    required this.pages,
    this.prevChapter,
    this.nextChapter,
  });
}

import 'package:dartz/dartz.dart';
import 'package:appmanga/core/error/failures.dart';
import '../repositories/manga_repository.dart';

class CreateChapterParams {
  final String mangaId;
  final int chapterNumber;
  final String? title;
  final bool isLocked;
  final int unlockCost;
  final bool isPremiumOnly;
  final List<String> imageUrls;

  CreateChapterParams({
    required this.mangaId,
    required this.chapterNumber,
    this.title,
    this.isLocked      = false,
    this.unlockCost    = 0,
    this.isPremiumOnly = false,
    required this.imageUrls,
  });
}

class CreateChapterUseCase {
  final MangaRepository repository;
  CreateChapterUseCase(this.repository);

  Future<Either<Failure, void>> call(
      CreateChapterParams params,
      ) {
    return repository.createChapter(params);
  }
}
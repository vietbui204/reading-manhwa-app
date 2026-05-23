import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/manga_card.dart';
import '../repositories/home_repository.dart';

class FilterByGenreUseCase {
  final HomeRepository repository;

  FilterByGenreUseCase(this.repository);

  Future<Either<Failure, List<MangaCard>>> call(String genre)
      => repository.filterByGenre(genre);
}

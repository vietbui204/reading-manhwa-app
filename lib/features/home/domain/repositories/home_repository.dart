import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/home_data.dart';
import '../entities/manga_card.dart';

abstract class HomeRepository {
  Future<Either<Failure, HomeData>> getHomeData();
  Future<Either<Failure, List<MangaCard>>> filterByGenre(String genre);
}

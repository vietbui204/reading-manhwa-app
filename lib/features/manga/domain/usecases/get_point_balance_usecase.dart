import 'package:dartz/dartz.dart';
import 'package:appmanga/core/error/failures.dart';
import '../repositories/manga_repository.dart';

class GetPointBalanceUseCase {
  final MangaRepository repository;
  GetPointBalanceUseCase(this.repository);

  Future<Either<Failure, int>> call() {
    return repository.getPointBalance();
  }
}

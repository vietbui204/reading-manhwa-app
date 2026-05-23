import 'package:dartz/dartz.dart';
import 'package:appmanga/core/error/failures.dart';
import '../repositories/profile_repository.dart';

class UnfollowUserUseCase {
  final ProfileRepository repository;
  UnfollowUserUseCase(this.repository);

  Future<Either<Failure, void>> call(String userId) {
    return repository.unfollowUser(userId);
  }
}

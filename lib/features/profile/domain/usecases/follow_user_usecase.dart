import 'package:dartz/dartz.dart';
import 'package:appmanga/core/error/failures.dart';
import '../repositories/profile_repository.dart';

class FollowUserUseCase {
  final ProfileRepository repository;
  FollowUserUseCase(this.repository);

  Future<Either<Failure, void>> call(String userId) {
    return repository.followUser(userId);
  }
}

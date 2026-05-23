import 'package:dartz/dartz.dart';
import 'package:appmanga/core/error/failures.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class GetUserProfileUseCase {
  final ProfileRepository repository;
  GetUserProfileUseCase(this.repository);

  Future<Either<Failure, ProfileEntity>> call(String userId) {
    return repository.getUserProfile(userId);
  }
}

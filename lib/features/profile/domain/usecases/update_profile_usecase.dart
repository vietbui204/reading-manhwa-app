import 'package:dartz/dartz.dart';
import 'package:appmanga/core/error/failures.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileParams {
  final String? username;
  final String? avatarUrl;
  UpdateProfileParams({this.username, this.avatarUrl});
}

class UpdateProfileUseCase {
  final ProfileRepository repository;
  UpdateProfileUseCase(this.repository);

  Future<Either<Failure, ProfileEntity>> call(UpdateProfileParams params) {
    return repository.updateProfile(
      username: params.username,
      avatarUrl: params.avatarUrl,
    );
  }
}

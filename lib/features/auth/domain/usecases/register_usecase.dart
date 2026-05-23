import 'package:dartz/dartz.dart';
import 'package:appmanga/core/error/failures.dart';
import '../entities/auth_token.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, AuthToken>> call({
    required String email,
    required String password,
    required String username,
    String? avatarUrl,
  }) {
    return repository.register(
      email: email,
      password: password,
      username: username,
      avatarUrl: avatarUrl,
    );
  }
}

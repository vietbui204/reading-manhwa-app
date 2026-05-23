import 'package:dartz/dartz.dart';
import 'package:appmanga/core/error/failures.dart';
import '../entities/auth_token.dart';
import '../repositories/auth_repository.dart';

class LoginGoogleUseCase {
  final AuthRepository repository;

  LoginGoogleUseCase(this.repository);

  Future<Either<Failure, AuthToken>> call(String googleIdToken) {
    return repository.loginWithGoogle(googleIdToken);
  }
}

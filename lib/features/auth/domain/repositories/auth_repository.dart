import 'package:dartz/dartz.dart';
import 'package:appmanga/core/error/failures.dart';
import '../entities/auth_token.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthToken>> login(String email, String password);
  Future<Either<Failure, AuthToken>> loginWithGoogle(String googleIdToken);
  Future<Either<Failure, AuthToken>> register({
    required String email,
    required String password,
    required String username,
    String? avatarUrl,
  });
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, AuthToken>> refreshToken(String refreshToken);
  Future<bool> isLoggedIn();
}

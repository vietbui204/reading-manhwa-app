import 'package:dartz/dartz.dart';
import 'package:appmanga/core/error/error_handler.dart';
import 'package:appmanga/core/error/failures.dart';
import 'package:appmanga/features/auth/domain/entities/auth_token.dart';
import 'package:appmanga/features/auth/domain/repositories/auth_repository.dart';
import 'package:appmanga/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:appmanga/features/auth/data/datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  AuthRepositoryImpl(this._remote, this._local);

  @override
  Future<Either<Failure, AuthToken>> login(String email, String password) async {
    try {
      final result = await _remote.login(email, password);
      await _local.saveAuthData(result);
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, AuthToken>> register({
    required String email,
    required String password,
    required String username,
    String? avatarUrl,
  }) async {
    try {
      final result = await _remote.register(
        email: email,
        password: password,
        username: username,
        avatarUrl: avatarUrl,
      );
      await _local.saveAuthData(result);
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, AuthToken>> loginWithGoogle(String googleIdToken) async {
    try {
      final result = await _remote.loginWithGoogle(googleIdToken);
      await _local.saveAuthData(result);
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _remote.logout();
      await _local.clearAuthData();
      return const Right(null);
    } catch (e) {
      // Vẫn xóa data local nếu remote lỗi
      await _local.clearAuthData();
      return const Right(null);
    }
  }

  @override
  Future<Either<Failure, AuthToken>> refreshToken(String refreshToken) async {
    // Refresh token logic is usually handled by AuthInterceptor
    // This is a placeholder for direct manual refresh if needed
    return Left(ServerFailure('Not implemented'));
  }

  @override
  Future<bool> isLoggedIn() => _local.isLoggedIn();
}

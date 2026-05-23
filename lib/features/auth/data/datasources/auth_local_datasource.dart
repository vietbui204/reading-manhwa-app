import 'package:appmanga/core/storage/local_storage.dart';
import 'package:appmanga/core/storage/token_manager.dart';
import 'package:appmanga/features/auth/data/models/auth_token_model.dart';
import 'package:appmanga/features/auth/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveAuthData(AuthTokenModel authToken);
  Future<void> clearAuthData();
  Future<bool> isLoggedIn();
  Future<String?> getAccessToken();
  
  // Các phương thức Onboarding còn thiếu
  Future<bool> hasOnboardingDone();
  Future<void> setOnboardingDone();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final TokenManager _tokenManager;
  final LocalStorage _localStorage;

  AuthLocalDataSourceImpl(this._tokenManager, this._localStorage);

  @override
  Future<void> saveAuthData(AuthTokenModel authToken) async {
    await _tokenManager.saveTokens(
      accessToken: authToken.accessToken,
      refreshToken: authToken.refreshToken,
    );
    final user = authToken.user as UserModel;
    await _localStorage.saveUserInfo(
      userId: user.id,
      email: user.email,
      username: user.username,
      role: user.role,
      avatarUrl: user.avatarUrl,
      pointBalance: user.pointBalance,
      isPremium: user.isPremium,
    );
  }

  @override
  Future<void> clearAuthData() async {
    await _tokenManager.clearTokens();
    await _localStorage.clearUserInfo();
  }

  @override
  Future<bool> isLoggedIn() async {
    return await _tokenManager.hasTokens();
  }

  @override
  Future<String?> getAccessToken() => _tokenManager.getAccessToken();

  @override
  Future<bool> hasOnboardingDone() async {
    return _localStorage.isOnboardingDone();
  }

  @override
  Future<void> setOnboardingDone() async {
    await _localStorage.setOnboardingDone();
  }
}

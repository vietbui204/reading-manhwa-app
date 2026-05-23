import 'package:shared_preferences/shared_preferences.dart';
import 'package:appmanga/core/constants/storage_keys.dart';

class LocalStorage {
  final SharedPreferences _prefs;

  LocalStorage(this._prefs);

  Future<void> saveUserInfo({
    required String userId,
    required String email,
    required String username,
    required String role,
    String? avatarUrl,
    required int pointBalance,
    required bool isPremium,
  }) async {
    await _prefs.setString(StorageKeys.userId, userId);
    await _prefs.setString(StorageKeys.userEmail, email);
    await _prefs.setString(StorageKeys.username, username);
    await _prefs.setString(StorageKeys.userRole, role);
    if (avatarUrl != null) {
      await _prefs.setString(StorageKeys.avatarUrl, avatarUrl);
    }
    await _prefs.setInt(StorageKeys.pointBalance, pointBalance);
    await _prefs.setBool(StorageKeys.isPremium, isPremium);
  }

  String? getUserId() => _prefs.getString(StorageKeys.userId);
  String? getEmail() => _prefs.getString(StorageKeys.userEmail);
  String? getUsername() => _prefs.getString(StorageKeys.username);
  String? getRole() => _prefs.getString(StorageKeys.userRole);
  String? getAvatarUrl() => _prefs.getString(StorageKeys.avatarUrl);
  int getPointBalance() => _prefs.getInt(StorageKeys.pointBalance) ?? 0;
  bool getIsPremium() => _prefs.getBool(StorageKeys.isPremium) ?? false;

  Future<void> clearUserInfo() async {
    await _prefs.remove(StorageKeys.userId);
    await _prefs.remove(StorageKeys.userEmail);
    await _prefs.remove(StorageKeys.username);
    await _prefs.remove(StorageKeys.userRole);
    await _prefs.remove(StorageKeys.avatarUrl);
    await _prefs.remove(StorageKeys.pointBalance);
    await _prefs.remove(StorageKeys.isPremium);
  }

  Future<void> setOnboardingDone() async {
    await _prefs.setBool(StorageKeys.onboardingDone, true);
  }

  bool isOnboardingDone() => _prefs.getBool(StorageKeys.onboardingDone) ?? false;
}

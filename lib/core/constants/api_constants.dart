import 'package:flutter/foundation.dart';

class ApiConstants {
  // Tự động điều chỉnh IP theo môi trường chạy
  // Web: localhost
  // Android Emulator: 10.0.2.2
  static const String baseUrl = kIsWeb 
      ? 'http://localhost:3000/api' 
      : 'http://10.0.2.2:3000/api';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // Auth endpoints
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String loginGoogle = '/auth/google';
  static const String refresh = '/auth/refresh';
  static const String logout = '/auth/logout';

  // Manga endpoints
  static const String home = '/home';
  static const String manga = '/manga';
  static const String mangaSearch = '/manga/search';

  // User endpoints
  static const String usersMe = '/users/me';
  static const String readingHistory = '/reading-history';

  // Points endpoints
  static const String tasks = '/tasks';
  static const String pointsBalance = '/points/balance';
  static const String pointsHistory = '/points/history';

  // Notification endpoints
  static const String notifications = '/notifications';
  static const String unreadCount = '/notifications/unread-count';
  static const String readAll = '/notifications/read-all';

  // Premium endpoints
  static const String premiumStatus = '/premium/status';
  static const String premiumPlans = '/premium/plans';

  // Thêm vào cuối class ApiConstants
  static const String chapters    = '/chapters';
  static const String uploadPages = '/upload/pages';
  static const String uploadCover = '/upload/cover';
}

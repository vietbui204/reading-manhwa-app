import 'package:appmanga/features/creator/presentation/bloc/create_chapter_bloc.dart';
import 'package:appmanga/features/manga/data/datasources/upload_remote_datasource.dart';
import 'package:appmanga/features/manga/domain/usecases/create_chapter_usecase.dart';
import 'package:appmanga/features/manga/domain/usecases/get_mangas_by_author_usecase.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:appmanga/core/network/dio_client.dart';
import 'package:appmanga/core/storage/token_manager.dart';
import 'package:appmanga/core/storage/local_storage.dart';
import 'package:appmanga/core/socket/socket_client.dart';

// Features - Auth
import 'package:appmanga/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:appmanga/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:appmanga/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:appmanga/features/auth/domain/repositories/auth_repository.dart';
import 'package:appmanga/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:appmanga/features/auth/domain/usecases/login_google_usecase.dart';
import 'package:appmanga/features/auth/domain/usecases/login_usecase.dart';
import 'package:appmanga/features/auth/domain/usecases/logout_usecase.dart';
import 'package:appmanga/features/auth/domain/usecases/register_usecase.dart';
import 'package:appmanga/features/auth/presentation/bloc/auth_bloc.dart';

// Features - Manga (Home, Explore, Search, Detail, Reader, History, Bookmarks, Comments)
import 'package:appmanga/features/manga/data/datasources/manga_remote_datasource.dart';
import 'package:appmanga/features/manga/data/repositories/manga_repository_impl.dart';
import 'package:appmanga/features/manga/domain/repositories/manga_repository.dart';
import 'package:appmanga/features/manga/domain/usecases/get_home_data_usecase.dart';
import 'package:appmanga/features/manga/domain/usecases/get_manga_list_usecase.dart';
import 'package:appmanga/features/manga/domain/usecases/get_manga_detail_usecase.dart';
import 'package:appmanga/features/manga/domain/usecases/get_chapter_pages_usecase.dart';
import 'package:appmanga/features/manga/domain/usecases/like_manga_usecase.dart';
import 'package:appmanga/features/manga/domain/usecases/unlike_manga_usecase.dart';
import 'package:appmanga/features/manga/domain/usecases/follow_manga_usecase.dart';
import 'package:appmanga/features/manga/domain/usecases/unfollow_manga_usecase.dart';
import 'package:appmanga/features/manga/domain/usecases/update_reading_history_usecase.dart';
import 'package:appmanga/features/manga/domain/usecases/unlock_chapter_usecase.dart';
import 'package:appmanga/features/manga/domain/usecases/get_point_balance_usecase.dart';
import 'package:appmanga/features/manga/domain/usecases/get_reading_history_usecase.dart';
import 'package:appmanga/features/bookmarks/domain/usecases/get_bookmarks_usecase.dart';
import 'package:appmanga/features/comment/domain/usecases/get_comments_usecase.dart';
import 'package:appmanga/features/comment/domain/usecases/create_comment_usecase.dart';
import 'package:appmanga/features/comment/domain/usecases/get_comment_replies_usecase.dart';
import 'package:appmanga/features/comment/domain/usecases/update_comment_usecase.dart';
import 'package:appmanga/features/comment/domain/usecases/delete_comment_usecase.dart';
import 'package:appmanga/features/comment/domain/usecases/like_comment_usecase.dart';
import 'package:appmanga/features/comment/domain/usecases/unlike_comment_usecase.dart';

// Features - Profile
import 'package:appmanga/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:appmanga/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:appmanga/features/profile/domain/repositories/profile_repository.dart';
import 'package:appmanga/features/profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:appmanga/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:appmanga/features/profile/domain/usecases/follow_user_usecase.dart';
import 'package:appmanga/features/profile/domain/usecases/unfollow_user_usecase.dart';

// Features - Notification
import 'package:appmanga/features/notification/data/datasources/notification_remote_datasource.dart';
import 'package:appmanga/features/notification/data/repositories/notification_repository_impl.dart';
import 'package:appmanga/features/notification/domain/repositories/notification_repository.dart';
import 'package:appmanga/features/notification/domain/usecases/get_notifications_usecase.dart';
import 'package:appmanga/features/notification/domain/usecases/get_unread_count_usecase.dart';
import 'package:appmanga/features/notification/domain/usecases/mark_read_usecase.dart';
import 'package:appmanga/features/notification/domain/usecases/mark_all_read_usecase.dart';

// Features - Points
import 'package:appmanga/features/points/data/datasources/points_remote_datasource.dart';
import 'package:appmanga/features/points/data/repositories/points_repository_impl.dart';
import 'package:appmanga/features/points/domain/repositories/points_repository.dart';
import 'package:appmanga/features/points/domain/usecases/get_tasks_usecase.dart';
import 'package:appmanga/features/points/domain/usecases/complete_task_usecase.dart';
import 'package:appmanga/features/points/domain/usecases/get_point_history_usecase.dart';
import 'package:appmanga/features/points/presentation/bloc/points_bloc.dart';

// Feature Blocs
import 'package:appmanga/features/home/presentation/bloc/home_bloc.dart';
import 'package:appmanga/features/explore/presentation/bloc/explore_bloc.dart';
import 'package:appmanga/features/search/presentation/bloc/search_bloc.dart';
import 'package:appmanga/features/manga_detail/presentation/bloc/manga_detail_bloc.dart';
import 'package:appmanga/features/reader/presentation/bloc/reader_bloc.dart';
import 'package:appmanga/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:appmanga/features/bookmarks/presentation/bloc/bookmarks_bloc.dart';
import 'package:appmanga/features/history/presentation/bloc/history_bloc.dart';
import 'package:appmanga/features/comment/presentation/bloc/comment_bloc.dart';
import 'package:appmanga/features/notification/presentation/bloc/notification_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ── Core & Storage ──────────────────────────
  final sharedPrefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPrefs);
  sl.registerLazySingleton<FlutterSecureStorage>(() => const FlutterSecureStorage());
  
  sl.registerLazySingleton<LocalStorage>(() => LocalStorage(sl()));
  sl.registerLazySingleton<TokenManager>(() => TokenManager(sl()));
  sl.registerLazySingleton<DioClient>(() => DioClient(sl()));
  sl.registerLazySingleton<SocketClient>(() => SocketClient(sl()));

  // ── Auth ─────────────────────────────
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl(), sl()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LoginGoogleUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => CheckAuthUseCase(sl()));

  // ── Manga ──────────────────
  sl.registerLazySingleton<MangaRemoteDataSource>(
    () => MangaRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<MangaRepository>(
    () => MangaRepositoryImpl(sl()),
  );
  // Đăng ký UploadRemoteDataSource nếu chưa có
  sl.registerLazySingleton<UploadRemoteDataSource>(
        () => UploadRemoteDataSourceImpl(sl()),
  );
  
  sl.registerLazySingleton(() => GetHomeDataUseCase(sl()));
  sl.registerLazySingleton(() => GetMangaListUseCase(sl()));
  sl.registerLazySingleton(() => GetMangaDetailUseCase(sl()));
  sl.registerLazySingleton(() => GetChapterPagesUseCase(sl()));
  sl.registerLazySingleton(() => LikeMangaUseCase(sl()));
  sl.registerLazySingleton(() => UnlikeMangaUseCase(sl()));
  sl.registerLazySingleton(() => FollowMangaUseCase(sl()));
  sl.registerLazySingleton(() => UnfollowMangaUseCase(sl()));
  sl.registerLazySingleton(() => UpdateReadingHistoryUseCase(sl()));
  sl.registerLazySingleton(() => UnlockChapterUseCase(sl()));
  sl.registerLazySingleton(() => GetPointBalanceUseCase(sl()));
  sl.registerLazySingleton(() => GetReadingHistoryUseCase(sl()));
  sl.registerLazySingleton(() => GetBookmarksUseCase(sl()));
  sl.registerLazySingleton(() => GetCommentsUseCase(sl()));
  sl.registerLazySingleton(() => CreateCommentUseCase(sl()));
  sl.registerLazySingleton(() => GetCommentRepliesUseCase(sl()));
  sl.registerLazySingleton(() => UpdateCommentUseCase(sl()));
  sl.registerLazySingleton(() => DeleteCommentUseCase(sl()));
  sl.registerLazySingleton(() => LikeCommentUseCase(sl()));
  sl.registerLazySingleton(() => UnlikeCommentUseCase(sl()));
  // Thêm vào hàm init() sau phần đăng ký manga usecases
  sl.registerLazySingleton(() => CreateChapterUseCase(sl()));
  sl.registerLazySingleton(() => GetMangasByAuthorUseCase(sl()));

  // ── Profile ──────────────────
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton(() => GetUserProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerLazySingleton(() => FollowUserUseCase(sl()));
  sl.registerLazySingleton(() => UnfollowUserUseCase(sl()));

  // ── Notification ──────────────────
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetNotificationsUseCase(sl()));
  sl.registerLazySingleton(() => GetUnreadCountUseCase(sl()));
  sl.registerLazySingleton(() => MarkReadUseCase(sl()));
  sl.registerLazySingleton(() => MarkAllReadUseCase(sl()));

  // ── Points ──────────────────
  sl.registerLazySingleton<PointsRemoteDataSource>(
        () => PointsRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<PointsRepository>(
        () => PointsRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetTasksUseCase(sl()));
  sl.registerLazySingleton(() => CompleteTaskUseCase(sl()));
  sl.registerLazySingleton(() => GetPointHistoryUseCase(sl()));

  // ── Blocs ─────────────────────────────
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      loginGoogleUseCase: sl(),
      logoutUseCase: sl(),
      checkAuthUseCase: sl(),
    ),
  );
  
  sl.registerFactory(() => HomeBloc(getHomeDataUseCase: sl()));
  sl.registerFactory(() => ExploreBloc(getMangaListUseCase: sl()));
  sl.registerFactory(() => SearchBloc(getMangaListUseCase: sl()));
  
  sl.registerFactory(() => MangaDetailBloc(
    getMangaDetailUseCase: sl(),
    likeMangaUseCase: sl(),
    unlikeMangaUseCase: sl(),
    followMangaUseCase: sl(),
    unfollowMangaUseCase: sl(),
  ));

  sl.registerFactory(() => ReaderBloc(
    getChapterPagesUseCase: sl(),
    updateReadingHistoryUseCase: sl(),
    likeMangaUseCase: sl(),
    unlikeMangaUseCase: sl(),
    followMangaUseCase: sl(),
    unfollowMangaUseCase: sl(),
  ));

  sl.registerFactory(() => ProfileBloc(
    getUserProfileUseCase: sl(),
    updateProfileUseCase: sl(),
    profileRepository: sl(),
  ));

  sl.registerFactory(() => BookmarksBloc(mangaRepository: sl()));
  sl.registerFactory(() => HistoryBloc(repository: sl()));
  sl.registerFactory(() => CommentBloc(mangaRepository: sl()));

  sl.registerFactory(() => PointsBloc(
    getTasksUseCase       : sl(),
    completeTaskUseCase   : sl(),
    getPointBalanceUseCase: sl(),
    getPointHistoryUseCase: sl(),
  ));

  sl.registerLazySingleton(() => NotificationBloc(
    repository: sl(),
    socketClient: sl(),
  ));

  sl.registerFactory(() => CreateChapterBloc(
    getMangasByAuthorUseCase: sl(),
    createChapterUseCase    : sl(),
    uploadDataSource        : sl(),
  ));
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:appmanga/core/di/injection.dart';
import 'package:appmanga/core/storage/local_storage.dart';

// Auth
import 'package:appmanga/features/auth/presentation/pages/splash_page.dart';
import 'package:appmanga/features/auth/presentation/pages/login_page.dart';
import 'package:appmanga/features/auth/presentation/pages/register_page.dart';
import 'package:appmanga/features/auth/data/datasources/auth_local_datasource.dart';

// Home & Search
import 'package:appmanga/features/home/presentation/pages/home_page.dart';
import 'package:appmanga/features/search/presentation/pages/search_page.dart';
import 'package:appmanga/features/search/presentation/bloc/search_bloc.dart';

// Manga & Reader
import 'package:appmanga/features/manga_detail/presentation/pages/manga_detail_page.dart';
import 'package:appmanga/features/manga_detail/presentation/bloc/manga_detail_bloc.dart';
import 'package:appmanga/features/manga_detail/presentation/bloc/manga_detail_event.dart';
import 'package:appmanga/features/reader/presentation/pages/reader_page.dart';
import 'package:appmanga/features/reader/presentation/bloc/reader_bloc.dart';
import 'package:appmanga/features/reader/presentation/bloc/reader_bloc.dart' as reader;

// Social & Profile
import 'package:appmanga/features/bookmarks/presentation/pages/bookmarks_page.dart';
import 'package:appmanga/features/bookmarks/presentation/bloc/bookmarks_bloc.dart';
import 'package:appmanga/features/bookmarks/presentation/bloc/bookmarks_event.dart';
import 'package:appmanga/features/history/presentation/pages/history_page.dart';
import 'package:appmanga/features/history/presentation/bloc/history_bloc.dart';
import 'package:appmanga/features/history/presentation/bloc/history_event.dart';
import 'package:appmanga/features/notification/presentation/pages/notification_page.dart';
import 'package:appmanga/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:appmanga/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:appmanga/features/profile/presentation/bloc/profile_event.dart';
import 'package:appmanga/features/profile/presentation/pages/profile_page.dart';

// Creator
import 'package:appmanga/features/creator/presentation/bloc/create_chapter_bloc.dart';
import 'package:appmanga/features/creator/presentation/pages/create_chapter_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) async {
      final localAuth = sl<AuthLocalDataSource>();
      final isLoggedIn = await localAuth.getAccessToken() != null;
      
      final bool isAuthRoute = state.matchedLocation == '/login' || 
                               state.matchedLocation == '/register' ||
                               state.matchedLocation == '/splash';

      if (!isLoggedIn) {
        if (!isAuthRoute) return '/splash';
      } else {
        if (isAuthRoute) return '/home';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashPage()),
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterPage()),
      GoRoute(path: '/home', builder: (_, __) => const HomePage()),
      
      GoRoute(
        path: '/search',
        builder: (context, state) => BlocProvider(
          create: (_) => sl<SearchBloc>(),
          child: const SearchPage(),
        ),
      ),
      
      GoRoute(
        path: '/manga/:id',
        builder: (context, state) {
          final mangaId = state.pathParameters['id']!;
          return BlocProvider(
            create: (_) => sl<MangaDetailBloc>()
              ..add(MangaDetailLoadRequested(mangaId)),
            child: MangaDetailPage(mangaId: mangaId),
          );
        },
      ),

      GoRoute(
        path: '/reader/:chapterId',
        builder: (context, state) {
          final chapterId = state.pathParameters['chapterId']!;
          return BlocProvider(
            create: (_) => sl<ReaderBloc>()
              ..add(reader.ReaderLoadRequested(chapterId)),
            child: ReaderPage(chapterId: chapterId),
          );
        },
      ),

      GoRoute(
        path: '/notifications',
        builder: (_, __) => BlocProvider.value(
          value: sl<NotificationBloc>(),
          child: const NotificationPage(),
        ),
      ),

      GoRoute(
        path: '/bookmarks',
        builder: (_, __) => BlocProvider(
          create: (_) => sl<BookmarksBloc>()..add(BookmarksLoadRequested()),
          child: const BookmarksPage(),
        ),
      ),

      GoRoute(
        path: '/history',
        builder: (_, __) => BlocProvider(
          create: (_) => sl<HistoryBloc>()..add(HistoryLoadRequested()),
          child: const HistoryPage(),
        ),
      ),

      GoRoute(
        path: '/profile/:id',
        builder: (context, state) {
          final userId = state.pathParameters['id']!;
          return BlocProvider(
            create: (_) => sl<ProfileBloc>()..add(ProfileLoadRequested(userId)),
            child: ProfilePage(userId: userId),
          );
        },
      ),

      GoRoute(
        path: '/creator/chapter/new',
        builder: (context, state) {
          final mangaId = state.uri.queryParameters['mangaId'];
          return BlocProvider(
            create: (_) {
              final bloc = sl<CreateChapterBloc>();
              final userId = sl<LocalStorage>().getUserId() ?? '';
              bloc.add(CreateChapterMangasLoaded(userId));
              return bloc;
            },
            child: CreateChapterPage(preselectedMangaId: mangaId),
          );
        },
      ),
    ],
  );
}

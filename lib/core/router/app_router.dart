import 'package:appmanga/core/storage/local_storage.dart';
import 'package:appmanga/features/creator/presentation/bloc/create_chapter_bloc.dart';
import 'package:appmanga/features/creator/presentation/pages/create_chapter_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:appmanga/features/auth/presentation/pages/splash_page.dart';
import 'package:appmanga/features/auth/presentation/pages/login_page.dart';
import 'package:appmanga/features/auth/presentation/pages/register_page.dart';
import 'package:appmanga/features/home/presentation/pages/home_page.dart';
import 'package:appmanga/features/search/presentation/pages/search_page.dart';
import 'package:appmanga/features/manga_detail/presentation/pages/manga_detail_page.dart';
import 'package:appmanga/features/manga_detail/presentation/bloc/manga_detail_bloc.dart';
import 'package:appmanga/features/manga_detail/presentation/bloc/manga_detail_event.dart';
import 'package:appmanga/features/reader/presentation/pages/reader_page.dart';
import 'package:appmanga/features/reader/presentation/bloc/reader_bloc.dart';
import 'package:appmanga/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:appmanga/core/di/injection.dart';

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
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchPage(),
      ),
      GoRoute(
        path   : '/creator/chapter/new',
        builder: (context, state) {
          final mangaId = state.uri.queryParameters['mangaId'];
          return BlocProvider(
            create: (_) {
              final bloc = sl<CreateChapterBloc>();
              // Load danh sách manga của author
              final userId = sl<LocalStorage>().getUserId() ?? '';
                bloc.add(CreateChapterMangasLoaded(userId));
              // Nếu có preselectedMangaId thì tự chọn
              return bloc;
            },
            child: CreateChapterPage(preselectedMangaId: mangaId),
          );
        },
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
              ..add(ReaderLoadRequested(chapterId)),
            child: ReaderPage(chapterId: chapterId), // Truyền ID vào đây
          );
        },
      ),
    ],
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appmanga/core/di/injection.dart' as di;
import 'package:appmanga/core/theme/app_theme.dart';
import 'package:appmanga/core/router/app_router.dart';
import 'package:appmanga/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:appmanga/features/auth/presentation/bloc/auth_event.dart';
import 'package:appmanga/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:appmanga/features/notification/presentation/bloc/notification_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MangaApp());
}

class MangaApp extends StatelessWidget {
  const MangaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<AuthBloc>()..add(AuthCheckRequested()),
        ),
        BlocProvider(
          create: (context) => di.sl<NotificationBloc>()..add(NotificationLoadRequested()),
        ),
      ],
      child: MaterialApp.router(
        title: 'MangaX',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        routerConfig: AppRouter.router,
      ),
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appmanga/features/auth/domain/usecases/login_usecase.dart';
import 'package:appmanga/features/auth/domain/usecases/register_usecase.dart';
import 'package:appmanga/features/auth/domain/usecases/login_google_usecase.dart';
import 'package:appmanga/features/auth/domain/usecases/logout_usecase.dart';
import 'package:appmanga/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:appmanga/core/socket/socket_client.dart';
import 'package:appmanga/core/di/injection.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LoginGoogleUseCase loginGoogleUseCase;
  final LogoutUseCase logoutUseCase;
  final CheckAuthUseCase checkAuthUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.loginGoogleUseCase,
    required this.logoutUseCase,
    required this.checkAuthUseCase,
  }) : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLogin);
    on<AuthRegisterRequested>(_onRegister);
    on<AuthGoogleLoginRequested>(_onGoogleLogin);
    on<AuthLogoutRequested>(_onLogout);
    on<AuthCheckRequested>(_onCheckAuth);
  }

  Future<void> _onLogin(AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await loginUseCase(event.email, event.password);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (token) {
        sl<SocketClient>().connect(); // Kết nối Socket
        emit(AuthSuccess(token.user));
      },
    );
  }

  Future<void> _onRegister(AuthRegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await registerUseCase(
      email: event.email,
      password: event.password,
      username: event.username,
      avatarUrl: event.avatarUrl,
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (token) {
        sl<SocketClient>().connect(); // Kết nối Socket
        emit(AuthSuccess(token.user));
      },
    );
  }

  Future<void> _onGoogleLogin(AuthGoogleLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await loginGoogleUseCase(event.googleIdToken);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (token) {
        sl<SocketClient>().connect(); // Kết nối Socket
        emit(AuthSuccess(token.user));
      },
    );
  }

  Future<void> _onLogout(AuthLogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await logoutUseCase();
    sl<SocketClient>().disconnect(); // Ngắt kết nối Socket
    emit(Unauthenticated());
  }

  Future<void> _onCheckAuth(AuthCheckRequested event, Emitter<AuthState> emit) async {
    final isLoggedIn = await checkAuthUseCase();
    if (isLoggedIn) {
      sl<SocketClient>().connect(); // Tự động kết nối nếu đã login
      // Thông tin user sẽ được load lại ở Profile hoặc Home
    } else {
      emit(Unauthenticated());
    }
  }
}

import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  AuthLoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String username;
  final String? avatarUrl;

  AuthRegisterRequested({
    required this.email,
    required this.password,
    required this.username,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [email, password, username, avatarUrl];
}

class AuthGoogleLoginRequested extends AuthEvent {
  final String googleIdToken;

  AuthGoogleLoginRequested(this.googleIdToken);

  @override
  List<Object?> get props => [googleIdToken];
}

class AuthLogoutRequested extends AuthEvent {}

class AuthCheckRequested extends AuthEvent {}

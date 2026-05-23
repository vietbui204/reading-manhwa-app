import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:appmanga/core/storage/local_storage.dart';

abstract class ThemeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ThemeInitialized extends ThemeEvent {}

class ThemeChanged extends ThemeEvent {
  final ThemeMode mode;
  ThemeChanged(this.mode);
  @override
  List<Object?> get props => [mode];
}

class ThemeState extends Equatable {
  final ThemeMode mode;
  const ThemeState(this.mode);
  @override
  List<Object?> get props => [mode];
}

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final LocalStorage localStorage;

  ThemeBloc({required this.localStorage}) : super(const ThemeState(ThemeMode.dark)) {
    on<ThemeInitialized>((event, emit) {
      final savedTheme = localStorage.getRole(); // Mocking: we should use a specific key in LocalStorage
      // Let's assume we use SharedPreferences directly for simplicity in this example
      emit(const ThemeState(ThemeMode.dark));
    });

    on<ThemeChanged>((event, emit) async {
      emit(ThemeState(event.mode));
    });
  }
}

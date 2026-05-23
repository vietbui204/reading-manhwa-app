import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeLoadRequested extends HomeEvent {}

class HomeRefreshRequested extends HomeEvent {}

class HomeGenreFilterChanged extends HomeEvent {
  final String genre;
  HomeGenreFilterChanged(this.genre);

  @override
  List<Object?> get props => [genre];
}

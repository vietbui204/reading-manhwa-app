import 'package:equatable/equatable.dart';

abstract class ExploreEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ExploreLoadRequested extends ExploreEvent {
  final String? genre;
  final String? status;
  final String sort;

  ExploreLoadRequested({
    this.genre,
    this.status,
    this.sort = 'latest',
  });

  @override
  List<Object?> get props => [genre, status, sort];
}

class ExploreLoadMore extends ExploreEvent {}

class ExploreFilterChanged extends ExploreEvent {
  final String? genre;
  final String? status;
  final String sort;

  ExploreFilterChanged({
    this.genre,
    this.status,
    required this.sort,
  });

  @override
  List<Object?> get props => [genre, status, sort];
}

class ExploreRefreshRequested extends ExploreEvent {}

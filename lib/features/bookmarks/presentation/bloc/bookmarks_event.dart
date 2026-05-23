import 'package:equatable/equatable.dart';

abstract class BookmarksEvent extends Equatable {
  const BookmarksEvent();

  @override
  List<Object?> get props => [];
}

class BookmarksLoadRequested extends BookmarksEvent {}

class BookmarksRefreshRequested extends BookmarksEvent {}

class BookmarksLoadMore extends BookmarksEvent {}

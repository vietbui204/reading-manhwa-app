import 'package:equatable/equatable.dart';
import 'package:appmanga/features/bookmarks/domain/entities/bookmark_entity.dart';
import 'package:appmanga/features/manga/domain/entities/manga_list_entity.dart';

abstract class BookmarksState extends Equatable {
  const BookmarksState();

  @override
  List<Object?> get props => [];
}

class BookmarksInitial extends BookmarksState {}

class BookmarksLoading extends BookmarksState {}

class BookmarksLoaded extends BookmarksState {
  final List<BookmarkEntity> bookmarks;
  final bool hasMore;
  final bool isLoadingMore;

  const BookmarksLoaded({
    required this.bookmarks,
    this.hasMore = false,
    this.isLoadingMore = false,
  });

  BookmarksLoaded copyWith({
    List<BookmarkEntity>? bookmarks,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return BookmarksLoaded(
      bookmarks: bookmarks ?? this.bookmarks,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [bookmarks, hasMore, isLoadingMore];
}

class BookmarksEmpty extends BookmarksState {}

class BookmarksError extends BookmarksState {
  final String message;
  const BookmarksError(this.message);

  @override
  List<Object?> get props => [message];
}

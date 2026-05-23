import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appmanga/features/manga/domain/repositories/manga_repository.dart';
import 'bookmarks_event.dart';
import 'bookmarks_state.dart';

class BookmarksBloc extends Bloc<BookmarksEvent, BookmarksState> {
  final MangaRepository mangaRepository;
  int _currentPage = 1;

  BookmarksBloc({required this.mangaRepository}) : super(BookmarksInitial()) {
    on<BookmarksLoadRequested>(_onLoadRequested);
    on<BookmarksRefreshRequested>(_onRefreshRequested);
    on<BookmarksLoadMore>(_onLoadMore);
  }

  Future<void> _onLoadRequested(BookmarksLoadRequested event, Emitter<BookmarksState> emit) async {
    emit(BookmarksLoading());
    _currentPage = 1;
    final result = await mangaRepository.getBookmarks(page: _currentPage);
    result.fold(
      (failure) => emit(BookmarksError(failure.message)),
      (bookmarks) {
        if (bookmarks.isEmpty) {
          emit(BookmarksEmpty());
        } else {
          emit(BookmarksLoaded(
            bookmarks: bookmarks,
            hasMore: bookmarks.length == 20,
          ));
        }
      },
    );
  }

  Future<void> _onRefreshRequested(BookmarksRefreshRequested event, Emitter<BookmarksState> emit) async {
    _currentPage = 1;
    final result = await mangaRepository.getBookmarks(page: _currentPage);
    result.fold(
      (failure) => emit(BookmarksError(failure.message)),
      (bookmarks) {
        if (bookmarks.isEmpty) {
          emit(BookmarksEmpty());
        } else {
          emit(BookmarksLoaded(
            bookmarks: bookmarks,
            hasMore: bookmarks.length == 20,
          ));
        }
      },
    );
  }

  Future<void> _onLoadMore(BookmarksLoadMore event, Emitter<BookmarksState> emit) async {
    if (state is! BookmarksLoaded) return;
    final current = state as BookmarksLoaded;
    if (current.isLoadingMore || !current.hasMore) return;

    emit(current.copyWith(isLoadingMore: true));
    _currentPage++;

    final result = await mangaRepository.getBookmarks(page: _currentPage);
    result.fold(
      (failure) => emit(current.copyWith(isLoadingMore: false)),
      (bookmarks) {
        emit(current.copyWith(
          bookmarks: [...current.bookmarks, ...bookmarks],
          hasMore: bookmarks.length == 20,
          isLoadingMore: false,
        ));
      },
    );
  }
}

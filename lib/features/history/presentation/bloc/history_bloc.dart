import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appmanga/features/manga/domain/repositories/manga_repository.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final MangaRepository repository;
  int _page = 1;

  HistoryBloc({required this.repository}) : super(HistoryInitial()) {
    on<HistoryLoadRequested>(_onLoadRequested);
    on<HistoryRefreshRequested>(_onRefreshRequested);
    on<HistoryLoadMore>(_onLoadMore);
  }

  Future<void> _onLoadRequested(HistoryLoadRequested event, Emitter<HistoryState> emit) async {
    emit(HistoryLoading());
    _page = 1;
    final result = await repository.getReadingHistory(page: _page);
    result.fold(
      (failure) => emit(HistoryError(failure.message)),
      (items) {
        if (items.isEmpty) {
          emit(HistoryEmpty());
        } else {
          emit(HistoryLoaded(
            items: items,
            hasMore: items.length == 20,
          ));
        }
      },
    );
  }

  Future<void> _onRefreshRequested(HistoryRefreshRequested event, Emitter<HistoryState> emit) async {
    _page = 1;
    final result = await repository.getReadingHistory(page: _page);
    result.fold(
      (failure) => emit(HistoryError(failure.message)),
      (items) {
        if (items.isEmpty) {
          emit(HistoryEmpty());
        } else {
          emit(HistoryLoaded(
            items: items,
            hasMore: items.length == 20,
          ));
        }
      },
    );
  }

  Future<void> _onLoadMore(HistoryLoadMore event, Emitter<HistoryState> emit) async {
    if (state is! HistoryLoaded) return;
    final current = state as HistoryLoaded;
    if (current.isLoadingMore || !current.hasMore) return;

    emit(current.copyWith(isLoadingMore: true));
    _page++;

    final result = await repository.getReadingHistory(page: _page);
    result.fold(
      (failure) => emit(current.copyWith(isLoadingMore: false)),
      (newItems) {
        emit(current.copyWith(
          items: [...current.items, ...newItems],
          hasMore: newItems.length == 20,
          isLoadingMore: false,
        ));
      },
    );
  }
}

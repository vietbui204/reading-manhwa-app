import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appmanga/features/manga/domain/usecases/get_manga_list_usecase.dart';
import 'explore_event.dart';
import 'explore_state.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  final GetMangaListUseCase getMangaListUseCase;

  ExploreBloc({required this.getMangaListUseCase}) : super(ExploreInitial()) {
    on<ExploreLoadRequested>(_onLoadRequested);
    on<ExploreLoadMore>(_onLoadMore);
    on<ExploreFilterChanged>(_onFilterChanged);
    on<ExploreRefreshRequested>((event, emit) => add(ExploreLoadRequested(
      genre: state is ExploreLoaded ? (state as ExploreLoaded).selectedGenre : null,
      status: state is ExploreLoaded ? (state as ExploreLoaded).selectedStatus : null,
      sort: state is ExploreLoaded ? (state as ExploreLoaded).selectedSort : 'latest',
    )));
  }

  Future<void> _onLoadRequested(ExploreLoadRequested event, Emitter<ExploreState> emit) async {
    emit(ExploreLoading());
    final result = await getMangaListUseCase(MangaListParams(
      page: 1,
      limit: 20,
      genre: event.genre,
      status: event.status,
      sort: event.sort,
    ));
    
    result.fold(
      (failure) => emit(ExploreError(failure.message)),
      (data) => emit(ExploreLoaded(
        mangas: data.data,
        pagination: data.pagination,
        selectedGenre: event.genre,
        selectedStatus: event.status,
        selectedSort: event.sort,
      )),
    );
  }

  Future<void> _onLoadMore(ExploreLoadMore event, Emitter<ExploreState> emit) async {
    if (state is! ExploreLoaded) return;
    final current = state as ExploreLoaded;
    
    if (current.isLoadingMore || current.pagination.page >= current.pagination.totalPages) return;

    emit(current.copyWith(isLoadingMore: true));

    final result = await getMangaListUseCase(MangaListParams(
      page: current.pagination.page + 1,
      limit: 20,
      genre: current.selectedGenre,
      status: current.selectedStatus,
      sort: current.selectedSort,
    ));

    result.fold(
      (failure) => emit(current.copyWith(isLoadingMore: false)),
      (data) => emit(current.copyWith(
        mangas: [...current.mangas, ...data.data],
        pagination: data.pagination,
        isLoadingMore: false,
      )),
    );
  }

  void _onFilterChanged(ExploreFilterChanged event, Emitter<ExploreState> emit) {
    add(ExploreLoadRequested(
      genre: event.genre,
      status: event.status,
      sort: event.sort,
    ));
  }
}

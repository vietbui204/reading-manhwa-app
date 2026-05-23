import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appmanga/features/manga/domain/usecases/get_manga_list_usecase.dart';
import 'package:stream_transform/stream_transform.dart';
import 'search_event.dart';
import 'search_state.dart';

const _duration = Duration(milliseconds: 500);

EventTransformer<Event> debounce<Event>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final GetMangaListUseCase getMangaListUseCase;

  SearchBloc({
    required this.getMangaListUseCase,
  }) : super(SearchInitial()) {
    on<SearchQueryChanged>(
      _onQueryChanged,
      transformer: debounce(_duration),
    );
    on<SearchCleared>((event, emit) => emit(SearchInitial()));
  }

  Future<void> _onQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim();
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());

    final result = await getMangaListUseCase(MangaListParams(
      search: query,
      page: 1,
      limit: 20,
    ));

    result.fold(
      (failure) => emit(SearchError(failure.message)),
      (data) {
        if (data.data.isEmpty) {
          emit(SearchEmpty(query));
        } else {
          emit(SearchLoaded(
            query: query,
            results: data.data,
            pagination: data.pagination,
          ));
        }
      },
    );
  }
}

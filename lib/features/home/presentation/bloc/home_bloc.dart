import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appmanga/features/manga/domain/usecases/get_home_data_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeDataUseCase getHomeDataUseCase;

  HomeBloc({
    required this.getHomeDataUseCase,
  }) : super(HomeInitial()) {
    on<HomeLoadRequested>(_onLoadRequested);
    on<HomeRefreshRequested>(_onRefreshRequested);
    on<HomeGenreFilterChanged>(_onGenreFilterChanged);
  }

  Future<void> _onLoadRequested(HomeLoadRequested event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    final result = await getHomeDataUseCase();
    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (data) => emit(HomeLoaded(data: data, selectedGenre: 'Tất cả')),
    );
  }

  Future<void> _onRefreshRequested(HomeRefreshRequested event, Emitter<HomeState> emit) async {
    final result = await getHomeDataUseCase();
    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (data) {
        final currentGenre = state is HomeLoaded ? (state as HomeLoaded).selectedGenre : 'Tất cả';
        emit(HomeLoaded(data: data, selectedGenre: currentGenre));
      },
    );
  }

  void _onGenreFilterChanged(HomeGenreFilterChanged event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      emit((state as HomeLoaded).copyWith(selectedGenre: event.genre));
    }
  }
}

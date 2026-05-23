import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appmanga/features/manga/domain/usecases/get_manga_detail_usecase.dart';
import 'package:appmanga/features/manga/domain/usecases/like_manga_usecase.dart';
import 'package:appmanga/features/manga/domain/usecases/unlike_manga_usecase.dart';
import 'package:appmanga/features/manga/domain/usecases/follow_manga_usecase.dart';
import 'package:appmanga/features/manga/domain/usecases/unfollow_manga_usecase.dart';
import 'manga_detail_event.dart';
import 'manga_detail_state.dart';

class MangaDetailBloc extends Bloc<MangaDetailEvent, MangaDetailState> {
  final GetMangaDetailUseCase getMangaDetailUseCase;
  final LikeMangaUseCase likeMangaUseCase;
  final UnlikeMangaUseCase unlikeMangaUseCase;
  final FollowMangaUseCase followMangaUseCase;
  final UnfollowMangaUseCase unfollowMangaUseCase;

  MangaDetailBloc({
    required this.getMangaDetailUseCase,
    required this.likeMangaUseCase,
    required this.unlikeMangaUseCase,
    required this.followMangaUseCase,
    required this.unfollowMangaUseCase,
  }) : super(MangaDetailInitial()) {
    on<MangaDetailLoadRequested>(_onLoadRequested);
    on<MangaDetailLikeToggled>(_onLikeToggled);
    on<MangaDetailFollowToggled>(_onFollowToggled);
  }

  Future<void> _onLoadRequested(
    MangaDetailLoadRequested event,
    Emitter<MangaDetailState> emit,
  ) async {
    emit(MangaDetailLoading());
    final result = await getMangaDetailUseCase(event.mangaId);
    result.fold(
      (failure) => emit(MangaDetailError(failure.message)),
      (manga) => emit(MangaDetailLoaded(
        manga: manga,
        isLiked: manga.isLiked,
        isFollowed: manga.isFollowed,
      )),
    );
  }

  Future<void> _onLikeToggled(
    MangaDetailLikeToggled event,
    Emitter<MangaDetailState> emit,
  ) async {
    if (state is! MangaDetailLoaded) return;
    final current = state as MangaDetailLoaded;
    final wasLiked = current.isLiked;

    emit(current.copyWith(isLiked: !wasLiked, isLikeLoading: true));

    final result = wasLiked
        ? await unlikeMangaUseCase(current.manga.id)
        : await likeMangaUseCase(current.manga.id);

    result.fold(
      (failure) => emit(current.copyWith(isLiked: wasLiked, isLikeLoading: false)),
      (_) => emit(current.copyWith(isLikeLoading: false)),
    );
  }

  Future<void> _onFollowToggled(
    MangaDetailFollowToggled event,
    Emitter<MangaDetailState> emit,
  ) async {
    if (state is! MangaDetailLoaded) return;
    final current = state as MangaDetailLoaded;
    final wasFollowed = current.isFollowed;

    emit(current.copyWith(isFollowed: !wasFollowed, isFollowLoading: true));

    final result = wasFollowed
        ? await unfollowMangaUseCase(current.manga.id)
        : await followMangaUseCase(current.manga.id);

    result.fold(
      (failure) => emit(current.copyWith(isFollowed: wasFollowed, isFollowLoading: false)),
      (_) => emit(current.copyWith(isFollowLoading: false)),
    );
  }
}

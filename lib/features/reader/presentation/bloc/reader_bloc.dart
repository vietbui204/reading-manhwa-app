import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:appmanga/features/manga/domain/entities/chapter_pages_entity.dart';
import 'package:appmanga/features/manga/domain/usecases/get_chapter_pages_usecase.dart';
import 'package:appmanga/features/manga/domain/usecases/update_reading_history_usecase.dart';
import 'package:appmanga/features/manga/domain/usecases/like_manga_usecase.dart';
import 'package:appmanga/features/manga/domain/usecases/unlike_manga_usecase.dart';
import 'package:appmanga/features/manga/domain/usecases/follow_manga_usecase.dart';
import 'package:appmanga/features/manga/domain/usecases/unfollow_manga_usecase.dart';

part 'reader_event.dart';
part 'reader_state.dart';

class ReaderBloc extends Bloc<ReaderEvent, ReaderState> {
  final GetChapterPagesUseCase getChapterPagesUseCase;
  final UpdateReadingHistoryUseCase updateReadingHistoryUseCase;
  final LikeMangaUseCase likeMangaUseCase;
  final UnlikeMangaUseCase unlikeMangaUseCase;
  final FollowMangaUseCase followMangaUseCase;
  final UnfollowMangaUseCase unfollowMangaUseCase;

  ReaderBloc({
    required this.getChapterPagesUseCase,
    required this.updateReadingHistoryUseCase,
    required this.likeMangaUseCase,
    required this.unlikeMangaUseCase,
    required this.followMangaUseCase,
    required this.unfollowMangaUseCase,
  }) : super(ReaderInitial()) {
    on<ReaderLoadRequested>(_onLoadRequested);
    on<ReaderPageChanged>(_onPageChanged);
    on<ReaderUIToggled>(_onUIToggled);
    on<ReaderBrightnessChanged>(_onBrightnessChanged);
    on<ReaderNextChapter>(_onNextChapter);
    on<ReaderPrevChapter>(_onPrevChapter);
    on<ReaderLikeToggled>(_onLikeToggled);
    on<ReaderFollowToggled>(_onFollowToggled);
  }

  Future<void> _onLoadRequested(ReaderLoadRequested event, Emitter<ReaderState> emit) async {
    emit(ReaderLoading());
    final result = await getChapterPagesUseCase(event.chapterId);
    result.fold(
      (failure) => emit(ReaderError(failure.message)),
      (data) {
        emit(ReaderLoaded(
          data: data,
          currentPage: 0,
          brightness: state is ReaderLoaded ? (state as ReaderLoaded).brightness : 1.0,
        ));
        // Ghi lịch sử ngay sau khi load thành công (fire-and-forget)
        updateReadingHistoryUseCase(UpdateReadingHistoryParams(chapterId: event.chapterId));
      },
    );
  }

  void _onPageChanged(ReaderPageChanged event, Emitter<ReaderState> emit) {
    if (state is ReaderLoaded) {
      final current = state as ReaderLoaded;
      emit(current.copyWith(currentPage: event.pageIndex));
    }
  }

  void _onUIToggled(ReaderUIToggled event, Emitter<ReaderState> emit) {
    if (state is ReaderLoaded) {
      final current = state as ReaderLoaded;
      emit(current.copyWith(showUI: !current.showUI));
    }
  }

  void _onBrightnessChanged(ReaderBrightnessChanged event, Emitter<ReaderState> emit) {
    if (state is ReaderLoaded) {
      final current = state as ReaderLoaded;
      emit(current.copyWith(brightness: event.value));
    }
  }

  void _onNextChapter(ReaderNextChapter event, Emitter<ReaderState> emit) {
    if (state is ReaderLoaded) {
      final nextChapter = (state as ReaderLoaded).data.nextChapter;
      if (nextChapter != null) add(ReaderLoadRequested(nextChapter.id));
    }
  }

  void _onPrevChapter(ReaderPrevChapter event, Emitter<ReaderState> emit) {
    if (state is ReaderLoaded) {
      final prevChapter = (state as ReaderLoaded).data.prevChapter;
      if (prevChapter != null) add(ReaderLoadRequested(prevChapter.id));
    }
  }

  Future<void> _onLikeToggled(ReaderLikeToggled event, Emitter<ReaderState> emit) async {
    if (state is! ReaderLoaded) return;
    final current = state as ReaderLoaded;
    final mangaId = current.data.chapter.mangaId;
    if (mangaId.isEmpty) return;

    final wasLiked = current.isLiked;
    emit(current.copyWith(isLiked: !wasLiked));

    final result = wasLiked ? await unlikeMangaUseCase(mangaId) : await likeMangaUseCase(mangaId);
    result.fold(
      (failure) => emit(current.copyWith(isLiked: wasLiked)),
      (_) => null,
    );
  }

  Future<void> _onFollowToggled(ReaderFollowToggled event, Emitter<ReaderState> emit) async {
    if (state is! ReaderLoaded) return;
    final current = state as ReaderLoaded;
    final mangaId = current.data.chapter.mangaId;
    if (mangaId.isEmpty) return;

    final wasFollowed = current.isFollowed;
    emit(current.copyWith(isFollowed: !wasFollowed));

    final result = wasFollowed ? await unfollowMangaUseCase(mangaId) : await followMangaUseCase(mangaId);
    result.fold(
      (failure) => emit(current.copyWith(isFollowed: wasFollowed)),
      (_) => null,
    );
  }
}

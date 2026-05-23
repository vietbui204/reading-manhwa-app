import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appmanga/features/profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:appmanga/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:appmanga/features/auth/domain/repositories/auth_repository.dart'; // Assume follow logic might be here or in profile repo
import 'package:appmanga/features/profile/domain/repositories/profile_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';


class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfileUseCase getUserProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final ProfileRepository profileRepository;

  ProfileBloc({
    required this.getUserProfileUseCase,
    required this.updateProfileUseCase,
    required this.profileRepository,
  }) : super(ProfileInitial()) {
    on<ProfileLoadRequested>(_onLoadRequested);
    on<ProfileFollowToggled>(_onFollowToggled);
    on<ProfileUpdateRequested>(_onUpdateRequested);
    on<ProfileMangasLoadRequested>(_onMangasLoadRequested);
    on<ProfileMangaDeleted>(_onMangaDeleted);
  }
  // Thêm 2 handler mới
  Future<void> _onMangasLoadRequested(
      ProfileMangasLoadRequested event,
      Emitter<ProfileState> emit,
      ) async {
    if (state is! ProfileLoaded) return;
    final current = state as ProfileLoaded;
    emit(current.copyWith(isMangasLoading: true));

    final result = await profileRepository.getUserMangas(event.userId);
    result.fold(
          (failure) => emit(current.copyWith(isMangasLoading: false)),
          (mangas)  => emit(current.copyWith(
        mangas         : mangas,
        isMangasLoading: false,
      )),
    );
  }

  Future<void> _onMangaDeleted(
      ProfileMangaDeleted event,
      Emitter<ProfileState> emit,
      ) async {
    if (state is! ProfileLoaded) return;
    final current = state as ProfileLoaded;
    emit(current.copyWith(isDeletingManga: true));

    final result = await profileRepository.deleteManga(event.mangaId);
    result.fold(
          (failure) => emit(current.copyWith(isDeletingManga: false)),
          (_) {
        // Xoá manga khỏi list local mà không cần reload
        final updatedMangas = current.mangas
            .where((m) => m.id != event.mangaId)
            .toList();
        emit(current.copyWith(
          mangas         : updatedMangas,
          isDeletingManga: false,
        ));
      },
    );
  }

  Future<void> _onLoadRequested(
    ProfileLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final result = await getUserProfileUseCase(event.userId);
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (profile) => emit(ProfileLoaded(profile: profile)),
    );
  }

  Future<void> _onFollowToggled(
    ProfileFollowToggled event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is! ProfileLoaded) return;
    final current = state as ProfileLoaded;
    final wasFollowed = current.profile.isFollowed;

    // Optimistic update
    emit(current.copyWith(
      profile: current.profile.copyWith(
        isFollowed: !wasFollowed,
        followerCount: wasFollowed
            ? current.profile.followerCount - 1
            : current.profile.followerCount + 1,
      ),
      isFollowLoading: true,
    ));

    final result = wasFollowed
        ? await profileRepository.unfollowUser(current.profile.id)
        : await profileRepository.followUser(current.profile.id);

    result.fold(
      (failure) => emit(current.copyWith(isFollowLoading: false)), // Rollback happens by not updating success state or we could explicit rollback
      (_) => emit(current.copyWith(isFollowLoading: false)),
    );
  }

  Future<void> _onUpdateRequested(
    ProfileUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is! ProfileLoaded) return;
    final current = state as ProfileLoaded;
    emit(current.copyWith(isUpdateLoading: true));

    final result = await updateProfileUseCase(
      UpdateProfileParams(
        username: event.username,
        avatarUrl: event.avatarUrl,
      ),
    );

    result.fold(
      (failure) => emit(current.copyWith(isUpdateLoading: false)),
      (updatedProfile) {
        emit(ProfileUpdateSuccess(updatedProfile));
        add(ProfileLoadRequested(updatedProfile.id));
      },
    );
  }
}

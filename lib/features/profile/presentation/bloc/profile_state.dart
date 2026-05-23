import 'package:equatable/equatable.dart';
import 'package:appmanga/features/profile/domain/entities/creator_manga_entity.dart';
import 'package:appmanga/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileEntity profile;
  final bool isFollowLoading;
  final bool isUpdateLoading;
  final List<CreatorMangaEntity> mangas;     // thêm
  final bool isMangasLoading;                // thêm
  final bool isDeletingManga;                // thêm

  const ProfileLoaded({
    required this.profile,
    this.isFollowLoading = false,
    this.isUpdateLoading = false,
    this.mangas          = const [],         // thêm
    this.isMangasLoading = false,            // thêm
    this.isDeletingManga = false,            // thêm

  });

  ProfileLoaded copyWith({
    ProfileEntity? profile,
    bool? isFollowLoading,
    bool? isUpdateLoading,
    List<CreatorMangaEntity>? mangas,
    bool? isMangasLoading,
    bool? isDeletingManga,
  }) {
    return ProfileLoaded(
      profile: profile ?? this.profile,
      isFollowLoading: isFollowLoading ?? this.isFollowLoading,
      isUpdateLoading: isUpdateLoading ?? this.isUpdateLoading,
      mangas          : mangas           ?? this.mangas,
      isMangasLoading : isMangasLoading  ?? this.isMangasLoading,
      isDeletingManga : isDeletingManga  ?? this.isDeletingManga,
    );
  }

  @override
  List<Object?> get props => [profile, isFollowLoading, isUpdateLoading, mangas, isMangasLoading, isDeletingManga];
}

class ProfileUpdateSuccess extends ProfileState {
  final ProfileEntity profile;
  const ProfileUpdateSuccess(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

import 'package:equatable/equatable.dart';
import 'package:appmanga/features/manga/domain/entities/manga_detail_entity.dart';

abstract class MangaDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MangaDetailInitial extends MangaDetailState {}

class MangaDetailLoading extends MangaDetailState {}

class MangaDetailLoaded extends MangaDetailState {
  final MangaDetailEntity manga;
  final bool isLiked;
  final bool isFollowed;
  final bool isLikeLoading;
  final bool isFollowLoading;

  MangaDetailLoaded({
    required this.manga,
    required this.isLiked,
    required this.isFollowed,
    this.isLikeLoading = false,
    this.isFollowLoading = false,
  });

  MangaDetailLoaded copyWith({
    MangaDetailEntity? manga,
    bool? isLiked,
    bool? isFollowed,
    bool? isLikeLoading,
    bool? isFollowLoading,
  }) {
    return MangaDetailLoaded(
      manga: manga ?? this.manga,
      isLiked: isLiked ?? this.isLiked,
      isFollowed: isFollowed ?? this.isFollowed,
      isLikeLoading: isLikeLoading ?? this.isLikeLoading,
      isFollowLoading: isFollowLoading ?? this.isFollowLoading,
    );
  }

  @override
  List<Object?> get props => [manga, isLiked, isFollowed, isLikeLoading, isFollowLoading];
}

class MangaDetailError extends MangaDetailState {
  final String message;
  MangaDetailError(this.message);

  @override
  List<Object?> get props => [message];
}

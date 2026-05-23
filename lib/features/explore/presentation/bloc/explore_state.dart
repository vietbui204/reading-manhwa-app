import 'package:equatable/equatable.dart';
import 'package:appmanga/features/manga/domain/entities/manga_entity.dart';
import 'package:appmanga/features/manga/domain/entities/manga_list_entity.dart';

abstract class ExploreState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ExploreInitial extends ExploreState {}

class ExploreLoading extends ExploreState {}

class ExploreLoaded extends ExploreState {
  final List<MangaEntity> mangas;
  final PaginationEntity pagination;
  final String? selectedGenre;
  final String? selectedStatus;
  final String selectedSort;
  final bool isLoadingMore;

  ExploreLoaded({
    required this.mangas,
    required this.pagination,
    this.selectedGenre,
    this.selectedStatus,
    this.selectedSort = 'latest',
    this.isLoadingMore = false,
  });

  @override
  List<Object?> get props => [mangas, pagination, selectedGenre, selectedStatus, selectedSort, isLoadingMore];

  ExploreLoaded copyWith({
    List<MangaEntity>? mangas,
    PaginationEntity? pagination,
    String? selectedGenre,
    String? selectedStatus,
    String? selectedSort,
    bool? isLoadingMore,
  }) {
    return ExploreLoaded(
      mangas: mangas ?? this.mangas,
      pagination: pagination ?? this.pagination,
      selectedGenre: selectedGenre ?? this.selectedGenre,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      selectedSort: selectedSort ?? this.selectedSort,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class ExploreError extends ExploreState {
  final String message;
  ExploreError(this.message);

  @override
  List<Object?> get props => [message];
}

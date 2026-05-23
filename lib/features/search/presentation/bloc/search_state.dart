import 'package:equatable/equatable.dart';
import 'package:appmanga/features/manga/domain/entities/manga_entity.dart';
import 'package:appmanga/features/manga/domain/entities/manga_list_entity.dart';

abstract class SearchState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final String query;
  final List<MangaEntity> results;
  final PaginationEntity pagination;
  final bool isLoadingMore;

  SearchLoaded({
    required this.query,
    required this.results,
    required this.pagination,
    this.isLoadingMore = false,
  });

  @override
  List<Object?> get props => [query, results, pagination, isLoadingMore];

  SearchLoaded copyWith({
    String? query,
    List<MangaEntity>? results,
    PaginationEntity? pagination,
    bool? isLoadingMore,
  }) {
    return SearchLoaded(
      query: query ?? this.query,
      results: results ?? this.results,
      pagination: pagination ?? this.pagination,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class SearchEmpty extends SearchState {
  final String query;
  SearchEmpty(this.query);

  @override
  List<Object?> get props => [query];
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);

  @override
  List<Object?> get props => [message];
}

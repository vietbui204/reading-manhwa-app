import 'package:equatable/equatable.dart';
import 'package:appmanga/features/manga/domain/entities/history_entity.dart';
import 'package:appmanga/features/manga/domain/entities/manga_list_entity.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object?> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<HistoryEntity> items;
  final bool hasMore;
  final bool isLoadingMore;

  const HistoryLoaded({
    required this.items,
    this.hasMore = false,
    this.isLoadingMore = false,
  });

  HistoryLoaded copyWith({
    List<HistoryEntity>? items,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return HistoryLoaded(
      items: items ?? this.items,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [items, hasMore, isLoadingMore];
}

class HistoryEmpty extends HistoryState {}

class HistoryError extends HistoryState {
  final String message;
  const HistoryError(this.message);

  @override
  List<Object?> get props => [message];
}

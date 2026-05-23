part of 'reader_bloc.dart';

abstract class ReaderState extends Equatable {
  const ReaderState();

  @override
  List<Object?> get props => [];
}

class ReaderInitial extends ReaderState {}

class ReaderLoading extends ReaderState {}

class ReaderLoaded extends ReaderState {
  final ChapterPagesEntity data;
  final int currentPage;
  final bool showUI;
  final double brightness;
  final bool isLiked;
  final bool isFollowed;

  const ReaderLoaded({
    required this.data,
    required this.currentPage,
    this.showUI = true,
    this.brightness = 1.0,
    this.isLiked = false,
    this.isFollowed = false,
  });

  ReaderLoaded copyWith({
    ChapterPagesEntity? data,
    int? currentPage,
    bool? showUI,
    double? brightness,
    bool? isLiked,
    bool? isFollowed,
  }) {
    return ReaderLoaded(
      data: data ?? this.data,
      currentPage: currentPage ?? this.currentPage,
      showUI: showUI ?? this.showUI,
      brightness: brightness ?? this.brightness,
      isLiked: isLiked ?? this.isLiked,
      isFollowed: isFollowed ?? this.isFollowed,
    );
  }

  @override
  List<Object?> get props => [data, currentPage, showUI, brightness, isLiked, isFollowed];
}

class ReaderError extends ReaderState {
  final String message;
  const ReaderError(this.message);

  @override
  List<Object?> get props => [message];
}

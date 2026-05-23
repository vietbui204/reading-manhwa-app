part of 'reader_bloc.dart';

abstract class ReaderEvent extends Equatable {
  const ReaderEvent();

  @override
  List<Object?> get props => [];
}

class ReaderLoadRequested extends ReaderEvent {
  final String chapterId;
  const ReaderLoadRequested(this.chapterId);

  @override
  List<Object?> get props => [chapterId];
}

class ReaderPageChanged extends ReaderEvent {
  final int pageIndex;
  const ReaderPageChanged(this.pageIndex);

  @override
  List<Object?> get props => [pageIndex];
}

class ReaderUIToggled extends ReaderEvent {}

class ReaderBrightnessChanged extends ReaderEvent {
  final double value;
  const ReaderBrightnessChanged(this.value);

  @override
  List<Object?> get props => [value];
}

class ReaderNextChapter extends ReaderEvent {}
class ReaderPrevChapter extends ReaderEvent {}

class ReaderLikeToggled extends ReaderEvent {}
class ReaderFollowToggled extends ReaderEvent {}

import 'package:equatable/equatable.dart';

abstract class MangaDetailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class MangaDetailLoadRequested extends MangaDetailEvent {
  final String mangaId;
  MangaDetailLoadRequested(this.mangaId);

  @override
  List<Object?> get props => [mangaId];
}

class MangaDetailLikeToggled extends MangaDetailEvent {}

class MangaDetailFollowToggled extends MangaDetailEvent {}

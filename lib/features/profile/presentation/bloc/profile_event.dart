import 'package:equatable/equatable.dart';
// Thêm 2 event mới
class ProfileMangasLoadRequested extends ProfileEvent {
  final String userId;
  const ProfileMangasLoadRequested(this.userId);
}

class ProfileMangaDeleted extends ProfileEvent {
  final String mangaId;
  const ProfileMangaDeleted(this.mangaId);
}

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileLoadRequested extends ProfileEvent {
  final String userId;
  const ProfileLoadRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

class ProfileFollowToggled extends ProfileEvent {}

class ProfileUpdateRequested extends ProfileEvent {
  final String? username;
  final String? avatarUrl;

  const ProfileUpdateRequested({this.username, this.avatarUrl});

  @override
  List<Object?> get props => [username, avatarUrl];
}

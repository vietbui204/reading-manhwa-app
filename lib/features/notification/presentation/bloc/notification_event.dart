import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
  @override
  List<Object?> get props => [];
}

class NotificationLoadRequested extends NotificationEvent {}

class NotificationRefresh extends NotificationEvent {}

class NotificationLoadMore extends NotificationEvent {}

class NotificationMarkRead extends NotificationEvent {
  final String id;
  const NotificationMarkRead(this.id);
  @override
  List<Object?> get props => [id];
}

class NotificationMarkAllRead extends NotificationEvent {}

class NotificationReceived extends NotificationEvent {
  final Map<String, dynamic> data;
  const NotificationReceived(this.data);
  @override
  List<Object?> get props => [data];
}

import 'package:equatable/equatable.dart';

abstract class PointsEvent extends Equatable {
  const PointsEvent();

  @override
  List<Object?> get props => [];
}

class PointsLoadRequested extends PointsEvent {}

class PointsRefreshRequested extends PointsEvent {}

class TaskCompleted extends PointsEvent {
  final String taskId;
  const TaskCompleted(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class PointsHistoryLoadRequested extends PointsEvent {}

class PointsHistoryLoadMore extends PointsEvent {}

import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  final String id;
  final String title;
  final String type; // daily / one_time
  final String actionType; // read_chapter / comment / follow_manga / daily_login / share / follow_user
  final int pointReward;
  final bool isActive;
  final bool isDone;
  final bool canClaim;

  const TaskEntity({
    required this.id,
    required this.title,
    required this.type,
    required this.actionType,
    required this.pointReward,
    required this.isActive,
    required this.isDone,
    required this.canClaim,
  });

  TaskEntity copyWith({
    bool? isDone,
    bool? canClaim,
  }) {
    return TaskEntity(
      id: id,
      title: title,
      type: type,
      actionType: actionType,
      pointReward: pointReward,
      isActive: isActive,
      isDone: isDone ?? this.isDone,
      canClaim: canClaim ?? this.canClaim,
    );
  }

  @override
  List<Object?> get props => [id, title, type, actionType, pointReward, isActive, isDone, canClaim];
}

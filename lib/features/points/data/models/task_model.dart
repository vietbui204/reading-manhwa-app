import 'package:appmanga/features/points/domain/entities/task_entity.dart';
import 'package:appmanga/features/manga/data/models/manga_model.dart';

class TaskModel extends TaskEntity {
  const TaskModel({
    required super.id,
    required super.title,
    required super.type,
    required super.actionType,
    required super.pointReward,
    required super.isActive,
    required super.isDone,
    required super.canClaim,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      actionType: json['actionType'] ?? json['action_type'] ?? '',
      pointReward: MangaModel.toInt(json['pointReward'] ?? json['point_reward']),
      isActive: MangaModel.toBool(json['isActive'] ?? json['is_active'], true),
      isDone: MangaModel.toBool(json['isDone'] ?? json['is_done'], false),
      canClaim: MangaModel.toBool(json['canClaim'] ?? json['can_claim'], true),
    );
  }
}

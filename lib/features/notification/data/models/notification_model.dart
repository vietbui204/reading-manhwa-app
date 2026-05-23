import 'package:appmanga/features/notification/domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  NotificationModel({
    required super.id,
    required super.type,
    super.actor,
    super.refId,
    required super.isRead,
    required super.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      actor: json['actor'] != null 
          ? NotificationActorModel.fromJson(json['actor']) 
          : null,
      refId: json['refId']?.toString(),
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class NotificationActorModel extends NotificationActorEntity {
  NotificationActorModel({
    required super.id,
    required super.username,
    super.avatarUrl,
  });

  factory NotificationActorModel.fromJson(Map<String, dynamic> json) {
    return NotificationActorModel(
      id: json['id']?.toString() ?? '',
      username: json['username']?.toString() ?? 'Ai đó',
      avatarUrl: json['avatarUrl']?.toString(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:appmanga/core/theme/app_colors.dart';

class NotificationEntity {
  final String id;
  final String type;
  final NotificationActorEntity? actor;
  final String? refId;
  final bool isRead;
  final DateTime createdAt;

  NotificationEntity({
    required this.id,
    required this.type,
    this.actor,
    this.refId,
    required this.isRead,
    required this.createdAt,
  });

  String get displayMessage {
    final name = actor?.username ?? 'Ai đó';
    switch (type) {
      case 'new_chapter':
        return '$name vừa ra chapter mới';
      case 'new_follower':
        return '$name đã follow bạn';
      case 'comment_reply':
        return '$name đã trả lời bình luận của bạn';
      case 'status_post':
        return '$name đã đăng trạng thái mới';
      case 'manga_published':
        return '$name đã đăng truyện mới';
      default:
        return 'Có thông báo mới';
    }
  }

  IconData get typeIcon {
    switch (type) {
      case 'new_chapter':
        return Icons.menu_book;
      case 'new_follower':
        return Icons.person_add;
      case 'comment_reply':
        return Icons.reply;
      case 'status_post':
        return Icons.dynamic_feed;
      case 'manga_published':
        return Icons.library_add;
      default:
        return Icons.notifications;
    }
  }

  Color typeColor(BuildContext context) {
    switch (type) {
      case 'new_chapter':
        return Colors.blue;
      case 'new_follower':
        return Colors.green;
      case 'comment_reply':
        return AppColors.red;
      case 'status_post':
        return Colors.orange;
      case 'manga_published':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}

class NotificationActorEntity {
  final String id;
  final String username;
  final String? avatarUrl;

  NotificationActorEntity({
    required this.id,
    required this.username,
    this.avatarUrl,
  });
}

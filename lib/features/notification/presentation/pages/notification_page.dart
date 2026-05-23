import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:appmanga/core/theme/app_colors.dart';
import 'package:appmanga/core/utils/format_helper.dart';
import 'package:appmanga/features/notification/domain/entities/notification_entity.dart';
import '../bloc/notification_bloc.dart';
import '../bloc/notification_event.dart';
import '../bloc/notification_state.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          BlocBuilder<NotificationBloc, NotificationState>(
            builder: (context, state) {
              if (state is NotificationLoaded && state.unreadCount > 0) {
                return TextButton(
                  onPressed: () => context.read<NotificationBloc>().add(NotificationMarkAllRead()),
                  child: const Text('Đọc tất cả', style: TextStyle(color: AppColors.red)),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.red));
          }
          if (state is NotificationLoaded) {
            if (state.notifications.isEmpty) {
              return _buildEmptyState();
            }
            return RefreshIndicator(
              onRefresh: () async => context.read<NotificationBloc>().add(NotificationRefresh()),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: state.notifications.length + (state.hasMore ? 1 : 0),
                separatorBuilder: (_, __) => const Divider(color: Colors.white10, height: 1),
                itemBuilder: (context, index) {
                  if (index == state.notifications.length) {
                    context.read<NotificationBloc>().add(NotificationLoadMore());
                    return const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()));
                  }
                  final notif = state.notifications[index];
                  return _NotificationItem(
                    notification: notif,
                    onTap: () {
                      if (!notif.isRead) {
                        context.read<NotificationBloc>().add(NotificationMarkRead(notif.id));
                      }
                      _navigateToRef(context, notif);
                    },
                  );
                },
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, size: 80, color: Colors.white.withOpacity(0.1)),
          const SizedBox(height: 16),
          const Text('Chưa có thông báo nào', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Các thông báo mới sẽ hiển thị ở đây', style: TextStyle(fontSize: 13, color: AppColors.darkText3)),
        ],
      ),
    );
  }

  void _navigateToRef(BuildContext context, NotificationEntity notif) {
    switch (notif.type) {
      case 'new_chapter':
      case 'manga_published':
      case 'comment_reply':
        if (notif.refId != null) context.push('/manga/${notif.refId}');
        break;
      case 'new_follower':
      case 'status_post':
        if (notif.actor?.id != null) context.push('/profile/${notif.actor!.id}');
        break;
    }
  }
}

class _NotificationItem extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onTap;

  const _NotificationItem({required this.notification, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: notification.isRead ? Colors.transparent : AppColors.red.withOpacity(0.05),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.darkBg3,
                  backgroundImage: notification.actor?.avatarUrl != null ? NetworkImage(notification.actor!.avatarUrl!) : null,
                  child: notification.actor?.avatarUrl == null ? const Icon(Icons.person, color: AppColors.darkText3) : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: notification.typeColor(context),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.darkBg, width: 1.5),
                    ),
                    child: Icon(notification.typeIcon, size: 10, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.displayMessage,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                      color: notification.isRead ? AppColors.darkText2 : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    FormatHelper.timeAgo(notification.createdAt),
                    style: const TextStyle(fontSize: 11, color: AppColors.darkText3),
                  ),
                ],
              ),
            ),
            if (!notification.isRead)
              Container(
                width: 8, height: 8,
                decoration: const BoxDecoration(color: AppColors.red, shape: BoxShape.circle),
              ),
          ],
        ),
      ),
    );
  }
}

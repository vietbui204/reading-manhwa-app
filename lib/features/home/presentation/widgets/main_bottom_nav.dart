import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appmanga/core/theme/app_colors.dart';
import 'package:appmanga/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:appmanga/features/notification/presentation/bloc/notification_state.dart';

class MainBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MainBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
          ),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: AppColors.red,
        unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
        selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Trang chủ'),
          const BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), label: 'Khám phá'),
          BottomNavigationBarItem(
            icon: _buildRewardIcon(),
            label: 'Điểm thưởng',
          ),
          BottomNavigationBarItem(
            icon: _buildNotificationBadge(),
            label: 'Bookmark', // Chỗ này bạn muốn là Bookmark nhưng icon là Notifications? 
            // Theo thiết kế là: Trang chủ, Khám phá, Thưởng (giữa), Bookmark, Hồ sơ.
            // Tôi sẽ giữ đúng thứ tự thiết kế của bạn.
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Hồ sơ'),
        ],
      ),
    );
  }

  Widget _buildNotificationBadge() {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        int count = 0;
        if (state is NotificationLoaded) {
          count = state.unreadCount;
        }
        return Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(Icons.bookmark_outline),
            if (count > 0)
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildRewardIcon() {
    return Container(
      width: 44,
      height: 44,
      margin: const EdgeInsets.only(bottom: 2),
      transform: Matrix4.translationValues(0, -10, 0),
      decoration: BoxDecoration(
        color: AppColors.red,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.red.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Icon(Icons.star, color: Colors.white, size: 24),
    );
  }
}

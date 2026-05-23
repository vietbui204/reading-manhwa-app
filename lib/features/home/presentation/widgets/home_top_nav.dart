import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:appmanga/core/theme/app_colors.dart';
import 'package:appmanga/core/di/injection.dart';
import 'package:appmanga/core/storage/local_storage.dart';
import 'package:appmanga/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:appmanga/features/notification/presentation/bloc/notification_state.dart';

class HomeTopNav extends StatelessWidget {
  const HomeTopNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          RichText(
            text: TextSpan(
              style: GoogleFonts.bebasNeue(
                fontSize: 28,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              children: const [
                TextSpan(text: 'MANGA'),
                TextSpan(
                  text: 'X',
                  style: TextStyle(color: AppColors.red),
                ),
              ],
            ),
          ),
          const Spacer(),
          _buildIconButton(context, Icons.search, () => context.push('/search')),
          const SizedBox(width: 12),
          _buildNotificationButton(context),
          const SizedBox(width: 12),
          _buildAvatarButton(context),
        ],
      ),
    );
  }

  Widget _buildIconButton(BuildContext context, IconData icon, VoidCallback onTap) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 20),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildNotificationButton(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        int unreadCount = 0;
        if (state is NotificationLoaded) {
          unreadCount = state.unreadCount;
        }

        return Stack(
          children: [
            _buildIconButton(context, Icons.notifications_none, () => context.push('/notifications')),
            if (unreadCount > 0)
              Positioned(
                right: 8,
                top: 8,
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

  Widget _buildAvatarButton(BuildContext context) {
    final userId = sl<LocalStorage>().getUserId();
    return InkWell(
      onTap: () => context.push('/profile/$userId'),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.red,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.person_outline, color: Colors.white, size: 20),
      ),
    );
  }
}

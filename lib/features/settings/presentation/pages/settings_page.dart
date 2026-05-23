import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:appmanga/core/theme/app_colors.dart';
import 'package:appmanga/core/theme/theme_bloc.dart';
import 'package:appmanga/core/storage/local_storage.dart';
import 'package:appmanga/core/di/injection.dart';
import 'package:appmanga/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:appmanga/features/auth/presentation/bloc/auth_event.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localStorage = sl<LocalStorage>();
    final isPremium = localStorage.getIsPremium();
    final balance = localStorage.getPointBalance();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildSectionHeader('Tài khoản'),
          _buildSettingsTile(
            icon: Icons.person_outline,
            title: 'Chỉnh sửa hồ sơ',
            onTap: () => context.push('/profile/${localStorage.getUserId()}'),
          ),
          _buildSettingsTile(
            icon: Icons.workspace_premium,
            title: 'Nâng cấp Premium',
            trailing: isPremium
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(4)),
                    child: const Text('ACTIVE', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                  )
                : null,
            onTap: () => context.push('/premium'),
          ),
          _buildSettingsTile(
            icon: Icons.stars_outlined,
            title: 'Điểm thưởng & Nhiệm vụ',
            trailing: Text('$balance điểm', style: const TextStyle(color: AppColors.red, fontSize: 12)),
            onTap: () => context.go('/points'),
          ),
          _buildSectionHeader('Hiển thị'),
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return _buildSettingsTile(
                icon: Icons.dark_mode_outlined,
                title: 'Chế độ tối',
                trailing: Switch(
                  value: state.mode == ThemeMode.dark,
                  activeColor: AppColors.red,
                  onChanged: (val) {
                    context.read<ThemeBloc>().add(ThemeChanged(val ? ThemeMode.dark : ThemeMode.light));
                  },
                ),
                onTap: null,
              );
            },
          ),
          _buildSectionHeader('Thông báo'),
          _buildSettingsTile(
            icon: Icons.notifications_outlined,
            title: 'Thông báo chapter mới',
            trailing: Switch(value: true, activeColor: AppColors.red, onChanged: (v) {}),
          ),
          _buildSectionHeader('Khác'),
          _buildSettingsTile(
            icon: Icons.info_outline,
            title: 'Về ứng dụng',
            subtitle: 'MangaX v1.0.0',
            onTap: () => showAboutDialog(context: context, applicationName: 'MangaX', applicationVersion: '1.0.0'),
          ),
          _buildSettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Chính sách bảo mật',
            onTap: () {},
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: OutlinedButton.icon(
              onPressed: () => _showLogoutConfirm(context),
              icon: const Icon(Icons.logout, color: AppColors.red, size: 18),
              label: const Text('Đăng xuất', style: TextStyle(color: AppColors.red, fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.red),
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Text(title.toUpperCase(),
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.darkText3, letterSpacing: 1.2)),
    );
  }

  Widget _buildSettingsTile({required IconData icon, required String title, String? subtitle, Widget? trailing, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 14, color: Colors.white)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.darkText3)) : null,
      trailing: trailing ?? const Icon(Icons.chevron_right, color: AppColors.darkText3, size: 20),
      onTap: onTap,
    );
  }

  void _showLogoutConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkBg2,
        title: const Text('Đăng xuất?', style: TextStyle(color: Colors.white)),
        content: const Text('Bạn có chắc chắn muốn đăng xuất khỏi tài khoản này?', style: TextStyle(color: AppColors.darkText2)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('HỦY', style: TextStyle(color: AppColors.darkText3))),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthBloc>().add(AuthLogoutRequested());
              context.go('/login');
            },
            child: const Text('ĐĂNG XUẤT', style: TextStyle(color: AppColors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

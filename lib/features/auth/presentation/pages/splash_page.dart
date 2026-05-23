import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:appmanga/core/theme/app_colors.dart';
import 'package:appmanga/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:appmanga/core/di/injection.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _showOnboarding = false;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final localAuth = sl<AuthLocalDataSource>();
    final isLoggedIn = await localAuth.getAccessToken() != null;

    if (isLoggedIn) {
      if (mounted) context.go('/home');
    } else {
      final onboardingDone = await localAuth.hasOnboardingDone();
      if (onboardingDone) {
        if (mounted) context.go('/login');
      } else {
        setState(() => _showOnboarding = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_showOnboarding) {
      return Scaffold(
        body: Center(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.bebasNeue(fontSize: 52, color: AppColors.darkText),
              children: const [
                TextSpan(text: 'MANGA'),
                TextSpan(text: 'X', style: TextStyle(color: AppColors.red)),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // Background Decoration
          Positioned(
            top: -50,
            right: -50,
            child: _buildCircle(200),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: _buildCircle(200),
          ),
          
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) => setState(() => _currentPage = index),
                    children: [
                      _buildOnboardingSlide(
                        icon: Icons.menu_book_rounded,
                        title: "Kho truyện khổng lồ",
                        desc: "Hàng nghìn bộ truyện manga, webtoon cập nhật liên tục mỗi ngày",
                      ),
                      _buildOnboardingSlide(
                        icon: Icons.stars_rounded,
                        title: "Tích điểm mở khoá",
                        desc: "Hoàn thành nhiệm vụ hàng ngày để nhận điểm và mở khoá chapter độc quyền",
                      ),
                      _buildOnboardingSlide(
                        icon: Icons.people_alt_rounded,
                        title: "Cộng đồng sôi động",
                        desc: "Bình luận, follow tác giả và nhận thông báo chapter mới ngay lập tức",
                      ),
                    ],
                  ),
                ),
                
                // Indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) => _buildIndicator(index == _currentPage)),
                ),
                const SizedBox(height: 40),
                
                // Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await sl<AuthLocalDataSource>().setOnboardingDone();
                          if (mounted) context.go('/register');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.red,
                          minimumSize: const Size(double.infinity, 52),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Bắt đầu ngay', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: () async {
                          await sl<AuthLocalDataSource>().setOnboardingDone();
                          if (mounted) context.go('/login');
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 52),
                          side: const BorderSide(color: AppColors.darkText3),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Tôi đã có tài khoản', style: TextStyle(color: AppColors.darkText)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.red.withOpacity(0.06),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildOnboardingSlide({required IconData icon, required String title, required String desc}) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 100, color: AppColors.red),
          const SizedBox(height: 40),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.bebasNeue(fontSize: 32, color: AppColors.darkText),
          ),
          const SizedBox(height: 16),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: AppColors.darkText2),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: isActive ? 3 : 8,
      width: isActive ? 20 : 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.red : AppColors.darkText3,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

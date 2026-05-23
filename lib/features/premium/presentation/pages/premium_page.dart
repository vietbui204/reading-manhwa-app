import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:appmanga/core/theme/app_colors.dart';
import 'package:appmanga/features/premium/domain/entities/premium_plan_entity.dart';
import '../bloc/premium_bloc.dart';
import '../bloc/premium_state.dart';

class PremiumPage extends StatelessWidget {
  const PremiumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PremiumBloc, PremiumState>(
        builder: (context, state) {
          if (state is PremiumLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.red));
          }
          if (state is PremiumLoaded) {
            return _buildContent(context, state);
          }
          if (state is PremiumError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, PremiumLoaded state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeroHeader(context),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('QUYỀN LỢI PREMIUM', 
                  style: GoogleFonts.bebasNeue(fontSize: 22, letterSpacing: 1.2, color: Colors.white)),
                const SizedBox(height: 20),
                _buildBenefitItem(Icons.lock_open, 'Đọc tất cả chapter premium', 'Không cần dùng điểm để mở khoá'),
                _buildBenefitItem(Icons.flash_on, 'Đọc chapter sớm nhất', 'Truy cập trước người dùng thường'),
                _buildBenefitItem(Icons.stars, 'Badge Premium đặc biệt', 'Hiển thị trên hồ sơ của bạn'),
                _buildBenefitItem(Icons.support_agent, 'Hỗ trợ ưu tiên', 'Được xử lý yêu cầu nhanh hơn'),
                const SizedBox(height: 32),
                Text('CHỌN GÓI CỦA BẠN', 
                  style: GoogleFonts.bebasNeue(fontSize: 22, letterSpacing: 1.2, color: Colors.white)),
                const SizedBox(height: 16),
                ...state.plans.map((plan) => _buildPlanCard(context, plan)),
                const SizedBox(height: 32),
                _buildCTAButton(context),
                if (state.isPremium) _buildStatusInfo(state.premiumUntil),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroHeader(BuildContext context) {
    return Container(
      height: 260,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFD4AC0D), Color(0xFFB7950B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.workspace_premium, size: 80, color: Colors.white),
          const SizedBox(height: 16),
          Text('MANGAX PREMIUM', 
            style: GoogleFonts.bebasNeue(fontSize: 36, color: Colors.white, letterSpacing: 4)),
          Text('Nâng tầm trải nghiệm đọc truyện của bạn', 
            style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(IconData icon, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.amber.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: Colors.amber, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                Text(desc, style: const TextStyle(color: AppColors.darkText3, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(BuildContext context, PremiumPlanEntity plan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.darkBg2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(plan.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                const SizedBox(height: 4),
                Text(plan.description, style: const TextStyle(color: AppColors.darkText3, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${plan.price.toInt()}đ', 
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber)),
              Text('/${plan.duration} ngày', style: const TextStyle(color: AppColors.darkText3, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCTAButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showComingSoon(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFD4AC0D),
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: const Text('NÂNG CẤP NGAY', 
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.5)),
    );
  }

  Widget _buildStatusInfo(DateTime? until) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 12),
          Text('Bạn đang là Premium. Hết hạn: ${until?.toString().split(' ')[0]}',
            style: const TextStyle(color: Colors.green, fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkBg2,
        title: const Text('Sắp ra mắt 🚀', style: TextStyle(color: Colors.white)),
        content: const Text('Tính năng thanh toán đang được phát triển. Vui lòng quay lại sau!',
            style: TextStyle(color: AppColors.darkText2)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('ĐÃ HIỂU', style: TextStyle(color: AppColors.red))),
        ],
      ),
    );
  }
}

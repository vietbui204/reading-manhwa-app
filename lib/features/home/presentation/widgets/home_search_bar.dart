import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:appmanga/core/theme/app_colors.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        // Tap vào search bar → navigate sang SearchPage
        onTap: () => context.push('/search'),
        child: Container(
          height: 46,
          decoration: BoxDecoration(
            color: AppColors.darkBg3,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.07),
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 14),
              Icon(Icons.search,
                  size: 18, color: AppColors.darkText3),
              const SizedBox(width: 10),
              Text(
                'Tìm kiếm tên truyện, tác giả...',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.darkText3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeSkeletonWidget extends StatelessWidget {
  const HomeSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final surfaceColor = Theme.of(context).colorScheme.surfaceVariant;
    final baseColor = surfaceColor;
    final highlightColor = Theme.of(context).colorScheme.surface;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 100), // Top Nav + Search Bar space
          
          // Banner Skeleton
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highlightColor,
              child: Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Section Header Skeleton
          _buildHeaderSkeleton(baseColor, highlightColor),
          const SizedBox(height: 12),
          
          // Horizontal List Skeleton
          SizedBox(
            height: 200,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, __) => _buildCardSkeleton(baseColor, highlightColor),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Rankings Skeleton
          _buildHeaderSkeleton(baseColor, highlightColor),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: List.generate(3, (index) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Shimmer.fromColors(
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                  child: Container(
                    height: 80,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSkeleton(Color base, Color highlight) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Shimmer.fromColors(
            baseColor: base,
            highlightColor: highlight,
            child: Container(height: 20, width: 100, color: Colors.white),
          ),
          Shimmer.fromColors(
            baseColor: base,
            highlightColor: highlight,
            child: Container(height: 14, width: 60, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildCardSkeleton(Color base, Color highlight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: base,
          highlightColor: highlight,
          child: Container(
            width: 110,
            height: 152,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Shimmer.fromColors(
          baseColor: base,
          highlightColor: highlight,
          child: Container(height: 12, width: 80, color: Colors.white),
        ),
      ],
    );
  }
}

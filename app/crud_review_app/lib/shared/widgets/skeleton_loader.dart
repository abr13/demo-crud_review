import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_colors.dart';

class SkeletonLoader extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const SkeletonLoader({super.key, this.width, this.height, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      period: const Duration(milliseconds: 1500),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class BusinessCardSkeleton extends StatelessWidget {
  const BusinessCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!, width: 1),
        ),
        child: Row(
          children: [
            // Icon skeleton
            const SkeletonLoader(
              width: 48,
              height: 48,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            const SizedBox(width: 16),
            // Content skeleton
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SkeletonLoader(width: double.infinity, height: 16),
                  const SizedBox(height: 4),
                  const SkeletonLoader(width: 120, height: 14),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const SkeletonLoader(width: 12, height: 12),
                      const SizedBox(width: 4),
                      const SkeletonLoader(width: 100, height: 13),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Rating skeleton
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SkeletonLoader(width: 50, height: 16),
                const SizedBox(height: 2),
                const SkeletonLoader(width: 30, height: 12),
                const SizedBox(height: 4),
                const SkeletonLoader(
                  width: 40,
                  height: 20,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewCardSkeleton extends StatelessWidget {
  const ReviewCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SkeletonLoader(
                  width: 40,
                  height: 40,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SkeletonLoader(width: 100, height: 14),
                      const SizedBox(height: 4),
                      const SkeletonLoader(width: 80, height: 12),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const SkeletonLoader(width: double.infinity, height: 14),
            const SizedBox(height: 4),
            const SkeletonLoader(width: double.infinity, height: 14),
            const SizedBox(height: 4),
            const SkeletonLoader(width: 200, height: 14),
          ],
        ),
      ),
    );
  }
}

class BusinessHeaderSkeleton extends StatelessWidget {
  const BusinessHeaderSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonLoader(width: double.infinity, height: 24),
          const SizedBox(height: 8),
          const SkeletonLoader(width: 150, height: 16),
          const SizedBox(height: 4),
          const SkeletonLoader(width: 200, height: 16),
          const SizedBox(height: 12),
          Row(
            children: [
              const SkeletonLoader(width: 80, height: 20),
              const SizedBox(width: 16),
              const SkeletonLoader(width: 100, height: 16),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/business_detail.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/extensions.dart';

class BusinessHeader extends StatelessWidget {
  final BusinessDetail businessDetail;

  const BusinessHeader({super.key, required this.businessDetail});

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
          // Business name
          Text(
            businessDetail.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),

          // Category and locality
          Row(
            children: [
              Icon(Icons.category, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                businessDetail.category,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  businessDetail.locality,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Rating and review count
          Row(
            children: [
              Row(
                children: [
                  const Icon(Icons.star, color: AppColors.rating, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    businessDetail.rating.formatRating(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Text(
                '${businessDetail.userRatingsTotal.formatReviewCount()} reviews',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),

          // Opening hours status
          if (businessDetail.openingHours != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  businessDetail.openingHours!.isOpenNow
                      ? Icons.schedule
                      : Icons.schedule_outlined,
                  size: 16,
                  color: businessDetail.openingHours!.isOpenNow
                      ? AppColors.success
                      : AppColors.error,
                ),
                const SizedBox(width: 4),
                Text(
                  businessDetail.openingHours!.isOpenNow
                      ? 'Open now'
                      : 'Closed',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: businessDetail.openingHours!.isOpenNow
                        ? AppColors.success
                        : AppColors.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

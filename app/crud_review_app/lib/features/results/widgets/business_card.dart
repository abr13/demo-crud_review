import 'package:flutter/material.dart';
import '../models/business.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/extensions.dart';

class BusinessCard extends StatelessWidget {
  final Business business;
  final VoidCallback? onTap;

  const BusinessCard({super.key, required this.business, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 0,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!, width: 1),
            ),
            child: Row(
              children: [
                // Business icon with better styling
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getCategoryColor(
                      business.category,
                    ).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getCategoryIcon(business.category),
                    color: _getCategoryColor(business.category),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                // Business info with better typography
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        business.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        business.category,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              business.locality,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[500],
                                height: 1.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Rating and distance with better layout
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: Colors.amber[600], size: 16),
                        const SizedBox(width: 4),
                        Text(
                          business.rating.formatRating(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '(${business.userRatingsTotal.formatReviewCount()})',
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        business.distanceMeters.formatDistance(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    final lowerCategory = category.toLowerCase();
    if (lowerCategory.contains('restaurant') ||
        lowerCategory.contains('food')) {
      return Colors.orange;
    } else if (lowerCategory.contains('coffee') ||
        lowerCategory.contains('cafe')) {
      return Colors.brown;
    } else if (lowerCategory.contains('shopping') ||
        lowerCategory.contains('store')) {
      return Colors.blue;
    } else if (lowerCategory.contains('gas') ||
        lowerCategory.contains('fuel')) {
      return Colors.green;
    } else if (lowerCategory.contains('hotel') ||
        lowerCategory.contains('lodging')) {
      return Colors.purple;
    } else {
      return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    final lowerCategory = category.toLowerCase();
    if (lowerCategory.contains('restaurant') ||
        lowerCategory.contains('food')) {
      return Icons.restaurant;
    } else if (lowerCategory.contains('coffee') ||
        lowerCategory.contains('cafe')) {
      return Icons.local_cafe;
    } else if (lowerCategory.contains('shopping') ||
        lowerCategory.contains('store')) {
      return Icons.shopping_bag;
    } else if (lowerCategory.contains('gas') ||
        lowerCategory.contains('fuel')) {
      return Icons.local_gas_station;
    } else if (lowerCategory.contains('hotel') ||
        lowerCategory.contains('lodging')) {
      return Icons.hotel;
    } else {
      return Icons.business;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/extensions/date_extensions.dart';
import '../../../domain/entities/dashboard_metrics.dart';

class ActivityFeed extends StatelessWidget {
  final List<ActivityItem> activities;
  const ActivityFeed({super.key, required this.activities});

  IconData _iconForType(String type) {
    switch (type) {
      case 'milestone': return LucideIcons.trophy;
      case 'alert': return LucideIcons.alertCircle;
      case 'campaign': return LucideIcons.megaphone;
      case 'billing': return LucideIcons.creditCard;
      case 'maintenance': return LucideIcons.wrench;
      default: return LucideIcons.activity;
    }
  }

  Color _colorForType(String type) {
    switch (type) {
      case 'milestone': return AppColors.success;
      case 'alert': return AppColors.error;
      case 'campaign': return AppColors.primary;
      case 'billing': return AppColors.secondary;
      case 'maintenance': return AppColors.warning;
      default: return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent Activity', style: AppTextStyles.h4),
          const SizedBox(height: 16),
          ...activities.map((a) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _colorForType(a.type).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(_iconForType(a.type), size: 14, color: _colorForType(a.type)),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(a.description, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary))),
                const SizedBox(width: 8),
                Text(a.timestamp.timeAgo, style: AppTextStyles.caption),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

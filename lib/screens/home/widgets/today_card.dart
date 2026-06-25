import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class TodayCard extends StatelessWidget {
  final int callbackCount;
  final int followupCount;
  final int deadlineCount;

  const TodayCard({
    super.key,
    required this.callbackCount,
    required this.followupCount,
    required this.deadlineCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Today', style: AppTextStyles.title),
            const Gap(16),
            Row(
              children: [
                Expanded(
                  child: _StatChip(
                    icon: Icons.phone_outlined,
                    label: 'Callbacks',
                    count: callbackCount,
                    color: AppColors.primary,
                    backgroundColor: AppColors.primaryLight,
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: _StatChip(
                    icon: Icons.access_time_outlined,
                    label: 'Deadlines',
                    count: deadlineCount,
                    color: AppColors.upcoming,
                    backgroundColor: AppColors.upcomingLight,
                  ),
                ),
              ],
            ),
            const Gap(12),
            _StatChip(
              icon: Icons.person_outline,
              label: 'Follow-ups',
              count: followupCount,
              color: AppColors.done,
              backgroundColor: AppColors.doneLight,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;
  final Color backgroundColor;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$count',
                  style: AppTextStyles.headline.copyWith(color: color, fontSize: 22),
                ),
                Text(
                  label,
                  style: AppTextStyles.label.copyWith(color: color.withValues(alpha: 0.8)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

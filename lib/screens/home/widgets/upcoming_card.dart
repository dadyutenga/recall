import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/date_utils.dart';
import '../../../models/task_model.dart';

class UpcomingCard extends StatelessWidget {
  final List<TaskModel> tasks;

  const UpcomingCard({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    final tomorrow = tasks.where((t) => AppDateUtils.isTomorrow(t.dueDate)).length;
    final thisWeek = tasks.where((t) => AppDateUtils.isThisWeek(t.dueDate)).length;
    final later = tasks.where((t) => !AppDateUtils.isTomorrow(t.dueDate) && !AppDateUtils.isThisWeek(t.dueDate)).length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Upcoming', style: AppTextStyles.title),
            const Gap(16),
            _UpcomingRow(label: 'Tomorrow', count: tomorrow),
            const Gap(12),
            _UpcomingRow(label: 'This week', count: thisWeek),
            const Gap(12),
            _UpcomingRow(label: 'Later', count: later),
          ],
        ),
      ),
    );
  }
}

class _UpcomingRow extends StatelessWidget {
  final String label;
  final int count;

  const _UpcomingRow({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.body),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: count > 0 ? AppColors.primaryLight : AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$count',
            style: TextStyle(
              color: count > 0 ? AppColors.primary : AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

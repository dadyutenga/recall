import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/task_model.dart';

class OverdueCard extends StatelessWidget {
  final List<TaskModel> tasks;

  const OverdueCard({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    final shownTasks = tasks.take(3).toList();
    final remaining = tasks.length - shownTasks.length;

    return Card(
      color: AppColors.overdueLight,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.warning_amber_rounded, color: AppColors.overdue, size: 18),
                ),
                const Gap(12),
                Text('Overdue', style: AppTextStyles.title.copyWith(color: AppColors.overdue)),
                const Spacer(),
                if (tasks.length > 3)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.overdue.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${tasks.length}',
                      style: AppTextStyles.label.copyWith(color: AppColors.overdue),
                    ),
                  ),
              ],
            ),
            const Gap(16),
            ...shownTasks.map((t) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(top: 8),
                        decoration: const BoxDecoration(
                          color: AppColors.overdue,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const Gap(10),
                      Expanded(
                        child: Text(
                          t.title,
                          style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
                        ),
                      ),
                    ],
                  ),
                )),
            if (remaining > 0)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '+$remaining more',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.overdue),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

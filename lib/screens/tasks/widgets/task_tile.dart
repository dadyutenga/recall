import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/task_model.dart';
import '../../../providers/task_provider.dart';
import '../../../shared/widgets/priority_badge.dart';

class TaskTile extends StatelessWidget {
  final TaskModel task;

  const TaskTile({super.key, required this.task});

  IconData get _typeIcon {
    switch (task.type) {
      case AppConstants.taskTypeCallback:
        return Icons.phone;
      case AppConstants.taskTypeFollowup:
        return Icons.person;
      case AppConstants.taskTypeDeadline:
        return Icons.event;
      default:
        return Icons.check_circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateText = DateFormat('MMM d, h:mm a').format(task.dueDate);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Slidable(
        key: ValueKey(task.id),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => context.read<TaskProvider>().deleteTask(task.id),
              backgroundColor: AppColors.overdue,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => context.read<TaskProvider>().markDone(task.id),
              backgroundColor: AppColors.done,
              foregroundColor: Colors.white,
              icon: Icons.check,
              label: 'Done',
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primaryLight,
              child: Icon(_typeIcon, color: AppColors.primary, size: 20),
            ),
            title: Text(task.title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(2),
                Text(dateText, style: AppTextStyles.caption),
                if (task.contactName != null) ...[
                  const Gap(2),
                  Text('${task.contactName}', style: AppTextStyles.caption),
                ],
              ],
            ),
            trailing: PriorityBadge(priority: task.priority),
            onTap: () {
              // Edit task (optional)
            },
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/date_utils.dart';
import '../../../providers/task_provider.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../tasks/widgets/task_tile.dart';

class DayTasksSheet extends StatelessWidget {
  final DateTime date;

  const DayTasksSheet({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final tasks = context.read<TaskProvider>().tasksByDate(date);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                AppDateUtils.formatDate(date),
                style: AppTextStyles.title,
              ),
              const Gap(12),
              Expanded(
                child: tasks.isEmpty
                    ? EmptyState(
                        title: 'No tasks',
                        subtitle: 'Nothing scheduled for this day',
                      )
                    : ListView.builder(
                        controller: scrollController,
                        itemCount: tasks.length,
                        itemBuilder: (context, index) => TaskTile(task: tasks[index]),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

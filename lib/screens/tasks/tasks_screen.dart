import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/task_provider.dart';
import '../../shared/widgets/empty_state.dart';
import 'widgets/task_tile.dart';
import 'widgets/task_filter_chips.dart';
import 'widgets/add_task_sheet.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  String _typeFilter = 'All';
  String _statusFilter = 'Pending';

  final List<String> _typeFilters = ['All', 'Callback', 'Follow-up', 'Deadline'];
  final List<String> _statusFilters = ['Pending', 'Done', 'Ignored'];

  String _typeKey(String label) {
    switch (label) {
      case 'Callback':
        return AppConstants.taskTypeCallback;
      case 'Follow-up':
        return AppConstants.taskTypeFollowup;
      case 'Deadline':
        return AppConstants.taskTypeDeadline;
      default:
        return 'All';
    }
  }

  String _statusKey(String label) {
    switch (label) {
      case 'Done':
        return AppConstants.statusDone;
      case 'Ignored':
        return AppConstants.statusIgnored;
      default:
        return AppConstants.statusPending;
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();

    List filtered = taskProvider.tasksByStatus(_statusKey(_statusFilter));
    if (_typeFilter != 'All') {
      filtered = filtered.where((t) => t.type == _typeKey(_typeFilter)).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (_) => const AddTaskSheet(),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          TaskFilterChips(
            filters: _typeFilters,
            selected: _typeFilter,
            onSelected: (value) => setState(() => _typeFilter = value),
          ),
          TaskFilterChips(
            filters: _statusFilters,
            selected: _statusFilter,
            onSelected: (value) => setState(() => _statusFilter = value),
          ),
          Expanded(
            child: filtered.isEmpty
                ? EmptyState(
                    title: 'No tasks',
                    subtitle: 'Tap + to add your first task',
                    actionLabel: 'Add Task',
                    onAction: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (_) => const AddTaskSheet(),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) => TaskTile(task: filtered[index]),
                  ),
          ),
        ],
      ),
    );
  }
}

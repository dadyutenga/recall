import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/hive_service.dart';
import '../services/notification_service.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/date_utils.dart';

class TaskProvider extends ChangeNotifier {
  List<TaskModel> _tasks = [];

  TaskProvider() {
    _loadTasks();
  }

  void _loadTasks() {
    _tasks = HiveService.tasks.values.toList();
    _tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    notifyListeners();
  }

  List<TaskModel> get allTasks => List.unmodifiable(_tasks);

  List<TaskModel> get todayTasks =>
      _tasks.where((t) => AppDateUtils.isToday(t.dueDate) && t.status == AppConstants.statusPending).toList();

  List<TaskModel> get overdueTasks =>
      _tasks.where((t) => AppDateUtils.isOverdue(t.dueDate) && t.status == AppConstants.statusPending).toList();

  List<TaskModel> get upcomingTasks =>
      _tasks.where((t) => !AppDateUtils.isOverdue(t.dueDate) && !AppDateUtils.isToday(t.dueDate) && t.status == AppConstants.statusPending).toList();

  List<TaskModel> get pendingTasks =>
      _tasks.where((t) => t.status == AppConstants.statusPending).toList();

  List<TaskModel> get doneTasks =>
      _tasks.where((t) => t.status == AppConstants.statusDone).toList();

  List<TaskModel> get ignoredTasks =>
      _tasks.where((t) => t.status == AppConstants.statusIgnored).toList();

  List<TaskModel> tasksByType(String type) =>
      _tasks.where((t) => t.type == type).toList();

  List<TaskModel> tasksByStatus(String status) =>
      _tasks.where((t) => t.status == status).toList();

  List<TaskModel> tasksByDate(DateTime date) =>
      _tasks.where((t) => AppDateUtils.dateKey(t.dueDate) == AppDateUtils.dateKey(date)).toList();

  Future<void> addTask(TaskModel task) async {
    await HiveService.tasks.put(task.id, task);
    if (task.remindAt != null) {
      await NotificationService.scheduleTaskReminder(task);
    }
    _loadTasks();
  }

  Future<void> updateTask(TaskModel task) async {
    await HiveService.tasks.put(task.id, task);
    _loadTasks();
  }

  Future<void> deleteTask(String id) async {
    await NotificationService.cancelReminder(id);
    await HiveService.tasks.delete(id);
    _loadTasks();
  }

  Future<void> markDone(String id) async {
    final task = HiveService.tasks.get(id);
    if (task != null) {
      task.status = AppConstants.statusDone;
      await task.save();
      await NotificationService.cancelReminder(id);
      _loadTasks();
    }
  }

  Future<void> markIgnored(String id) async {
    final task = HiveService.tasks.get(id);
    if (task != null) {
      task.status = AppConstants.statusIgnored;
      await task.save();
      await NotificationService.cancelReminder(id);
      _loadTasks();
    }
  }

  int get callbackCount => _tasks.where((t) => t.type == AppConstants.taskTypeCallback && t.status == AppConstants.statusPending).length;
  int get followupCount => _tasks.where((t) => t.type == AppConstants.taskTypeFollowup && t.status == AppConstants.statusPending).length;
  int get deadlineCount => _tasks.where((t) => t.type == AppConstants.taskTypeDeadline && t.status == AppConstants.statusPending).length;
}

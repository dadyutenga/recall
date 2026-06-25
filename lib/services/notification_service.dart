import '../core/utils/notification_utils.dart';
import '../models/task_model.dart';
import '../core/constants/app_constants.dart';

class NotificationService {
  static Future<void> init() async {
    await NotificationUtils.init();
    await NotificationUtils.requestPermission();
  }

  static Future<void> scheduleTaskReminder(TaskModel task) async {
    if (task.remindAt == null) return;
    if (task.remindAt!.isBefore(DateTime.now())) return;

    await NotificationUtils.scheduleNotification(
      id: NotificationUtils.notificationIdFromString(task.id),
      title: 'Recall: ${task.title}',
      body: 'Reminder for your ${task.type} task',
      scheduledDate: task.remindAt!,
    );
  }

  static Future<void> cancelReminder(String taskId) async {
    await NotificationUtils.cancelNotification(
      NotificationUtils.notificationIdFromString(taskId),
    );
  }

  static Future<void> scheduleDailyDigest({
    int hour = AppConstants.defaultDigestHour,
    int minute = AppConstants.defaultDigestMinute,
  }) async {
    await NotificationUtils.scheduleDailyDigest(
      id: 99999,
      title: 'Daily Recall',
      body: 'You have pending tasks today. Check them out!',
      hour: hour,
      minute: minute,
    );
  }

  static Future<void> showInstantNotification({
    required String title,
    required String body,
  }) async {
    await NotificationUtils.scheduleNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      scheduledDate: DateTime.now(),
    );
  }
}

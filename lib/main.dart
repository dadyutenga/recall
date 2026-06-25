import 'package:flutter/material.dart';
import 'app.dart';
import 'services/hive_service.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveService.init();
  await NotificationService.init();

  runApp(const RecallApp());
}

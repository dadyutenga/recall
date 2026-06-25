import 'package:hive_flutter/hive_flutter.dart';
import '../models/task_model.dart';
import '../models/person_model.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TaskModelAdapter());
    Hive.registerAdapter(PersonModelAdapter());
    await Hive.openBox<TaskModel>('tasks');
    await Hive.openBox<PersonModel>('people');
    await Hive.openBox('settings');
  }

  static Box<TaskModel> get tasks => Hive.box<TaskModel>('tasks');
  static Box<PersonModel> get people => Hive.box<PersonModel>('people');
  static Box get settings => Hive.box('settings');

  static String? get userName => settings.get('userName');
  static set userName(String? value) => settings.put('userName', value);
  static bool get hasCompletedSetup => userName != null && userName!.isNotEmpty;
}

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
  }

  static Box<TaskModel> get tasks => Hive.box<TaskModel>('tasks');
  static Box<PersonModel> get people => Hive.box<PersonModel>('people');
}

import '../../models/task_model.dart';
import '../../models/person_model.dart';

class ExportUtils {
  static Map<String, dynamic> tasksToJson(List<TaskModel> tasks) {
    return {
      'tasks': tasks.map((t) => t.toExportMap()).toList(),
    };
  }

  static Map<String, dynamic> peopleToJson(List<PersonModel> people) {
    return {
      'people': people.map((p) => p.toExportMap()).toList(),
    };
  }

  static Map<String, dynamic> fullExport({
    required List<TaskModel> tasks,
    required List<PersonModel> people,
  }) {
    return {
      'exported_at': DateTime.now().toIso8601String(),
      'version': '1.0',
      'tasks': tasks.map((t) => t.toExportMap()).toList(),
      'people': people.map((p) => p.toExportMap()).toList(),
    };
  }
}

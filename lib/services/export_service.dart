import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import '../models/task_model.dart';
import '../models/person_model.dart';
import '../services/hive_service.dart';
import '../core/constants/app_constants.dart';

class ExportService {
  static Future<void> exportToJson() async {
    final tasks = HiveService.tasks.values.toList();
    final people = HiveService.people.values.toList();

    final data = {
      'exported_at': DateTime.now().toIso8601String(),
      'version': AppConstants.exportVersion,
      'tasks': tasks.map((t) => t.toExportMap()).toList(),
      'people': people.map((p) => p.toExportMap()).toList(),
    };

    final jsonString = jsonEncode(data);
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/recall_backup_${DateTime.now().millisecondsSinceEpoch}.json');
    await file.writeAsString(jsonString);

    await SharePlus.instance.share(
      ShareParams(
        text: 'Recall Backup',
        files: [XFile(file.path)],
      ),
    );
  }

  static Future<String> importFromJson() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result == null || result.files.isEmpty) {
      return 'No file selected';
    }

    final filePath = result.files.single.path;
    if (filePath == null) return 'Could not read file';

    final file = File(filePath);
    final jsonString = await file.readAsString();
    final data = jsonDecode(jsonString) as Map<String, dynamic>;

    if (data['version'] != AppConstants.exportVersion) {
      return 'Invalid backup file version';
    }

    final taskList = data['tasks'] as List? ?? [];
    final peopleList = data['people'] as List? ?? [];

    int taskCount = 0;
    int peopleCount = 0;

    for (final t in taskList) {
      final task = TaskModel.fromExportMap(t as Map<String, dynamic>);
      await HiveService.tasks.put(task.id, task);
      taskCount++;
    }

    for (final p in peopleList) {
      final person = PersonModel.fromExportMap(p as Map<String, dynamic>);
      await HiveService.people.put(person.id, person);
      peopleCount++;
    }

    return 'Imported $taskCount tasks, $peopleCount people';
  }
}

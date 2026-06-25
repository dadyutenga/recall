import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? description;

  @HiveField(3)
  String type;

  @HiveField(4)
  String priority;

  @HiveField(5)
  String status;

  @HiveField(6)
  DateTime dueDate;

  @HiveField(7)
  DateTime? remindAt;

  @HiveField(8)
  String? phone;

  @HiveField(9)
  String? contactName;

  @HiveField(10)
  String? personId;

  @HiveField(11)
  DateTime createdAt;

  TaskModel({
    required this.id,
    required this.title,
    this.description,
    required this.type,
    required this.priority,
    this.status = 'pending',
    required this.dueDate,
    this.remindAt,
    this.phone,
    this.contactName,
    this.personId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toExportMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'priority': priority,
      'status': status,
      'dueDate': dueDate.toIso8601String(),
      'remindAt': remindAt?.toIso8601String(),
      'phone': phone,
      'contactName': contactName,
      'personId': personId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory TaskModel.fromExportMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      type: map['type'] as String,
      priority: map['priority'] as String,
      status: map['status'] as String? ?? 'pending',
      dueDate: DateTime.parse(map['dueDate'] as String),
      remindAt: map['remindAt'] != null
          ? DateTime.parse(map['remindAt'] as String)
          : null,
      phone: map['phone'] as String?,
      contactName: map['contactName'] as String?,
      personId: map['personId'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  TaskModel copyWith({
    String? title,
    String? description,
    String? type,
    String? priority,
    String? status,
    DateTime? dueDate,
    DateTime? remindAt,
    String? phone,
    String? contactName,
    String? personId,
  }) {
    return TaskModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      remindAt: remindAt ?? this.remindAt,
      phone: phone ?? this.phone,
      contactName: contactName ?? this.contactName,
      personId: personId ?? this.personId,
      createdAt: createdAt,
    );
  }
}

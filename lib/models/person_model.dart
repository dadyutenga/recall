import 'package:hive/hive.dart';

part 'person_model.g.dart';

@HiveType(typeId: 1)
class PersonModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? phone;

  @HiveField(3)
  String? notes;

  @HiveField(4)
  DateTime? lastContactDate;

  @HiveField(5)
  DateTime createdAt;

  PersonModel({
    required this.id,
    required this.name,
    this.phone,
    this.notes,
    this.lastContactDate,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toExportMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'notes': notes,
      'lastContactDate': lastContactDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory PersonModel.fromExportMap(Map<String, dynamic> map) {
    return PersonModel(
      id: map['id'] as String,
      name: map['name'] as String,
      phone: map['phone'] as String?,
      notes: map['notes'] as String?,
      lastContactDate: map['lastContactDate'] != null
          ? DateTime.parse(map['lastContactDate'] as String)
          : null,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  PersonModel copyWith({
    String? name,
    String? phone,
    String? notes,
    DateTime? lastContactDate,
  }) {
    return PersonModel(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      notes: notes ?? this.notes,
      lastContactDate: lastContactDate ?? this.lastContactDate,
      createdAt: createdAt,
    );
  }
}

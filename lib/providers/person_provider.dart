import 'package:flutter/material.dart';
import '../models/person_model.dart';
import '../services/hive_service.dart';
import '../core/constants/app_constants.dart';

class PersonProvider extends ChangeNotifier {
  List<PersonModel> _people = [];

  PersonProvider() {
    _loadPeople();
  }

  void _loadPeople() {
    _people = HiveService.people.values.toList();
    _people.sort((a, b) => a.name.compareTo(b.name));
    notifyListeners();
  }

  List<PersonModel> get allPeople => List.unmodifiable(_people);

  int getPendingTasksForPerson(String personId) {
    return HiveService.tasks.values
        .where((t) => t.personId == personId && t.status == AppConstants.statusPending)
        .length;
  }

  Future<void> addPerson(PersonModel person) async {
    await HiveService.people.put(person.id, person);
    _loadPeople();
  }

  Future<void> updatePerson(PersonModel person) async {
    await HiveService.people.put(person.id, person);
    _loadPeople();
  }

  Future<void> deletePerson(String id) async {
    await HiveService.people.delete(id);
    _loadPeople();
  }
}

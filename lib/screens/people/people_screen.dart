import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/person_provider.dart';
import '../../shared/widgets/empty_state.dart';
import 'widgets/person_tile.dart';
import 'widgets/add_person_sheet.dart';

class PeopleScreen extends StatelessWidget {
  const PeopleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final personProvider = context.watch<PersonProvider>();
    final people = personProvider.allPeople;

    return Scaffold(
      appBar: AppBar(
        title: const Text('People'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (_) => const AddPersonSheet(),
              );
            },
          ),
        ],
      ),
      body: people.isEmpty
          ? EmptyState(
              title: 'No people yet',
              subtitle: 'Add people you follow up with regularly',
              actionLabel: 'Add Person',
              onAction: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (_) => const AddPersonSheet(),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: people.length,
              itemBuilder: (context, index) => PersonTile(person: people[index]),
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/person_model.dart';
import '../../../providers/person_provider.dart';

class PersonTile extends StatelessWidget {
  final PersonModel person;

  const PersonTile({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    final pendingCount = context.watch<PersonProvider>().getPendingTasksForPerson(person.id);
    final daysSinceContact = person.lastContactDate != null
        ? DateTime.now().difference(person.lastContactDate!).inDays
        : null;
    final isStale = daysSinceContact != null && daysSinceContact >= 7;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => context.read<PersonProvider>().deletePerson(person.id),
              backgroundColor: AppColors.overdue,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: Card(
          color: isStale ? AppColors.upcomingLight : AppColors.surface,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary,
              child: Text(
                person.name.isNotEmpty ? person.name[0].toUpperCase() : '?',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
            title: Text(person.name, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(2),
                if (person.phone != null)
                  Text(person.phone!, style: AppTextStyles.caption),
                if (person.lastContactDate != null)
                  Text(
                    'Last contact: ${daysSinceContact}d ago',
                    style: AppTextStyles.caption,
                  ),
              ],
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: pendingCount > 0 ? AppColors.primaryLight : AppColors.border,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$pendingCount pending',
                style: TextStyle(
                  color: pendingCount > 0 ? AppColors.primary : AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

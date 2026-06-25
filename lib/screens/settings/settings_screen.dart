import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../services/export_service.dart';
import '../../services/notification_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TimeOfDay _digestTime = const TimeOfDay(hour: 8, minute: 0);

  Future<void> _pickDigestTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _digestTime,
    );
    if (time != null) {
      setState(() => _digestTime = time);
      await NotificationService.scheduleDailyDigest(hour: time.hour, minute: time.minute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Notifications', style: AppTextStyles.title),
          const Gap(8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.notifications_active, color: AppColors.primary),
              title: const Text('Daily Digest'),
              subtitle: Text('Send every day at ${_digestTime.format(context)}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _pickDigestTime,
            ),
          ),
          const Gap(24),
          Text('Data', style: AppTextStyles.title),
          const Gap(8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.upload_file, color: AppColors.primary),
                  title: const Text('Export Backup'),
                  subtitle: const Text('Share your data as JSON'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    await ExportService.exportToJson();
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.download, color: AppColors.primary),
                  title: const Text('Import Backup'),
                  subtitle: const Text('Restore from a JSON file'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    final message = await ExportService.importFromJson();
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(message)),
                    );
                  },
                ),
              ],
            ),
          ),
          const Gap(24),
          Text('About', style: AppTextStyles.title),
          const Gap(8),
          const Card(
            child: ListTile(
              leading: Icon(Icons.info, color: AppColors.primary),
              title: Text('App Version'),
              subtitle: Text(AppConstants.appVersion),
            ),
          ),
        ],
      ),
    );
  }
}

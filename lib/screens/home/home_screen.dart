import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/date_utils.dart';
import '../../providers/task_provider.dart';
import '../../providers/call_log_provider.dart';
import '../../services/hive_service.dart';
import 'widgets/today_card.dart';
import 'widgets/overdue_card.dart';
import 'widgets/upcoming_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<CallLogProvider>().fetchMissedCalls();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final callLogProvider = context.watch<CallLogProvider>();
    final userName = HiveService.userName;
    final greeting = userName != null
        ? '${AppDateUtils.getGreeting()}, $userName'
        : AppDateUtils.getGreeting();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: const DecorationImage(
                      image: AssetImage('assets/img/usericons.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(greeting, style: AppTextStyles.headline),
                      const Gap(4),
                      Text(
                        AppDateUtils.formatDate(DateTime.now()),
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Gap(24),
            if (callLogProvider.missedCalls.isNotEmpty) ...[
              _MissedCallsBanner(count: callLogProvider.missedCalls.length),
              const Gap(16),
            ],
            TodayCard(
              callbackCount: taskProvider.callbackCount,
              deadlineCount: taskProvider.deadlineCount,
              followupCount: taskProvider.followupCount,
            ),
            const Gap(16),
            if (taskProvider.overdueTasks.isNotEmpty) ...[
              OverdueCard(tasks: taskProvider.overdueTasks),
              const Gap(16),
            ],
            UpcomingCard(tasks: taskProvider.upcomingTasks),
          ],
        ),
      ),
    );
  }
}

class _MissedCallsBanner extends StatelessWidget {
  final int count;

  const _MissedCallsBanner({required this.count});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surfaceContainerLow,
      child: InkWell(
        onTap: () {
          // Navigate to Tasks with callback filter
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.phone_missed, color: AppColors.primary, size: 20),
              ),
              const Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$count unreturned call${count == 1 ? '' : 's'}',
                      style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const Gap(2),
                    Text(
                      'Tap to add callbacks',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

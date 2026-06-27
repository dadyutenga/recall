import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/date_utils.dart';

class TodayCard extends StatelessWidget {
  final int callbackCount;
  final int followupCount;
  final int deadlineCount;
  final VoidCallback? onTap;

  const TodayCard({
    super.key,
    required this.callbackCount,
    required this.followupCount,
    required this.deadlineCount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final total = callbackCount + followupCount + deadlineCount;
    final theme = Theme.of(context);

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      elevation: 0.5,
      shadowColor: AppColors.primary.withValues(alpha: 0.12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Gradient header
              Container(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, AppColors.primaryContainer],
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.today,
                          color: Colors.white, size: 20),
                    ),
                    const Gap(14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Today',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              height: 1.2,
                            ),
                          ),
                          const Gap(2),
                          Text(
                            AppDateUtils.formatDate(DateTime.now()),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$total task${total == 1 ? '' : 's'}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Stat tiles
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: _StatTile(
                        icon: Icons.phone_outlined,
                        label: 'Callbacks',
                        count: callbackCount,
                        color: AppColors.primary,
                        backgroundColor: AppColors.primaryLight,
                      ),
                    ),
                    const Gap(10),
                    Expanded(
                      child: _StatTile(
                        icon: Icons.person_outline,
                        label: 'Follow-ups',
                        count: followupCount,
                        color: AppColors.done,
                        backgroundColor: AppColors.doneLight,
                      ),
                    ),
                    const Gap(10),
                    Expanded(
                      child: _StatTile(
                        icon: Icons.event_outlined,
                        label: 'Deadlines',
                        count: deadlineCount,
                        color: AppColors.upcoming,
                        backgroundColor: AppColors.upcomingLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;
  final Color backgroundColor;

  const _StatTile({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasTasks = count > 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: BoxDecoration(
        color: hasTasks ? backgroundColor : AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: hasTasks
              ? color.withValues(alpha: 0.22)
              : AppColors.border.withValues(alpha: 0.6),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: hasTasks
                  ? Colors.white.withValues(alpha: 0.7)
                  : Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const Gap(8),
          Text(
            '$count',
            style: theme.textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 22,
              height: 1.1,
              letterSpacing: -0.5,
            ),
          ),
          const Gap(2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              color: hasTasks
                  ? color.withValues(alpha: 0.85)
                  : AppColors.textMuted,
              fontWeight: FontWeight.w600,
              fontSize: 11,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}


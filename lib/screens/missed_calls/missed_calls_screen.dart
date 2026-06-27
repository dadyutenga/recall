import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/date_utils.dart';
import '../../providers/call_log_provider.dart';
import '../tasks/widgets/add_task_sheet.dart';

class MissedCallsScreen extends StatefulWidget {
  const MissedCallsScreen({super.key});

  @override
  State<MissedCallsScreen> createState() => _MissedCallsScreenState();
}

class _MissedCallsScreenState extends State<MissedCallsScreen> {
  final Set<int> _selected = {};

  String _displayName(CallLogEntry call) {
    final name = call.name;
    if (name != null && name.trim().isNotEmpty) return name;
    return call.formattedNumber ?? call.number ?? 'Unknown';
  }

  void _toggle(int index) {
    setState(() {
      if (_selected.contains(index)) {
        _selected.remove(index);
      } else {
        _selected.add(index);
      }
    });
  }

  Future<void> _refresh() {
    return context.read<CallLogProvider>().fetchMissedCalls();
  }

  void _addCallback(List<CallLogEntry> calls) {
    if (_selected.isEmpty) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        final first = calls[_selected.first];
        final name = _displayName(first);
        final phone = first.number ?? first.formattedNumber ?? '';
        final contact = first.name != null && first.name!.trim().isNotEmpty
            ? first.name!.trim()
            : null;
        return AddTaskSheet(
          initialType: AppConstants.taskTypeCallback,
          initialTitle: 'Call back $name',
          initialContactName: contact,
          initialPhone: phone,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final callLogProvider = context.watch<CallLogProvider>();
    final calls = callLogProvider.missedCalls;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Missed Calls'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
          ),
          if (_selected.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.phone),
              tooltip: 'Add callback',
              onPressed: calls.isEmpty ? null : () => _addCallback(calls),
            ),
        ],
      ),
      body: callLogProvider.loading
          ? const Center(child: CircularProgressIndicator())
          : calls.isEmpty
              ? EmptyMissedCalls(onRefresh: _refresh)
              : ListView.separated(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: calls.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1, indent: 72),
                  itemBuilder: (context, index) {
                    final call = calls[index];
                    final isSelected = _selected.contains(index);
                    final name = _displayName(call);
                    final phone = call.number ?? call.formattedNumber;
                    final dateTime = call.timestamp != null
                        ? DateTime.fromMillisecondsSinceEpoch(call.timestamp!)
                        : null;

                    return InkWell(
                      onTap: () => _toggle(index),
                      child: Container(
                        color: isSelected
                            ? AppColors.primaryLight
                            : Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.primaryLight,
                              child: const Icon(Icons.phone_missed,
                                  color: AppColors.primary, size: 20),
                            ),
                            const Gap(12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(name,
                                      style: AppTextStyles.body
                                          .copyWith(fontWeight: FontWeight.w600)),
                                  if (phone != null) ...[
                                    const Gap(2),
                                    Text(phone, style: AppTextStyles.caption),
                                  ],
                                  if (dateTime != null) ...[
                                    const Gap(2),
                                    Text(
                                      '${AppDateUtils.formatDate(dateTime)}, '
                                      '${AppDateUtils.formatTime(dateTime)}',
                                      style: AppTextStyles.caption,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            Checkbox(
                              value: isSelected,
                              onChanged: (_) => _toggle(index),
                              activeColor: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

class EmptyMissedCalls extends StatelessWidget {
  final Future<void> Function() onRefresh;
  const EmptyMissedCalls({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.phone_missed, size: 64, color: AppColors.textSecondary),
          const Gap(16),
          Text('No missed calls', style: AppTextStyles.title),
          const Gap(8),
          const Text(
            'Permission denied or no missed calls in the last 7 days.',
            style: AppTextStyles.caption,
            textAlign: TextAlign.center,
          ),
          const Gap(24),
          ElevatedButton(
            onPressed: onRefresh,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
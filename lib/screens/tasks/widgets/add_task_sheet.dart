import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/task_model.dart';
import '../../../providers/task_provider.dart';

class AddTaskSheet extends StatefulWidget {
  final String? initialType;
  final String? initialTitle;
  final String? initialContactName;
  final String? initialPhone;

  const AddTaskSheet({
    super.key,
    this.initialType,
    this.initialTitle,
    this.initialContactName,
    this.initialPhone,
  });

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  late int _step;
  late String _type;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contactController = TextEditingController();
  final _phoneController = TextEditingController();

  String _priority = AppConstants.priorityMedium;
  DateTime? _dueDate;
  bool _setReminder = false;
  DateTime? _reminderDate;

  @override
  void initState() {
    super.initState();
    _type = widget.initialType ?? AppConstants.taskTypeCallback;
    _titleController.text = widget.initialTitle ?? '';
    _contactController.text = widget.initialContactName ?? '';
    _phoneController.text = widget.initialPhone ?? '';
    // If a type was provided (e.g. callback from a missed call), skip step 1
    _step = widget.initialType != null ? 2 : 1;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _contactController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final date = await showOmniDateTimePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(hours: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      is24HourMode: false,
    );
    if (date != null) setState(() => _dueDate = date);
  }

  Future<void> _pickReminder() async {
    final date = await showOmniDateTimePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(hours: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      is24HourMode: false,
    );
    if (date != null) setState(() => _reminderDate = date);
  }

  String? _titleError;
  String? _dueDateError;

  Future<void> _save() async {
    setState(() {
      _titleError =
          _titleController.text.trim().isEmpty ? 'Title is required' : null;
      _dueDateError = _dueDate == null ? 'Due date is required' : null;
    });

    if (_titleError != null || _dueDateError != null) return;

    final task = TaskModel(
      id: const Uuid().v4(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      type: _type,
      priority: _priority,
      dueDate: _dueDate!,
      remindAt: _setReminder ? _reminderDate : null,
      contactName: _type == AppConstants.taskTypeCallback
          ? (_contactController.text.trim().isEmpty
              ? null
              : _contactController.text.trim())
          : null,
      phone: _type == AppConstants.taskTypeCallback
          ? (_phoneController.text.trim().isEmpty
              ? null
              : _phoneController.text.trim())
          : null,
    );

    await context.read<TaskProvider>().addTask(task);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Padding(
          padding: EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: _step == 1 ? _buildStep1() : _buildStep2(),
          ),
        );
      },
    );
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const Gap(16),
        Text('What type of task?', style: AppTextStyles.title),
        const Gap(20),
        _TypeButton(
          icon: Icons.phone,
          label: 'Callback',
          subtitle: 'Return a missed call',
          selected: _type == AppConstants.taskTypeCallback,
          onTap: () => setState(() {
            _type = AppConstants.taskTypeCallback;
            _step = 2;
          }),
        ),
        const Gap(12),
        _TypeButton(
          icon: Icons.person,
          label: 'Follow-up',
          subtitle: 'Check in with someone',
          selected: _type == AppConstants.taskTypeFollowup,
          onTap: () => setState(() {
            _type = AppConstants.taskTypeFollowup;
            _step = 2;
          }),
        ),
        const Gap(12),
        _TypeButton(
          icon: Icons.event,
          label: 'Deadline',
          subtitle: 'A task with a due date',
          selected: _type == AppConstants.taskTypeDeadline,
          onTap: () => setState(() {
            _type = AppConstants.taskTypeDeadline;
            _step = 2;
          }),
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => setState(() => _step = 1),
            ),
            Text('New ${_type[0].toUpperCase()}${_type.substring(1)}', style: AppTextStyles.title),
          ],
        ),
        const Gap(16),
        TextField(
          controller: _titleController,
          decoration: InputDecoration(
            labelText: 'Title',
            border: const OutlineInputBorder(),
            errorText: _titleError,
          ),
        ),
        const Gap(12),
        TextField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: 'Description (optional)',
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
        ),
        if (_type == AppConstants.taskTypeCallback) ...[
          const Gap(12),
          TextField(
            controller: _contactController,
            decoration: const InputDecoration(
              labelText: 'Contact Name',
              border: OutlineInputBorder(),
            ),
          ),
          const Gap(12),
          TextField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
          ),
        ],
        const Gap(12),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Due Date'),
          subtitle: Text(
            _dueDate == null ? 'Select date & time' : _dueDate.toString(),
            style: AppTextStyles.caption,
          ),
          trailing: const Icon(Icons.calendar_today),
          onTap: _pickDueDate,
        ),
        if (_dueDateError != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 12),
            child: Text(_dueDateError!,
                style: const TextStyle(color: Colors.red, fontSize: 12)),
          ),
        const Gap(12),
        Text('Priority', style: AppTextStyles.label),
        const Gap(6),
        Row(
          children: [AppConstants.priorityHigh, AppConstants.priorityMedium, AppConstants.priorityLow]
              .map((p) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(p[0].toUpperCase() + p.substring(1)),
                      selected: _priority == p,
                      onSelected: (_) => setState(() => _priority = p),
                    ),
                  ))
              .toList(),
        ),
        const Gap(12),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Set Reminder'),
          value: _setReminder,
          onChanged: (value) => setState(() {
            _setReminder = value;
            if (value && _reminderDate == null) _pickReminder();
          }),
        ),
        if (_setReminder)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Reminder Time'),
            subtitle: Text(
              _reminderDate == null ? 'Select reminder time' : _reminderDate.toString(),
              style: AppTextStyles.caption,
            ),
            trailing: const Icon(Icons.alarm),
            onTap: _pickReminder,
          ),
        const Gap(24),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Save Task', style: TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }
}

class _TypeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _TypeButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryLight : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: selected ? AppColors.primary : AppColors.primaryLight,
              child: Icon(icon, color: selected ? Colors.white : AppColors.primary),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                  Text(subtitle, style: AppTextStyles.caption),
                ],
              ),
            ),
            if (selected) const Icon(Icons.check_circle, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}

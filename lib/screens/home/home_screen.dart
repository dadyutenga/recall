import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/utils/date_utils.dart';
import '../../models/task_model.dart';
import '../../providers/call_log_provider.dart';
import '../../providers/task_provider.dart';
import '../../screens/missed_calls/missed_calls_screen.dart';
import '../../services/hive_service.dart';

// Design tokens for the home screen.
class _Palette {
  static const primary = Color(0xFF1A4FBA);
  static const surface = Color(0xFFFFFFFF);
  static const background = Color(0xFFF2F4FB);
  static const danger = Color(0xFFE53935);
  static const success = Color(0xFF2E7D32);
  static const amber = Color(0xFFE8820B);
  static const muted = Color(0xFF6B7280);
  static const dangerBg = Color(0xFFFFF5F5);
  static const dangerBorder = Color(0xFFF8C9C6);
  static const primarySoft = Color(0xFFE8F0FF);
  static const successSoft = Color(0xFFE6F4EA);
  static const amberSoft = Color(0xFFFFF1DD);
  static const border = Color(0xFFE5E7EB);
}

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

  TextStyle _font({
    double size = 16,
    FontWeight weight = FontWeight.w400,
    Color color = _Palette.surface,
    double letterSpacing = 0,
    double height = 1.3,
  }) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
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
      backgroundColor: _Palette.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Header — greeting + date + avatar.
              _Header(greeting: greeting, font: _font),
              const Gap(16),

              // 2. Unreturned calls banner — pill card, missed-call icon, chevron.
              if (callLogProvider.missedCalls.isNotEmpty) ...[
                _MissedCallsBanner(
                  count: callLogProvider.missedCalls.length,
                  font: _font,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const MissedCallsScreen()),
                  ),
                ),
                const Gap(12),
              ],

              // 3. Today section — unified container with header + 3 stat cards.
              _TodaySection(
                callbackCount: taskProvider.callbackCount,
                followupCount: taskProvider.followupCount,
                deadlineCount: taskProvider.deadlineCount,
                font: _font,
              ),
              const Gap(12),

              // 4. Overdue section — red accent, ListTiles with red dot.
              if (taskProvider.overdueTasks.isNotEmpty) ...[
                _OverdueSection(
                  tasks: taskProvider.overdueTasks,
                  font: _font,
                ),
                const Gap(12),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// 1. Header.
class _Header extends StatelessWidget {
  final String greeting;
  final TextStyle Function({
    double size,
    FontWeight weight,
    Color color,
    double letterSpacing,
    double height,
  }) font;

  const _Header({required this.greeting, required this.font});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: const DecorationImage(
              image: AssetImage('assets/img/usericons.png'),
              fit: BoxFit.cover,
            ),
            border: Border.all(color: _Palette.border),
          ),
        ),
        const Gap(14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: font(
                  size: 22,
                  weight: FontWeight.w700,
                  color: const Color(0xFF111827),
                  height: 1.2,
                ),
              ),
              const Gap(2),
              Text(
                AppDateUtils.formatDate(DateTime.now()),
                style: font(size: 13, weight: FontWeight.w500, color: _Palette.muted),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// 2. Missed calls banner — pill-shaped card.
class _MissedCallsBanner extends StatelessWidget {
  final int count;
  final VoidCallback onTap;
  final TextStyle Function({
    double size,
    FontWeight weight,
    Color color,
    double letterSpacing,
    double height,
  }) font;

  const _MissedCallsBanner({
    required this.count,
    required this.font,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: _Palette.primarySoft,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _Palette.primary.withValues(alpha: 0.18)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _Palette.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.phone_missed,
                    color: Colors.white, size: 20),
              ),
              const Gap(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$count unreturned call${count == 1 ? '' : 's'}',
                      style: font(
                        size: 15,
                        weight: FontWeight.w700,
                        color: _Palette.primary,
                      ),
                    ),
                    const Gap(2),
                    Text(
                      'Tap to add callbacks',
                      style: font(
                        size: 12,
                        weight: FontWeight.w500,
                        color: _Palette.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right,
                  color: _Palette.primary, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}

// 3. Today section — unified container wrapping header + 3 stat cards.
class _TodaySection extends StatelessWidget {
  final int callbackCount;
  final int followupCount;
  final int deadlineCount;
  final TextStyle Function({
    double size,
    FontWeight weight,
    Color color,
    double letterSpacing,
    double height,
  }) font;

  const _TodaySection({
    required this.callbackCount,
    required this.followupCount,
    required this.deadlineCount,
    required this.font,
  });

  @override
  Widget build(BuildContext context) {
    final total = callbackCount + followupCount + deadlineCount;

    return Container(
      decoration: BoxDecoration(
        color: _Palette.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A2B5C).withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Section header.
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: _Palette.primary,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(Icons.today,
                      color: Colors.white, size: 20),
                ),
                const Gap(12),
                Expanded(
                  child: Text(
                    'Today',
                    style: font(
                      size: 18,
                      weight: FontWeight.w700,
                      color: const Color(0xFF111827),
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                  decoration: BoxDecoration(
                    color: _Palette.primarySoft,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$total task${total == 1 ? '' : 's'}',
                    style: font(
                      size: 12,
                      weight: FontWeight.w700,
                      color: _Palette.primary,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: _Palette.border),
          // 3 stat cards.
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.phone_outlined,
                    label: 'Callbacks',
                    count: callbackCount,
                    color: _Palette.primary,
                    soft: _Palette.primarySoft,
                    font: font,
                  ),
                ),
                const Gap(10),
                Expanded(
                  child: _StatCard(
                    icon: Icons.person_outline,
                    label: 'Follow-ups',
                    count: followupCount,
                    color: _Palette.success,
                    soft: _Palette.successSoft,
                    font: font,
                  ),
                ),
                const Gap(10),
                Expanded(
                  child: _StatCard(
                    icon: Icons.calendar_today_outlined,
                    label: 'Deadlines',
                    count: deadlineCount,
                    color: _Palette.amber,
                    soft: _Palette.amberSoft,
                    font: font,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Stat card — colored icon in rounded square, bold number, muted label.
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;
  final Color soft;
  final TextStyle Function({
    double size,
    FontWeight weight,
    Color color,
    double letterSpacing,
    double height,
  }) font;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
    required this.soft,
    required this.font,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: BoxDecoration(
        color: soft,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const Gap(10),
          Text(
            '$count',
            style: font(
              size: 22,
              weight: FontWeight.w800,
              color: color,
              height: 1.1,
            ),
          ),
          const Gap(2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: font(
              size: 11,
              weight: FontWeight.w600,
              color: _Palette.muted,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// 4. Overdue section — deep red left accent, light red bg, ListTiles.
class _OverdueSection extends StatelessWidget {
  final List<TaskModel> tasks;
  final TextStyle Function({
    double size,
    FontWeight weight,
    Color color,
    double letterSpacing,
    double height,
  }) font;

  const _OverdueSection({required this.tasks, required this.font});

  @override
  Widget build(BuildContext context) {
    final shown = tasks.take(4).toList();
    final remaining = tasks.length - shown.length;

    return Container(
      decoration: BoxDecoration(
        color: _Palette.dangerBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _Palette.dangerBorder),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 4px deep red left accent.
            Container(
              width: 4,
              decoration: const BoxDecoration(
                color: _Palette.danger,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded,
                            color: _Palette.danger, size: 20),
                        const Gap(8),
                        Text(
                          'Overdue',
                          style: font(
                            size: 16,
                            weight: FontWeight.w700,
                            color: _Palette.danger,
                          ),
                        ),
                        const Spacer(),
                        if (tasks.length > 1)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 9, vertical: 3),
                            decoration: BoxDecoration(
                              color: _Palette.danger,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${tasks.length}',
                              style: font(
                                size: 11,
                                weight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const Gap(4),
                    ...shown.map((t) => ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: const Padding(
                            padding: EdgeInsets.only(left: 4, top: 2),
                            child: _RedDot(),
                          ),
                          title: Text(
                            t.title,
                            style: font(
                              size: 14,
                              weight: FontWeight.w600,
                              color: const Color(0xFF2A1012),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            AppDateUtils.formatDate(t.dueDate),
                            style: font(
                              size: 11,
                              weight: FontWeight.w500,
                              color: _Palette.danger,
                            ),
                          ),
                        )),
                    if (remaining > 0)
                      Padding(
                        padding: const EdgeInsets.only(left: 28, top: 2),
                        child: Text(
                          '+$remaining more',
                          style: font(
                            size: 12,
                            weight: FontWeight.w600,
                            color: _Palette.danger,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RedDot extends StatelessWidget {
  const _RedDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: _Palette.danger,
        shape: BoxShape.circle,
      ),
    );
  }
}
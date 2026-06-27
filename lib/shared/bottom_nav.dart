import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      backgroundColor: Colors.white,
      elevation: 0,
      height: 64,
      indicatorColor: const Color(0xFF1A4FBA).withValues(alpha: 0.12),
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: selected
              ? const Color(0xFF1A4FBA)
              : const Color(0xFF6B7280),
        );
      }),
      destinations: [
        NavigationDestination(
          icon: Icon(Icons.home_outlined, color: Color(0xFF6B7280)),
          selectedIcon: Icon(Icons.home, color: Color(0xFF1A4FBA)),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.checklist_outlined, color: Color(0xFF6B7280)),
          selectedIcon: Icon(Icons.checklist, color: Color(0xFF1A4FBA)),
          label: 'Tasks',
        ),
        NavigationDestination(
          icon: Icon(Icons.people_outline, color: Color(0xFF6B7280)),
          selectedIcon: Icon(Icons.people, color: Color(0xFF1A4FBA)),
          label: 'People',
        ),
        NavigationDestination(
          icon: Icon(Icons.calendar_month_outlined, color: Color(0xFF6B7280)),
          selectedIcon: Icon(Icons.calendar_month, color: Color(0xFF1A4FBA)),
          label: 'Calendar',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined, color: Color(0xFF6B7280)),
          selectedIcon: Icon(Icons.settings, color: Color(0xFF1A4FBA)),
          label: 'Settings',
        ),
      ],
    );
  }
}

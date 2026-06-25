import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'providers/task_provider.dart';
import 'providers/person_provider.dart';
import 'providers/call_log_provider.dart';
import 'screens/home/home_screen.dart';
import 'screens/tasks/tasks_screen.dart';
import 'screens/people/people_screen.dart';
import 'screens/calendar/calendar_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/welcome_screen.dart';
import 'shared/bottom_nav.dart';
import 'shared/widgets/recall_fab.dart';
import 'screens/tasks/widgets/add_task_sheet.dart';

class RecallApp extends StatelessWidget {
  const RecallApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => PersonProvider()),
        ChangeNotifierProvider(create: (_) => CallLogProvider()),
      ],
      child: MaterialApp(
        title: 'Recall',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        home: const WelcomeScreen(),
      ),
    );
  }
}

class MainContent extends StatefulWidget {
  const MainContent({super.key});

  @override
  State<MainContent> createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    TasksScreen(),
    PeopleScreen(),
    CalendarScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (innerContext) => Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: BottomNav(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
        ),
        floatingActionButton: _currentIndex == 0 || _currentIndex == 1
            ? RecallFab(
                onPressed: () => showModalBottomSheet(
                  context: innerContext,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) => const AddTaskSheet(),
                ),
              )
            : null,
      ),
    );
  }
}

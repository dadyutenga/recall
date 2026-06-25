# TASK.md — Recall App Build Plan
> 4-hour sprint. Local-only Flutter app. Build in order. Skip nothing.

---

## Pre-Sprint Checklist (Do BEFORE starting the clock)

- [ ] Flutter project created: `flutter create recall --org com.biglitecode`
- [ ] pubspec.yaml dependencies added (from SKILL.md)
- [ ] `flutter pub get` ran successfully
- [ ] `assets/icons/` folder created, app_icon.png placed
- [ ] `assets/illustrations/` folder created, downloaded 3-4 PNGs from unDraw
- [ ] AndroidManifest.xml permissions added
- [ ] Hive build_runner ready: `flutter pub run build_runner build`

---

## HOUR 1 — Foundation (0:00 – 1:00)

### Task 1.1 — Theme & Colors (15 min)
- [ ] Create `lib/core/theme/app_colors.dart` — paste from SKILL.md
- [ ] Create `lib/core/theme/app_text_styles.dart`
  ```dart
  // headline, title, body, caption, label
  // Use font: default system (no Google Fonts needed)
  ```
- [ ] Create `lib/core/theme/app_theme.dart`
  ```dart
  ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(primary: AppColors.primary),
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: AppBarTheme(backgroundColor: AppColors.surface, elevation: 0),
    cardTheme: CardTheme(color: AppColors.surface, elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.border))),
  );
  ```
- [ ] Wire theme in `app.dart` and `main.dart`

### Task 1.2 — Models + Hive Setup (20 min)
- [ ] Write `TaskModel` in `lib/models/task_model.dart` (fields from SKILL.md)
- [ ] Write `PersonModel` in `lib/models/person_model.dart`
- [ ] Add `@HiveType` and `@HiveField` annotations
- [ ] Run: `flutter pub run build_runner build --delete-conflicting-outputs`
- [ ] Create `lib/services/hive_service.dart`
  ```dart
  class HiveService {
    static Future<void> init() async {
      await Hive.initFlutter();
      Hive.registerAdapter(TaskModelAdapter());
      Hive.registerAdapter(PersonModelAdapter());
      await Hive.openBox<TaskModel>('tasks');
      await Hive.openBox<PersonModel>('people');
    }
    static Box<TaskModel> get tasks => Hive.box<TaskModel>('tasks');
    static Box<PersonModel> get people => Hive.box<PersonModel>('people');
  }
  ```
- [ ] Call `HiveService.init()` in `main()` before `runApp()`

### Task 1.3 — Providers (25 min)
- [ ] `lib/providers/task_provider.dart`
  ```dart
  // Methods needed:
  // addTask(TaskModel), updateTask(TaskModel), deleteTask(String id)
  // markDone(String id), markIgnored(String id)
  // get allTasks, get todayTasks, get overdueTasks, get upcomingTasks
  // get tasksByType(String type), get tasksByStatus(String status)
  // get tasksByDate(DateTime date)  ← for calendar
  ```
- [ ] `lib/providers/person_provider.dart`
  ```dart
  // Methods: addPerson, updatePerson, deletePerson
  // get allPeople, getPendingTasksForPerson(String personId)
  ```
- [ ] Register both providers in `main.dart` with `MultiProvider`

---

## HOUR 2 — Core Screens (1:00 – 2:00)

### Task 2.1 — Bottom Navigation (10 min)
- [ ] Create `lib/shared/bottom_nav.dart`
  - 5 tabs: Home, Tasks, People, Calendar, Settings
  - Use `NavigationBar` (Material 3)
  - Icons: `home_outlined`, `checklist`, `people_outline`, `calendar_month_outlined`, `settings_outlined`
  - Active icon fills (no custom colors needed, uses primary)

### Task 2.2 — Home Dashboard (25 min)
- [ ] `lib/screens/home/home_screen.dart`
  - AppBar: "Good morning 👋" + date subtitle
  - Call log suggestion banner (if missed calls exist) — yellow card at top
  - 3 sections: Today, Overdue, Upcoming
- [ ] `today_card.dart` — shows count chips (📞 callbacks, ⏰ deadlines, 👤 followups)
  - Tap chip → navigates to Tasks filtered
- [ ] `overdue_card.dart` — red background, list of overdue task titles
  - Max 3 shown, "+N more" if more exist
- [ ] `upcoming_card.dart` — tomorrow / this week counts

### Task 2.3 — Tasks Screen (25 min)
- [ ] `lib/screens/tasks/tasks_screen.dart`
  - Filter chips row: All | Callback | Follow-up | Deadline
  - Status chips: Pending | Done | Ignored
  - ListView of TaskTile widgets
- [ ] `task_tile.dart`
  - Leading: type icon (📞 / 👤 / 📅)
  - Title + due date + priority badge
  - `flutter_slidable`: swipe right = done ✅, swipe left = delete 🗑️
  - Tap → expand or edit sheet
- [ ] `task_filter_chips.dart` — reusable chip row widget

---

## HOUR 3 — Features (2:00 – 3:00)

### Task 3.1 — Quick Capture FAB + Bottom Sheet (25 min)
> This is the most important feature. Build it well.

- [ ] `lib/shared/widgets/recall_fab.dart`
  - FloatingActionButton with `+` icon
  - `onPressed` → `showModalBottomSheet`
- [ ] `add_task_sheet.dart` — the bottom sheet
  - Step 1: Pick type (3 big buttons — Callback / Follow-up / Deadline)
  - Step 2: Form based on type
    - All types: Title, Due Date (omni_datetime_picker), Priority (High/Med/Low)
    - Callback only: Contact Name, Phone number
    - All types: Optional reminder toggle + time picker
  - Save button → `context.read<TaskProvider>().addTask(...)` → close sheet
  - Schedule notification if remindAt is set

### Task 3.2 — People Screen (20 min)
- [ ] `lib/screens/people/people_screen.dart`
  - List of PersonModel cards
  - Each card: Name, last contact date, count of pending tasks
  - Color: if no contact in 7+ days → subtle orange tint
- [ ] `add_person_sheet.dart` — Name, Phone, Notes fields
- [ ] `person_tile.dart` — swipe left to delete

### Task 3.3 — Notification Service (15 min)
- [ ] `lib/services/notification_service.dart`
  ```dart
  Future<void> init()  // call in main()
  Future<void> scheduleTaskReminder(TaskModel task)
  Future<void> cancelReminder(String taskId)
  Future<void> scheduleDailyDigest(int hour, int minute)
  Future<void> showInstantNotification(String title, String body)
  ```
- [ ] Call `NotificationService.init()` in `main()` after Hive init
- [ ] Wire `scheduleTaskReminder()` inside `TaskProvider.addTask()`
- [ ] Wire `cancelReminder()` inside `TaskProvider.markDone()`

---

## HOUR 4 — Polish & Ship (3:00 – 4:00)

### Task 4.1 — Calendar Screen (20 min)
- [ ] `lib/screens/calendar/calendar_screen.dart`
  - Use `table_calendar` package
  - `eventLoader`: return tasks for each day
  - Day markers: red dot = overdue, orange = upcoming, green = done
  - `onDaySelected` → show `day_tasks_sheet.dart` (bottom sheet listing tasks for that day)
- [ ] `day_tasks_sheet.dart` — simple list of TaskTile for selected date

### Task 4.2 — Call Log Integration (15 min)
- [ ] `lib/services/call_log_service.dart`
  ```dart
  Future<bool> requestPermission()
  Future<List<CallLogEntry>> getMissedCalls({int daysBack = 7})
  // Filter: only missed, only those not already captured in Hive
  ```
- [ ] `lib/providers/call_log_provider.dart`
  - Holds `List<CallLogEntry> missedCalls`
  - `fetchMissedCalls()` called on Home screen init
- [ ] In `home_screen.dart`: show suggestion banner
  ```
  📞 You have 3 unreturned calls — Add callbacks?
  ```
  - Tap → goes to Tasks with pre-filled callback form for that number

### Task 4.3 — Settings + Export/Import (15 min)
- [ ] `lib/screens/settings/settings_screen.dart`
  - Daily digest time picker
  - Export button → `ExportService.exportToJson()` → `share_plus` share sheet
  - Import button → `file_picker` picks .json → `ExportService.importFromJson()`
  - App version, About section
- [ ] `lib/services/export_service.dart`
  ```dart
  Future<void> exportToJson()
  // 1. Get all tasks + people from Hive
  // 2. Convert to Map, jsonEncode
  // 3. Save to temp file via path_provider
  // 4. Share via share_plus

  Future<void> importFromJson(String filePath)
  // 1. Read file, jsonDecode
  // 2. Validate structure (check 'version' key)
  // 3. Write to Hive boxes
  // 4. Notify providers to refresh
  ```

### Task 4.4 — Empty States (5 min)
- [ ] Add `EmptyState` widget: illustration + title + subtitle + optional CTA button
- [ ] Use on: Tasks (no tasks yet), People (no contacts), Calendar (no tasks this month)
- [ ] Pull illustrations from `assets/illustrations/`

### Task 4.5 — Final Polish (5 min)
- [ ] Test add task → appears on Home
- [ ] Test mark done → disappears from pending, notification cancelled
- [ ] Test export → JSON file shares correctly
- [ ] Test missed calls banner appears (use a real missed call on your device)
- [ ] Build APK: `flutter build apk --release`
- [ ] Install: `flutter install`

---

## Features Deferred (Build Later)

| Feature | Why Deferred |
|---|---|
| WhatsApp follow-up tracking | Needs Accessibility Service, complex |
| AI assistant ("You haven't called John in 14 days") | Add after people tab has 2 weeks of data |
| Gamification / productivity score | Day 2 feature |
| Firebase push notifications | Not needed, local notifications sufficient |
| Dark mode | Light mode ships first |
| iOS release | Requires Mac + Apple Developer account |

---

## Build Order Summary (Visual)

```
HOUR 1          HOUR 2          HOUR 3          HOUR 4
─────────────   ─────────────   ─────────────   ─────────────
Theme           BottomNav       FAB + Sheet     Calendar
Models          Home Dashboard  People Screen   Call Logs
Hive Service    Tasks Screen    Notifications   Settings + Export
Providers                                       Empty States
                                                APK Build
```

---

## Quick Commands Reference

```bash
# Create project
flutter create recall --org com.biglitecode

# Get packages
flutter pub get

# Generate Hive adapters (run after editing models)
flutter pub run build_runner build --delete-conflicting-outputs

# Generate app icon (after placing icon in assets/icons/)
flutter pub run flutter_launcher_icons

# Run on device
flutter run

# Build release APK
flutter build apk --release

# APK location
build/app/outputs/flutter-apk/app-release.apk
```

---

## Illustrations to Download Before You Start

Go to **undraw.co**, set color to `#2D6CDF`, download these:

| Illustration Name (search on unDraw) | Used On |
|---|---|
| "No data" or "Empty" | Tasks empty state |
| "People" or "Team" | People tab empty state |
| "Calendar" or "Schedule" | Calendar empty state |
| "Notification" or "Push" | Onboarding / notification prompt |

Save all as PNG to `assets/illustrations/` folder.

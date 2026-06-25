# SKILL.md — Recall App (Flutter)
> Personal follow-up, callback & deadline tracker. Local-only. Light mode. Android-first.

---

## 1. App Identity

| Property | Value |
|---|---|
| App Name | Recall |
| Package | com.biglitecode.recall |
| Platform | Android (primary), iOS (secondary) |
| Theme | Light mode only |
| Storage | Hive (local, no backend) |
| State | Provider |
| Min SDK | Android 21 (5.0+) |

---

## 2. Folder Structure

```
lib/
├── main.dart
├── app.dart                    # MaterialApp, theme, routes
│
├── core/
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   └── app_theme.dart
│   ├── constants/
│   │   └── app_constants.dart
│   └── utils/
│       ├── date_utils.dart
│       ├── notification_utils.dart
│       └── export_utils.dart
│
├── models/
│   ├── task_model.dart         # Unified task (callback/followup/deadline)
│   ├── task_model.g.dart       # Hive generated
│   ├── person_model.dart
│   └── person_model.g.dart
│
├── providers/
│   ├── task_provider.dart
│   ├── person_provider.dart
│   └── call_log_provider.dart
│
├── services/
│   ├── hive_service.dart       # Box init, CRUD helpers
│   ├── notification_service.dart
│   ├── call_log_service.dart   # READ_CALL_LOG permission + fetch
│   └── export_service.dart     # JSON export/import
│
├── screens/
│   ├── home/
│   │   ├── home_screen.dart
│   │   └── widgets/
│   │       ├── today_card.dart
│   │       ├── overdue_card.dart
│   │       └── upcoming_card.dart
│   │
│   ├── tasks/
│   │   ├── tasks_screen.dart
│   │   └── widgets/
│   │       ├── task_tile.dart
│   │       ├── task_filter_chips.dart
│   │       └── add_task_sheet.dart     # Bottom sheet quick capture
│   │
│   ├── people/
│   │   ├── people_screen.dart
│   │   └── widgets/
│   │       ├── person_tile.dart
│   │       └── add_person_sheet.dart
│   │
│   ├── calendar/
│   │   ├── calendar_screen.dart
│   │   └── widgets/
│   │       └── day_tasks_sheet.dart
│   │
│   └── settings/
│       ├── settings_screen.dart
│       └── widgets/
│           └── export_import_tile.dart
│
└── shared/
    ├── widgets/
    │   ├── recall_fab.dart         # The + FAB
    │   ├── priority_badge.dart
    │   ├── empty_state.dart
    │   └── section_header.dart
    └── bottom_nav.dart
```

---

## 3. Data Models

### TaskModel (Hive)
```dart
@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0) String id;           // uuid
  @HiveField(1) String title;
  @HiveField(2) String? description;
  @HiveField(3) String type;         // 'callback' | 'followup' | 'deadline'
  @HiveField(4) String priority;     // 'high' | 'medium' | 'low'
  @HiveField(5) String status;       // 'pending' | 'done' | 'ignored'
  @HiveField(6) DateTime dueDate;
  @HiveField(7) DateTime? remindAt;
  @HiveField(8) String? phone;       // for callbacks
  @HiveField(9) String? contactName; // for callbacks
  @HiveField(10) String? personId;   // link to PersonModel
  @HiveField(11) DateTime createdAt;
}
```

### PersonModel (Hive)
```dart
@HiveType(typeId: 1)
class PersonModel extends HiveObject {
  @HiveField(0) String id;
  @HiveField(1) String name;
  @HiveField(2) String? phone;
  @HiveField(3) String? notes;
  @HiveField(4) DateTime? lastContactDate;
  @HiveField(5) DateTime createdAt;
}
```

---

## 4. Dependencies (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management
  provider: ^6.1.2

  # Local Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0

  # Notifications
  flutter_local_notifications: ^17.2.2
  timezone: ^0.9.4

  # Call Log (Android)
  call_log: ^4.0.1

  # Permissions
  permission_handler: ^11.3.1

  # Unique IDs
  uuid: ^4.4.0

  # Date/Time Picker
  omni_datetime_picker: ^2.0.3

  # Calendar UI
  table_calendar: ^3.1.2

  # JSON Export/Import
  path_provider: ^2.1.3
  share_plus: ^9.0.0

  # File Picker (for import)
  file_picker: ^8.1.2

  # UI Extras
  flutter_slidable: ^3.1.1    # swipe to complete/delete on task tiles
  badges: ^3.1.2              # notification dot on bottom nav
  gap: ^3.0.1                 # clean spacing widget
  intl: ^0.19.0               # date formatting

dev_dependencies:
  hive_generator: ^2.0.1
  build_runner: ^2.4.11
  flutter_launcher_icons: ^0.13.1

flutter_icons:
  android: true
  ios: true
  image_path: "assets/icons/app_icon.png"  # 1024x1024 PNG
```

---

## 5. Theme — App Colors

```dart
// app_colors.dart
class AppColors {
  // Base
  static const background   = Color(0xFFF8F9FA);
  static const surface      = Color(0xFFFFFFFF);
  static const border       = Color(0xFFE9ECEF);

  // Brand
  static const primary      = Color(0xFF2D6CDF);   // trust blue
  static const primaryLight = Color(0xFFEBF1FD);

  // Status
  static const overdue      = Color(0xFFE53E3E);   // red
  static const overdueLight = Color(0xFFFFF5F5);
  static const upcoming     = Color(0xFFDD6B20);   // orange
  static const upcomingLight= Color(0xFFFFFAF0);
  static const done         = Color(0xFF38A169);   // green
  static const doneLight    = Color(0xFFF0FFF4);

  // Priority
  static const high         = Color(0xFFE53E3E);
  static const medium       = Color(0xFFDD6B20);
  static const low          = Color(0xFF38A169);

  // Text
  static const textPrimary  = Color(0xFF1A202C);
  static const textSecondary= Color(0xFF718096);
  static const textMuted    = Color(0xFFA0AEC0);
}
```

---

## 6. Key Services — How They Work

### NotificationService
- Init on app start with `flutter_local_notifications`
- `scheduleTaskReminder(TaskModel task)` — exact time notification
- `scheduleDailyDigest(TimeOfDay time)` — every morning summary
- Cancel notification by task id when task marked done
- Request permission on first launch (Android 13+)

### CallLogService
- Request `READ_CALL_LOG` permission via `permission_handler`
- Fetch missed calls from last 7 days via `call_log` package
- Filter: type == CallType.missed && not already in Hive tasks
- Return as `List<CallLogEntry>` for Home Dashboard suggestions
- User taps "Add Callback" → creates TaskModel with phone prefilled

### ExportService
```dart
// Export
Map<String, dynamic> toJson() => {
  'exported_at': DateTime.now().toIso8601String(),
  'version': '1.0',
  'tasks': tasks.map((t) => t.toMap()).toList(),
  'people': people.map((p) => p.toMap()).toList(),
};
// Save to Downloads, share via share_plus

// Import
// file_picker picks .json file
// Parse, validate version, write to Hive boxes
// Show count: "Imported 24 tasks, 8 people"
```

---

## 7. Navigation Structure

```
BottomNav (5 tabs):
  0 - Home       (house icon)
  1 - Tasks      (checklist icon)
  2 - People     (person icon)
  3 - Calendar   (calendar icon)
  4 - Settings   (gear icon)

FAB (+) visible on Home + Tasks screens only
FAB opens modal bottom sheet → pick type → fill form → save
```

---

## 8. Android Permissions (AndroidManifest.xml)

```xml
<uses-permission android:name="android.permission.READ_CALL_LOG"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.USE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"
  android:maxSdkVersion="28"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"
  android:maxSdkVersion="32"/>
```

---

## 9. Illustrations — Free Assets

| Source | URL | Use |
|---|---|---|
| unDraw | undraw.co | Empty states, onboarding |
| Storyset | storyset.com | Onboarding illustrations |
| Humaaans | humaaans.com | People-related empty states |
| Flaticon | flaticon.com | App icon base |
| Icons8 | icons8.com | App icon alternative |

**Color tip:** unDraw lets you set a hex color before downloading — set it to `#2D6CDF` (your primary) so illustrations match the theme automatically.

**App Icon:** Download 1024x1024 PNG from Flaticon/Icons8, place at `assets/icons/app_icon.png`, run `flutter pub run flutter_launcher_icons` — done.

---

## 10. Code Conventions

- File names: `snake_case.dart`
- Classes: `PascalCase`
- Constants: `kConstantName`
- Provider methods: verb first — `addTask()`, `deleteTask()`, `markDone()`
- Hive box names: `'tasks'`, `'people'`
- Never put business logic in screens — screens call provider methods only
- Every screen has its own `/widgets/` subfolder
- No hardcoded strings in UI — use `AppConstants` or direct string vars at top of file

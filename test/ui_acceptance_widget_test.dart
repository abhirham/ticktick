import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:flowtask/app/providers.dart';
import 'package:flowtask/app/theme.dart';
import 'package:flowtask/core/time/flow_date_utils.dart';
import 'package:flowtask/data/local/app_database.dart';
import 'package:flowtask/features/calendar/presentation/calendar_screen.dart';
import 'package:flowtask/features/lists/application/list_group_providers.dart';
import 'package:flowtask/features/lists/data/list_group_repository.dart';
import 'package:flowtask/features/lists/presentation/lists_screen.dart';
import 'package:flowtask/features/tasks/application/task_providers.dart';
import 'package:flowtask/features/tasks/data/task_repository.dart';
import 'package:flowtask/features/tasks/domain/task_draft.dart';
import 'package:flowtask/features/tasks/domain/task_enums.dart';
import 'package:flowtask/features/tasks/presentation/screens/add_task_screen.dart';
import 'package:flowtask/features/tasks/presentation/screens/task_detail_screen.dart';
import 'package:flowtask/features/tasks/presentation/screens/today_screen.dart';
import 'package:flowtask/features/tasks/presentation/widgets/natural_language_task_input.dart';

void main() {
  late AppDatabase database;
  late TaskRepository repository;
  final fixedNow = DateTime(2026, 5, 12, 9);

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = TaskRepository(database, now: () => fixedNow);
  });

  tearDown(() async {
    await database.close();
  });

  testWidgets('Today postpone moves overdue tasks to today', (tester) async {
    final overdue = await repository.createTask(
      TaskDraft(
        title: 'Renew overdue insurance',
        dueDate: fixedNow.subtract(const Duration(days: 2)),
      ),
    );
    await repository.createTask(
      TaskDraft(title: 'Due this morning', dueDate: fixedNow),
    );

    await tester.pumpWidget(
      _screenHarness(
        database: database,
        repository: repository,
        today: fixedNow,
        child: const TodayScreen(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Postpone'), findsOneWidget);
    await tester.tap(find.text('Postpone'));
    await tester.pumpAndSettle();

    final updated = await repository.readTask(overdue.id);
    expect(updated?.dueDate, dateOnly(fixedNow));

    await _disposeHarness(tester);
  });

  testWidgets('Calendar shows due tasks and switches view from the header', (
    tester,
  ) async {
    final today = dateOnly(DateTime.now());
    await repository.createTask(
      TaskDraft(title: 'Calendar-visible task', dueDate: today),
    );

    await tester.pumpWidget(
      _screenHarness(
        database: database,
        repository: repository,
        today: today,
        child: const CalendarScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Calendar-visible task'), findsWidgets);
    await tester.tap(find.byTooltip('Calendar view'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Agenda'));
    await tester.pumpAndSettle();

    expect(find.text('Calendar-visible task'), findsWidgets);

    await _disposeHarness(tester);
  });

  testWidgets('Add Task parses natural language chips and saves metadata', (
    tester,
  ) async {
    await tester.pumpWidget(
      _routerHarness(
        database: database,
        repository: repository,
        today: fixedNow,
        initialLocation: '/add',
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    const raw =
        'Keep in today: send builder email tomorrow at 5pm p1 every weekday remind me 10 minutes before';
    await tester.enterText(find.byType(TextField).first, raw);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Tomorrow'), findsOneWidget);
    expect(find.text('5:00p.m.'), findsOneWidget);
    expect(find.text('Weekdays'), findsOneWidget);
    expect(find.text('10 min before'), findsOneWidget);
    expect(find.text('High'), findsOneWidget);
    expect(find.text('Keep in Today'), findsOneWidget);

    await tester.tap(find.text('Save Task'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    final tasks = await database.select(database.taskItems).get();
    final task = tasks.single;
    final reminders = await (database.select(
      database.reminderEntries,
    )..where((reminder) => reminder.taskId.equals(task.id))).get();

    expect(task.title, 'send builder email');
    expect(task.dueDate, tomorrowOf(DateTime.now()));
    expect(task.dueTime, '17:00');
    expect(task.priority, TaskPriority.high.value);
    expect(task.isPersistent, isTrue);
    expect(task.recurrenceRuleId, isNotNull);
    expect(reminders.single.offsetMinutes, -10);

    await _disposeHarness(tester);
  });

  testWidgets('Task Detail can mark an open task complete', (tester) async {
    final task = await repository.createTask(
      TaskDraft(title: 'Finish task detail flow', dueDate: fixedNow),
    );

    await tester.pumpWidget(
      _routerHarness(
        database: database,
        repository: repository,
        today: fixedNow,
        initialLocation: '/task/${task.id}',
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Task Detail'), findsOneWidget);
    await tester.tap(find.text('Mark Complete'));
    await tester.pumpAndSettle();

    final updated = await repository.readTask(task.id);
    expect(updated?.status, TaskStatus.completed.value);

    await _disposeHarness(tester);
  });

  testWidgets('reminder editor returns relative reminder selections', (
    tester,
  ) async {
    List<TaskReminderDraft>? result;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildFlowTaskTheme(Brightness.light),
        darkTheme: buildFlowTaskTheme(Brightness.dark),
        themeMode: ThemeMode.dark,
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: Center(
                child: InkWell(
                  onTap: () async {
                    result = await showTaskReminderEditorSheet(
                      context,
                      initialReminders: const [],
                      dueDate: DateTime(2026, 5, 14),
                      dueTime: '17:00',
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Open reminder editor'),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open reminder editor'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('10 min before'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    expect(result, hasLength(1));
    expect(result!.single.offsetMinutes, -10);
    expect(result!.single.remindAt, DateTime(2026, 5, 14, 16, 50));

    await _disposeHarness(tester);
  });

  testWidgets('long list names fit at larger Android text scale', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    final previousOnError = FlutterError.onError;
    final overflowErrors = <FlutterErrorDetails>[];
    FlutterError.onError = (details) {
      if (details.exceptionAsString().contains('overflowed')) {
        overflowErrors.add(details);
        return;
      }
      previousOnError?.call(details);
    };
    addTearDown(() => FlutterError.onError = previousOnError);

    const longListName =
        'Insurance renewals and household paperwork that needs careful tracking';
    await tester.pumpWidget(
      _listsHarness(
        listName: longListName,
        today: fixedNow,
        textScaler: const TextScaler.linear(1.35),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text(longListName), findsWidgets);
    expect(overflowErrors, isEmpty);

    await _disposeHarness(tester);
  });

  testWidgets('Lists screen renders grouped list sections and tasks', (
    tester,
  ) async {
    await tester.pumpWidget(
      _listsHarness(
        listName: 'Home Projects',
        today: fixedNow,
        sections: [
          ListTaskSection(
            id: 'errands',
            title: 'Errands',
            groupId: 'errands',
            tasks: [
              _taskItem(
                title: 'Buy replacement filters',
                listId: 'long-list',
                groupId: 'errands',
                now: fixedNow,
              ),
            ],
          ),
        ],
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Home Projects'), findsWidgets);
    expect(find.text('Errands'), findsOneWidget);
    expect(find.text('Buy replacement filters'), findsOneWidget);
    expect(find.byTooltip('Group and sort'), findsOneWidget);

    await _disposeHarness(tester);
  });
}

Future<void> _disposeHarness(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump();
  await tester.pump(Duration.zero);
}

Widget _screenHarness({
  required AppDatabase database,
  required TaskRepository repository,
  required DateTime today,
  required Widget child,
  TextScaler textScaler = TextScaler.noScaling,
}) {
  return ProviderScope(
    overrides: [
      appDatabaseProvider.overrideWithValue(database),
      taskRepositoryProvider.overrideWithValue(repository),
      todayDateProvider.overrideWithValue(today),
    ],
    child: MaterialApp(
      theme: buildFlowTaskTheme(Brightness.light),
      darkTheme: buildFlowTaskTheme(Brightness.dark),
      themeMode: ThemeMode.dark,
      home: Builder(
        builder: (context) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: textScaler),
            child: Scaffold(drawer: const Drawer(), body: child),
          );
        },
      ),
    ),
  );
}

Widget _routerHarness({
  required AppDatabase database,
  required TaskRepository repository,
  required DateTime today,
  required String initialLocation,
}) {
  final router = GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/add',
        builder: (context, state) => const Scaffold(body: AddTaskScreen()),
      ),
      GoRoute(
        path: '/today',
        builder: (context, state) => const Scaffold(body: Text('Today')),
      ),
      GoRoute(
        path: '/trash',
        builder: (context, state) => const Scaffold(body: Text('Trash')),
      ),
      GoRoute(
        path: '/task/:id',
        builder: (context, state) {
          return Scaffold(
            body: TaskDetailScreen(taskId: state.pathParameters['id']!),
          );
        },
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      appDatabaseProvider.overrideWithValue(database),
      taskRepositoryProvider.overrideWithValue(repository),
      todayDateProvider.overrideWithValue(today),
    ],
    child: MaterialApp.router(
      theme: buildFlowTaskTheme(Brightness.light),
      darkTheme: buildFlowTaskTheme(Brightness.dark),
      themeMode: ThemeMode.dark,
      routerConfig: router,
    ),
  );
}

Widget _listsHarness({
  required String listName,
  required DateTime today,
  TextScaler textScaler = TextScaler.noScaling,
  List<ListTaskSection> sections = const [],
}) {
  final list = TaskList(
    id: 'long-list',
    name: listName,
    color: '#13C8A0',
    icon: null,
    sortOrder: 1,
    createdAt: today,
    updatedAt: today,
    isArchived: false,
    isSystemList: false,
  );

  return ProviderScope(
    overrides: [
      openTaskCountProvider.overrideWith((ref) => Stream.value(1)),
      completedTaskCountProvider.overrideWith((ref) => Stream.value(0)),
      trashTaskCountProvider.overrideWith((ref) => Stream.value(0)),
      listSummariesProvider.overrideWith(
        (ref) => Stream.value([TaskListSummary(list: list, openTaskCount: 1)]),
      ),
      listTaskSectionsProvider.overrideWith(
        (ref, request) => Stream.value(sections),
      ),
      todayDateProvider.overrideWithValue(today),
    ],
    child: MaterialApp(
      theme: buildFlowTaskTheme(Brightness.light),
      darkTheme: buildFlowTaskTheme(Brightness.dark),
      themeMode: ThemeMode.dark,
      home: Builder(
        builder: (context) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: textScaler),
            child: const Scaffold(drawer: Drawer(), body: ListsScreen()),
          );
        },
      ),
    ),
  );
}

TaskItem _taskItem({
  required String title,
  required String listId,
  required String groupId,
  required DateTime now,
}) {
  return TaskItem(
    id: 'task-$title',
    title: title,
    description: null,
    status: TaskStatus.open.value,
    priority: TaskPriority.none.value,
    listId: listId,
    groupId: groupId,
    createdAt: now,
    updatedAt: now,
    completedAt: null,
    deletedAt: null,
    dueDate: null,
    dueTime: null,
    startDate: null,
    startTime: null,
    timeZone: 'UTC',
    isAllDay: true,
    isPersistent: false,
    showInTodayUntilComplete: false,
    persistentStartedAt: null,
    persistentCompletedAt: null,
    todayCarryForwardCount: 0,
    lastCarriedForwardAt: null,
    recurrenceRuleId: null,
    recurrenceParentTaskId: null,
    recurrenceOccurrenceDate: null,
    originalInput: null,
    sortOrder: 0,
  );
}

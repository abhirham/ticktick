import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flowtask/app/providers.dart';
import 'package:flowtask/app/theme.dart';
import 'package:flowtask/data/local/app_database.dart';
import 'package:flowtask/features/settings/application/settings_providers.dart';
import 'package:flowtask/features/settings/data/settings_repository.dart';
import 'package:flowtask/features/settings/presentation/settings_screen.dart';
import 'package:flowtask/features/tasks/application/task_providers.dart';

void main() {
  late AppDatabase database;
  late SettingsRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = SettingsRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  testWidgets('settings toggles write persisted values', (tester) async {
    await tester.pumpWidget(_settingsHarness(database));
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('settings_toggle_showOverdueTasksInToday')),
    );
    await tester.pumpAndSettle();

    await _scrollTo(
      tester,
      find.byKey(
        const ValueKey('settings_toggle_showCompletedTasksInCalendar'),
      ),
    );
    await tester.tap(
      find.byKey(
        const ValueKey('settings_toggle_showCompletedTasksInCalendar'),
      ),
    );
    await tester.pumpAndSettle();

    final settings = await repository.readSettings();
    expect(settings.showOverdueTasksInToday, isTrue);
    expect(settings.showCompletedTasksInCalendar, isTrue);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });

  testWidgets('option rows persist selections and survive rebuild', (
    tester,
  ) async {
    await tester.pumpWidget(_settingsHarness(database));
    await tester.pumpAndSettle();

    await _selectOption(
      tester,
      rowKey: 'settings_option_themeMode',
      optionKey: 'settings_option_themeMode_dark',
    );
    await _selectOption(
      tester,
      rowKey: 'settings_option_firstDayOfWeek',
      optionKey: 'settings_option_firstDayOfWeek_monday',
    );
    await _selectOption(
      tester,
      rowKey: 'settings_option_defaultListId',
      optionKey: 'settings_option_defaultListId_personal',
    );

    var settings = await repository.readSettings();
    expect(settings.themeMode, 'dark');
    expect(settings.firstDayOfWeek, 'monday');
    expect(settings.defaultListId, 'personal');

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(_settingsHarness(database));
    await tester.pumpAndSettle();

    expect(find.text('Dark'), findsOneWidget);
    await _scrollTo(
      tester,
      find.byKey(const ValueKey('settings_option_firstDayOfWeek')),
    );
    expect(find.text('Monday'), findsOneWidget);
    await _scrollTo(
      tester,
      find.byKey(const ValueKey('settings_option_defaultListId')),
    );
    expect(find.text('Personal'), findsOneWidget);

    settings = await repository.readSettings();
    expect(settings.themeMode, 'dark');

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });
}

Future<void> _selectOption(
  WidgetTester tester, {
  required String rowKey,
  required String optionKey,
}) async {
  final row = find.byKey(ValueKey(rowKey));
  await _scrollTo(tester, row);
  await tester.tap(row);
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(ValueKey(optionKey)));
  await tester.pumpAndSettle();
}

Future<void> _scrollTo(WidgetTester tester, Finder finder) async {
  final scrollable = find.byType(Scrollable).first;
  if (finder.evaluate().isEmpty) {
    await tester.drag(scrollable, const Offset(0, 900));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      finder,
      280,
      scrollable: scrollable,
    );
  } else {
    await tester.ensureVisible(finder);
  }
  await tester.pumpAndSettle();
}

Widget _settingsHarness(AppDatabase database) {
  return ProviderScope(
    overrides: [
      appDatabaseProvider.overrideWithValue(database),
      flowTaskSettingsProvider.overrideWith(
        (ref) => Stream.fromFuture(SettingsRepository(database).readSettings()),
      ),
      taskListsProvider.overrideWith((ref) => Stream.value(_taskLists())),
    ],
    child: MaterialApp(
      theme: buildFlowTaskTheme(Brightness.light),
      darkTheme: buildFlowTaskTheme(Brightness.dark),
      themeMode: ThemeMode.dark,
      home: const Scaffold(drawer: Drawer(), body: SettingsScreen()),
    ),
  );
}

List<TaskList> _taskLists() {
  final now = DateTime(2026, 5, 12, 9);
  return [
    TaskList(
      id: AppDatabase.inboxListId,
      name: 'Inbox',
      color: '#4774FA',
      icon: null,
      sortOrder: 0,
      createdAt: now,
      updatedAt: now,
      isArchived: false,
      isSystemList: true,
    ),
    TaskList(
      id: 'personal',
      name: 'Personal',
      color: '#13C8A0',
      icon: null,
      sortOrder: 1,
      createdAt: now,
      updatedAt: now,
      isArchived: false,
      isSystemList: false,
    ),
  ];
}

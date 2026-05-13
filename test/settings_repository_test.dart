import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flowtask/data/local/app_database.dart';
import 'package:flowtask/features/settings/data/settings_repository.dart';

void main() {
  late AppDatabase database;
  late SettingsRepository repository;
  final now = DateTime(2026, 5, 12, 9);

  setUpAll(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  });

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = SettingsRepository(database, now: () => now);
  });

  tearDown(() async {
    await database.close();
  });

  test('reads defaults from the settings table', () async {
    final settings = await repository.readSettings();

    expect(settings.themeMode, 'system');
    expect(settings.remindersEnabled, isTrue);
    expect(settings.defaultReminderOffsetMinutes, 0);
    expect(settings.showPersistentTasksInToday, isTrue);
    expect(settings.defaultListId, AppDatabase.inboxListId);
    expect(settings.defaultGrouping, 'manualGroups');
    expect(settings.defaultCalendarView, 'month');
    expect(settings.widgetDisplayMode, 'countOnly');
    expect(settings.repeatingOverdueBehavior, 'completeOverdueAndGenerateNext');
  });

  test('persists bool, string, and int settings', () async {
    await repository.setString(SettingKeys.themeMode, 'dark');
    await repository.setBool(SettingKeys.showOverdueTasksInToday, true);
    await repository.setBool(SettingKeys.widgetShowsLockScreenTitles, true);
    await repository.setInt(SettingKeys.defaultReminderOffsetMinutes, 15);
    await repository.setString(SettingKeys.defaultCalendarView, 'week');

    final settings = await repository.readSettings();

    expect(settings.themeMode, 'dark');
    expect(settings.showOverdueTasksInToday, isTrue);
    expect(settings.widgetShowsLockScreenTitles, isTrue);
    expect(settings.defaultReminderOffsetMinutes, 15);
    expect(settings.defaultCalendarView, 'week');
  });

  test('keeps persisted settings when defaults are seeded on reopen', () async {
    final directory = await Directory.systemTemp.createTemp(
      'flowtask_settings_test',
    );
    final file = File('${directory.path}/settings.sqlite');

    final firstDatabase = AppDatabase(NativeDatabase(file));
    final firstRepository = SettingsRepository(firstDatabase, now: () => now);
    await firstRepository.setString(SettingKeys.themeMode, 'dark');
    await firstRepository.setBool(SettingKeys.showCarriedForwardCount, false);
    await firstDatabase.close();

    final reopenedDatabase = AppDatabase(NativeDatabase(file));
    final reopenedRepository = SettingsRepository(
      reopenedDatabase,
      now: () => now,
    );
    final settings = await reopenedRepository.readSettings();

    expect(settings.themeMode, 'dark');
    expect(settings.showCarriedForwardCount, isFalse);

    await reopenedDatabase.close();
    await directory.delete(recursive: true);
  });

  test('falls back to defaults for unknown option values', () async {
    await repository.setString(SettingKeys.themeMode, 'neon');
    await repository.setString(SettingKeys.firstDayOfWeek, 'funday');

    final settings = await repository.readSettings();

    expect(settings.themeMode, 'system');
    expect(settings.firstDayOfWeek, 'system');
  });
}

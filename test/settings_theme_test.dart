import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flowtask/app/providers.dart';
import 'package:flowtask/app/theme.dart';
import 'package:flowtask/data/local/app_database.dart';
import 'package:flowtask/features/settings/application/settings_providers.dart';
import 'package:flowtask/features/settings/data/settings_repository.dart';

void main() {
  testWidgets('dark theme mode is applied from settings', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());

    await SettingsRepository(database).setString(SettingKeys.themeMode, 'dark');
    await tester.pumpWidget(_appHarness(database));
    await tester.pumpAndSettle();

    expect(_currentBrightness(tester), Brightness.dark);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await database.close();
  });

  testWidgets('light theme mode is applied from settings', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());

    await SettingsRepository(
      database,
    ).setString(SettingKeys.themeMode, 'light');
    await tester.pumpWidget(_appHarness(database));
    await tester.pumpAndSettle();

    expect(_currentBrightness(tester), Brightness.light);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await database.close();
  });

  testWidgets('system theme mode follows platform brightness', (tester) async {
    tester.binding.platformDispatcher.platformBrightnessTestValue =
        Brightness.dark;
    addTearDown(
      tester.binding.platformDispatcher.clearPlatformBrightnessTestValue,
    );
    final database = AppDatabase(NativeDatabase.memory());

    await SettingsRepository(
      database,
    ).setString(SettingKeys.themeMode, 'system');
    await tester.pumpWidget(_appHarness(database));
    await tester.pumpAndSettle();

    expect(_currentBrightness(tester), Brightness.dark);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await database.close();
  });
}

Widget _appHarness(AppDatabase database) {
  return ProviderScope(
    overrides: [
      appDatabaseProvider.overrideWithValue(database),
      flowTaskSettingsProvider.overrideWith(
        (ref) => Stream.fromFuture(SettingsRepository(database).readSettings()),
      ),
    ],
    child: Consumer(
      builder: (context, ref, _) {
        final themeMode = ref.watch(flowTaskThemeModeProvider);
        return MaterialApp(
          themeMode: themeMode,
          theme: buildFlowTaskTheme(Brightness.light),
          darkTheme: buildFlowTaskTheme(Brightness.dark),
          home: const Text('Theme Probe'),
        );
      },
    ),
  );
}

Brightness _currentBrightness(WidgetTester tester) {
  final probe = find.text('Theme Probe');
  return Theme.of(tester.element(probe)).brightness;
}

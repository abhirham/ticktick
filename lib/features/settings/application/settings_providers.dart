import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../data/settings_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(ref.watch(appDatabaseProvider));
});

final flowTaskSettingsProvider = StreamProvider<FlowTaskSettings>((ref) {
  return ref.watch(settingsRepositoryProvider).watchSettings();
});

final flowTaskThemeModeProvider = Provider<ThemeMode>((ref) {
  final settings =
      ref.watch(flowTaskSettingsProvider).valueOrNull ??
      FlowTaskSettings.defaults;

  return switch (settings.themeMode) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };
});

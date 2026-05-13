import '../../../data/local/app_database.dart';

abstract final class SettingKeys {
  static const themeMode = 'themeMode';
  static const remindersEnabled = 'remindersEnabled';
  static const defaultReminderOffsetMinutes = 'defaultReminderOffsetMinutes';
  static const showOverdueTasksInToday = 'showOverdueTasksInToday';
  static const showPersistentTasksInToday = 'showPersistentTasksInToday';
  static const showCarriedForwardCount = 'showCarriedForwardCount';
  static const persistentTaskPosition = 'persistentTaskPosition';
  static const defaultListId = 'defaultListId';
  static const defaultGrouping = 'defaultGrouping';
  static const defaultCalendarView = 'defaultCalendarView';
  static const firstDayOfWeek = 'firstDayOfWeek';
  static const showCompletedTasksInCalendar = 'showCompletedTasksInCalendar';
  static const widgetDisplayMode = 'widgetDisplayMode';
  static const widgetShowsLockScreenTitles = 'widgetShowsLockScreenTitles';
  static const widgetTapDestination = 'widgetTapDestination';
  static const repeatingOverdueBehavior = 'repeatingOverdueBehavior';
}

class SettingsOption {
  const SettingsOption({
    required this.value,
    required this.label,
    this.description,
  });

  final String value;
  final String label;
  final String? description;
}

abstract final class SettingsOptions {
  static const themeModes = [
    SettingsOption(value: 'system', label: 'System'),
    SettingsOption(value: 'light', label: 'Light'),
    SettingsOption(value: 'dark', label: 'Dark'),
  ];

  static const defaultReminderOffsets = [
    SettingsOption(value: '0', label: 'At due time'),
    SettingsOption(value: '5', label: '5 minutes before'),
    SettingsOption(value: '15', label: '15 minutes before'),
    SettingsOption(value: '60', label: '1 hour before'),
    SettingsOption(value: '1440', label: '1 day before'),
  ];

  static const persistentTaskPositions = [
    SettingsOption(value: 'beforeScheduledTasks', label: 'Before scheduled'),
    SettingsOption(value: 'afterScheduledTasks', label: 'After scheduled'),
    SettingsOption(value: 'bottom', label: 'Bottom of Today'),
  ];

  static const defaultGroupings = [
    SettingsOption(value: 'manualGroups', label: 'Manual groups'),
    SettingsOption(value: 'dueDate', label: 'Due date'),
    SettingsOption(value: 'priority', label: 'Priority'),
    SettingsOption(value: 'status', label: 'Status'),
    SettingsOption(value: 'persistent', label: 'Persistent'),
    SettingsOption(value: 'none', label: 'None'),
  ];

  static const calendarViews = [
    SettingsOption(value: 'month', label: 'Month'),
    SettingsOption(value: 'week', label: 'Week'),
    SettingsOption(value: 'day', label: 'Day'),
    SettingsOption(value: 'agenda', label: 'Agenda'),
  ];

  static const firstDaysOfWeek = [
    SettingsOption(value: 'system', label: 'System'),
    SettingsOption(value: 'sunday', label: 'Sunday'),
    SettingsOption(value: 'monday', label: 'Monday'),
    SettingsOption(value: 'saturday', label: 'Saturday'),
  ];

  static const widgetDisplayModes = [
    SettingsOption(value: 'countOnly', label: 'Count only'),
    SettingsOption(value: 'countAndTitles', label: 'Count and titles'),
  ];

  static const widgetTapDestinations = [
    SettingsOption(value: 'today', label: 'Today'),
    SettingsOption(value: 'addTask', label: 'Add task'),
    SettingsOption(value: 'calendar', label: 'Calendar'),
  ];

  static const repeatingOverdueBehaviors = [
    SettingsOption(
      value: 'completeOverdueAndGenerateNext',
      label: 'Complete overdue and create next',
    ),
    SettingsOption(
      value: 'skipMissedAndGenerateNext',
      label: 'Skip missed and create next',
    ),
    SettingsOption(value: 'askEveryTime', label: 'Ask each time'),
  ];

  static String labelFor(Iterable<SettingsOption> options, String value) {
    for (final option in options) {
      if (option.value == value) {
        return option.label;
      }
    }
    return value;
  }
}

class FlowTaskSettings {
  const FlowTaskSettings({
    required this.themeMode,
    required this.remindersEnabled,
    required this.defaultReminderOffsetMinutes,
    required this.showOverdueTasksInToday,
    required this.showPersistentTasksInToday,
    required this.showCarriedForwardCount,
    required this.persistentTaskPosition,
    required this.defaultListId,
    required this.defaultGrouping,
    required this.defaultCalendarView,
    required this.firstDayOfWeek,
    required this.showCompletedTasksInCalendar,
    required this.widgetDisplayMode,
    required this.widgetShowsLockScreenTitles,
    required this.widgetTapDestination,
    required this.repeatingOverdueBehavior,
  });

  final String themeMode;
  final bool remindersEnabled;
  final int defaultReminderOffsetMinutes;
  final bool showOverdueTasksInToday;
  final bool showPersistentTasksInToday;
  final bool showCarriedForwardCount;
  final String persistentTaskPosition;
  final String defaultListId;
  final String defaultGrouping;
  final String defaultCalendarView;
  final String firstDayOfWeek;
  final bool showCompletedTasksInCalendar;
  final String widgetDisplayMode;
  final bool widgetShowsLockScreenTitles;
  final String widgetTapDestination;
  final String repeatingOverdueBehavior;

  static final defaults = FlowTaskSettings.fromValues(const {});

  factory FlowTaskSettings.fromEntries(Iterable<SettingsEntry> entries) {
    return FlowTaskSettings.fromValues({
      for (final entry in entries) entry.key: entry.value,
    });
  }

  factory FlowTaskSettings.fromValues(Map<String, String> values) {
    return FlowTaskSettings(
      themeMode: _readOption(
        values,
        SettingKeys.themeMode,
        SettingsOptions.themeModes,
      ),
      remindersEnabled: _readBool(values, SettingKeys.remindersEnabled),
      defaultReminderOffsetMinutes: _readInt(
        values,
        SettingKeys.defaultReminderOffsetMinutes,
      ),
      showOverdueTasksInToday: _readBool(
        values,
        SettingKeys.showOverdueTasksInToday,
      ),
      showPersistentTasksInToday: _readBool(
        values,
        SettingKeys.showPersistentTasksInToday,
      ),
      showCarriedForwardCount: _readBool(
        values,
        SettingKeys.showCarriedForwardCount,
      ),
      persistentTaskPosition: _readOption(
        values,
        SettingKeys.persistentTaskPosition,
        SettingsOptions.persistentTaskPositions,
      ),
      defaultListId: _readString(values, SettingKeys.defaultListId),
      defaultGrouping: _readOption(
        values,
        SettingKeys.defaultGrouping,
        SettingsOptions.defaultGroupings,
      ),
      defaultCalendarView: _readOption(
        values,
        SettingKeys.defaultCalendarView,
        SettingsOptions.calendarViews,
      ),
      firstDayOfWeek: _readOption(
        values,
        SettingKeys.firstDayOfWeek,
        SettingsOptions.firstDaysOfWeek,
      ),
      showCompletedTasksInCalendar: _readBool(
        values,
        SettingKeys.showCompletedTasksInCalendar,
      ),
      widgetDisplayMode: _readOption(
        values,
        SettingKeys.widgetDisplayMode,
        SettingsOptions.widgetDisplayModes,
      ),
      widgetShowsLockScreenTitles: _readBool(
        values,
        SettingKeys.widgetShowsLockScreenTitles,
      ),
      widgetTapDestination: _readOption(
        values,
        SettingKeys.widgetTapDestination,
        SettingsOptions.widgetTapDestinations,
      ),
      repeatingOverdueBehavior: _readOption(
        values,
        SettingKeys.repeatingOverdueBehavior,
        SettingsOptions.repeatingOverdueBehaviors,
      ),
    );
  }

  static String _readString(Map<String, String> values, String key) {
    return values[key] ?? _defaultValue(key);
  }

  static bool _readBool(Map<String, String> values, String key) {
    return (values[key] ?? _defaultValue(key)) == 'true';
  }

  static int _readInt(Map<String, String> values, String key) {
    return int.tryParse(values[key] ?? _defaultValue(key)) ??
        int.parse(_defaultValue(key));
  }

  static String _readOption(
    Map<String, String> values,
    String key,
    Iterable<SettingsOption> options,
  ) {
    final value = values[key] ?? _defaultValue(key);
    for (final option in options) {
      if (option.value == value) {
        return value;
      }
    }
    return _defaultValue(key);
  }

  static String _defaultValue(String key) {
    return AppDatabase.settingsDefaults[key]?.$1 ?? '';
  }
}

class SettingsRepository {
  SettingsRepository(this._db, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _now;

  Stream<FlowTaskSettings> watchSettings() {
    return _db
        .select(_db.settingsEntries)
        .watch()
        .map(FlowTaskSettings.fromEntries);
  }

  Future<FlowTaskSettings> readSettings() async {
    final entries = await _db.select(_db.settingsEntries).get();
    return FlowTaskSettings.fromEntries(entries);
  }

  Future<void> setBool(String key, bool value) {
    return _write(key: key, value: '$value');
  }

  Future<void> setInt(String key, int value) {
    return _write(key: key, value: '$value');
  }

  Future<void> setString(String key, String value) {
    return _write(key: key, value: value);
  }

  Future<void> _write({required String key, required String value}) async {
    await _db
        .into(_db.settingsEntries)
        .insertOnConflictUpdate(
          SettingsEntriesCompanion.insert(
            key: key,
            value: value,
            valueType: _valueType(key),
            updatedAt: _now(),
          ),
        );
  }

  String _valueType(String key) {
    return AppDatabase.settingsDefaults[key]?.$2 ?? 'string';
  }
}

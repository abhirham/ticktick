import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../data/local/app_database.dart';
import '../../tasks/application/task_providers.dart';
import '../../tasks/presentation/widgets/task_widgets.dart';
import '../application/settings_providers.dart';
import '../data/settings_repository.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final settings =
        ref.watch(flowTaskSettingsProvider).valueOrNull ??
        FlowTaskSettings.defaults;
    final repository = ref.read(settingsRepositoryProvider);
    final lists =
        ref.watch(taskListsProvider).valueOrNull ?? const <TaskList>[];
    final defaultListOptions = _defaultListOptions(
      lists,
      settings.defaultListId,
    );

    return ColoredBox(
      color: colors.bg,
      child: Column(
        children: [
          FlowTaskPageHeader(
            title: 'Settings',
            leading: FlowIconButton(
              icon: Icons.menu_rounded,
              tooltip: 'Open navigation',
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 112),
              children: [
                _SettingsPanel(
                  title: 'Theme',
                  children: [
                    _SettingsOptionRow(
                      key: const ValueKey('settings_option_themeMode'),
                      icon: Icons.brightness_auto_rounded,
                      iconColor: colors.primary,
                      title: 'Theme mode',
                      value: SettingsOptions.labelFor(
                        SettingsOptions.themeModes,
                        settings.themeMode,
                      ),
                      onTap: () => _showOptionSheet(
                        context,
                        ref,
                        title: 'Theme mode',
                        settingKey: SettingKeys.themeMode,
                        selectedValue: settings.themeMode,
                        options: SettingsOptions.themeModes,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _SettingsPanel(
                  title: 'Reminders',
                  children: [
                    _SettingsToggleRow(
                      key: const ValueKey('settings_toggle_remindersEnabled'),
                      icon: Icons.notifications_active_outlined,
                      iconColor: const Color(0xFFF7B43B),
                      title: 'Reminder alerts',
                      description: 'Allow task reminders to be scheduled.',
                      value: settings.remindersEnabled,
                      onChanged: (value) => repository.setBool(
                        SettingKeys.remindersEnabled,
                        value,
                      ),
                    ),
                    _SettingsOptionRow(
                      key: const ValueKey(
                        'settings_option_defaultReminderOffsetMinutes',
                      ),
                      icon: Icons.alarm_rounded,
                      iconColor: colors.primaryBright,
                      title: 'Default reminder',
                      value: SettingsOptions.labelFor(
                        SettingsOptions.defaultReminderOffsets,
                        '${settings.defaultReminderOffsetMinutes}',
                      ),
                      onTap: () => _showOptionSheet(
                        context,
                        ref,
                        title: 'Default reminder',
                        settingKey: SettingKeys.defaultReminderOffsetMinutes,
                        selectedValue:
                            '${settings.defaultReminderOffsetMinutes}',
                        options: SettingsOptions.defaultReminderOffsets,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _SettingsPanel(
                  title: 'Today',
                  children: [
                    _SettingsToggleRow(
                      key: const ValueKey(
                        'settings_toggle_showOverdueTasksInToday',
                      ),
                      icon: Icons.event_busy_outlined,
                      iconColor: colors.danger,
                      title: 'Show overdue tasks in Today',
                      value: settings.showOverdueTasksInToday,
                      onChanged: (value) => repository.setBool(
                        SettingKeys.showOverdueTasksInToday,
                        value,
                      ),
                    ),
                    _SettingsToggleRow(
                      key: const ValueKey(
                        'settings_toggle_showPersistentTasksInToday',
                      ),
                      icon: Icons.push_pin_outlined,
                      iconColor: const Color(0xFF13C8A0),
                      title: 'Show persistent tasks in Today',
                      value: settings.showPersistentTasksInToday,
                      onChanged: (value) => repository.setBool(
                        SettingKeys.showPersistentTasksInToday,
                        value,
                      ),
                    ),
                    _SettingsToggleRow(
                      key: const ValueKey(
                        'settings_toggle_showCarriedForwardCount',
                      ),
                      icon: Icons.update_rounded,
                      iconColor: colors.primary,
                      title: 'Show carried-forward count',
                      value: settings.showCarriedForwardCount,
                      onChanged: (value) => repository.setBool(
                        SettingKeys.showCarriedForwardCount,
                        value,
                      ),
                    ),
                    _SettingsOptionRow(
                      key: const ValueKey(
                        'settings_option_persistentTaskPosition',
                      ),
                      icon: Icons.vertical_align_center_rounded,
                      iconColor: const Color(0xFF4F79FF),
                      title: 'Persistent task position',
                      value: SettingsOptions.labelFor(
                        SettingsOptions.persistentTaskPositions,
                        settings.persistentTaskPosition,
                      ),
                      onTap: () => _showOptionSheet(
                        context,
                        ref,
                        title: 'Persistent task position',
                        settingKey: SettingKeys.persistentTaskPosition,
                        selectedValue: settings.persistentTaskPosition,
                        options: SettingsOptions.persistentTaskPositions,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _SettingsPanel(
                  title: 'Defaults',
                  children: [
                    _SettingsOptionRow(
                      key: const ValueKey('settings_option_defaultListId'),
                      icon: Icons.inbox_outlined,
                      iconColor: colors.primary,
                      title: 'Default list',
                      value: SettingsOptions.labelFor(
                        defaultListOptions,
                        settings.defaultListId,
                      ),
                      onTap: () => _showOptionSheet(
                        context,
                        ref,
                        title: 'Default list',
                        settingKey: SettingKeys.defaultListId,
                        selectedValue: settings.defaultListId,
                        options: defaultListOptions,
                      ),
                    ),
                    _SettingsOptionRow(
                      key: const ValueKey('settings_option_defaultGrouping'),
                      icon: Icons.splitscreen_rounded,
                      iconColor: const Color(0xFF55A8FF),
                      title: 'Default grouping',
                      value: SettingsOptions.labelFor(
                        SettingsOptions.defaultGroupings,
                        settings.defaultGrouping,
                      ),
                      onTap: () => _showOptionSheet(
                        context,
                        ref,
                        title: 'Default grouping',
                        settingKey: SettingKeys.defaultGrouping,
                        selectedValue: settings.defaultGrouping,
                        options: SettingsOptions.defaultGroupings,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _SettingsPanel(
                  title: 'Calendar',
                  children: [
                    _SettingsOptionRow(
                      key: const ValueKey('settings_option_firstDayOfWeek'),
                      icon: Icons.view_week_outlined,
                      iconColor: colors.primaryBright,
                      title: 'First day of week',
                      value: SettingsOptions.labelFor(
                        SettingsOptions.firstDaysOfWeek,
                        settings.firstDayOfWeek,
                      ),
                      onTap: () => _showOptionSheet(
                        context,
                        ref,
                        title: 'First day of week',
                        settingKey: SettingKeys.firstDayOfWeek,
                        selectedValue: settings.firstDayOfWeek,
                        options: SettingsOptions.firstDaysOfWeek,
                      ),
                    ),
                    _SettingsOptionRow(
                      key: const ValueKey(
                        'settings_option_defaultCalendarView',
                      ),
                      icon: Icons.calendar_month_rounded,
                      iconColor: colors.primary,
                      title: 'Default view',
                      value: SettingsOptions.labelFor(
                        SettingsOptions.calendarViews,
                        settings.defaultCalendarView,
                      ),
                      onTap: () => _showOptionSheet(
                        context,
                        ref,
                        title: 'Default calendar view',
                        settingKey: SettingKeys.defaultCalendarView,
                        selectedValue: settings.defaultCalendarView,
                        options: SettingsOptions.calendarViews,
                      ),
                    ),
                    _SettingsToggleRow(
                      key: const ValueKey(
                        'settings_toggle_showCompletedTasksInCalendar',
                      ),
                      icon: Icons.task_alt_rounded,
                      iconColor: const Color(0xFF13C8A0),
                      title: 'Show completed tasks in Calendar',
                      value: settings.showCompletedTasksInCalendar,
                      onChanged: (value) => repository.setBool(
                        SettingKeys.showCompletedTasksInCalendar,
                        value,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _SettingsPanel(
                  title: 'Widget',
                  children: [
                    _SettingsOptionRow(
                      key: const ValueKey('settings_option_widgetDisplayMode'),
                      icon: Icons.widgets_outlined,
                      iconColor: colors.primary,
                      title: 'Widget display',
                      value: SettingsOptions.labelFor(
                        SettingsOptions.widgetDisplayModes,
                        settings.widgetDisplayMode,
                      ),
                      onTap: () => _showOptionSheet(
                        context,
                        ref,
                        title: 'Widget display',
                        settingKey: SettingKeys.widgetDisplayMode,
                        selectedValue: settings.widgetDisplayMode,
                        options: SettingsOptions.widgetDisplayModes,
                      ),
                    ),
                    _SettingsToggleRow(
                      key: const ValueKey(
                        'settings_toggle_widgetShowsLockScreenTitles',
                      ),
                      icon: Icons.lock_outline_rounded,
                      iconColor: const Color(0xFFF7B43B),
                      title: 'Show titles on lock screen',
                      value: settings.widgetShowsLockScreenTitles,
                      onChanged: (value) => repository.setBool(
                        SettingKeys.widgetShowsLockScreenTitles,
                        value,
                      ),
                    ),
                    _SettingsOptionRow(
                      key: const ValueKey(
                        'settings_option_widgetTapDestination',
                      ),
                      icon: Icons.touch_app_outlined,
                      iconColor: colors.primaryBright,
                      title: 'Widget tap opens',
                      value: SettingsOptions.labelFor(
                        SettingsOptions.widgetTapDestinations,
                        settings.widgetTapDestination,
                      ),
                      onTap: () => _showOptionSheet(
                        context,
                        ref,
                        title: 'Widget tap opens',
                        settingKey: SettingKeys.widgetTapDestination,
                        selectedValue: settings.widgetTapDestination,
                        options: SettingsOptions.widgetTapDestinations,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _SettingsPanel(
                  title: 'Repeating',
                  children: [
                    _SettingsOptionRow(
                      key: const ValueKey(
                        'settings_option_repeatingOverdueBehavior',
                      ),
                      icon: Icons.repeat_rounded,
                      iconColor: colors.primary,
                      title: 'Overdue repeat behavior',
                      value: SettingsOptions.labelFor(
                        SettingsOptions.repeatingOverdueBehaviors,
                        settings.repeatingOverdueBehavior,
                      ),
                      onTap: () => _showOptionSheet(
                        context,
                        ref,
                        title: 'Overdue repeat behavior',
                        settingKey: SettingKeys.repeatingOverdueBehavior,
                        selectedValue: settings.repeatingOverdueBehavior,
                        options: SettingsOptions.repeatingOverdueBehaviors,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<SettingsOption> _defaultListOptions(
    List<TaskList> lists,
    String selectedListId,
  ) {
    final seen = <String>{};
    final options = <SettingsOption>[];

    void add(String id, String label) {
      if (seen.add(id)) {
        options.add(SettingsOption(value: id, label: label));
      }
    }

    add(AppDatabase.inboxListId, 'Inbox');
    for (final list in lists) {
      add(list.id, list.name);
    }
    if (!seen.contains(selectedListId)) {
      add(selectedListId, selectedListId);
    }
    return options;
  }

  Future<void> _showOptionSheet(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required String settingKey,
    required String selectedValue,
    required List<SettingsOption> options,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.colors.surface,
      barrierColor: Colors.black.withValues(alpha: 0.72),
      showDragHandle: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return _SettingsOptionSheet(
          title: title,
          settingKey: settingKey,
          selectedValue: selectedValue,
          options: options,
          onSelected: (value) {
            return ref
                .read(settingsRepositoryProvider)
                .setString(settingKey, value);
          },
        );
      },
    );
  }
}

class _SettingsPanel extends StatelessWidget {
  const _SettingsPanel({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: colors.text,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 8),
          for (var index = 0; index < children.length; index++) ...[
            if (index > 0) const _SettingsRowDivider(),
            children[index],
          ],
        ],
      ),
    );
  }
}

class _SettingsRowDivider extends StatelessWidget {
  const _SettingsRowDivider();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(left: 42),
      child: SizedBox(
        height: 1,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.textSubtle.withValues(alpha: 0.22),
          ),
        ),
      ),
    );
  }
}

class _SettingsOptionRow extends StatelessWidget {
  const _SettingsOptionRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: true,
      label: title,
      value: value,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 52),
          child: Row(
            children: [
              SizedBox(
                width: 28,
                child: Icon(icon, color: iconColor, size: 23),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colors.text,
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    height: 1.25,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: colors.textMuted,
                    fontSize: 15,
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.chevron_right_rounded,
                color: colors.textMuted,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsToggleRow extends StatelessWidget {
  const _SettingsToggleRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.onChanged,
    this.description,
    super.key,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String? description;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: true,
      toggled: value,
      label: title,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => onChanged(!value),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 52),
          child: Row(
            children: [
              SizedBox(
                width: 28,
                child: Icon(icon, color: iconColor, size: 23),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: colors.text,
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          height: 1.25,
                        ),
                      ),
                      if (description != null) ...[
                        const SizedBox(height: 3),
                        Text(
                          description!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: colors.textMuted,
                            fontSize: 13.5,
                            height: 1.25,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 14),
              _FlowSettingsSwitch(value: value),
            ],
          ),
        ),
      ),
    );
  }
}

class _FlowSettingsSwitch extends StatelessWidget {
  const _FlowSettingsSwitch({required this.value});

  final bool value;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOut,
      width: 44,
      height: 26,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: value ? colors.primary : colors.surfaceRaised,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: value ? colors.primary : colors.border,
          width: 1,
        ),
      ),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: value ? colors.textStrong : colors.textMuted,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _SettingsOptionSheet extends StatelessWidget {
  const _SettingsOptionSheet({
    required this.title,
    required this.settingKey,
    required this.selectedValue,
    required this.options,
    required this.onSelected,
  });

  final String title;
  final String settingKey;
  final String selectedValue;
  final List<SettingsOption> options;
  final Future<void> Function(String value) onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: colors.textStrong,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 10),
            for (final option in options)
              InkWell(
                key: ValueKey('settings_option_${settingKey}_${option.value}'),
                borderRadius: BorderRadius.circular(14),
                onTap: () async {
                  await onSelected(option.value);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 50),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              option.label,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: colors.text,
                                fontSize: 17,
                                height: 1.25,
                              ),
                            ),
                            if (option.description != null) ...[
                              const SizedBox(height: 3),
                              Text(
                                option.description!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: colors.textMuted,
                                  fontSize: 13.5,
                                  height: 1.25,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (option.value == selectedValue)
                        Icon(Icons.check_rounded, color: colors.primary),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

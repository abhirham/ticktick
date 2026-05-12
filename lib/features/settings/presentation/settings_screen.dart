import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../tasks/presentation/widgets/task_widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
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
              children: const [
                _SettingsPanel(
                  title: 'Theme',
                  rows: ['System theme', 'Light mode', 'Dark mode'],
                ),
                SizedBox(height: 16),
                _SettingsPanel(
                  title: 'Today',
                  rows: [
                    'Show overdue tasks in Today',
                    'Show persistent tasks in Today',
                    'Show carried-forward count',
                    'Persistent task position',
                  ],
                ),
                SizedBox(height: 16),
                _SettingsPanel(
                  title: 'Upcoming Phases',
                  rows: [
                    'Reminder permissions',
                    'Calendar defaults',
                    'Widget display options',
                    'Repeating overdue behavior',
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsPanel extends StatelessWidget {
  const _SettingsPanel({required this.title, required this.rows});

  final String title;
  final List<String> rows;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: colors.text,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          for (final row in rows)
            SizedBox(
              height: 56,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      row,
                      style: TextStyle(color: colors.text, fontSize: 21),
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: colors.textMuted),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

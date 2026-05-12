import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flowtask/app/flowtask_app.dart';
import 'package:flowtask/data/local/app_database.dart';
import 'package:flowtask/features/tasks/application/task_providers.dart';

void main() {
  testWidgets('FlowTask launches to Today', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          todayTasksProvider.overrideWith(
            (ref) => Stream.value(const <TaskItem>[]),
          ),
          overdueTasksProvider.overrideWith(
            (ref) => Stream.value(const <TaskItem>[]),
          ),
          completedTasksProvider.overrideWith(
            (ref) => Stream.value(const <TaskItem>[]),
          ),
          taskListsProvider.overrideWith(
            (ref) => Stream.value(const <TaskList>[]),
          ),
          inboxOpenCountProvider.overrideWith((ref) => Stream.value(0)),
          openTaskCountProvider.overrideWith((ref) => Stream.value(0)),
          completedTaskCountProvider.overrideWith((ref) => Stream.value(0)),
          trashTaskCountProvider.overrideWith((ref) => Stream.value(0)),
        ],
        child: const FlowTaskApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Today'), findsWidgets);
    expect(find.byIcon(Icons.add_rounded), findsWidgets);

    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pumpAndSettle();

    expect(find.text('What would you like to do?'), findsOneWidget);
  });
}

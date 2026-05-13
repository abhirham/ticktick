import 'package:flutter_test/flutter_test.dart';

import 'package:flowtask/data/local/app_database.dart';
import 'package:flowtask/features/tasks/domain/task_enums.dart';
import 'package:flowtask/features/tasks/presentation/widgets/natural_language_task_input.dart';

void main() {
  final now = DateTime(2026, 5, 12, 14, 30);

  test('form state turns parsed metadata into a task draft', () {
    const raw =
        'Keep in today: send builder email /Home > Builder tomorrow at 5pm p1 every weekday remind me 10 minutes before';
    final form = NaturalLanguageTaskFormState(now: () => now)..parse(raw);
    final draft = form.toDraft(
      rawInput: raw,
      description: 'Bring photos.',
      lists: [
        _list(id: AppDatabase.inboxListId, name: 'Inbox'),
        _list(),
      ],
      groups: [_group()],
    );

    expect(draft.title, 'send builder email');
    expect(draft.description, 'Bring photos.');
    expect(draft.listId, 'home');
    expect(draft.groupId, 'builder');
    expect(draft.dueDate, DateTime(2026, 5, 13));
    expect(draft.dueTime, '17:00');
    expect(draft.priority, TaskPriority.high);
    expect(draft.isPersistent, isTrue);
    expect(draft.showInTodayUntilComplete, isTrue);
    expect(draft.repeatRule?.frequency, TaskRepeatFrequency.weekly);
    expect(draft.repeatRule?.weekdays, '1,2,3,4,5');
    expect(draft.reminders.single.offsetMinutes, -10);
    expect(draft.reminders.single.remindAt, DateTime(2026, 5, 13, 16, 50));
  });

  test('removed metadata is excluded before saving', () {
    const raw = 'Call bank tomorrow at 5pm p1 /Home';
    final form = NaturalLanguageTaskFormState(now: () => now)..parse(raw);

    form.remove(TaskInputMetadataKind.date);
    form.remove(TaskInputMetadataKind.time);
    form.remove(TaskInputMetadataKind.priority);
    form.remove(TaskInputMetadataKind.list);

    final draft = form.toDraft(
      rawInput: raw,
      description: null,
      lists: [
        _list(id: AppDatabase.inboxListId, name: 'Inbox'),
        _list(),
      ],
      groups: const [],
    );

    expect(draft.title, 'Call bank');
    expect(draft.dueDate, isNull);
    expect(draft.dueTime, isNull);
    expect(draft.priority, TaskPriority.none);
    expect(draft.listId, AppDatabase.inboxListId);
  });

  test('missing parsed list and group produce save warnings', () {
    const raw = 'Book plumber /House > Builder tomorrow';
    final form = NaturalLanguageTaskFormState(now: () => now)..parse(raw);

    final messages = form.warningMessages(
      lists: [_list(id: AppDatabase.inboxListId, name: 'Inbox')],
      groups: const [],
    );

    expect(
      messages,
      contains('List "House" does not exist. Saving will use Inbox.'),
    );
    expect(
      messages,
      contains('Group "Builder" needs a matching list before it can be saved.'),
    );
  });
}

TaskList _list({String id = 'home', String name = 'Home'}) {
  final now = DateTime(2026, 5, 12, 9);
  return TaskList(
    id: id,
    name: name,
    color: '#4774FA',
    icon: null,
    sortOrder: 0,
    createdAt: now,
    updatedAt: now,
    isArchived: false,
    isSystemList: id == AppDatabase.inboxListId,
  );
}

ListGroup _group({String id = 'builder', String listId = 'home'}) {
  final now = DateTime(2026, 5, 12, 9);
  return ListGroup(
    id: id,
    listId: listId,
    name: 'Builder',
    sortOrder: 0,
    createdAt: now,
    updatedAt: now,
    isCollapsed: false,
  );
}

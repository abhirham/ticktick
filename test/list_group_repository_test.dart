import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flowtask/data/local/app_database.dart';
import 'package:flowtask/features/lists/data/list_group_repository.dart';
import 'package:flowtask/features/tasks/data/task_repository.dart';
import 'package:flowtask/features/tasks/domain/task_draft.dart';

void main() {
  late AppDatabase database;
  late ListGroupRepository listRepository;
  late TaskRepository taskRepository;
  final now = DateTime(2026, 5, 12, 9);

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    listRepository = ListGroupRepository(database, now: () => now);
    taskRepository = TaskRepository(database, now: () => now);
  });

  tearDown(() async {
    await database.close();
  });

  test('creates, styles, renames, and reorders lists', () async {
    final errands = await listRepository.createList(
      name: ' Errands ',
      color: '#13c8a0',
      icon: 'flag',
    );
    final home = await listRepository.createList(name: 'Home');

    await listRepository.renameList(id: errands.id, name: 'Weekly errands');
    await listRepository.updateListStyle(
      id: errands.id,
      color: '#f7b43b',
      icon: 'spark',
    );
    await listRepository.reorderLists([
      home.id,
      AppDatabase.inboxListId,
      errands.id,
    ]);

    final summaries = await listRepository.watchListSummaries().first;

    expect(summaries.map((summary) => summary.list.id), [
      home.id,
      AppDatabase.inboxListId,
      errands.id,
    ]);
    expect(summaries.last.list.name, 'Weekly errands');
    expect(summaries.last.list.color, '#F7B43B');
    expect(summaries.last.list.icon, 'spark');
  });

  test('creates, renames, collapses, reorders, and deletes groups', () async {
    final list = await listRepository.createList(name: 'Projects');
    final active = await listRepository.createGroup(
      listId: list.id,
      name: 'Active',
    );
    final later = await listRepository.createGroup(
      listId: list.id,
      name: 'Later',
    );
    final groupedTask = await taskRepository.createTask(
      TaskDraft(title: 'Grouped task', listId: list.id, groupId: active.id),
    );
    final looseTask = await taskRepository.createTask(
      TaskDraft(title: 'Loose task', listId: list.id),
    );

    await listRepository.renameGroup(id: active.id, name: 'Now');
    await listRepository.setGroupCollapsed(id: later.id, isCollapsed: true);
    await listRepository.reorderGroups(
      listId: list.id,
      orderedIds: [later.id, active.id],
    );

    var sections = await listRepository
        .watchListTaskSections(
          listId: list.id,
          sortMode: ListTaskSortMode.title,
        )
        .first;

    expect(sections.first.title, 'Ungrouped');
    expect(sections.first.isUngrouped, isTrue);
    expect(sections.first.tasks.single.id, looseTask.id);
    expect(sections[1].groupId, later.id);
    expect(sections[1].isCollapsed, isTrue);
    expect(sections[2].title, 'Now');
    expect(sections[2].tasks.single.id, groupedTask.id);

    await listRepository.moveTaskToGroup(
      taskId: looseTask.id,
      listId: list.id,
      groupId: later.id,
    );
    sections = await listRepository
        .watchListTaskSections(listId: list.id)
        .first;
    expect(sections.first.tasks, isEmpty);
    expect(sections[1].tasks.single.id, looseTask.id);

    await listRepository.deleteGroup(later.id);
    sections = await listRepository
        .watchListTaskSections(listId: list.id)
        .first;
    expect(sections.map((section) => section.groupId), [null, active.id]);
    expect(sections.first.tasks.single.id, looseTask.id);
  });

  test('deleting a list moves tasks to Inbox and removes its groups', () async {
    final list = await listRepository.createList(name: 'Temporary');
    final group = await listRepository.createGroup(
      listId: list.id,
      name: 'Soon',
    );
    final task = await taskRepository.createTask(
      TaskDraft(title: 'Keep me', listId: list.id, groupId: group.id),
    );

    await listRepository.deleteList(list.id);

    final summaries = await listRepository.watchListSummaries().first;
    expect(
      summaries.map((summary) => summary.list.id),
      isNot(contains(list.id)),
    );

    final tasks = await taskRepository.watchAllOpenTasks().first;
    final movedTask = tasks.singleWhere((item) => item.id == task.id);
    expect(movedTask.listId, AppDatabase.inboxListId);
    expect(movedTask.groupId, isNull);

    final groups = await listRepository.watchGroups(list.id).first;
    expect(groups, isEmpty);
  });
}

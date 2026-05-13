# FlowTask Implementation Plan

## Phase 1: Foundation

- Flutter scaffold for Android and iOS.
- Riverpod app providers.
- GoRouter shell with Today, Calendar, Lists, Add Task, and Settings.
- Drift + SQLite database with all planned tables.
- Default Inbox list and settings.
- Basic task creation, editing, completion, trash, restore, and permanent delete.
- Today, All Tasks, Completed, and Trash queries.
- Dark-first UI aligned with `style-guide.md`.

## Phase 2: Lists and Grouping

- Create, rename, delete, archive, and reorder lists.
- Create, rename, delete, collapse, and reorder groups.
- Move tasks between groups.
- Grouped List Detail view.

## Phase 3: Natural-Language Task Entry

- Deterministic parser interface and models.
- Date, time, priority, list, group, recurrence, reminder, and persistent extraction.
- Editable parsed chips.
- Natural Language Debug screen.

## Phase 4: Persistent Tasks

- Full "Keep in Today until complete" flows.
- Carry-forward counts and settings.
- Persistent badges and tests.

## Phase 5: Repeating Tasks

- Recurrence editor and engine.
- Generate next occurrence on completion.
- Persistent repeating behavior.

## Phase 6: Reminders

- Local notification scheduling and permissions.
- Multiple reminders, snooze, cancel, and reschedule behavior.
- Notification scheduling integrated with the reminder service.

## Phase 7: Calendar

- Month, week, day, and agenda views.
- Calendar settings and task date movement.

## Phase 8: Today Tasks Widget

- Flutter widget snapshot service.
- MethodChannel `flowtask/widget_bridge`.
- Android SharedPreferences `FlowTaskWidget` key `today_snapshot`.
- Android App Widget provider, resources, and manifest receiver.
- iOS WidgetKit extension bundle `com.flowtask.flowtask.todaywidget`.
- iOS app group `group.com.flowtask.flowtask`.
- Widget settings snapshot fields: `displayMode`,
  `lockScreenTitlesEnabled`, and `tapDestination`.
- Deep links: `flowtask://today`, `flowtask://add`,
  `flowtask://calendar`, and `flowtask://task/{id}`.
- Midnight refresh.

## Phase 9: Polish

- Empty, error, and undo states.
- Accessibility labels.
- Final QA and documentation refresh.

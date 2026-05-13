# FlowTask Product Spec

FlowTask is a focused offline-first task manager for Android and iOS. It keeps the surface area intentionally small: normal tasks, persistent tasks, repeating tasks, reminders, deterministic natural-language entry, lists with groups, a task calendar, and a Today Tasks widget.

## Principles

- Local-first: no login, no cloud sync, no external APIs.
- Fast capture: creating a task should require only a title.
- Today clarity: the Today screen may include due-today tasks, persistent tasks, and optionally overdue tasks.
- Widget clarity: the widget count is stricter than Today and counts only open tasks whose due date is exactly today.
- Simple recovery: completed tasks and deleted tasks remain visible in Completed and Trash.

## Primary Navigation

- Today
- Calendar
- Lists
- Add Task
- Settings

## Secondary Views

- All Tasks
- Completed
- Trash
- Task Detail
- List Detail
- Reminder Settings
- Natural Language Debug
- Widget Settings

## Deep Links

- `flowtask://today`
- `flowtask://add`
- `flowtask://calendar`
- `flowtask://task/{id}`

## Implementation Status

FlowTask includes the Flutter scaffold, clean architecture folders, Drift
database, routing, theme, task CRUD, lists/groups, natural-language chips,
persistent task behavior, recurrence generation, reminders and notifications,
calendar controls, native widgets, and deep links.

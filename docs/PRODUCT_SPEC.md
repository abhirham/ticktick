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

## Phase 1 Scope

The first implementation checkpoint provides the Flutter scaffold, clean architecture folders, Drift database, routing, theme, basic task CRUD, Inbox, Today, All Tasks, Completed, and Trash.

Later phases add list grouping, natural-language chips, persistent task refinements, recurrence generation, reminders, full calendar controls, and native widgets.

# FlowTask Remaining Tasks

## UI And Style Guide

- [x] Do another phone pass against `style-guide.md` for Today, drawer, quick add, task detail, calendar, lists, and settings.
- [x] Confirm text scale, row height, card radius, icon size, and safe-area spacing match the reference screenshots on the Samsung device.
- [x] Capture fresh screenshots for each main screen and keep them under `build/screenshots/` for comparison.
- [ ] Fix any remaining default Material-looking controls, dialogs, inputs, pickers, or buttons.
- [ ] [in progress: codex/phone-smoke] Verify quick-add and task-detail sheets with the keyboard open and closed.
- [ ] [in progress: codex/phone-smoke] Verify long task titles, long list names, and large Android font settings do not overflow.

## Task Basics

- [x] Finish create, edit, complete, delete, restore, and permanently delete flows across all task screens.
- [x] Make sure normal tasks can be created with title-only input.
- [x] Add complete task editing for due date, due time, priority, list, group, reminder, repeat rule, and description.
- [x] Add undo snackbar for common destructive actions where appropriate.
- [x] Confirm completed tasks remain visible in Completed and deleted tasks remain visible in Trash.

## Lists And Groups

- [x] Implement create, rename, delete, and reorder lists.
- [x] Implement list colors and optional list icons.
- [x] Implement create, rename, delete, collapse, expand, and reorder groups.
- [x] Implement moving tasks between groups.
- [x] Add the delete-group choice flow: move tasks to Ungrouped, delete tasks, or move tasks to another group.
- [x] Keep Ungrouped visible for every list.
- [x] Add list grouping modes: manual, due date, priority, status, persistent vs normal, and none.
- [x] Add sorting modes inside groups: manual, due date, priority, created date, and title.

## Natural Language Entry

- [x] Expand parser coverage for all examples in `docs/NATURAL_LANGUAGE_SPEC.md`.
- [x] Add editable parsed chips for date, time, repeat, reminder, priority, list, group, and persistent.
- [x] Support removing parsed chips before saving.
- [x] Add list/group confirmation or warning behavior when parsed list/group does not exist.
- [x] Finish Natural Language Debug Screen output for raw input, cleaned title, parsed metadata, and warnings.
- [x] Add parser tests for ambiguous dates, missing years, time without date, list/group syntax, reminders, recurrence, and persistent phrases.

## Persistent Tasks

- [x] Finish "Keep in Today until complete" toggle in add and detail flows.
- [x] Ensure persistent no-date tasks always appear in Today while open.
- [x] Show persistent badges and carried-forward labels.
- [x] Implement carried-forward count updates.
- [x] Add settings for persistent visibility, carried-forward count, and persistent task position.
- [x] Test persistent tasks created yesterday, completed persistent tasks, due-date preservation, and natural-language persistent triggers.

## Repeating Tasks

- [x] Finish recurrence editor UI.
- [x] Implement next occurrence generation when a repeating task is completed.
- [x] Prevent duplicate future occurrences.
- [x] Support daily, weekly, monthly, yearly, custom intervals, weekdays, weekends, selected weekdays, last Friday, and every other Saturday.
- [ ] [in progress: codex/main] Implement overdue repeating behavior setting.
- [x] Verify persistent plus repeating tasks do not duplicate.
- [x] Add recurrence engine tests for all supported patterns.

## Reminders And Notifications

- [x] Finish reminder editor UI with multiple reminders per task.
- [ ] [in progress: codex/main] Schedule local notifications with `flutter_local_notifications` and `timezone`.
- [ ] [in progress: codex/main] Request and display notification permission status.
- [ ] [in progress: codex/main] Add test notification button in settings.
- [ ] [in progress: codex/main] Cancel reminders on complete/delete and reschedule on date/time changes.
- [ ] [in progress: codex/main] Implement notification actions: mark complete, snooze, and open task.
- [ ] [in progress: codex/main] Implement snooze reminders without changing due date.
- [ ] [in progress: codex/main] Handle Android exact alarm limitations gracefully.
- [ ] [in progress: codex/main] Add reminder scheduling, cancellation, reschedule, snooze, repeating, and persistent tests.

## Calendar

- [x] Finish Month, Week, Day, and Agenda views.
- [x] Show normal due tasks, recurrence occurrences, and persistent tasks with due dates on correct calendar dates.
- [x] Exclude overdue tasks from today unless due date is actually today.
- [x] Exclude persistent no-date tasks from calendar blocks.
- [x] Add date tap to create task for that date.
- [x] Add task move-to-date and clear-date behavior.
- [x] Add calendar settings for first day of week, default view, and completed visibility.
- [x] Add calendar query tests.

## Today Widget

- [x] Finish `WidgetDataService` summary generation.
- [x] Persist widget-safe snapshots with due-today count, generated time, timezone, and next due-today task titles.
- [x] Ensure widget count includes only open tasks with `dueDate == today`.
- [x] Exclude overdue, completed, deleted, future, no-date, and persistent no-date tasks from widget count.
- [ ] [in progress: codex/native] Implement iOS WidgetKit home-screen and lock-screen widgets.
- [ ] [in progress: codex/native] Implement Android home-screen App Widget.
- [ ] [in progress: codex/native] Add Android lock-screen support only where OS/device allows it.
- [ ] [in progress: codex/native] Add deep links for `flowtask://today`, `flowtask://task/{id}`, and `flowtask://add`.
- [ ] [in progress: codex/native] Add midnight, timezone-change, task-change, and app-open widget refresh triggers.
- [ ] [in progress: codex/native] Add widget privacy settings.
- [x] Add widget snapshot and widget-count tests.

## Settings

- [x] Finish settings persistence for theme, reminders, today behavior, calendar, widget, recurrence overdue behavior, default list, and default grouping.
- [x] Confirm light, dark, and system theme modes work.
- [x] Add settings screen tests for toggles, option rows, and persistence.

## Native Platform

- [x] Verify Android app runs cleanly on the connected Samsung phone.
- [x] Keep the connected Android phone awake during QA sessions.
- [ ] [in progress: codex/native] Verify iOS app builds and launches in Simulator or on device.
- [ ] [in progress: codex/native] Add iOS WidgetKit extension target under `ios/Runner/FlowTaskTodayWidget`.
- [ ] [in progress: codex/native] Add Android App Widget files under `android/app/flowtask_today_widget`.
- [ ] [in progress: codex/native] Confirm native widgets read the shared widget data bridge.
- [ ] [in progress: codex/native] Confirm app icons, labels, launch theme, and permissions are production-ready.

## Tests And QA

- [ ] [in progress: codex/qa] Expand repository tests beyond the current baseline.
- [ ] [in progress: codex/qa] Add unit tests for task repository, parser, recurrence engine, reminders, list/group repository, Today query, completed/trash behavior, calendar query, and widget count.
- [ ] [in progress: codex/qa] Add widget tests for Today, Calendar, Add Task, Task Detail, List Detail, grouped list UI, reminder editor, natural-language chips, and widget settings.
- [ ] [in progress: codex/qa] Add feasible native/widget tests for Android and iOS widget snapshots.
- [ ] [in progress: codex/qa] Add integration tests for the core acceptance flows.
- [x] Run `flutter analyze` before each checkpoint.
- [x] Run `flutter test` before each checkpoint.
- [ ] [in progress: codex/main] Keep committing small checkpoints with clear messages.

## Cleanup

- [x] Decide whether to keep, delete, or commit `assets/brand/flowtask-icon.svg`.
- [ ] [in progress: codex/main] Review docs for drift after implementation changes.
- [ ] [in progress: codex/main] Remove any dead code, placeholder UI, or unused routes.
- [ ] [in progress: codex/main] Audit all buttons so unsupported actions are disabled or implemented.

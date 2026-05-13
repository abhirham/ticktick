# FlowTask Remaining Tasks

## UI And Style Guide

- [ ] [in progress: codex/phone-pass] Do another phone pass against `style-guide.md` for Today, drawer, quick add, task detail, calendar, lists, and settings.
- [ ] [in progress: codex/phone-pass] Confirm text scale, row height, card radius, icon size, and safe-area spacing match the reference screenshots on the Samsung device.
- [ ] [in progress: codex/phone-pass] Capture fresh screenshots for each main screen and keep them under `build/screenshots/` for comparison.
- [ ] Fix any remaining default Material-looking controls, dialogs, inputs, pickers, or buttons.
- [ ] [in progress: codex/phone-pass] Verify quick-add and task-detail sheets with the keyboard open and closed.
- [ ] [in progress: codex/phone-pass] Verify long task titles, long list names, and large Android font settings do not overflow.

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
- [ ] Add the delete-group choice flow: move tasks to Ungrouped, delete tasks, or move tasks to another group.
- [x] Keep Ungrouped visible for every list.
- [ ] Add list grouping modes: manual, due date, priority, status, persistent vs normal, and none.
- [ ] Add sorting modes inside groups: manual, due date, priority, created date, and title.

## Natural Language Entry

- [x] Expand parser coverage for all examples in `docs/NATURAL_LANGUAGE_SPEC.md`.
- [ ] Add editable parsed chips for date, time, repeat, reminder, priority, list, group, and persistent.
- [ ] Support removing parsed chips before saving.
- [ ] Add list/group confirmation or warning behavior when parsed list/group does not exist.
- [ ] Finish Natural Language Debug Screen output for raw input, cleaned title, parsed metadata, and warnings.
- [x] Add parser tests for ambiguous dates, missing years, time without date, list/group syntax, reminders, recurrence, and persistent phrases.

## Persistent Tasks

- [x] Finish "Keep in Today until complete" toggle in add and detail flows.
- [x] Ensure persistent no-date tasks always appear in Today while open.
- [x] Show persistent badges and carried-forward labels.
- [x] Implement carried-forward count updates.
- [x] Add settings for persistent visibility, carried-forward count, and persistent task position.
- [x] Test persistent tasks created yesterday, completed persistent tasks, due-date preservation, and natural-language persistent triggers.

## Repeating Tasks

- [ ] Finish recurrence editor UI.
- [ ] Implement next occurrence generation when a repeating task is completed.
- [ ] Prevent duplicate future occurrences.
- [ ] Support daily, weekly, monthly, yearly, custom intervals, weekdays, weekends, selected weekdays, last Friday, and every other Saturday.
- [ ] Implement overdue repeating behavior setting.
- [ ] Verify persistent plus repeating tasks do not duplicate.
- [ ] Add recurrence engine tests for all supported patterns.

## Reminders And Notifications

- [ ] Finish reminder editor UI with multiple reminders per task.
- [ ] Schedule local notifications with `flutter_local_notifications` and `timezone`.
- [ ] Request and display notification permission status.
- [ ] Add test notification button in settings.
- [ ] Cancel reminders on complete/delete and reschedule on date/time changes.
- [ ] Implement notification actions: mark complete, snooze, and open task.
- [ ] Implement snooze reminders without changing due date.
- [ ] Handle Android exact alarm limitations gracefully.
- [ ] Add reminder scheduling, cancellation, reschedule, snooze, repeating, and persistent tests.

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
- [ ] Implement iOS WidgetKit home-screen and lock-screen widgets.
- [ ] Implement Android home-screen App Widget.
- [ ] Add Android lock-screen support only where OS/device allows it.
- [ ] Add deep links for `flowtask://today`, `flowtask://task/{id}`, and `flowtask://add`.
- [ ] Add midnight, timezone-change, task-change, and app-open widget refresh triggers.
- [ ] Add widget privacy settings.
- [x] Add widget snapshot and widget-count tests.

## Settings

- [x] Finish settings persistence for theme, reminders, today behavior, calendar, widget, recurrence overdue behavior, default list, and default grouping.
- [x] Confirm light, dark, and system theme modes work.
- [x] Add settings screen tests for toggles, option rows, and persistence.

## Native Platform

- [ ] [in progress: codex/phone-pass] Verify Android app runs cleanly on the connected Samsung phone.
- [ ] Verify iOS app builds and launches in Simulator or on device.
- [ ] Add iOS WidgetKit extension target under `ios/Runner/FlowTaskTodayWidget`.
- [ ] Add Android App Widget files under `android/app/flowtask_today_widget`.
- [ ] Confirm native widgets read the shared widget data bridge.
- [ ] Confirm app icons, labels, launch theme, and permissions are production-ready.

## Tests And QA

- [ ] Expand repository tests beyond the current baseline.
- [ ] Add unit tests for task repository, parser, recurrence engine, reminders, list/group repository, Today query, completed/trash behavior, calendar query, and widget count.
- [ ] Add widget tests for Today, Calendar, Add Task, Task Detail, List Detail, grouped list UI, reminder editor, natural-language chips, and widget settings.
- [ ] Add feasible native/widget tests for Android and iOS widget snapshots.
- [ ] Add integration tests for the core acceptance flows.
- [ ] [in progress: codex/phone-pass] Run `flutter analyze` before each checkpoint.
- [ ] [in progress: codex/phone-pass] Run `flutter test` before each checkpoint.
- [ ] Keep committing small checkpoints with clear messages.

## Cleanup

- [ ] Decide whether to keep, delete, or commit `assets/brand/flowtask-icon.svg`.
- [ ] Review docs for drift after implementation changes.
- [ ] Remove any dead code, placeholder UI, or unused routes.
- [ ] Audit all buttons so unsupported actions are disabled or implemented.

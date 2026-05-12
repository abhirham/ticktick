# Today Tasks Widget Spec

FlowTask includes a Today Tasks widget for quick glanceable due-today counts.

## Required Widget

Today Count Bubble.

The count includes only tasks where:

- `status == open`
- `deleted_at == null`
- `completed_at == null`
- `due_date == today` in the user's local time zone

The count excludes:

- Overdue tasks
- Completed tasks
- Deleted tasks
- Tomorrow and future tasks
- No-date tasks
- Persistent no-date tasks
- Future repeating occurrences

## Data Bridge

Flutter writes a small widget-safe snapshot:

- `dueTodayCount`
- `generatedAt`
- `timeZone`
- `nextDueTodayTasks`

Native widgets read only this snapshot.

## Native Targets

- iOS WidgetKit home-screen and lock-screen widgets.
- Android App Widget for home screen.
- Android lock-screen support only where the OS/device supports it.

## Phase 1 Status

Phase 1 includes the `widget_snapshots` table and a due-today count query. Native widgets are scheduled for Phase 8.

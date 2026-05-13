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
- `displayMode`
- `lockScreenTitlesEnabled`
- `tapDestination`

Native widgets read only this snapshot.

The Flutter-to-native bridge uses MethodChannel `flowtask/widget_bridge`.
Android also persists the latest widget-safe payload to SharedPreferences
`FlowTaskWidget` under key `today_snapshot` so the App Widget can render outside
the Flutter process.

## Native Targets

- iOS WidgetKit home-screen and lock-screen widgets in extension bundle
  `com.flowtask.flowtask.todaywidget`.
- iOS widget data is shared through app group `group.com.flowtask.flowtask`.
- Android App Widget for home screen, with provider, resources, and manifest
  receiver under the Android app target.
- Android lock-screen support only where the OS/device supports it.

## Deep Links

Widget taps and notification/task entry points use these routes:

- `flowtask://today`
- `flowtask://add`
- `flowtask://calendar`
- `flowtask://task/{id}`

`tapDestination` controls which supported deep link a widget tap opens.

## Implementation Status

The `widget_snapshots` table, due-today count query, Flutter snapshot service,
MethodChannel bridge, Android App Widget, and iOS WidgetKit extension are
implemented.

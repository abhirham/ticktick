# Calendar Spec

The calendar is task-only. It does not sync external calendars and does not include habits, pomodoro, or countdowns.

## Views

- Month
- Week
- Day
- Agenda

## Inclusion Rules

Show:

- Normal tasks due on each date
- Repeating occurrences on their occurrence date
- Persistent tasks only when they have a due date
- Completed tasks only if enabled

Do not show:

- Deleted tasks
- Overdue tasks on today unless their due date is today
- Persistent no-date tasks as calendar blocks

## Deep Link

The Calendar view is reachable through `flowtask://calendar`.

## Implementation Status

Month, week, day, and agenda views are implemented with calendar settings and
task date movement.

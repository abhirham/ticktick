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

## Phase 1 Status

Phase 1 includes a simple date task query and starter Calendar screen. Full calendar controls are scheduled for Phase 7.

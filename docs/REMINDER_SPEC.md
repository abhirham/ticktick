# Reminder Spec

FlowTask reminders use `flutter_local_notifications` and `timezone` for timezone-aware local notifications.

## Reminder Types

- At due time
- Custom date/time
- X minutes, hours, or days before due time
- Multiple reminders per task
- Repeating task reminders
- Persistent task reminders

## Behavior

- Schedule when a reminder is added.
- Cancel when removed, completed, or deleted.
- Reschedule when task date/time changes.
- Reschedule for the next recurrence occurrence.
- Snoozing creates a temporary reminder and does not alter the due date.

## Notification Actions

- Mark complete
- Snooze 5 minutes
- Snooze 10 minutes
- Snooze 30 minutes
- Snooze 1 hour
- Open task

## Phase 1 Status

The schema includes reminders. Scheduling, permissions, and snooze are scheduled for Phase 6.

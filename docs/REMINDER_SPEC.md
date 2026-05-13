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
- Notification scheduling is integrated with the reminder service, so reminder
  create/update/delete flows are responsible for keeping local notifications in
  sync with stored reminder records.

## Notification Actions

- Mark complete
- Snooze 5 minutes
- Snooze 10 minutes
- Snooze 30 minutes
- Snooze 1 hour
- Open task

## Implementation Status

The schema, reminder service integration, notification scheduling, permissions,
snooze, cancellation, and recurrence rescheduling behavior are implemented.

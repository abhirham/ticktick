# Recurrence Spec

Repeating tasks are represented by one recurrence rule and generated task occurrences. Completing the current occurrence creates the next occurrence without duplicating future tasks.

## Supported Rules

- Daily, weekly, monthly, yearly
- Custom intervals: every X days or weeks
- Weekdays and weekends
- Selected weekdays
- Monthly by day, such as the 15th
- Monthly by position, such as last Friday
- Yearly by month/day

## Completion Behavior

Settings control overdue recurrence behavior:

- Complete overdue and generate next
- Skip overdue and generate next
- Keep overdue and create next
- Ask each time

## Persistent + Repeating

A repeating task can also be persistent. Each generated occurrence may stay in Today until completed, but completing it must generate only one next occurrence.

## Phase 1 Status

The schema includes recurrence fields and recurrence rule storage. The recurrence engine is scheduled for Phase 5.

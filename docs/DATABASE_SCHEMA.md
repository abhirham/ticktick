# FlowTask Database Schema

FlowTask uses Drift with SQLite. All timestamps are stored as local `DateTime` values through Drift. Date-only fields are normalized to local midnight.

## tasks

Stores normal, persistent, and generated recurrence task instances.

- `id` text primary key
- `title` text
- `description` text nullable
- `status` text: `open`, `completed`, `deleted`
- `priority` text: `none`, `low`, `medium`, `high`
- `list_id` text
- `group_id` text nullable
- `created_at`, `updated_at` datetime
- `completed_at`, `deleted_at` datetime nullable
- `due_date`, `start_date` datetime nullable
- `due_time`, `start_time` text nullable, `HH:mm`
- `time_zone` text
- `is_all_day` boolean
- `is_persistent` boolean
- `show_in_today_until_complete` boolean
- `persistent_started_at`, `persistent_completed_at` datetime nullable
- `today_carry_forward_count` integer
- `last_carried_forward_at` datetime nullable
- `recurrence_rule_id`, `recurrence_parent_task_id` text nullable
- `recurrence_occurrence_date` datetime nullable
- `original_input` text nullable
- `sort_order` integer

## lists

Stores user-editable normal lists. Smart views are rendered by the app and are not editable lists.

- `id` text primary key
- `name` text
- `color` text
- `icon` text nullable
- `sort_order` integer
- `created_at`, `updated_at` datetime
- `is_archived` boolean
- `is_system_list` boolean

## list_groups

- `id` text primary key
- `list_id` text
- `name` text
- `sort_order` integer
- `created_at`, `updated_at` datetime
- `is_collapsed` boolean

## reminders

- `id` text primary key
- `task_id` text
- `reminder_type` text
- `remind_at` datetime
- `offset_minutes` integer nullable
- `is_enabled` boolean
- `created_at`, `updated_at` datetime

## recurrence_rules

- `id` text primary key
- `repeat_frequency` text
- `repeat_interval` integer
- `repeat_weekdays` text nullable
- `repeat_month_day` integer nullable
- `repeat_end_type` text
- `repeat_end_date` datetime nullable
- `repeat_occurrence_count` integer nullable
- `created_at`, `updated_at` datetime

## settings

Key-value settings with a `value_type` field for interpretation.

## activity_logs

Append-only audit records for task/list actions.

## widget_snapshots

Small privacy-safe widget payloads, including due-today count and optional next task titles.

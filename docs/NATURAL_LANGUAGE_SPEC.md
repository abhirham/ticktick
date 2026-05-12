# Natural-Language Spec

The parser must be deterministic, offline, locale-aware where possible, and replaceable by a future AI parser through an interface.

```dart
NaturalLanguageTaskParser.parse(input, now, timeZone, locale)
```

## Output Models

- `ParsedTaskInput`
- `ParsedRecurrence`
- `ParsedReminder`
- `ParserResultWarning`

## Required Extraction

- Clean task title
- Due date and time
- Start date and time
- Recurrence
- Reminder
- Priority
- List and group
- Persistent flag
- Original raw input
- Warnings

## Syntax

- Priority: `p1`, `p2`, `p3`, `p4`, `!high`, `!medium`, `!low`, `urgent`, `important`, `high priority`
- List: `/Home`
- Group: `/House > Builder`
- Persistent: `keep in today`, `until complete`, `until done`, `carry forward`, `persistent task`, `keep showing`, `stay in today`
- Reminder: `remind me at 9am`, `remind me 10 minutes before`, `alert me tomorrow morning`

## Cleanup

Parsed metadata phrases must be removed from the saved title. For example, `Keep in today: send builder email` becomes `send builder email`.

## Phase 1 Status

Phase 1 includes the database fields and app structure. The deterministic parser is scheduled for Phase 3.

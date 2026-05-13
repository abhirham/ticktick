import 'package:flutter/material.dart';

import '../../app/theme.dart';

Future<DateTime?> showFlowDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) {
  return showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
    builder: (context, child) {
      final colors = context.colors;
      final base = Theme.of(context);
      return Theme(
        data: base.copyWith(
          colorScheme: base.colorScheme.copyWith(
            primary: colors.primary,
            onPrimary: colors.textStrong,
            surface: colors.surface,
            onSurface: colors.text,
          ),
          dialogTheme: DialogThemeData(backgroundColor: colors.surface),
          datePickerTheme: DatePickerThemeData(
            backgroundColor: colors.surface,
            surfaceTintColor: Colors.transparent,
            headerBackgroundColor: colors.surface,
            headerForegroundColor: colors.textStrong,
            headerHeadlineStyle: TextStyle(
              color: colors.textStrong,
              fontSize: 23,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
            headerHelpStyle: TextStyle(
              color: colors.textMuted,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            dayStyle: TextStyle(
              color: colors.text,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            dayForegroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return colors.textStrong;
              }
              if (states.contains(WidgetState.disabled)) {
                return colors.textSubtle;
              }
              return colors.text;
            }),
            dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return colors.primary;
              }
              return Colors.transparent;
            }),
            todayForegroundColor: WidgetStateProperty.all(colors.primary),
            todayBorder: BorderSide(color: colors.primary),
            weekdayStyle: TextStyle(
              color: colors.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            yearStyle: TextStyle(
              color: colors.text,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            yearForegroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return colors.textStrong;
              }
              return colors.text;
            }),
            yearBackgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return colors.primary;
              }
              return Colors.transparent;
            }),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: colors.primary),
          ),
        ),
        child: child ?? const SizedBox.shrink(),
      );
    },
  );
}

import 'package:flutter/material.dart';

@immutable
class FlowTaskColors extends ThemeExtension<FlowTaskColors> {
  const FlowTaskColors({
    required this.bg,
    required this.surface,
    required this.surfaceRaised,
    required this.surfaceSelected,
    required this.primary,
    required this.primaryBright,
    required this.danger,
    required this.dangerStrong,
    required this.text,
    required this.textStrong,
    required this.textMuted,
    required this.textSubtle,
    required this.icon,
    required this.iconMuted,
    required this.border,
  });

  final Color bg;
  final Color surface;
  final Color surfaceRaised;
  final Color surfaceSelected;
  final Color primary;
  final Color primaryBright;
  final Color danger;
  final Color dangerStrong;
  final Color text;
  final Color textStrong;
  final Color textMuted;
  final Color textSubtle;
  final Color icon;
  final Color iconMuted;
  final Color border;

  static const dark = FlowTaskColors(
    bg: Color(0xFF000000),
    surface: Color(0xFF1C1C1C),
    surfaceRaised: Color(0xFF202020),
    surfaceSelected: Color(0xFF232D48),
    primary: Color(0xFF4774FA),
    primaryBright: Color(0xFF4B78FF),
    danger: Color(0xFFDA3E38),
    dangerStrong: Color(0xFFE64A45),
    text: Color(0xFFE6E6E6),
    textStrong: Color(0xFFF1F1F1),
    textMuted: Color(0xFF8A8A8A),
    textSubtle: Color(0xFF636363),
    icon: Color(0xFFD9D9D9),
    iconMuted: Color(0xFF8D8D8D),
    border: Color(0xFF5E5E5E),
  );

  static const light = FlowTaskColors(
    bg: Color(0xFFF7F7F8),
    surface: Color(0xFFFFFFFF),
    surfaceRaised: Color(0xFFF0F1F4),
    surfaceSelected: Color(0xFFE8EEFF),
    primary: Color(0xFF285CEA),
    primaryBright: Color(0xFF4774FA),
    danger: Color(0xFFC7352F),
    dangerStrong: Color(0xFFD33D37),
    text: Color(0xFF171717),
    textStrong: Color(0xFF050505),
    textMuted: Color(0xFF6F6F72),
    textSubtle: Color(0xFF9A9A9E),
    icon: Color(0xFF262626),
    iconMuted: Color(0xFF77777A),
    border: Color(0xFFB7B7BA),
  );

  @override
  FlowTaskColors copyWith({
    Color? bg,
    Color? surface,
    Color? surfaceRaised,
    Color? surfaceSelected,
    Color? primary,
    Color? primaryBright,
    Color? danger,
    Color? dangerStrong,
    Color? text,
    Color? textStrong,
    Color? textMuted,
    Color? textSubtle,
    Color? icon,
    Color? iconMuted,
    Color? border,
  }) {
    return FlowTaskColors(
      bg: bg ?? this.bg,
      surface: surface ?? this.surface,
      surfaceRaised: surfaceRaised ?? this.surfaceRaised,
      surfaceSelected: surfaceSelected ?? this.surfaceSelected,
      primary: primary ?? this.primary,
      primaryBright: primaryBright ?? this.primaryBright,
      danger: danger ?? this.danger,
      dangerStrong: dangerStrong ?? this.dangerStrong,
      text: text ?? this.text,
      textStrong: textStrong ?? this.textStrong,
      textMuted: textMuted ?? this.textMuted,
      textSubtle: textSubtle ?? this.textSubtle,
      icon: icon ?? this.icon,
      iconMuted: iconMuted ?? this.iconMuted,
      border: border ?? this.border,
    );
  }

  @override
  FlowTaskColors lerp(ThemeExtension<FlowTaskColors>? other, double t) {
    if (other is! FlowTaskColors) {
      return this;
    }
    return FlowTaskColors(
      bg: Color.lerp(bg, other.bg, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceRaised: Color.lerp(surfaceRaised, other.surfaceRaised, t)!,
      surfaceSelected: Color.lerp(surfaceSelected, other.surfaceSelected, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryBright: Color.lerp(primaryBright, other.primaryBright, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      dangerStrong: Color.lerp(dangerStrong, other.dangerStrong, t)!,
      text: Color.lerp(text, other.text, t)!,
      textStrong: Color.lerp(textStrong, other.textStrong, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      textSubtle: Color.lerp(textSubtle, other.textSubtle, t)!,
      icon: Color.lerp(icon, other.icon, t)!,
      iconMuted: Color.lerp(iconMuted, other.iconMuted, t)!,
      border: Color.lerp(border, other.border, t)!,
    );
  }
}

extension FlowTaskTheme on BuildContext {
  FlowTaskColors get colors => Theme.of(this).extension<FlowTaskColors>()!;
}

ThemeData buildFlowTaskTheme(Brightness brightness) {
  final colors = brightness == Brightness.dark
      ? FlowTaskColors.dark
      : FlowTaskColors.light;
  final colorScheme = ColorScheme.fromSeed(
    seedColor: colors.primary,
    brightness: brightness,
    primary: colors.primary,
    surface: colors.surface,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colors.bg,
    fontFamily: 'Roboto',
    extensions: [colors],
    appBarTheme: AppBarTheme(
      backgroundColor: colors.bg,
      foregroundColor: colors.textStrong,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: colors.surface,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: InputBorder.none,
      hintStyle: TextStyle(color: colors.textMuted),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: colors.surfaceRaised,
      contentTextStyle: TextStyle(color: colors.text),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

// lib/themes/app_themes.dart
import 'package:flutter/material.dart';

//TODO: deprecate gradient and constant glow, remnant from TeachAssist color system reuse

@immutable
class CustomThemeColors extends ThemeExtension<CustomThemeColors> {
  const CustomThemeColors({
    required this.gradientStart,
    required this.gradientEnd,
    required this.customGlow,
    required this.primaryBackground,
  });

  final Color? gradientStart;
  final Color? gradientEnd;
  final Color? customGlow;
  final Color? primaryBackground;

  @override
  CustomThemeColors copyWith({
    Color? gradientStart,
    Color? gradientEnd,
    Color? customGlow,
    Color? primaryBackground,
  }) {
    return CustomThemeColors(
      gradientStart: gradientStart ?? this.gradientStart,
      gradientEnd: gradientEnd ?? this.gradientEnd,
      customGlow: customGlow ?? this.customGlow,
      primaryBackground: primaryBackground ?? this.primaryBackground,
    );
  }

  @override
  CustomThemeColors lerp(ThemeExtension<CustomThemeColors>? other, double t) {
    if (other is! CustomThemeColors) return this;
    return CustomThemeColors(
      gradientStart: Color.lerp(gradientStart, other.gradientStart, t),
      gradientEnd: Color.lerp(gradientEnd, other.gradientEnd, t),
      customGlow: Color.lerp(customGlow, other.customGlow, t),
      primaryBackground:
          Color.lerp(primaryBackground, other.primaryBackground, t),
    );
  }
}

/// custom theme colors (Option A: Dark Navy + Neon Green Glow)
class customColors {
  static const Color background = Color(0xFF06101E); // dark navy
  static const Color glow = Color(0xFF00FFA8); // neon green
  static const Color accent = Color(0xFF5E72FF); // purple-blue
}

/// Central theme definitions
class AppThemes {
  // --- Light Theme ---
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorSchemeSeed: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(backgroundColor: Colors.blue),
    cardTheme: const CardThemeData(elevation: 4),
    extensions: const <ThemeExtension<dynamic>>[
      CustomThemeColors(
        gradientStart: Colors.blue,
        gradientEnd: Colors.lightBlueAccent,
        customGlow: Colors.transparent,
        primaryBackground: Colors.white,
      ),
    ],
  );

  // --- Dark Theme ---
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorSchemeSeed: Colors.grey,
    scaffoldBackgroundColor: const Color(0xFF0B0B0B),
    appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF111217)),
    cardTheme: const CardThemeData(elevation: 6),
    extensions: <ThemeExtension<dynamic>>[
      CustomThemeColors(
        gradientStart: Colors.grey.shade900,
        gradientEnd: Colors.black,
        customGlow: customColors.glow.withAlpha(31), // ~12% opacity
        primaryBackground: const Color(0xFF0B0B0B),
      ),
    ],
  );

  // --- custom Theme (Dark Mode Only) ---
  static final ThemeData customTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: customColors.background,
    appBarTheme: const AppBarTheme(backgroundColor: customColors.background),
    cardTheme: CardThemeData(
      color: customColors.background,
      elevation: 10,
      shadowColor: customColors.accent.withAlpha(153), // ~60% opacity
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: customColors.accent,
      brightness: Brightness.dark,
      primary: customColors.accent,
      secondary: customColors.accent,
    ),
    extensions: const <ThemeExtension<dynamic>>[
      CustomThemeColors(
        gradientStart: customColors.background,
        gradientEnd: customColors.glow,
        customGlow: customColors.accent,
        primaryBackground: customColors.background,
      ),
    ],
  );

  /// Get theme for a given AppTheme enum value and system brightness
  /// This handles the "system" preset by checking actual device brightness
  static ThemeData getTheme(
    AppTheme appTheme, {
    required bool isSystemDark,
    required Color colorSeed,
  }) {
    switch (appTheme) {
      case AppTheme.custom:
        // Custom theme with dynamic glow based on accent color
        return customTheme.copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: colorSeed,
            brightness: Brightness.dark,
            primary: colorSeed,
            secondary: colorSeed,
          ),
          extensions: <ThemeExtension<dynamic>>[
            CustomThemeColors(
              gradientStart: customColors.background,
              gradientEnd: colorSeed,
              customGlow: colorSeed, // Use accent color as glow (full strength)
              primaryBackground: customColors.background,
            ),
          ],
        );

      case AppTheme.light:
        return lightTheme.copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: colorSeed,
            brightness: Brightness.light,
          ),
        );

      case AppTheme.dark:
        return darkTheme.copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: colorSeed,
            brightness: Brightness.dark,
          ),
          extensions: <ThemeExtension<dynamic>>[
            CustomThemeColors(
              gradientStart: Colors.grey.shade900,
              gradientEnd: Colors.black,
              customGlow: colorSeed.withAlpha(31), // Use accent with 12% opacity
              primaryBackground: const Color(0xFF0B0B0B),
            ),
          ],
        );

      case AppTheme.system:
        // Use device system preference
        if (isSystemDark) {
          return darkTheme.copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: colorSeed,
              brightness: Brightness.dark,
            ),
            extensions: <ThemeExtension<dynamic>>[
              CustomThemeColors(
                gradientStart: Colors.grey.shade900,
                gradientEnd: Colors.black,
                customGlow: colorSeed.withAlpha(31), // Use accent with 12% opacity
                primaryBackground: const Color(0xFF0B0B0B),
              ),
            ],
          );
        } else {
          return lightTheme.copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: colorSeed,
              brightness: Brightness.light,
            ),
          );
        }
    }
  }
}

/// App theme enum
enum AppTheme { system, light, dark, custom }

extension AppThemeLabel on AppTheme {
  String get label {
    switch (this) {
      case AppTheme.system:
        return 'System Default';
      case AppTheme.light:
        return 'Light';
      case AppTheme.dark:
        return 'Dark';
      case AppTheme.custom:
        return 'Custom';
    }
  }
}
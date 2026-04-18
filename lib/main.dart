// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'themes/app_themes.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize theme provider with saved preferences
  final themeProvider = ThemeProvider();
  await themeProvider.initialize();

  runApp(
    ChangeNotifierProvider<ThemeProvider>(
      create: (_) => themeProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        // Determine if system is in dark mode (for the "system" preset)
        final mediaQuery = MediaQuery.of(context);
        final isSystemDark =
            mediaQuery.platformBrightness == Brightness.dark;

        // Get the appropriate theme
        final themeLight = AppThemes.getTheme(
          themeProvider.appTheme,
          isSystemDark: false,
          colorSeed: themeProvider.colorSeed,
        );

        final themeDark = AppThemes.getTheme(
          themeProvider.appTheme,
          isSystemDark: true,
          colorSeed: themeProvider.colorSeed,
        );

        return MaterialApp(
          title: 'TeachAssist',
          debugShowCheckedModeBanner: false,
          theme: themeLight,
          darkTheme: themeDark,
          themeMode: themeProvider.themeMode,
          home: const HomePage(),
        );
      },
    );
  }
}
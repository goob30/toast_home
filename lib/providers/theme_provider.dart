// lib/providers/theme_provider.dart
import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../themes/app_themes.dart';

/// Manages theme state and persistence
class ThemeProvider extends ChangeNotifier {
  late SharedPreferences _prefs;
  bool _isInitialized = false;

  // Theme state
  late AppTheme _appTheme;
  late ThemeMode _themeMode;
  late Color _colorSeed;
  late bool _useGradientColors;

  // Getters
  AppTheme get appTheme => _appTheme;
  ThemeMode get themeMode => _themeMode;
  Color get colorSeed => _colorSeed;
  bool get useGradientColors => _useGradientColors;
  bool get isInitialized => _isInitialized;

  ThemeProvider() {
    // Set defaults
    _appTheme = AppTheme.system;
    _themeMode = ThemeMode.system;
    _colorSeed = Colors.green;
    _useGradientColors = false;
  }

  /// Initialize with saved preferences
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();

    // Load saved values or use defaults
    final themeName = _prefs.getString('appTheme') ?? 'system';
    final themeModeName = _prefs.getString('themeMode') ?? 'system';
    final colorSeedInt = _prefs.getInt('colorSeed') ?? Colors.blue.value;
    final gradient = _prefs.getBool('useGradient') ?? false;

    _appTheme = AppTheme.values.firstWhere(
      (e) => e.name == themeName,
      orElse: () => AppTheme.system,
    );
    _themeMode = ThemeMode.values.firstWhere(
      (e) => e.name == themeModeName,
      orElse: () => ThemeMode.system,
    );
    _colorSeed = Color(colorSeedInt);
    _useGradientColors = gradient;

    _isInitialized = true;
    notifyListeners();
  }

  /// Change app theme preset
  Future<void> setAppTheme(AppTheme theme) async {
    if (_appTheme == theme) return;
    _appTheme = theme;
    await _prefs.setString('appTheme', theme.name);
    notifyListeners();
  }

  /// Change theme mode (Light/Dark/System)
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    await _prefs.setString('themeMode', mode.name);
    notifyListeners();
  }

  /// Change color seed
  Future<void> setColorSeed(Color color) async {
    if (_colorSeed == color) return;
    _colorSeed = color;
    await _prefs.setInt('colorSeed', color.value);
    notifyListeners();
  }

  /// Toggle gradient mode
  Future<void> setUseGradientColors(bool use) async {
    if (_useGradientColors == use) return;
    _useGradientColors = use;
    await _prefs.setBool('useGradient', use);
    notifyListeners();
  }

  Color? shiftedColorHue (Color color1, double hueShift) {
    
    final hsl = HSLColor.fromColor(color1);
    final newHue = (hsl.hue + hueShift) % 360;
    return hsl.withHue(newHue).toColor();
  }

  Color? lightened (Color color1, double lightShift) {
    final hsl = HSLColor. fromColor(color1);
    final newLight = (hsl.lightness + lightShift).clamp(0.0, 1.0);
    return hsl.withLightness(newLight).toColor();
  }
}
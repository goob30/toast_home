// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../themes/app_themes.dart';
import 'settings_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    double lightenAmount = isDark ? 0.02 : -0.02;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const SettingsPage(),
              ),
            ),
          ),
        ],
      ),
      body: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          final custom =
              Theme.of(context).extension<CustomThemeColors>();

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: themeProvider.colorSeed.withAlpha(80),
                        blurRadius: 15,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Card(
                    elevation: 0,
                    

                    //shadowColor: themeProvider.colorSeed.withAlpha(50), // this is glow
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    color: themeProvider.lightened(Theme.of(context).scaffoldBackgroundColor, lightenAmount ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            'Current Theme Settings',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          _SettingRow(
                            label: 'App Theme',
                            value: themeProvider.appTheme.label,
                          ),
                          const SizedBox(height: 8),
                          _SettingRow(
                            label: 'Theme Mode',
                            value: themeProvider.themeMode.toString().split('.')[1],
                          ),
                          const SizedBox(height: 8),
                          _SettingRow(
                            label: 'Gradient Colors',
                            value: themeProvider.useGradientColors
                                ? 'Enabled'
                                : 'Disabled',
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Accent Color: '),
                              const SizedBox(width: 8),
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  boxShadow: [BoxShadow(
                                    color: themeProvider.colorSeed.withAlpha(102), // im a bit slow in the head its not this one
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                  )],
                                  color: themeProvider.colorSeed, 
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface,
                                  ),
                                ),
                                
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final String label;
  final String value;

  const _SettingRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
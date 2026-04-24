import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teach_assist/pages/safetyinfo_page.dart';
import '../providers/theme_provider.dart';
import '../themes/app_themes.dart';
import 'package:flutter/services.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const _chipAnimDuration = Duration(milliseconds: 200);

  // Available accent colors
  static const accentOptions = <Color>[
    Colors.blue,
    Colors.teal,
    Colors.indigo,
    Colors.orange,
    Colors.pink,
    Colors.purple,
  ];
  // ---------------color
  static const modeColors = <Color>[
    Colors.red,
    Colors.green,
    Colors.yellow,
  ];

  @override 
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final custom =
            Theme.of(context).extension<CustomThemeColors>();

        return Scaffold(
          appBar: AppBar(title: const Text('Settings')),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              

              Row(
                children: [
                  Text('App Theme'),
                  Spacer(),
                  DropdownButton<AppTheme>(
                    value: themeProvider.appTheme,
                    items: AppTheme.values
                        .map(
                          (theme) => DropdownMenuItem(
                            value: theme,
                            child: Text(theme.label),
                          ),
                        )
                        .toList(),
                    onChanged: (theme) {
                      if (theme != null) {
                        themeProvider.setAppTheme(theme);
                      }
                    },
                  ),
                ],
              ),


              // -------- Accent Color Selector --------
              Text(
                'Accent Color',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              
              const SizedBox(height: 12),
              Wrap(
                spacing: 16,
                runSpacing: 12,
                children: [
                  for (final color in accentOptions)
                    _ColorChip(
                      color: color,
                      isSelected: themeProvider.colorSeed == color,
                      onTap: () =>
                          themeProvider.setColorSeed(color),
                      customGlow: custom?.customGlow,
                    ),
                ],
              ),

              const SizedBox(height: 40),
              ElevatedButton(onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SafetyinfoPage(),
                  ),
                );
              }, child: Text('Safety Info')),
              
              const Divider(height: 40),

              Row(
                children: [
                  Text('Device ID'),
                  Spacer(),
                  SizedBox(
                    width: 100,
                    child: TextField(
                      textAlign: TextAlign.right,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Animated color chip widget
class _ColorChip extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? customGlow;

  const _ColorChip({
    required this.color,
    required this.isSelected,
    required this.onTap,
    this.customGlow,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        width: isSelected ? 48 : 40,
        height: isSelected ? 48 : 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            width: isSelected ? 3 : 1.5,
            color: isSelected
                ? Theme.of(context).colorScheme.onSurface
                : Colors.grey.withAlpha(128),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: (customGlow ??
                            Theme.of(context).colorScheme.primary)
                        .withAlpha(61), // ~24% opacity
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
      ),
    );
  }
}
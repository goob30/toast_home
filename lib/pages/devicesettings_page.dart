import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teach_assist/pages/safetyinfo_page.dart';
import '../providers/theme_provider.dart';
import '../themes/app_themes.dart';

class DevicesettingsPage extends StatefulWidget {
  const DevicesettingsPage({super.key});

  @override
  State<DevicesettingsPage> createState() => _DevicesettingsPageState();
}

class _DevicesettingsPageState extends State<DevicesettingsPage> {
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
          appBar: AppBar(title: const Text('Device Settings')),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              ElevatedButton(onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SafetyinfoPage(),
                  ),
                );
              }, child: Text('Safety Info')),
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
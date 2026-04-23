import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../themes/app_themes.dart';
import 'settings_page.dart';
import '../bt_handler.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:async';
import 'device_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
  static const modeColors = <Color>[
    Colors.red,
    Colors.green,
    Colors.yellow,
  ];

  static const fanModes = <String> [
    "Auto",
    "Low",
    "Medium",
    "High"
  ];
}

class _HomePageState extends State<HomePage>{
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    double lightenAmount = isDark ? 0.02 : -0.02;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          Consumer<BtService>(
            builder: (context, btService, _) {
              return Row(
                children: [
                  ElevatedButton(
                    onPressed: btService.isScanning
                        ? () => btService.stopScan()
                        : () => btService.scanAndConnectHM10(),
                    child: Text(btService.isScanning ? "Stop" : "Scan"),
                  ),
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
              );
            },
          ),
        ],
      ),
      body: Consumer2<ThemeProvider, BtService>(
        builder: (context, themeProvider, btService, _) {
          final custom =
              Theme.of(context).extension<CustomThemeColors>();
          final isBtConnected = btService.isBtConnected;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context, MaterialPageRoute(
                        builder: (_) => const DevicePage(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: isBtConnected 
                            ? HomePage.modeColors[1].withAlpha(80)
                            : HomePage.modeColors[0].withAlpha(80),
                          blurRadius: 15,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Card(
                      elevation: 0,
                      

                      //shadowColor: themeProvider.colorSeed.withAlpha(50); // this is glow
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      color: themeProvider.lightened(Theme.of(context).scaffoldBackgroundColor, lightenAmount ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(
                              isBtConnected ? 'Connected' : 'Disconnected',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Helmet',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 16),
                            _ValueRow(
                              label: 'Expression',
                              value: themeProvider.appTheme.label,
                            ),
                            const SizedBox(height: 8),
                            _ValueRow(
                              label: 'Fan Mode',
                              value: themeProvider.themeMode.toString().split('.')[1],
                            ),
                            const SizedBox(height: 8),
                            _ValueRow(
                              label: 'Audio Passthrough',
                              value: themeProvider.useGradientColors
                                  ? 'Enabled'
                                  : 'Disabled',
                            ),
                            const SizedBox(height:8),
                            Row(
                              children: [
                                const Text('Debug Bluetooth Disc/Con'),
                                Switch(
                                  value: isBtConnected,
                                  onChanged: (val) {btService.updateConnectionStatus(val);},
                                ),
                              ],
                            ),
                          ],
                        ),
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

class _NameRow extends StatefulWidget {
  final String label;
  final MainAxisAlignment alignment;

  const _NameRow({required this.label, required this.alignment});

  @override
  State<_NameRow> createState() => _NameRowState();
}

class _NameRowState extends State<_NameRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: widget.alignment,
      children: [
        Text(
          widget.label,
        ),
      ],
    );
  }
}

class _ValueRow extends StatefulWidget {
  final String label;
  final String? value;

  const _ValueRow({
    required this.label,
    this.value,
  });

  @override
  State<_ValueRow> createState() => _ValueRowState();
}

class _ValueRowState extends State<_ValueRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        if (widget.value != null)
          Text(
            widget.value!,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
      ],
    );
  }
}
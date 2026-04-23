import 'package:flutter/material.dart';
import '../bt_handler.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:async';
import '../providers/theme_provider.dart';
import '../themes/app_themes.dart';
import 'package:provider/provider.dart';
import 'settings_page.dart';
import 'devicesettings_page.dart';

class DevicePage extends StatefulWidget {
  const DevicePage({super.key});

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  bool automaticFanControl = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    double lightenAmount = isDark ? 0.08 : -0.08;
    return Scaffold(
      appBar: AppBar(
        title: Text('Helmet'), // Change to dynamic to get name from BT
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const DevicesettingsPage(),
              ),
            ),
          ),
        ],
        
      ),
      body: Consumer2<ThemeProvider, BtService>(
        builder: (context, themeProvider, btService, _) {
          final isBtConnected = btService.isBtConnected;
          
          
          return ListView(
            padding: const EdgeInsetsDirectional.only(top: 0, start: 10, end: 10, bottom: 10),
            children: [
              Icon(
                Icons.person,
                size: 100,
              ),
              const SizedBox(height: 0), // probably remove this later
              Row( // Battery levels row
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // L hand battery
                  CircleAvatar(
                    radius: 12,
                    child: Text(
                      "L",
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(width:7),
                  isBtConnected ?
                  RotatedBox(
                    quarterTurns: 1, child: Transform.scale(
                      scale: 1.25, child: Icon(Icons.battery_full_rounded),
                    ),
                  ) : Icon(Icons.link_off_rounded, color: Colors.grey),
                  //
                  SizedBox(width: 40),
                  // Main battery
                  CircleAvatar(
                    radius: 12,
                    child: Icon(Icons.cruelty_free_rounded)
                  ),
                  const SizedBox(width:7),
                  isBtConnected ?
                  RotatedBox(
                    quarterTurns: 1, child: Transform.scale(
                      scale: 1.25, child: Icon(Icons.battery_full_rounded),
                    ),
                  ) : Icon(Icons.link_off_rounded, color: Colors.grey),
                  //
                  SizedBox(width: 40,),
                  // R hand battery
                  CircleAvatar(
                    radius: 12,
                    child: Text(
                      "R",
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(width:7),
                  isBtConnected ?
                  RotatedBox(
                    quarterTurns: 1, child: Transform.scale(
                      scale: 1.25, child: Icon(Icons.battery_full_rounded),
                    ),
                  ) : Icon(Icons.link_off_rounded, color: Colors.grey),
                  
                ],
                
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: themeProvider.lightened(Theme.of(context).scaffoldBackgroundColor, lightenAmount ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 3 buttons filling width
                    Row(
                      children: [
                        Expanded(child: ElevatedButton(
                          onPressed: automaticFanControl ? null : () {}, child: const Text('A'))),
                        const SizedBox(width: 16),
                        Expanded(child: ElevatedButton(
                          onPressed: automaticFanControl ? null : () {}, child: const Text('B'))),
                        const SizedBox(width: 16),
                        Expanded(child: ElevatedButton(
                          onPressed: automaticFanControl ? null : () {}, child: const Text('C'))),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Toggle + text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Builder(
                          builder: (context) {
                            return GestureDetector(
                              onTapDown: (details) {
                                final overlay =
                                    Overlay.of(context).context.findRenderObject() as RenderBox;

                                showMenu(
                                  context: context,
                                  position: RelativeRect.fromRect(
                                    Rect.fromPoints(
                                      details.globalPosition,
                                      details.globalPosition,
                                    ),
                                    Offset.zero & overlay.size,
                                  ),
                                  items: const [
                                    PopupMenuItem(
                                      enabled: false,
                                      child: Text(
                                        'Automatically adjusts fan speed and active fans based on temperature, humidity and/or CO2 levels. This feature may be unstable.', 
                                      ),
                                    ),
                                  ],
                                );
                              },
                              child: const Text('Automatic fan control'),
                            );
                          },
                        ),
                        Switch(
                          value: automaticFanControl,
                          onChanged: (val) {
                            setState(() {
                              automaticFanControl = val;
                            });
                          },
                        ),
                      ],
                    )
                    
                  ],
                ),
              ),
              const SizedBox(height:20),
              Row(
              
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {}, child: Text('PLACEHOLDER'), style: ElevatedButton.styleFrom(
                        minimumSize: const Size(100, 80), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                      )
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {}, child: Text('PLACEHOLDER'), style: ElevatedButton.styleFrom(
                        minimumSize: const Size(100, 80), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                      )
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
              
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {}, child: Text('PLACEHOLDER'), style: ElevatedButton.styleFrom(
                        minimumSize: const Size(100, 80), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                      )
                    ),
                  ),
                  
                  
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {}, child: Text('PLACEHOLDER'), style: ElevatedButton.styleFrom(
                        minimumSize: const Size(100, 80), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                      )
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

            ],
          );
        },
      ),
    );
  }
}
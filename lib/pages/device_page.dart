import 'package:flutter/material.dart';
import '../bt_handler.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:async';
import '../providers/theme_provider.dart';
import '../themes/app_themes.dart';

class DevicePage extends StatefulWidget {
  const DevicePage({super.key});

  @override 
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  StreamSubscription? _btConnectionSub;
  bool isBtConnected = false;

  @override
  void initState() {
    super.initState();
    final btService = BtService();
    _btConnectionSub = btService.device?.connectionState.listen((state) {
      setState(() {
        isBtConnected = state == BluetoothConnectionState.connected;
      });
    });
  }

  @override
  void dispose() {
    _btConnectionSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    double lightenAmount = isDark ? 0.08 : -0.08;
    return Scaffold(
      appBar: AppBar(
        title: Text('Helmet'), // Change to dynamic to get name from BT
        
      ),
      body: ListView(
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
              ) : Icon(Icons.link_off_rounded, color: Colors.white.withAlpha(75)),
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
              ) : Icon(Icons.link_off_rounded, color: Colors.white.withAlpha(75)),
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
              ) : Icon(Icons.link_off_rounded, color: Colors.white.withAlpha(75)),
              
            ],
            
          ),
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: ThemeProvider().lightened(Theme.of(context).scaffoldBackgroundColor, lightenAmount ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 3 buttons filling width
                Row(
                  children: [
                    Expanded(child: ElevatedButton(
                      onPressed: () {}, child: const Text('A'), style: ElevatedButton.styleFrom(
                        backgroundColor: ))),
                    const SizedBox(width: 16),
                    Expanded(child: ElevatedButton(
                      onPressed: () {}, child: const Text('B'))),
                    const SizedBox(width: 16),
                    Expanded(child: ElevatedButton(
                      onPressed: () {}, child: const Text('C'))),
                  ],
                ),

                const SizedBox(height: 16),

                // Toggle + text
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Enable setting'),
                    Switch(
                      value: true,
                      onChanged: (_) {},
                    ),
                  ],
                ),
              ],
            ),
          )

        ],
      ),
    );
  }
}
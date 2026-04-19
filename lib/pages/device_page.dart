import 'package:flutter/material.dart';
import '../bt_handler.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:async';

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
    return Scaffold();
  }
}
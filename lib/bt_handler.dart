import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BtService {
  static final BtService _instance = BtService._internal();
  factory BtService() => _instance;
  BtService._internal();
  

  BluetoothDevice? device;
  BluetoothCharacteristic? txCharacteristic;
  BluetoothCharacteristic? rxCharacteristic;

  StreamSubscription<List<int>>? _rxSubscription;

  final StreamController<List<int>> _dataStreamController = StreamController.broadcast();
  Stream<List<int>> get dataStream => _dataStreamController.stream;

  static const String serviceUUID = "0000FFE0-0000-1000-8000-00805F9B34FB";
  static const String characteristicUfluttUID = "0000FFE1-0000-1000-8000-00805F9B34FB";

  Future<void> connect(BluetoothDevice device) async {}
  Future<void> disconnect() async {}
  Future<void> tx(List<int> data) async {}

  void dispose() {
    _rxSubscription?.cancel();
    _dataStreamController.close();
  }

}
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BtService extends ChangeNotifier {
  static final BtService _instance = BtService._internal();
  factory BtService() => _instance;
  BtService._internal();

  bool _isBtConnected = false;
  bool get isBtConnected => _isBtConnected;
  
  BluetoothDevice? device;
  BluetoothCharacteristic? txCharacteristic;
  BluetoothCharacteristic? rxCharacteristic;
  
  StreamSubscription<List<int>>? _rxSubscription;
  StreamSubscription<BluetoothConnectionState>? _connectionSubscription;
  
  final StreamController<List<int>> _dataStreamController = StreamController.broadcast();
  Stream<List<int>> get dataStream => _dataStreamController.stream;

  static const String serviceUUID = "0000FFE0-0000-1000-8000-00805F9B34FB";
  static const String characteristicUUID = "0000FFE1-0000-1000-8000-00805F9B34FB";

  StreamSubscription<List<ScanResult>>? _scanSubscription;

  bool _isScanning = false;
  bool get isScanning => _isScanning;

  void updateConnectionStatus(bool connected) {
    _isBtConnected = connected;
    notifyListeners();
  }

  Future<void> connect(BluetoothDevice newDevice) async {
    try {
      device = newDevice;
      
      await device!.connect(license: License.free);
      
      _connectionSubscription = device!.connectionState.listen((state) {
        updateConnectionStatus(state == BluetoothConnectionState.connected);
      });
      
      final services = await device!.discoverServices();
      for (var service in services) {
        if (service.uuid.toString().toUpperCase() == serviceUUID) {
          for (var characteristic in service.characteristics) {
            if (characteristic.uuid.toString().toUpperCase() == characteristicUUID) {
              txCharacteristic = characteristic;
              rxCharacteristic = characteristic;
              
              await rxCharacteristic!.setNotifyValue(true);
              
              _rxSubscription = rxCharacteristic!.lastValueStream.listen((data) {
                _handleIncomingData(data);
              });
              
              break;
            }
          }
        }
      }
      
      updateConnectionStatus(true);
    } catch (e) {
      debugPrint('Connection error: $e');
      updateConnectionStatus(false);
    }
  }
  
  Future<void> disconnect() async {
    try {
      await _rxSubscription?.cancel();
      await _connectionSubscription?.cancel();
      await device?.disconnect();
      updateConnectionStatus(false);
    } catch (e) {
      debugPrint('Disconnect error: $e');
    }
  }
  
  void _handleIncomingData(List<int> data) {
    if (data.length >= 2) {
      final target = data[0];
      final value = data[1];
      
      debugPrint('Received - Target: $target, Value: $value');
      
      _dataStreamController.add(data);
      notifyListeners();
    }
  }
  
  Future<void> sendPacket({required int target, required int value}) async {
    if (txCharacteristic == null || !_isBtConnected) {
      debugPrint('Not connected');
      return;
    }
    
    try {
      final packet = [target, value];
      await txCharacteristic!.write(packet, withoutResponse: true);
      debugPrint('Sent - Target: $target, Value: $value');
    } catch (e) {
      debugPrint('Send error: $e');
    }
  }
  
  Future<void> tx(List<int> data) async {
    if (txCharacteristic == null || !_isBtConnected) {
      debugPrint('Not connected');
      return;
    }
    
    try {
      await txCharacteristic!.write(data, withoutResponse: true);
    } catch (e) {
      debugPrint('TX error: $e');
    }
  }

  Future<void> scanAndConnectHM10({String targetName = "HMSoft"}) async {
    if (_isScanning) return;

    final adapterState = await FlutterBluePlus.adapterState.first;
    if (adapterState != BluetoothAdapterState.on) {
      debugPrint("Bluetooth is OFF");
      return;
    }

    _isScanning = true;
    notifyListeners();

    try {
      if (FlutterBluePlus.isScanningNow) {
        await FlutterBluePlus.stopScan();
      }

      _scanSubscription = FlutterBluePlus.scanResults.listen((results) async {
        for (var r in results) {
          final name = r.device.platformName;

          if (name == targetName) {
            await FlutterBluePlus.stopScan();
            await _scanSubscription?.cancel();

            _isScanning = false;
            notifyListeners();

            await connect(r.device);
            return;
          }
        }
      });

      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 5),
      );
    } catch (e) {
      debugPrint("Scan error: $e");
      _isScanning = false;
      notifyListeners();
    }
  }

  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
    await _scanSubscription?.cancel();

    _isScanning = false;
    notifyListeners();
  }
  
  @override
  void dispose() {
    _rxSubscription?.cancel();
    _connectionSubscription?.cancel();
    _dataStreamController.close();
    super.dispose();
  }
}
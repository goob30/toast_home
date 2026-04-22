import 'package:flutter/material.dart';

class SafetyinfoPage extends StatelessWidget {
  const SafetyinfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Safety Info'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: const Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Do not rely solely on this app or sensor data as safety measures. Sensor information may drift or be delayed.\n\n'
            'If the readings indicate unsafe conditions, or if you feel unwell '
            '(lightheaded, dizzy, tired), take off the helmet immediately and air it out for a few minutes.',
          ),
        ),
      ),
    );
  }
}
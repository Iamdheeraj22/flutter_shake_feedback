import 'package:flutter/material.dart';
import 'package:flutter_shake_feedback/flutter_shake_feedback.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ShakeFeedbackDemo(),
    );
  }
}

class ShakeFeedbackDemo extends StatefulWidget {
  const ShakeFeedbackDemo({super.key});

  @override
  State<ShakeFeedbackDemo> createState() => _ShakeFeedbackDemoState();
}

class _ShakeFeedbackDemoState extends State<ShakeFeedbackDemo> {
  ShakeSensitivity _sensitivity = ShakeSensitivity.medium;
  bool _enabled = true;
  int _shakeCount = 0;
  
  void _onShake() {
    setState(() {
      _shakeCount++;
    });
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Feedback',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text('You shook the device! What would you like to report?'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ShakeFeedback(
      sensitivity: _sensitivity,
      enabled: _enabled,
      onShake: _onShake,
      child: Scaffold(
        appBar: AppBar(title: const Text('Shake Feedback Demo')),
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              'Shake Count: $_shakeCount',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            const Text('Settings', style: TextStyle(fontSize: 18)),
            SwitchListTile(
              title: const Text('Enable Shake Detection'),
              value: _enabled,
              onChanged: (val) {
                setState(() => _enabled = val);
              },
            ),
            ListTile(
              title: const Text('Sensitivity'),
              trailing: DropdownButton<ShakeSensitivity>(
                value: _sensitivity,
                items: ShakeSensitivity.values.map((s) {
                  return DropdownMenuItem(
                    value: s,
                    child: Text(s.name.toUpperCase()),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _sensitivity = val);
                  }
                },
              ),
            ),
            const SizedBox(height: 32),
            const Text('Live Accelerometer Data', style: TextStyle(fontSize: 18)),
            StreamBuilder<UserAccelerometerEvent>(
              stream: userAccelerometerEventStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Text('Waiting for data...');
                final data = snapshot.data!;
                return Text(
                  'X: ${data.x.toStringAsFixed(2)}\nY: ${data.y.toStringAsFixed(2)}\nZ: ${data.z.toStringAsFixed(2)}',
                  style: const TextStyle(fontFamily: 'monospace'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

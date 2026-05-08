import 'dart:async';
import 'dart:math';

import 'package:flutter_shake_feedback/src/domain/repositories/shake_repository.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// A concrete implementation of [ShakeRepository] that utilizes the `sensors_plus`
/// package to monitor raw accelerometer events.
///
/// This repository implements a robust, sequence-based multi-shake detection algorithm.
/// It tracks a series of rapid movements that surpass a certain acceleration threshold.
/// It filters out false positives by enforcing a slop time between movements, ensuring
/// consecutive deliberate shakes, and dropping counts if the movement stops for too long.
class ShakeRepositoryImpl implements ShakeRepository {
  final _shakeController = StreamController<void>.broadcast();
  StreamSubscription<UserAccelerometerEvent>? _sensorSubscription;

  @override
  Stream<void> get onShake => _shakeController.stream;

  // Configuration
  double _shakeThresholdAcceleration = 40.0; // m/s^2 (approx 1.5g)
  final int _shakeSlopTimeMS = 500;
  final int _shakeCountResetTimeMS = 3000;
  final int _shakeMinimumCount = 4; // Need 2 rapid movements

  int _shakeTimestamp = 0;
  int _shakeCount = 0;

  bool _isListening = false;
  bool _isPaused = false;

  DateTime? _lastShakeTriggerTime;
  Duration _cooldown = const Duration(seconds: 3);

  @override
  void setSensitivity({required double threshold}) {
    _shakeThresholdAcceleration = threshold;
  }
  
  @override
  void setCooldown(Duration cooldown) {
    _cooldown = cooldown;
  }

  @override
  void startListening() {
    if (_isListening) return;
    _isListening = true;
    _isPaused = false;
    _sensorSubscription = userAccelerometerEventStream(
      samplingPeriod: SensorInterval.uiInterval,
    ).listen((UserAccelerometerEvent event) {
      if (_isPaused) return;

      double x = event.x;
      double y = event.y;
      double z = event.z;

      // magnitude is in m/s^2
      double magnitude = sqrt(x * x + y * y + z * z);

      if (magnitude > _shakeThresholdAcceleration) {
        final now = DateTime.now().millisecondsSinceEpoch;

        if (_shakeTimestamp + _shakeSlopTimeMS > now) {
          return; // Ignore close shakes
        }

        if (_shakeTimestamp + _shakeCountResetTimeMS < now) {
          _shakeCount = 0;
        }

        _shakeTimestamp = now;
        _shakeCount++;

        if (_shakeCount >= _shakeMinimumCount) {
          _triggerShake();
        }
      }
    });
  }

  @override
  void pauseListening() {
    _isPaused = true;
  }

  @override
  void resumeListening() {
    if (_isListening) {
      _isPaused = false;
      _shakeCount = 0;
    } else {
      startListening();
    }
  }

  @override
  void stopListening() {
    _sensorSubscription?.cancel();
    _sensorSubscription = null;
    _isListening = false;
    _isPaused = false;
  }

  void _triggerShake() {
    final now = DateTime.now();
    if (_lastShakeTriggerTime == null ||
        now.difference(_lastShakeTriggerTime!) > _cooldown) {
      _lastShakeTriggerTime = now;
      _shakeCount = 0;
      _shakeController.add(null);
    }
  }

  @override
  void dispose() {
    _shakeController.close();
    stopListening();
  }
}

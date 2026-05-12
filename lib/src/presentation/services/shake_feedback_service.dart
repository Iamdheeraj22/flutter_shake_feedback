import 'dart:async';
import 'package:flutter_shake_feedback/src/core/constants/shake_constants.dart';
import 'package:flutter_shake_feedback/src/domain/repositories/shake_repository.dart';

/// Manages the state and configuration of the shake detection system.
/// 
/// The `ShakeFeedbackService` delegates actual sensor tracking, math calculations,
/// and cooldown evaluations to the [ShakeRepository]. It acts primarily as a bridge
/// that synchronizes UI configurations (like threshold and cooldown) down to the 
/// repository, and triggers the [onShakeDetected] callback.
class ShakeFeedbackService {
  final ShakeRepository _shakeRepository;
  
  StreamSubscription? _shakeSubscription;
  
  ShakeSensitivity _sensitivity;
  Duration _cooldown;
  bool _enabled;
  
  final void Function() onShakeDetected;

  ShakeFeedbackService({
    required ShakeRepository shakeRepository,
    required this.onShakeDetected,
    ShakeSensitivity sensitivity = ShakeSensitivity.medium,
    Duration cooldown = const Duration(seconds: 2),
    bool enabled = true,
  })  : _shakeRepository = shakeRepository,
        _sensitivity = sensitivity,
        _cooldown = cooldown,
        _enabled = enabled {
    
    _updateRepositoryConfig();

    _shakeSubscription = _shakeRepository.onShake.listen((_) {
      onShakeDetected();
    });

    if (_enabled) {
      _shakeRepository.startListening();
    }
  }

  void _updateRepositoryConfig() {
    final threshold = ShakeConstants.getThreshold(_sensitivity);
    _shakeRepository.setSensitivity(threshold: threshold);
    _shakeRepository.setCooldown(_cooldown);
  }

  void updateConfiguration({
    ShakeSensitivity? sensitivity,
    Duration? cooldown,
    bool? enabled,
  }) {
    if (sensitivity != null) _sensitivity = sensitivity;
    if (cooldown != null) _cooldown = cooldown;
    
    _updateRepositoryConfig();

    if (enabled != null) {
      if (_enabled != enabled) {
        _enabled = enabled;
        if (_enabled) {
          _shakeRepository.startListening();
        } else {
          _shakeRepository.stopListening();
        }
      }
    }
  }

  void dispose() {
    _shakeSubscription?.cancel();
    _shakeRepository.dispose();
  }
}

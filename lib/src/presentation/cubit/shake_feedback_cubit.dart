import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shake_feedback/src/core/constants/shake_constants.dart';
import 'package:flutter_shake_feedback/src/domain/repositories/shake_repository.dart';
import 'package:flutter_shake_feedback/src/presentation/cubit/shake_feedback_state.dart';

/// Manages the state of the shake detection system within the presentation layer.
/// 
/// The `ShakeFeedbackCubit` delegates all actual sensor tracking, math calculations,
/// and cooldown evaluations to the [ShakeRepository]. It acts primarily as a bridge
/// that synchronizes UI configurations (like threshold and cooldown) down to the 
/// repository, and maps the successful `onShake` stream events up to the UI as
/// distinct [ShakeFeedbackState] instances.
class ShakeFeedbackCubit extends Cubit<ShakeFeedbackState> {
  final ShakeRepository _shakeRepository;
  
  StreamSubscription? _shakeSubscription;
  
  ShakeSensitivity _sensitivity;
  Duration _cooldown;
  bool _enabled;

  ShakeFeedbackCubit({
    required ShakeRepository shakeRepository,
    ShakeSensitivity sensitivity = ShakeSensitivity.medium,
    Duration cooldown = const Duration(seconds: 2),
    bool enabled = true,
  })  : _shakeRepository = shakeRepository,
        _sensitivity = sensitivity,
        _cooldown = cooldown,
        _enabled = enabled,
        super(ShakeInitial()) {
    
    _updateRepositoryConfig();

    _shakeSubscription = _shakeRepository.onShake.listen((_) {
      emit(ShakeDetected());
      Future.microtask(() {
        if (!isClosed) emit(ShakeListening());
      });
    });

    if (_enabled) {
      _shakeRepository.startListening();
      emit(ShakeListening());
    } else {
      emit(ShakeDisabled());
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
          emit(ShakeListening());
        } else {
          _shakeRepository.stopListening();
          emit(ShakeDisabled());
        }
      }
    }
  }

  @override
  Future<void> close() {
    _shakeSubscription?.cancel();
    _shakeRepository.dispose();
    return super.close();
  }
}

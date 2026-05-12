import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shake_feedback/src/core/constants/shake_constants.dart';
import 'package:flutter_shake_feedback/src/data/repositories/shake_repository_impl.dart';
import 'package:flutter_shake_feedback/src/presentation/services/shake_feedback_service.dart';

/// A widget that detects device shake gestures and triggers a callback.
///
/// This widget initializes the [ShakeFeedbackService] and listens for accelerometer
/// events. When a shake is detected based on the configured [sensitivity],
/// it executes the [onShake] callback.
///
/// Example usage:
/// ```dart
/// ShakeFeedback(
///   onShake: () {
///     print("Shake detected!");
///   },
///   child: const MyApp(),
/// )
/// ```
class ShakeFeedback extends StatefulWidget {
  /// The widget below this widget in the tree.
  ///
  /// Typically, you would wrap your entire `MaterialApp` or specific
  /// screen scaffolds with this widget to enable shake detection globally or locally.
  final Widget child;

  /// The callback that is executed when a shake gesture is detected.
  ///
  /// This will not be called again until the [cooldown] period has passed
  /// since the last triggered shake.
  final VoidCallback onShake;

  /// The sensitivity level required to trigger a shake event.
  ///
  /// Use lower sensitivity for easier detection, and higher sensitivity
  /// for harder shakes. Defaults to [ShakeSensitivity.medium].
  final ShakeSensitivity sensitivity;

  /// The duration to wait before allowing another shake event to trigger.
  ///
  /// This prevents multiple events from firing consecutively during a single
  /// extended physical shake. Defaults to 2 seconds.
  final Duration cooldown;

  /// Whether to trigger a haptic feedback vibration when a shake is detected.
  ///
  /// Defaults to true. Note that haptics require device hardware support.
  final bool enableHaptic;

  /// Whether the shake detection is currently active.
  ///
  /// When false, the accelerometer stream is paused to save battery, and
  /// [onShake] will not be called. Defaults to true.
  final bool enabled;

  /// Creates a [ShakeFeedback] widget.
  ///
  /// The [child] and [onShake] arguments are required.
  const ShakeFeedback({
    super.key,
    required this.child,
    required this.onShake,
    this.sensitivity = ShakeSensitivity.medium,
    this.cooldown = const Duration(seconds: 2),
    this.enableHaptic = true,
    this.enabled = true,
  });

  @override
  State<ShakeFeedback> createState() => _ShakeFeedbackState();
}

class _ShakeFeedbackState extends State<ShakeFeedback> {
  late final ShakeFeedbackService _shakeFeedbackService;

  @override
  void initState() {
    super.initState();
    _shakeFeedbackService = ShakeFeedbackService(
      shakeRepository: ShakeRepositoryImpl(),
      sensitivity: widget.sensitivity,
      cooldown: widget.cooldown,
      enabled: widget.enabled,
      onShakeDetected: _handleShake,
    );
  }

  void _handleShake() {
    if (widget.enableHaptic) {
      HapticFeedback.vibrate();
    }
    widget.onShake();
  }

  /// Called whenever the widget configuration changes.
  ///
  /// Updates the underlying [ShakeFeedbackService] if the [sensitivity],
  /// [cooldown], or [enabled] properties are modified.
  @override
  void didUpdateWidget(covariant ShakeFeedback oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sensitivity != widget.sensitivity ||
        oldWidget.cooldown != widget.cooldown ||
        oldWidget.enabled != widget.enabled) {
      _shakeFeedbackService.updateConfiguration(
        sensitivity: widget.sensitivity,
        cooldown: widget.cooldown,
        enabled: widget.enabled,
      );
    }
  }

  @override
  void dispose() {
    _shakeFeedbackService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

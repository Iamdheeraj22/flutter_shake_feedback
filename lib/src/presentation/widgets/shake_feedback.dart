import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shake_feedback/src/core/constants/shake_constants.dart';
import 'package:flutter_shake_feedback/src/data/repositories/shake_repository_impl.dart';

import 'package:flutter_shake_feedback/src/presentation/cubit/shake_feedback_cubit.dart';
import 'package:flutter_shake_feedback/src/presentation/cubit/shake_feedback_state.dart';

/// A widget that detects device shake gestures and triggers a callback.
///
/// This widget wraps its [child] in a `BlocProvider` and listens for accelerometer
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
class ShakeFeedback extends StatelessWidget {
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

  /// Builds the widget tree by providing the [ShakeFeedbackCubit] to its descendants.
  ///
  /// Initializes the cubit with the provided use cases and data sources,
  /// and wraps the child with `_ShakeFeedbackListener` to handle state emissions.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShakeFeedbackCubit(
        shakeRepository: ShakeRepositoryImpl(),
        sensitivity: sensitivity,
        cooldown: cooldown,
        enabled: enabled,
      ),
      child: _ShakeFeedbackListener(
        onShake: onShake,
        enableHaptic: enableHaptic,
        sensitivity: sensitivity,
        cooldown: cooldown,
        enabled: enabled,
        child: child,
      ),
    );
  }
}

/// An internal widget that listens to the [ShakeFeedbackCubit] and triggers
/// the [onShake] callback when the [ShakeDetected] state is emitted.
class _ShakeFeedbackListener extends StatefulWidget {
  final Widget child;
  final VoidCallback onShake;
  final bool enableHaptic;
  final ShakeSensitivity sensitivity;
  final Duration cooldown;
  final bool enabled;

  const _ShakeFeedbackListener({
    required this.child,
    required this.onShake,
    required this.enableHaptic,
    required this.sensitivity,
    required this.cooldown,
    required this.enabled,
  });

  @override
  State<_ShakeFeedbackListener> createState() => _ShakeFeedbackListenerState();
}

class _ShakeFeedbackListenerState extends State<_ShakeFeedbackListener> {
  /// Called whenever the widget configuration changes.
  ///
  /// Updates the underlying [ShakeFeedbackCubit] if the [sensitivity],
  /// [cooldown], or [enabled] properties are modified, allowing dynamic
  /// configuration changes without rebuilding the cubit state entirely.
  @override
  void didUpdateWidget(covariant _ShakeFeedbackListener oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sensitivity != widget.sensitivity ||
        oldWidget.cooldown != widget.cooldown ||
        oldWidget.enabled != widget.enabled) {
      context.read<ShakeFeedbackCubit>().updateConfiguration(
            sensitivity: widget.sensitivity,
            cooldown: widget.cooldown,
            enabled: widget.enabled,
          );
    }
  }

  /// Builds the [BlocListener] that responds to state changes from the Cubit.
  ///
  /// Triggers [HapticFeedback.vibrate] (if enabled) and calls the [onShake]
  /// callback whenever the [ShakeDetected] state is emitted by the cubit.
  @override
  Widget build(BuildContext context) {
    return BlocListener<ShakeFeedbackCubit, ShakeFeedbackState>(
      listener: (context, state) {
        if (state is ShakeDetected) {
          if (widget.enableHaptic) {
            HapticFeedback.vibrate();
          }
          widget.onShake();
        }
      },
      child: widget.child,
    );
  }
}

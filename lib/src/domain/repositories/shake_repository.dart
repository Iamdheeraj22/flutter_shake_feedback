

/// Defines the contract for a repository that listens to accelerometer events
/// and triggers callbacks when a distinct physical shake of the device is detected.
abstract class ShakeRepository {
  /// A stream that emits a `void` event every time a valid shake sequence is detected
  /// and the cooldown period has elapsed.
  Stream<void> get onShake;

  /// Updates the acceleration magnitude required to register a single shake movement.
  /// 
  /// The [threshold] is measured in m/s^2. Higher values require a stronger physical force.
  void setSensitivity({required double threshold});

  /// Updates the duration that must pass between consecutive successful shake detections.
  /// 
  /// This prevents a single prolonged shake from triggering multiple events rapidly.
  void setCooldown(Duration cooldown);

  /// Subscribes to the device's accelerometer sensor and begins monitoring for shakes.
  /// 
  /// If the repository is already listening, this method does nothing.
  void startListening();

  /// Temporarily pauses the evaluation of accelerometer events without closing the stream.
  void pauseListening();

  /// Resumes the evaluation of accelerometer events if paused. 
  /// 
  /// If the repository wasn't listening, it calls [startListening].
  void resumeListening();

  /// Cancels the accelerometer subscription and stops all processing.
  void stopListening();

  /// Cleans up resources, including closing the [onShake] stream controller
  /// and cancelling any active sensor subscriptions.
  void dispose();
}

/// Defines the available sensitivity levels for detecting a physical device shake.
///
/// These values correlate to the minimum G-force acceleration magnitude
/// required to trigger a shake event.
enum ShakeSensitivity {
  /// Requires the least amount of force to trigger a shake.
  low,
  /// A balanced sensitivity suitable for typical user interactions.
  medium,
  /// Requires a very strong and deliberate physical shake to trigger.
  high,
}

/// A utility class storing predefined acceleration thresholds for each [ShakeSensitivity].
class ShakeConstants {
  static const double lowThreshold = 6.5;
  static const double mediumThreshold = 4.0;
  static const double highThreshold = 2.8;

  static double getThreshold(ShakeSensitivity sensitivity) {
    switch (sensitivity) {
      case ShakeSensitivity.low:
        return lowThreshold;
      case ShakeSensitivity.medium:
        return mediumThreshold;
      case ShakeSensitivity.high:
        return highThreshold;
    }
  }
}

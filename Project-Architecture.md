# Flutter Shake Feedback

A production-ready Flutter package for detecting device shake gestures and triggering customizable feedback actions.

---

# Package Information

| Property | Value |
|---|---|
| Package Name | flutter_shake_feedback |
| Architecture | Clean Architecture |
| State Management | Bloc/Cubit |
| Platform Support | Android, iOS |
| Flutter SDK | >=3.22.0 |
| Dart SDK | >=3.0.0 |

---

# Vision

The purpose of this package is to provide a lightweight, scalable, and developer-friendly solution for detecting device shake gestures and performing customizable actions such as:

- Feedback Bottom Sheet
- App Rating Prompt
- Bug Reporting
- Debug Menu
- Custom Event Trigger
- Haptic Feedback
- Analytics Events

---

# Core Features (MVP)

## Shake Detection
Detect device shake gestures using accelerometer sensors.

---

## Sensitivity Levels
Support multiple sensitivity configurations.

```dart
enum ShakeSensitivity {
  low,
  medium,
  high,
}
```

---

## Cooldown Support
Prevent multiple shake triggers continuously.

```dart
cooldown: Duration(seconds: 2)
```

---

## Haptic Feedback
Optional vibration feedback on successful shake detection.

---

## Enable/Disable Support
Dynamically enable or disable shake listening.

---

## Callback Support
Execute custom actions when a shake is detected.

```dart
onShake: () {}
```

---

# Recommended Public API

```dart
ShakeFeedback(
  sensitivity: ShakeSensitivity.medium,
  cooldown: Duration(seconds: 2),
  enableHaptic: true,
  enabled: true,
  onShake: () {},
  child: child,
)
```

---

# Clean Architecture

The package should follow Clean Architecture principles to ensure:

- Scalability
- Maintainability
- Testability
- Separation of Concerns

---

# Architecture Layers

```txt
Presentation Layer
      ↓
Domain Layer
      ↓
Data Layer
```

---

# Folder Structure

```txt
lib/
│
├── flutter_shake_feedback.dart
│
├── src/
│   │
│   ├── core/
│   │   ├── constants/
│   │   ├── extensions/
│   │   ├── helpers/
│   │   ├── services/
│   │   └── utils/
│   │
│   ├── data/
│   │   ├── datasources/
│   │   ├── models/
│   │   ├── repositories/
│   │   └── services/
│   │
│   ├── domain/
│   │   ├── entities/
│   │   ├── repositories/
│   │   └── usecases/
│   │
│   ├── presentation/
│   │   ├── cubit/
│   │   │   ├── shake_feedback_cubit.dart
│   │   │   ├── shake_feedback_state.dart
│   │   │   └── shake_feedback_listener.dart
│   │   │
│   │   ├── widgets/
│   │   │   ├── shake_feedback.dart
│   │   │   ├── shake_feedback_builder.dart
│   │   │   └── shake_feedback_provider.dart
│   │   │
│   │   └── controllers/
│   │
│   └── generated/
│
├── example/
│
├── test/
│   ├── data/
│   ├── domain/
│   ├── presentation/
│   └── widget_test/
│
└── pubspec.yaml
```

---

# State Management (Cubit)

The package should use Cubit because:

- lightweight
- scalable
- reactive
- easy testing
- better stream handling

---

# Cubit Responsibilities

## ShakeFeedbackCubit

Responsible for:

- Listening accelerometer stream
- Detecting shake state
- Managing cooldown
- Managing enable/disable state
- Triggering feedback events

---

# Cubit States

```dart
sealed class ShakeFeedbackState {}

final class ShakeInitial extends ShakeFeedbackState {}

final class ShakeListening extends ShakeFeedbackState {}

final class ShakeDetected extends ShakeFeedbackState {}

final class ShakeDisabled extends ShakeFeedbackState {}

final class ShakeCooldown extends ShakeFeedbackState {}
```

---

# Domain Layer

The domain layer contains:

- Entities
- Repository contracts
- Use cases

This layer must not depend on Flutter.

---

# Entity Example

```dart
class ShakeEventEntity {
  final double acceleration;
  final DateTime detectedAt;

  const ShakeEventEntity({
    required this.acceleration,
    required this.detectedAt,
  });
}
```

---

# Use Cases

## DetectShakeUseCase
Responsible for processing accelerometer values.

---

## ValidateCooldownUseCase
Checks whether cooldown duration has completed.

---

## TriggerHapticUseCase
Triggers vibration feedback.

---

# Data Layer

The data layer handles:

- Sensor stream handling
- Accelerometer processing
- Repository implementations

---

# Sensor Service

Recommended package:

```yaml
sensors_plus:
```

---

# Shake Detection Logic

## Formula

```txt
acceleration = sqrt(x² + y² + z²)
```

---

# Shake Detection Flow

```txt
Accelerometer Event
        ↓
Filter Gravity Noise
        ↓
Calculate Delta
        ↓
Compare Threshold
        ↓
Validate Cooldown
        ↓
Emit ShakeDetected State
        ↓
Trigger Callback
```

---

# Recommended Sensitivity Thresholds

| Sensitivity | Threshold |
|---|---|
| Low | 3.5 |
| Medium | 2.7 |
| High | 1.8 |

---

# Widget Responsibilities

## ShakeFeedback

Main wrapper widget.

Responsible for:

- Providing Cubit
- Listening shake states
- Triggering callbacks
- Wrapping child widget tree

---

# Example Usage

```dart
ShakeFeedback(
  sensitivity: ShakeSensitivity.medium,
  cooldown: Duration(seconds: 2),
  enableHaptic: true,
  enabled: true,
  onShake: () {
    debugPrint("Shake detected");
  },
  child: MaterialApp(
    home: HomeScreen(),
  ),
)
```

---

# Performance Optimizations

## Important Rules

- Avoid unnecessary widget rebuilds
- Use internal stream subscriptions
- Dispose listeners properly
- Pause sensors in background
- Use lightweight calculations only

---

# Error Handling

The package should handle:

- Unsupported sensors
- Stream interruptions
- Permission issues
- Multiple listener prevention

---

# Unit Testing

Unit tests are mandatory.

---

# Test Coverage

## Data Layer
- Accelerometer parsing
- Threshold calculation
- Cooldown validation

---

## Domain Layer
- Use cases
- Repository contracts

---

## Presentation Layer
- Cubit states
- Widget behavior
- Shake detection flow

---

# Widget Tests

Test cases:

- Shake callback execution
- Cooldown prevention
- Enable/disable state
- Haptic trigger
- Sensitivity behavior

---

# Example Application

The example app should contain:

- Sensitivity Selector
- Enable/Disable Toggle
- Shake Counter
- Live Accelerometer Values
- Feedback Bottom Sheet Demo
- Cooldown Visualizer

---

# Documentation Plan

## README Sections

- Overview
- Features
- Installation
- Quick Start
- Advanced Usage
- Sensitivity Levels
- Cooldown Behavior
- Example GIFs
- API Reference
- Performance Notes

---

# Roadmap
## v1.0.0

### Core Features
- Shake Detection
- Sensitivity Levels
- Cooldown Support
- Callback Support
- Haptic Feedback

---

### UI Features
- Default Feedback Bottom Sheet
- Custom Builder Support
- Debug Overlay

---

### Advanced Features
- Screenshot Capture
- Bug Reporting
- Share Logs

---

### Production Features
- Stable Release
- Full Documentation
- Production Optimizations
- Example Showcase
- CI/CD Integration
- Unit & Widget Testing
- Pub.dev Optimization


---

# Recommended Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter

  flutter_bloc:
  equatable:
  sensors_plus:
```

---

# Recommended Dev Dependencies

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter

  bloc_test:
  mocktail:
  flutter_lints:
```

---

# CI/CD Recommendation

Use GitHub Actions for:

- Static Analysis
- Unit Testing
- Format Checking
- Pub Score Validation

---

# Publishing Checklist

- Complete README
- Example Application
- Unit Tests
- API Documentation
- Changelog
- License
- GIF Demo
- Pub.dev Score Optimization

---

# Final Goal

Build a lightweight, scalable, production-ready Flutter package that becomes the standard shake detection and feedback solution for Flutter developers.
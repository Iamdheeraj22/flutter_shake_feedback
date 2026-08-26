# Flutter Shake Feedback

A highly robust, sequence-based shake detection package for Flutter, built using strict Clean Architecture. This package allows you to easily wrap your application or specific screens to detect when a user physically shakes their device, triggering feedback prompts, bug reporters, or hidden developer menus without false positives.

## Features

- **Advanced Sequence Detection:** Ignores single accidental bumps. A valid shake requires a sequence of rapid, deliberate movements before triggering.
- **Configurable Sensitivity:** Choose from `low`, `medium`, or `high` sensitivity to match your target audience or physical device types.
- **Configurable Cooldowns:** Built-in cooldown timers prevent users from spamming the shake trigger.
- **Clean Architecture:** Implemented using isolated Data, Domain, and Presentation layers, making it highly testable and extensible.

## Getting started

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_shake_feedback: ^1.0.3
```

## Usage

Simply wrap the part of your application that you want to be "shake-aware" using the `ShakeFeedback` widget.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_shake_feedback/flutter_shake_feedback.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ShakeFeedback(
        // The sensitivity of the physical shake required
        sensitivity: ShakeSensitivity.medium,
        
        // How long to wait before allowing another shake to be registered
        cooldown: const Duration(seconds: 3),
        
        // The callback triggered when a valid multi-shake is detected
        onShake: () {
          // e.g., show a feedback bottom sheet or a bug report dialog
          showDialog(
            context: context,
            builder: (context) => const AlertDialog(
              title: Text('Shake Detected!'),
              content: Text('Would you like to send feedback?'),
            ),
          );
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('Shake Demo')),
          body: const Center(
            child: Text('Shake your phone to trigger the event!'),
          ),
        ),
      ),
    );
  }
}
```

## How to Contribute

We welcome community contributions! If you'd like to help improve the package, please follow these steps:

1. **Fork the Repository:** Create your own fork of the project.
2. **Create a Branch:** Create a feature branch (`git checkout -b feature/my-new-feature`).
3. **Follow the Architecture:** Ensure any new code adheres to the existing Clean Architecture patterns (Data, Domain, Presentation).
4. **Write Tests:** Add unit tests for any new features or logic changes. We strictly require high test coverage.
5. **Run the Analyzer:** Ensure your code passes all linting rules by running `flutter analyze`.
6. **Submit a Pull Request:** Open a PR against the `main` branch with a clear description of your changes.

If you encounter any bugs or have feature requests, please file an issue on the repository's issue tracker!

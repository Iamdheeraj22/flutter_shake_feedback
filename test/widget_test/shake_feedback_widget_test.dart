import 'package:flutter/material.dart';
import 'package:flutter_shake_feedback/flutter_shake_feedback.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ShakeFeedback widget renders child properly', (WidgetTester tester) async {
    bool didShake = false;

    await tester.pumpWidget(
      MaterialApp(
        home: ShakeFeedback(
          onShake: () {
            didShake = true;
          },
          child: const Text('Shake Me'),
        ),
      ),
    );

    expect(find.text('Shake Me'), findsOneWidget);
    expect(didShake, isFalse);
  });
}

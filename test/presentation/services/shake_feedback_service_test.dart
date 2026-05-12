import 'dart:async';
import 'package:flutter_shake_feedback/src/core/constants/shake_constants.dart';
import 'package:flutter_shake_feedback/src/domain/repositories/shake_repository.dart';
import 'package:flutter_shake_feedback/src/presentation/services/shake_feedback_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockShakeRepository extends Mock implements ShakeRepository {}

void main() {
  late MockShakeRepository mockShakeRepository;
  late StreamController<void> shakeController;

  setUpAll(() {
    registerFallbackValue(ShakeSensitivity.medium);
    registerFallbackValue(Duration.zero);
  });

  setUp(() {
    mockShakeRepository = MockShakeRepository();
    shakeController = StreamController<void>.broadcast();

    when(() => mockShakeRepository.onShake)
        .thenAnswer((_) => shakeController.stream);
    when(() => mockShakeRepository.setSensitivity(threshold: any(named: 'threshold'))).thenReturn(null);
    when(() => mockShakeRepository.setCooldown(any())).thenReturn(null);
    when(() => mockShakeRepository.startListening()).thenReturn(null);
    when(() => mockShakeRepository.stopListening()).thenReturn(null);
    when(() => mockShakeRepository.dispose()).thenReturn(null);
  });

  tearDown(() {
    shakeController.close();
  });

  test('calls onShakeDetected when repository emits a shake', () async {
    bool didShake = false;
    final service = ShakeFeedbackService(
      shakeRepository: mockShakeRepository,
      onShakeDetected: () {
        didShake = true;
      },
    );

    await Future.delayed(const Duration(milliseconds: 100)); // allow subscription
    shakeController.add(null); // emit a shake
    await Future.delayed(Duration.zero); // allow event loop to process

    expect(didShake, isTrue);
    service.dispose();
  });

  test('does not start listening when initialized with enabled=false', () {
    final service = ShakeFeedbackService(
      shakeRepository: mockShakeRepository,
      enabled: false,
      onShakeDetected: () {},
    );

    verifyNever(() => mockShakeRepository.startListening());
    service.dispose();
  });
  
  test('starts listening when initialized with enabled=true', () {
    final service = ShakeFeedbackService(
      shakeRepository: mockShakeRepository,
      enabled: true,
      onShakeDetected: () {},
    );

    verify(() => mockShakeRepository.startListening()).called(1);
    service.dispose();
  });
}

import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_shake_feedback/src/core/constants/shake_constants.dart';
import 'package:flutter_shake_feedback/src/domain/repositories/shake_repository.dart';
import 'package:flutter_shake_feedback/src/presentation/cubit/shake_feedback_cubit.dart';
import 'package:flutter_shake_feedback/src/presentation/cubit/shake_feedback_state.dart';
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

  blocTest<ShakeFeedbackCubit, ShakeFeedbackState>(
    'emits [ShakeDetected, ShakeListening] when repository emits a shake',
    build: () {
      return ShakeFeedbackCubit(
        shakeRepository: mockShakeRepository,
      );
    },
    act: (cubit) async {
      await Future.delayed(const Duration(milliseconds: 100)); // allow subscription
      shakeController.add(null); // emit a shake
    },
    expect: () => [
      isA<ShakeDetected>(),
      isA<ShakeListening>(),
    ],
  );

  test('initial state is ShakeDisabled when initialized with enabled=false', () {
    final cubit = ShakeFeedbackCubit(
      shakeRepository: mockShakeRepository,
      enabled: false,
    );
    expect(cubit.state, isA<ShakeDisabled>());
  });
}

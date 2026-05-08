import 'package:flutter_shake_feedback/src/data/repositories/shake_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ShakeRepositoryImpl initializes correctly', () {
    final repository = ShakeRepositoryImpl();
    expect(repository.onShake, isA<Stream<void>>());
    repository.dispose();
  });
}

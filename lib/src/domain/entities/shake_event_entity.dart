class ShakeEventEntity {
  final double acceleration;
  final DateTime detectedAt;

  const ShakeEventEntity({
    required this.acceleration,
    required this.detectedAt,
  });
}

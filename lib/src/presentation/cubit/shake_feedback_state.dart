import 'package:equatable/equatable.dart';

/// The base class for all states managed by the ShakeFeedbackCubit.
sealed class ShakeFeedbackState extends Equatable {
  const ShakeFeedbackState();

  @override
  List<Object?> get props => [];
}

/// The initial state when the cubit is created but hasn't started monitoring.
final class ShakeInitial extends ShakeFeedbackState {}

/// The state emitted when the feedback system is actively listening for shake events.
final class ShakeListening extends ShakeFeedbackState {}

/// The state emitted immediately when a valid physical shake sequence is detected.
final class ShakeDetected extends ShakeFeedbackState {}

/// The state emitted when the shake feedback system is explicitly disabled or stopped.
final class ShakeDisabled extends ShakeFeedbackState {}

/// The state emitted when a shake was recently detected and the system is currently
/// in its cooldown phase, ignoring new interactions.
final class ShakeCooldown extends ShakeFeedbackState {}

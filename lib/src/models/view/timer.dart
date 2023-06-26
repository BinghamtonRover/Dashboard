import "package:flutter/foundation.dart";

/// Contains the duration of a current mission
class MissionTimer with ChangeNotifier{
  /// Name of the mission 
  final String name;

  /// The time which the timer should end
  final DateTime end;

  /// Whether or not to decrement timer
  /// Used for pausing and resuming timer
  bool paused = false;

  /// Time remaining while timer is running
  Duration get timeLeft => end.difference(DateTime.now());

  /// Formatted string of [timeLeft]
  String get timeLeftFormatted => timeLeft.toString().split(".").first.padLeft(8, "0");

  /// See if less than a minute remains on timer
  bool get underMin => timeLeft < const Duration(minutes: 1);

  /// Time remaining on timer when paused
  Duration? remainingTime;

  /// Creates a Timer to display
  MissionTimer({
    required this.name,
    required Duration duration,
  }) : end = DateTime.now().add(duration);
}

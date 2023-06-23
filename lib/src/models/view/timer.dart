import "package:flutter/foundation.dart";

/// Contains the duration of a current mission
class MissionTimer with ChangeNotifier{
  /// Name of the mission 
  final String name;

  /// The current duration of a mission
  Duration duration;
  
  /// The time which the timer should end
  late DateTime end;

  /// Whether or not to decrement timer
  /// Used for pausing and resuming timer
  bool paused = false;

  /// Time remaining while timer is running
  Duration get timeLeft => end.difference(DateTime.now());

  /// Time remaining on timer when paused
  Duration? remainingTime;

  /// Creates a Timer to display
  MissionTimer({
    required this.name,
    required this.duration,
  }){
    end = DateTime.now().add(duration);
  }
}

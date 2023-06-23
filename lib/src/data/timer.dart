
/// Contains the duration of a current mission
class MissionTimer {
  /// Name of the mission 
  final String name;

  /// The current duration of a mission
  int duration;
  
  /// The time which the timer should end
  late DateTime end;

  /// Time 
  Duration get timeLeft => end.difference(DateTime.now());

  /// Creates a Timer to display
  MissionTimer({
    required this.name,
    required this.duration,
  }){
    end = DateTime.now().add(Duration(minutes: duration));
  }
}

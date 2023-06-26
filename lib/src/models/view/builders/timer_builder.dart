import "package:rover_dashboard/models.dart";

/// A [ValueBuilder] to modify a [MissionTimer]
class TimerBuilder extends ValueBuilder<MissionTimer> {
  /// Name of timer
  String name = "";
  
  /// Number of minutes
  NumberBuilder<int> duration = NumberBuilder<int>(0);

  @override
	bool get isValid => duration.isValid && name.isNotEmpty;

  @override
	MissionTimer get value => MissionTimer(
    name: name,
    duration: Duration(minutes: duration.value),
  );

  /// Starts the timer
  bool startTimer(){
    models.home.startTimer(value);
    return true;
  }
}

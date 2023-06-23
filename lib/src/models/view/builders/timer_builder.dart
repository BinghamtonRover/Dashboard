import "package:rover_dashboard/data.dart";
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

  /// Updates Timer Name based on user input
  void setName(String input){
    name = input;
  }

  /// Updates Timer duration based on input
  void setTime(String input){
    duration = NumberBuilder<int>(int.parse(input)); // Can always garuntee this is a int because of regex
  }

  /// Starts the timer
  bool startTimer(){
    models.home.startTimer(timer: value);
    return true;
  }
}

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// A [ValueBuilder] to modify a [MissionTimer]
class TimerBuilder extends ValueBuilder<MissionTimer> {
  /// Name of mission
  String name = "";
  
  /// Number of minutes
  final duration = NumberBuilder<int>(0);

  @override
	bool get isValid => duration.isValid && name.isNotEmpty;

  @override
	MissionTimer get value => MissionTimer(
    name: name,
    duration: Duration(minutes: duration.value),
  );

  /// Updates text based on user input
  void update(String text){
    name = text;
    notifyListeners();
  }
}

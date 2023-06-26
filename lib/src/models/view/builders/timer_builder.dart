import "package:rover_dashboard/models.dart";

/// Starts a [MissionTimer] based on user input.
class TimerBuilder extends ValueBuilder<void> {
  /// Name of timer
  String name = "";
  
  /// Number of minutes
  NumberBuilder<int> duration = NumberBuilder<int>(0);

  @override
  bool get isValid => name.isNotEmpty && duration.value > 0;

  @override
  void get value { /* Use [start] instead */ }

  @override
  List<NumberBuilder> get otherBuilders => [duration];

  /// Sets the name of the timer and updates the UI.
  void setName(String input) {
    name = input;
    notifyListeners();
  }

  /// Starts the timer
  void start() {
    models.home.mission.start(title: name, duration: Duration(minutes: duration.value));
  }
}

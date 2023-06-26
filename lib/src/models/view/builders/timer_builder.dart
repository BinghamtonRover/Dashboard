import "package:flutter/foundation.dart";
import "package:rover_dashboard/models.dart";

/// A [ValueBuilder] to modify a [MissionTimer]
class TimerBuilder with ChangeNotifier {
  /// Name of timer
  String name = "";
  
  /// Number of minutes
  NumberBuilder<int> duration = NumberBuilder<int>(0);

  /// Starts the timer
  bool startTimer() {
    models.home.mission.start(title: name, duration: Duration(minutes: duration.value));
    return true;
  }
}

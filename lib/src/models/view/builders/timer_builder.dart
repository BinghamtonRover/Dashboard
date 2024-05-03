import "package:flutter/material.dart";
import "package:rover_dashboard/models.dart";

/// Starts a [MissionTimer] based on user input.
class TimerBuilder extends ValueBuilder<void> {
  /// The text controller for the timer name.
  final nameController = TextEditingController();
  
  /// Number of minutes
  NumberBuilder<int> duration = NumberBuilder<int>(0);

  @override
  bool get isValid => nameController.text.isNotEmpty && duration.value > 0;

  @override
  void get value { /* Use [start] instead */ }

  @override
  List<NumberBuilder> get otherBuilders => [duration];

  /// Updates the UI.
  void update(_) => notifyListeners();

  /// Starts the timer
  void start() {
    models.home.mission.start(title: nameController.text, duration: Duration(minutes: duration.value));
  }
}

import "dart:async";
import "package:flutter/foundation.dart";

/// A timer to keep track of progress in a mission. 
/// 
/// Control using [start], [pause], [resume], and [cancel].
class MissionTimer with ChangeNotifier {
  /// The title for this timer. Null means no timer has been set. 
  String? title;
  /// The time remaining. Stops decreasing when [isPaused] is true.
  Duration timeLeft = Duration.zero;
  /// Whether this timer is paused.
  bool isPaused = false;
  /// Runs every second to deduct one second from [timeLeft].
  Timer? _timer;

  /// Whether this timer has under a minute remaining.
  bool get underMin => timeLeft <= const Duration(minutes: 1);

  /// Updates the [timeLeft] field and cancels and checks if the timer has finished.
  void _update(_) {
    timeLeft -= const Duration(seconds: 1);
    if (timeLeft == Duration.zero) cancel();
    notifyListeners();
  }

  /// Starts a new timer with the given title and duration. Cancels any previous timer.
  void start({required String title, required Duration duration}) {
    cancel();
    isPaused = false;
    this.title = title;
    timeLeft = duration;
    _timer = Timer.periodic(const Duration(seconds: 1), _update);
    notifyListeners();
  }

  /// Pauses the timer.
  void pause() { 
    isPaused = true; 
    _timer?.cancel(); 
    notifyListeners();
  }

  /// Resumes the timer.
  void resume() { 
    isPaused = false; 
    _timer = Timer.periodic(const Duration(seconds: 1), _update); 
  }

  /// Cancels the timer.
  void cancel() { 
    title = null; 
    _timer?.cancel(); 
    notifyListeners(); 
  }
}

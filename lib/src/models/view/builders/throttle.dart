import "package:flutter/foundation.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// A view model to allow the user to edit a throttle value and send it to the rover.
class ThrottleBuilder with ChangeNotifier {
  /// A [NumberBuilder] to modify the throttle value.
  final controller = NumberBuilder<double>(0, min: 0, max: 1);
  
  /// Whether the throttle is valid. 
  bool get isValid => controller.isValid;
  /// Whether the throttle command is still sending.
  bool isLoading = false;
  /// The error with the throttle, if any. 
  String? errorText;

  /// Saves the throttle to the rover. Does not perform a handshake.
  Future<void> save() async {
    isLoading = true;
    notifyListeners();
    final throttle = controller.value;
    final command = DriveCommand(setThrottle: true, throttle: throttle);
    models.messages.sendMessage(command);
    await Future<void>.delayed(const Duration(milliseconds: 200));
    isLoading = false;
    notifyListeners();
  }
}

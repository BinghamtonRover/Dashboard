import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// A view model to modify a color and send it to the rover.
class ColorBuilder with ChangeNotifier {
  /// The color being chosen.
  ProtoColor color = ProtoColor.BLUE;

  /// Whether the LED strip should blink this color.
  bool blink = false;

	/// Sets [color] to the rover's current color.
  ColorBuilder();

	/// Whether [setColor] is still running.
	bool isLoading = false;
	/// The error when calling [setColor], if any.
	String? errorText;

  /// Updates the color being chosen.
  void updateColor(Set<ProtoColor>? value) {
    if (value == null) return;
    color = value.first;
    notifyListeners();
  }

  /// Updates [blink].
  // ignore: avoid_positional_boolean_parameters
  void updateBlink(bool? value) {
    if (value == null) return;
    blink = value;
    notifyListeners();
  }

  /// Sends the color to the rover.
	Future<bool> setColor() async {
		isLoading = true;
		notifyListeners();
		final result = await models.rover.settings.setColor(color, blink: blink);
		errorText = result ? null : "The rover did not accept this command";
		isLoading = false;
		notifyListeners();
		return result;
	}
}

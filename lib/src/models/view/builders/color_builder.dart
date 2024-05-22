import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// A view model to modify a color and send it to the rover.
class ColorBuilder with ChangeNotifier {
  ProtoColor color = ProtoColor.BLUE;

	/// Sets [color] to the rover's current color.
  ColorBuilder();

	/// Whether [setColor] is still running.
	bool isLoading = false;
	/// The error when calling [setColor], if any.
	String? errorText;

  void updateColor(Set<ProtoColor>? value) {
    if (value == null) return;
    color = value.first;
    notifyListeners();
  }

	Future<bool> setColor() async {
		isLoading = true;
		notifyListeners();
		final result = await models.rover.settings.setColor(color);
		errorText = result ? null : "The rover did not accept this command";
		isLoading = false;
		notifyListeners();
		return result;
	}
}

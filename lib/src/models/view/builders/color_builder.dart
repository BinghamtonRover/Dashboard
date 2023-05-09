import "dart:ui" show Color;

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// A view model to modify a color and send it to the rover.
class ColorBuilder extends ValueBuilder<Color> {
	/// The red channel.
	final red = NumberBuilder<int>(0);
	/// The green channel.
	final green = NumberBuilder<int>(0);
	/// The blue channel.
	final blue = NumberBuilder<int>(0);

	/// Creates a view model to modify a color.
	ColorBuilder() {
		red.addListener(notifyListeners);
		green.addListener(notifyListeners);
		blue.addListener(notifyListeners);
	}

	@override
	Color get value => Color.fromARGB(255, red.value, green.value, blue.value);

	@override
	bool get isValid => red.isValid && green.isValid && blue.isValid;

	/// Whether [setColor] is still running.
	bool isLoading = false;
	/// The error when calling [setColor], if any.
	String? errorText;

	/// Sets the LED strip on the rover to the color in [value].
	Future<bool> setColor() async {
		isLoading = true;
		notifyListeners();
		final color = ProtoColor().fromColor(value);
		// Specifically not awaited since the rover isn't reporting this back
		await models.rover.settings.setColor(color);
		isLoading = false;
		notifyListeners();
		return true;
	}
}

import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// The leftmost color on the spectrum.
HSVColor minColor = HSVColor.fromColor(Colors.redAccent[700]!);
/// The rightmost color on the spectrum.
HSVColor maxColor = HSVColor.fromColor(Colors.pink);

/// Utilities for color data.
extension ColorUtils on ProtoColor {
	/// Creates a new [ProtoColor] from a Flutter [Color].
	ProtoColor fromColor(Color other) => ProtoColor(
		red: other.red / 255,
		green: other.green / 255,
		blue: other.blue / 255,
	);

	/// Converts this message to a Flutter [Color].
	Color toColor() => Color.fromARGB(
		255, (red*255).toInt(), (green*255).toInt(), (blue*255).toInt(),
	);
}

/// A view model to modify a color and send it to the rover.
class ColorBuilder extends ValueBuilder<Color> {
	/// The color to show in the UI.
	Color color;

	/// The value of the color slider in the UI.
	/// 
	/// This will not match [color] on startup but that's okay.
	double slider = 0;

	/// Sets [color] to the rover's current color.
	ColorBuilder() : color = models.rover.settings.settings.color.toColor(); 

	@override
	Color get value => color;

	@override
	bool get isValid => true;

	/// Updates [color] based on the slider [value].
	void updateSlider(double value) { 
		color = HSVColor.lerp(minColor, maxColor, value)!.toColor();
		slider = value;
		notifyListeners(); 
	}

	/// Whether [setColor] is still running.
	bool isLoading = false;
	/// The error when calling [setColor], if any.
	String? errorText;

	/// Sets the LED strip on the rover to the color in [value].
	Future<bool> setColor() async {
		isLoading = true;
		notifyListeners();
		final color = ProtoColor().fromColor(value);
		final result = await models.rover.settings.setColor(color);
		errorText = result ? null : "The rover did not accept this command";
		isLoading = false;
		notifyListeners();
		return result;
	}
}

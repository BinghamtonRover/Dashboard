import "dart:io";
import "package:flutter/material.dart";

/// A view model to modify a value.
/// 
/// The value being modified is saved in [value], which must be a valid [T]. The UI, however, may
/// contain invalid data inputted by the user. Use [isValid] to see if [value] matches the UI.
abstract class ValueBuilder<T> with ChangeNotifier {
	/// The value being updated in the UI.
	T get value;

	/// Whether the [value] in the UI is valid.
	/// 
	/// Do not try to access [value] if this is false.
	bool get isValid;
}

/// A [ValueBuilder] backed by a Flutter [TextField].
abstract class TextBuilder<T> extends ValueBuilder<T> {
	@override
	T value;

	/// The controller for the [TextField]. 
	/// 
	/// This allows the text field to be prefilled with a value.
	final TextEditingController controller;

	/// Creates a view model to update settings.
	/// 
	/// If [text] is not null, it will be used instead of [value] to prefill the [controller].
	TextBuilder(this.value, {String? text}) : 
		controller = TextEditingController(text: text ?? value.toString());

	/// The error to display in the UI, if any.
	String? error;

	@override
	bool get isValid => error == null;

	/// Updates the [value] based on the user's input.
	/// 
	/// Perform validation here and set [error] accordingly. You do not have to set [value] in this
	/// function -- for example, if the user entered an invalid input.
	void update(String input);
}

/// A specialized [TextBuilder] to handle numeric inputs.
/// 
/// [T] can be either [int] or [double], and the UI will validate that.
class NumberBuilder<T extends num> extends TextBuilder<T> {
	/// Whether this builder is modifying a decimal number.
	bool get isInteger => List<int> == List<T>;

	/// Creates a number builder based on an initial value.
	NumberBuilder(super.value);

	@override
	void update(String input) {
		if (input.isEmpty) {
			error = "Must not be empty";
		} else if (double.tryParse(input) == null) {
			error = "Invalid number";
		} else if (isInteger && int.tryParse(input) == null) {
			error = "Must be an integer";
		} else {
			error = null;
			if (isInteger) {
				value = int.parse(input) as T;
			} else {
				value = double.parse(input) as T;
			}
		}
		notifyListeners();
	}
}

/// A specialized [TextBuilder] to handle IP addresses.
class AddressBuilder extends TextBuilder<InternetAddress> {
	/// A regular expression representing a valid IP address.
	static final regex = RegExp(r"\d{3}\.\d{3}\.\d{1}\.\d{1,3}");

	/// Creates an IP address builder with the given initial value.
	AddressBuilder(InternetAddress value) : 
		super(value, text: value.address.toString());

	@override
	void update(String input) {
		if (input.isEmpty) {
			error = "Must not be blank";
		} else if (regex.stringMatch(input) != input || input.endsWith(".")) {
			error = "Not a valid IP";
		} else if (input.split(".").any((part) => int.parse(part) > 255)) {
			error = "IP out of range";
		} else {
			error = null;
			value = InternetAddress(input);
		}
		notifyListeners();
	}
}

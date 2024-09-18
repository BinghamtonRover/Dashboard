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

	/// Other builders to listen to.
	List<ChangeNotifier> get otherBuilders => [];

	/// Listens to all [otherBuilders] as part of this builder.
	ValueBuilder() {
		for (final builder in otherBuilders) {
			builder.addListener(notifyListeners);
		}
	}

	@override
	void dispose() {
		for (final builder in otherBuilders) {
			builder.removeListener(notifyListeners);
		}
		super.dispose();
	}
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
		controller = TextEditingController(text: text ?? value.toString()), super();

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

	/// The minimum allowed value.
	final num? min;

	/// The maximum allowed value.
	final num? max;

	/// Creates a number builder based on an initial value.
	NumberBuilder(super.value, {this.min, this.max});

	@override
	void update(String input) {
		if (input.isEmpty) {
			error = "Empty";
		} else if (double.tryParse(input) == null) {
			error = "Invalid number";
		} else if (isInteger && int.tryParse(input) == null) {
			error = "Not an integer";
		} else {
			error = null;
			final result = isInteger ? (int.parse(input) as T) : (double.parse(input) as T);
			if (min != null && result < min!) error = "Must be >$min";
			if (max != null && result > max!) error = "Must be <$max";
			value = result;
		}
		notifyListeners();
	}

	/// Clears the value in this builder.
	void clear() {
		error = null;
		value = (isInteger ? 0 : 0.0) as T;
		controller.text = value.toString();
		notifyListeners();
	}
}

/// A specialized [TextBuilder] to handle IP addresses.
class AddressBuilder extends TextBuilder<InternetAddress> {
	/// A regular expression representing a valid IP address.
	static final regex = RegExp(r"\d+\.\d+\.\d+\.\d+");

	/// Creates an IP address builder with the given initial value.
	AddressBuilder(super.value) : super(text: value.address);

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

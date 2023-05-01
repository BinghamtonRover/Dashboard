import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/widgets.dart";

/// Creates a widget to edit a [SocketConfig], backed by [SocketBuilder].
class SocketEditor extends StatelessWidget {
	/// The name of the socket being edited.
	final String name;

	/// The [SocketBuilder] view model behind this widget.
	/// 
	/// Performs validation and tracks the text entered into the fields.
	final SocketBuilder model;

	/// Whether to edit the port as well.
	final bool editPort;

	/// Creates a widget to edit host and port data for a socket.
	const SocketEditor({
		required this.name,
		required this.model, 
		this.editPort = true
	});

	@override
	Widget build(BuildContext context) => ProviderConsumer<SocketBuilder>.value(
		value: model,
		builder: (model) => Row(
			children: [
				const SizedBox(width: 16),
				Expanded(child: Text(name)),
				const Spacer(flex: 2),
				Expanded(child: TextField(
					onChanged: model.address.update,
					controller: model.address.controller,
					decoration: InputDecoration(errorText: model.address.error),
					inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"\d|\."))]
				)),
				const SizedBox(width: 12),
				if (editPort) ...[
					Expanded(child: TextField(
						onChanged: model.port.update,
						controller: model.port.controller,
						decoration: InputDecoration(errorText: model.port.error),
						inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"\d"))],
					)),
				] else const Spacer()
			],
		)
	);
}

/// A widget to edit a number, backed by [NumberBuilder].
class NumberEditor extends StatelessWidget {
	/// The value this number represents.
	final String name;

	/// Shows extra details.
	final String? subtitle;

	/// The view model backing this value.
	final NumberBuilder model;

	/// How much space to allocate in between the label and text field.
	final int spacerFlex;

	/// Creates a widget to modify a number.
	const NumberEditor({
		required this.name, 
		required this.model, 
		this.subtitle,
		this.spacerFlex = 4,
	});

	@override
	Widget build(BuildContext context) => ProviderConsumer<TextBuilder<num>>.value(
		value: model,
		builder: (model) => Row(
			mainAxisAlignment: MainAxisAlignment.spaceBetween,
			children: [
				Expanded(child: subtitle == null ? ListTile(title: Text(name)) : ListTile(
					title: Text(name),
					subtitle: Text(subtitle!),
				)),
				Spacer(flex: spacerFlex),
				Expanded(child: TextField(
					onChanged: model.update,
					decoration: InputDecoration(errorText: model.error),
					controller: model.controller,
					inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"\d|\."))],
				)),
			]
		)
	);
}

/// A widget to choose a single value from a dropdown.
class DropdownEditor<T> extends StatelessWidget {
	/// The name to show when editing these settings.
	final String name;

	/// The chosen value in the dropdown.
	final T value;

	/// A callback for when a new value is selected. Is not called when the user cancels.
	final ValueChanged<T> onChanged;

	/// A list of items to choose from.
	final List<T> items;

	/// Converts a [T] item to a user-friendly string.
	final String Function(T) humanName;

	/// Creates a [DropdownButton] list to choose between items.
	const DropdownEditor({
		required this.name,
		required this.value,
		required this.onChanged,
		required this.items,
		required this.humanName,
	});

	@override
	Widget build(BuildContext context) => ListTile(
		title: Text(name),
		trailing: DropdownButton<T>(
			value: value,
			onChanged: (input) { 
				if (input == null) return;
				onChanged(input);
			},
			items: [
				for (final other in items) DropdownMenuItem<T>(
					value: other,
					child: Text(humanName(other)),
				),
			],
		)
	);
}

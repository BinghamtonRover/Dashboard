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
		builder: (model, _) => Row(
			children: [
				Expanded(child: Text(name)),
				const Spacer(),
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

	/// The view model backing this value.
	final NumberBuilder model;

	/// Creates a widget to modify a number.
	const NumberEditor({required this.name, required this.model});

	@override
	Widget build(BuildContext context) => ProviderConsumer<TextBuilder<num>>.value(
		value: model,
		builder: (model, _) => Row(
			mainAxisAlignment: MainAxisAlignment.spaceBetween,
			children: [
				Expanded(child: Text(name)),
				const Spacer(),
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
	final String name;
	final T value;
	final ValueChanged<T> onChanged;
	final List<T> items;
	final String Function(T) humanName;

	const DropdownEditor({
		required this.name,
		required this.value,
		required this.onChanged,
		required this.items,
		required this.humanName,
	});

	@override
	Widget build(BuildContext context) => Row(
		mainAxisAlignment: MainAxisAlignment.spaceBetween,
		children: [
			Text(name),
			DropdownButton<T>(
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
		]
	);
}

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
		this.editPort = true,
	});

	@override
	Widget build(BuildContext context) => ProviderConsumer<SocketBuilder>.value(
		value: model,
		builder: (model) => Row(
			children: [
				const SizedBox(width: 16),
				Expanded(flex: 5, child: Text(name)),
				const Spacer(),
				Expanded(child: TextField(
					onChanged: model.address.update,
					controller: model.address.controller,
					decoration: InputDecoration(errorText: model.address.error),
					inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"\d|\."))],
				),),
				const SizedBox(width: 12),
				if (editPort) ...[
					Expanded(child: TextField(
						onChanged: model.port.update,
						controller: model.port.controller,
						decoration: InputDecoration(errorText: model.port.error),
						inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"\d"))],
					),),
				] else const Spacer()
			],
		),
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
	final double? width;

	/// The amount of space to allocate to the title.
	final int titleFlex;

	/// Creates a widget to modify a number.
	const NumberEditor({
		required this.name, 
		required this.model, 
		this.subtitle,
		this.titleFlex = 4,
		this.width,
	});

	@override
	Widget build(BuildContext context) => ProviderConsumer<TextBuilder<num>>.value(
		value: model,
		builder: (model) => Row(
			mainAxisSize: MainAxisSize.min,
			children: [
				Expanded(
					flex: titleFlex,
					child: subtitle == null ? ListTile(title: Text(name)) : ListTile(
						title: Text(name),
						subtitle: Text(subtitle!),
					),
				),
				if (width == null) const Spacer()
				else SizedBox(width: width),
				Expanded(child: TextField(
					onChanged: model.update,
					decoration: InputDecoration(errorText: model.error),
					controller: model.controller,
					inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"\d|\.|-"))],
				),),
			],
		),
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
	Widget build(BuildContext context) => Row(
		children: [
			Text(name),
			const SizedBox(width: 12), 
			DropdownButton<T>(
				focusNode: FocusNode(),
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
			),
		],
	);
}

/// A widget to edit a color, backed by [ColorBuilder].
class ColorEditor extends StatelessWidget {
	/// The view model for this color.
	final ColorBuilder model;
	/// A widget that modifies the given view model's color.
	const ColorEditor(this.model);

	@override
	Widget build(BuildContext context) => ProviderConsumer<ColorBuilder>.value(
		value: model,
		builder: (model) => AlertDialog(
			title: const Text("Pick a color"),
			actions: [
				TextButton(child: const Text("Cancel"), onPressed: () => Navigator.of(context).pop()),
				ElevatedButton(
					onPressed: () async {
						final result = await model.setColor();
						if (result && context.mounted) Navigator.of(context).pop();
					},
					child: const Text("Save"), 
				),
			],
			content: Column(
				mainAxisSize: MainAxisSize.min,
				children: [
					Slider(
						value: model.slider, 
						onChanged: model.updateSlider,
						label: "color",
					),
					Container(height: 50, width: double.infinity, color: model.value),
					if (model.isLoading) const Text("Loading..."),
					if (model.errorText != null) Text(model.errorText!, style: const TextStyle(color: Colors.red)),
				],
			),
		),
	);
}

/// A widget to edit a color, backed by [TimerBuilder].
class TimerEditor extends StatelessWidget {
	/// The view model for this color.
	final TimerBuilder model;
	/// A widget that modifies the given view model's color.
	const TimerEditor(this.model);

	@override
	Widget build(BuildContext context) => ProviderConsumer<TimerBuilder>.value(
		value: model,
		builder: (model) => AlertDialog(
			title: const Text("Start a timer"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
				children: [
          SizedBox(
            height: 50, 
            width: double.infinity,
            child: TextField(
              onChanged: model.setName, 
              decoration: const InputDecoration(hintText: "Timer Name"),
            ),
          ),
          SizedBox(
            height: 50, 
            width: double.infinity,
            child: TextField(
              onChanged: model.duration.update,
              decoration: const InputDecoration(hintText: "Number of Minutes"),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"\d"))],
            ),
          ),
        ],
      ),
			actions: [
				TextButton(child: const Text("Cancel"), onPressed: () => Navigator.of(context).pop()),
				ElevatedButton(
					onPressed: model.isValid ? () { model.start(); Navigator.of(context).pop(); } : null,
					child: const Text("Save"), 
				),
			],
		),
	);
}

/// A widget to edit a GPS coordinate in degree/minute/seconds or decimal format.
class GpsEditor extends StatelessWidget {
	/// The [ValueBuilder] backing this widget.
	final GpsBuilder model;
	/// Listens to [model] to rebuild the UI.
	const GpsEditor({required this.model});

	@override
	Widget build(BuildContext context) => ProviderConsumer<GpsBuilder>.value(
		value: model,
		builder: (model) => Row(children: [
			DropdownEditor(
				name: "Type", 
				value: model.type,
				onChanged: model.updateType,
				items: GpsType.values,
				humanName: (type) => type.humanName,
			),
			const SizedBox(width: 12),
			switch (model.type) {
				GpsType.degrees => Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
					Row(children: [  // Longitude
						const Text("Longitude:"),
						SizedBox(width: 200, child: NumberEditor(name: "Degrees", width: 12, titleFlex: 1, model: model.longDegrees)),
						SizedBox(width: 200, child: NumberEditor(name: "Minutes", width: 12, titleFlex: 1, model: model.longMinutes)),
						SizedBox(width: 200, child: NumberEditor(name: "Seconds", width: 12, titleFlex: 1, model: model.longSeconds)),
					],),
					Row(children: [  // Latitude
						const Text("Latitude:"),
						SizedBox(width: 200, child: NumberEditor(name: "Degrees", width: 12, titleFlex: 1, model: model.latDegrees)),
						SizedBox(width: 200, child: NumberEditor(name: "Minutes", width: 12, titleFlex: 1, model: model.latMinutes)),
						SizedBox(width: 200, child: NumberEditor(name: "Seconds", width: 12, titleFlex: 1, model: model.latSeconds)),
					],),
				],),
				GpsType.decimal => Row(children: [
					SizedBox(width: 225, child: NumberEditor(name: "Longitude", width: 0, titleFlex: 1, model: model.longDecimal)),
					SizedBox(width: 200, child: NumberEditor(name: "Latitude", width: 0, titleFlex: 1, model: model.latDecimal)),
				],),
			},
		],),
	);
}

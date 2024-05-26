import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/widgets.dart";

/// Creates a widget to edit a [SocketInfo], backed by [SocketBuilder].
class SocketEditor extends ReusableReactiveWidget<SocketBuilder> {
	/// The name of the socket being edited.
	final String name;

	/// Whether to edit the port as well.
	final bool editPort;

	/// Creates a widget to edit host and port data for a socket.
	const SocketEditor({
		required this.name,
		required SocketBuilder model, 
		this.editPort = true,
	}) : super(model);

	@override
	Widget build(BuildContext context, SocketBuilder model) => Row(
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
      ] else const Spacer(),
    ],
	);
}

/// A widget to edit a number, backed by [NumberBuilder].
class NumberEditor extends ReusableReactiveWidget<NumberBuilder> {
	/// The value this number represents.
	final String name;

	/// Shows extra details.
	final String? subtitle;

	/// How much space to allocate in between the label and text field.
	final double? width;

	/// The amount of space to allocate to the title.
	final int titleFlex;

	/// Creates a widget to modify a number.
	const NumberEditor({
    required NumberBuilder model,
		required this.name, 
		this.subtitle,
		this.titleFlex = 4,
		this.width,
	}) : super(model);

	@override
	Widget build(BuildContext context, NumberBuilder model) => Row(
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
class ColorEditor extends ReusableReactiveWidget<ColorBuilder> {
	/// A widget that modifies the given view model's color.
	const ColorEditor(super.model);

	@override
	Widget build(BuildContext context, ColorBuilder model) => AlertDialog(
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
        SegmentedButton(
          style: SegmentedButton.styleFrom(selectedBackgroundColor: Colors.transparent),
          onSelectionChanged: model.updateColor,
          emptySelectionAllowed: true,
          selected: {model.color},
          segments: [
            ButtonSegment(
              value: ProtoColor.RED,
              icon: Container(height: 48, width: 48, margin: const EdgeInsets.all(8), color: Colors.red),
              label: const Text("Red"),
            ),
            ButtonSegment(
              value: ProtoColor.GREEN,
              icon: Container(height: 48, width: 48, margin: const EdgeInsets.all(8), color: Colors.green),
              label: const Text("Green"),
            ),
            ButtonSegment(
              value: ProtoColor.BLUE,
              icon: Container(height: 48, width: 48, margin: const EdgeInsets.all(8), color: Colors.blue),
              label: const Text("Blue"),
            ),
          ],
        ),
        const SizedBox(height: 16),
        CheckboxListTile(
          value: model.blink, 
          onChanged: model.updateBlink,
          title: const Text("Blink"),
        ),
      ],
    ),
	);
}

/// A widget to edit a color, backed by [TimerBuilder].
class TimerEditor extends ReactiveWidget<TimerBuilder> {
  @override
  TimerBuilder createModel() => TimerBuilder();
  
	@override
	Widget build(BuildContext context, TimerBuilder model) => AlertDialog(
    title: const Text("Start a timer"),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 50, 
          width: double.infinity,
          child: TextField(
            controller: model.nameController,
            onChanged: model.update,
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
	);
}

/// A widget to edit a GPS coordinate in degree/minute/seconds or decimal format.
class GpsEditor extends ReusableReactiveWidget<GpsBuilder> {
	/// Listens to [model] to rebuild the UI.
	const GpsEditor(super.model);

	@override
	Widget build(BuildContext context, GpsBuilder model) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      DropdownEditor(
        name: "Type", 
        value: model.type,
        onChanged: model.updateType,
        items: GpsType.values,
        humanName: (type) => type.humanName,
      ),
      const SizedBox(width: 12),
      if (model.type == GpsType.degrees) ...[
        const Text("Longitude:"),
        SizedBox(width: 200, child: NumberEditor(name: "Degrees", width: 12, titleFlex: 1, model: model.longDegrees)),
        SizedBox(width: 200, child: NumberEditor(name: "Minutes", width: 12, titleFlex: 1, model: model.longMinutes)),
        SizedBox(width: 200, child: NumberEditor(name: "Seconds", width: 12, titleFlex: 1, model: model.longSeconds)),
        const Text("Latitude:"),
        SizedBox(width: 200, child: NumberEditor(name: "Degrees", width: 12, titleFlex: 1, model: model.latDegrees)),
        SizedBox(width: 200, child: NumberEditor(name: "Minutes", width: 12, titleFlex: 1, model: model.latMinutes)),
        SizedBox(width: 200, child: NumberEditor(name: "Seconds", width: 12, titleFlex: 1, model: model.latSeconds)),
      ] else ...[
        SizedBox(width: 225, child: NumberEditor(name: "Longitude", width: 0, titleFlex: 1, model: model.longDecimal)),
        SizedBox(width: 200, child: NumberEditor(name: "Latitude", width: 0, titleFlex: 1, model: model.latDecimal)),
      ],
    ],
  );
}

/// An [AlertDialog] to prompt the user for a throttle value and send it to the rover.
class ThrottleEditor extends ReactiveWidget<ThrottleBuilder> {
  @override
  ThrottleBuilder createModel() => ThrottleBuilder();

  @override
  Widget build(BuildContext context, ThrottleBuilder model) => AlertDialog(
    title: const Text("Adjust throttle"),
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        NumberEditor(name: "Throttle", model: model.controller),
        const SizedBox(height: 12),
        if (model.errorText != null) Text(
          model.errorText!,
          style: const TextStyle(color: Colors.red),
        ),
      ],
    ),
    actions: [
      ElevatedButton(
        onPressed: !model.isValid || model.isLoading ? null : () async {
          await model.save(); 
          if (!context.mounted) return;
          Navigator.of(context).pop();
         },
        child: const Text("Save"),
      ),
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text("Cancel"),
      ),
    ],
  ); 
}

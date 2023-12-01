import "package:flutter/material.dart";

/// A widget that listens to a [ChangeNotifier] and rebuilds when the model updates.
abstract class ReactiveWidget<T extends ChangeNotifier> extends StatefulWidget {
  /// Whether the associated model should be disposed after this widget is.
  final bool shouldDispose;
  
	/// A const constructor.
	const ReactiveWidget({this.shouldDispose = true});

	/// A function to create or find the model. This function will only be called once.
	T createModel();

	/// Builds the UI according to the state in [model].
	Widget build(BuildContext context, T model);

	@override
	ReactiveWidgetState createState() => ReactiveWidgetState<T>();
}

/// A state for [ReactiveWidget] that manages the [model].
class ReactiveWidgetState<T extends ChangeNotifier> extends State<ReactiveWidget<T>>{
	/// The model to listen to.
	late final T model;

	@override
	void initState() {
		super.initState();
		model = widget.createModel();
		model.addListener(listener);
	}

	@override
	void dispose() {
		model.removeListener(listener);
    if (widget.shouldDispose) model.dispose();
		super.dispose();
	}

	/// Updates the UI when [model] updates.
	void listener() => setState(() {});

	@override
	Widget build(BuildContext context) => widget.build(context, model);
}

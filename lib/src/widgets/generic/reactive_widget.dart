import "package:flutter/material.dart";

abstract class ReactiveWidgetInterface<T extends ChangeNotifier> extends StatefulWidget {
  const ReactiveWidgetInterface({super.key});
  T createModel();
  bool get shouldDispose;

	@override
	ReactiveWidgetState createState() => ReactiveWidgetState<T>();

  /// Builds the UI according to the state in [model].
	Widget build(BuildContext context, T model);

  @mustCallSuper
  void didUpdateWidget(covariant ReactiveWidgetInterface<T> oldWidget, T model) { }
}

/// A widget that listens to a [ChangeNotifier] and rebuilds when the model updates.
abstract class ReactiveWidget<T extends ChangeNotifier> extends ReactiveWidgetInterface<T> {
	/// A const constructor.
	const ReactiveWidget({super.key});

	/// A function to create or find the model. This function will only be called once.
  @override
	T createModel();

  @override
  bool get shouldDispose => true;
}

abstract class ReusableReactiveWidget<T extends ChangeNotifier> extends ReactiveWidgetInterface<T> {
  final T model;
  const ReusableReactiveWidget(this.model);

  @override
  T createModel() => model;

  @override
  bool get shouldDispose => false;
}

/// A state for [ReactiveWidget] that manages the [model].
class ReactiveWidgetState<T extends ChangeNotifier> extends State<ReactiveWidgetInterface<T>>{
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

  @override
  void didUpdateWidget(covariant ReactiveWidgetInterface<T> oldWidget) {
    widget.didUpdateWidget(oldWidget, model);
    super.didUpdateWidget(oldWidget);
  }

	/// Updates the UI when [model] updates.
	void listener() => setState(() {});

	@override
	Widget build(BuildContext context) => widget.build(context, model);
}

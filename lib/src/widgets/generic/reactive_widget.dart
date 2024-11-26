import "package:flutter/material.dart";

/// A widget that listens to a [ChangeNotifier] (called the view model) and updates when it does.
///
/// - If you're listening to an existing view model, use [ReusableReactiveWidget].
/// - If you're listening to a view model created by this widget, use [ReactiveWidget].
abstract class ReactiveWidgetInterface<T extends ChangeNotifier> extends StatefulWidget {
  /// A const constructor.
  const ReactiveWidgetInterface({super.key});
  /// Creates the view model. This is only called once in the widget's lifetime.
  T createModel();
  /// Whether this widget should dispose the model after it's destroyed.
  ///
  /// Normally, we want the widget to clean up after itself and dispose its view model. But it's
  /// also common for one view model to create and depend on another model. In this case, if we
  /// are listening to the sub-model, we don't want to dispose it while the parent model is still
  /// using it.
  bool get shouldDispose;

	@override
	ReactiveWidgetState createState() => ReactiveWidgetState<T>();

  /// Builds the UI according to the state in [model].
	Widget build(BuildContext context, T model);

  /// This function gives you an opportunity to update the view model when the widget updates.
  ///
  /// For more details, see [State.didUpdateWidget].
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

/// A [ReactiveWidgetInterface] that "borrows" a view model and does not dispose of it.
abstract class ReusableReactiveWidget<T extends ChangeNotifier> extends ReactiveWidgetInterface<T> {
  /// The model to borrow.
  final T model;
  /// A const constructor.
  const ReusableReactiveWidget(this.model);

  @override
  T createModel() => model;

  @override
  bool get shouldDispose => false;
}

/// A state for [ReactiveWidget] that manages the [model].
class ReactiveWidgetState<T extends ChangeNotifier> extends State<ReactiveWidgetInterface<T>>{
	/// The model to listen to.
	late T model;

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
    if (oldWidget is ReusableReactiveWidget<T> && widget is ReusableReactiveWidget<T>) {
      final newModel = (widget as ReusableReactiveWidget<T>).model;
      if (model != newModel) {
        // Stop listening to the old one, listen to the new one.
        // Don't dispose of the old one since it's reusable.
        model.removeListener(listener);
        model = newModel;
        model.addListener(listener);
      }
    }
    super.didUpdateWidget(oldWidget);
  }

	/// Updates the UI when [model] updates.
	void listener() => setState(() {});

	@override
	Widget build(BuildContext context) => widget.build(context, model);
}

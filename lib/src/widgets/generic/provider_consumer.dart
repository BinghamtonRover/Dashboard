import "package:flutter/material.dart";
import "package:provider/provider.dart";

/// A [Provider] and a [Consumer], wrapped in one.
/// 
/// To use, pass in a [create] function to create a new [ChangeNotifier], then pass a [builder] to
/// build the UI based on the data in the model. To not dispose, use the [value] constructror.
class ProviderConsumer<T extends ChangeNotifier> extends StatelessWidget {
	/// The value, if using [ChangeNotifierProvider.value].
	final T? value;

	/// A function to create the [ChangeNotifier]
	final T Function()? create;

	/// A function to build the UI based on the [ChangeNotifier].
	final Widget Function(T) builder;

	/// A widget that rebuilds when the underlying data changes.
	const ProviderConsumer({
		required this.create,
		required this.builder,
	}) : value = null;

	/// Analagous to [Provider.value].
	const ProviderConsumer.value({
		required this.value, 
		required this.builder, 
	}) : create = null;

	Widget get consumer => Consumer<T>(
		builder: (context, model, _) => builder(model)
	);

	@override
	Widget build(BuildContext context) => value == null 
		? ChangeNotifierProvider<T>(create: (_) => create!(), child: consumer)
		: ChangeNotifierProvider<T>.value(value: value!, child: consumer);
}

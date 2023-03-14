import "package:flutter/material.dart";
import "package:provider/provider.dart";

/// A [Provider] and a [Consumer], wrapped in one.
/// 
/// To use, pass in a [create] function to create a new [ChangeNotifier], then pass a [builder] to
/// build the UI based on the data in the model. If you have a widget that does *not* depend on the 
/// underlying data, you can pass it in the [cachedChild] parameter to ensure it is not rebuilt. 
class ProviderConsumer<T extends ChangeNotifier> extends StatelessWidget {
	/// A function to create the [ChangeNotifier].
	final T Function() create;

	/// A function to build the UI based on the [ChangeNotifier].
	final Widget Function(T, Widget) builder;

	/// An optional [Widget] that does not depend on the model.
	/// 
	/// Large widget subtrees that don't depend on the model don't need to be rebuilt when the model
	/// updates. Passing the subtree here will ensure it is only built once. 
	final Widget? cachedChild;

	/// A widget that rebuilds when the underlying data changes.
	const ProviderConsumer({
		required this.create,
		required this.builder,
		this.cachedChild,
	});

	/// Analagous to [Provider.value].
	ProviderConsumer.value({
		required T value, 
		required this.builder, 
		this.cachedChild
	}) : create = (() => value);

	@override
	Widget build(BuildContext context) => ChangeNotifierProvider<T>(
		create: (_) => create(),
		builder: (context, _) => Consumer<T>(
			builder: (context, model, _) => builder(model, cachedChild ?? Container()),
		)
	);
}

import "protobuf.dart";

/// A readout of metrics reported by one of the rover's subsystems. 
/// 
/// To use this class, create a subclass that extends this class with [T] as the generated 
/// Protobuf class. For example, to create metrics for the science subsystem, use:
/// ```dart
/// class ScienceMetrics extends Metrics<ScienceMessage> { }
/// ```
abstract class Metrics<T extends Message> {
	/// The underlying data used to get these metrics.
	final T data;

	/// A const constructor for metrics.
	const Metrics(this.data);

	/// A collective name for this group of metrics (usually the name of the subsystem).
	String get name;

	/// A list of user-friendly explanations for each of the metrics.
	/// 
	/// Be sure to store the actual values as fields. This property should be a list of one 
	/// user-friendly explanation per metric. 
	List<String> get allMetrics;

	/// Updates [data] with new data.
	void update(T newData) => data.mergeFromMessage(newData);
}

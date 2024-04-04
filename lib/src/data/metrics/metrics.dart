import "package:math";

import "package:flutter/foundation.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/services.dart";

class MetricLine {
	final Severity severity;
	final String text;
	MetricLine(this.text, {this.severity = Severity.info});
}

/// A readout of metrics reported by one of the rover's subsystems. 
/// 
/// To use this class, create a subclass that extends this class with [T] as the generated 
/// Protobuf class. For example, to create metrics for the science subsystem, use:
/// ```dart
/// class ScienceMetrics extends Metrics<ScienceMessage> { }
/// ```
abstract class Metrics<T extends Message> with ChangeNotifier {
	/// The underlying data used to get these metrics.
	final T data;

	/// A const constructor for metrics.
	Metrics(this.data);

	/// A collective name for this group of metrics (usually the name of the subsystem).
	String get name;

	/// A list of user-friendly explanations for each of the metrics.
	/// 
	/// Be sure to store the actual values as fields. This property should be a list of one 
	/// user-friendly explanation per metric. 
	List<MetricLine> get allMetrics;

	Severity get overallSeverity {
		final indexes = [for (final metric in allMetrics) metric.severity.index];
		final index = indexes.reduce(max);
		return Severity.values[index];
	}

	/// Updates [data] with new data.
	void update(T value) {
		data.mergeFromMessage(value);
		notifyListeners();
		services.files.logData(value);
	}
}

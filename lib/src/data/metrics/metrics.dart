// import "package:math";

import "dart:math";

import "package:flutter/foundation.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";

/// Class to construct a Metric
class MetricLine {
  /// Severity of the Metric
	final Severity? severity;
  /// Message for the Metric
	final String text;
  /// Constructor for the MetricLine class
	MetricLine(this.text, {this.severity});
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

  /// Fetch the overall Security
	Severity? get overallSeverity {
		final indexes = [for (final metric in allMetrics) metric.severity?.index ?? -1];
		final index = indexes.reduce(max);
    if (index == -1) return null;
		return Severity.values[index];
	}

	/// Updates [data] with new data.
	void update(T value) {
    if (version == null) {
      version = parseVersion(value);
      final major = version!.major;
      final minor = version!.minor;
      if (major == supportedVersion) {
        models.home.setMessage(severity: Severity.info, text: "Connected to $name v$major.$minor");
      } else {
        models.home.setMessage(severity: Severity.critical, text: "Received $name v$major.$minor, expected ^$supportedVersion.0");
        return;
      }
    }
    
		data.mergeFromMessage(value);
		notifyListeners();
		services.files.logData(value);
	}

  /// The version of the data that the firmware sends.
  Version? version;
  /// Parses the version out of a given data packet.
  Version parseVersion(T message);
  /// The currently-supported (major) version for this Dashboard.
  int get supportedVersion;
}

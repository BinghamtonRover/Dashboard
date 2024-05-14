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

  /// Checks this message's version and checks for support.
  bool checkVersion(T data) {
    final newVersion = parseVersion(data);
    if (newVersion.hasMajor()) version = newVersion;
    if (!matchesVersion && newVersion.hasMajor()) {
      models.home.setMessage(severity: Severity.critical, text: "Received $name v${version.format()}, expected ^${supportedVersion.format()}", permanent: true);
    }
    return matchesVersion;
  }

	/// Updates [data] with new data.
	void update(T value) {
    if (!checkVersion(value)) return;    
		services.files.logData(value);
		data.mergeFromMessage(value);
		notifyListeners();
	}

  /// The version of the data that the firmware sends.
  Version version = Version();
  /// Parses the version out of a given data packet.
  Version parseVersion(T message);
  /// The currently-supported version for this Dashboard.
  Version get supportedVersion;
  /// A command to notify the firmware of the Dashboard's [supportedVersion].
  Message get versionCommand;
  /// Whether the Dashboard is certain the firmware matches the right version.
  bool get matchesVersion => supportedVersion.isCompatible(version);
}

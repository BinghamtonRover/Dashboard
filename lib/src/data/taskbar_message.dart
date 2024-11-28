import "package:rover_dashboard/data.dart";

/// A message to show on the taskbar, with an associated severity.
class TaskbarMessage {
	/// The severity of this message.
	final Severity severity;

	/// The text of this message.
	final String text;

	/// Creates a message to show on the taskbar.
	TaskbarMessage({
		required this.severity,
		required this.text,
	});

  /// Returns the severity in the equivalent value for a [BurtLogLevel]
  BurtLogLevel get burtLogLevel => switch (severity) {
    Severity.info => BurtLogLevel.info,
    Severity.warning => BurtLogLevel.warning,
    Severity.error => BurtLogLevel.error,
    Severity.critical => BurtLogLevel.critical,
  };

  /// Returns the message in the form of a [BurtLog]
  BurtLog get burtLog => BurtLog(level: burtLogLevel, title: text, device: Device.DASHBOARD);
}

/// The level of danger a message represents.
enum Severity {
	/// A simple message that doesn't represent an issue.
	info, 

	/// A warning that something may go wrong soon.
	/// 
	/// This could be used to imply possible damage to the rover, possible disconnects, etc.
	warning, 

	/// Some operation did not work and requires manual intervention.
	error,

	/// Something went wrong and data or commands may be lost.
	critical;
}

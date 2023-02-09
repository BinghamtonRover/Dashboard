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

	/// The rover is in a critical state and emergency measaures must be taken.
	critical;
}

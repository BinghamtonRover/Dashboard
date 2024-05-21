import "dart:math";

import "package:protobuf/protobuf.dart";
import "package:rover_dashboard/data.dart";

export "package:protobuf/protobuf.dart" show GeneratedMessageGenericExtensions;

/// A function that decodes a Protobuf messages serialized form.
/// 
/// The `.fromBuffer` constructor is a type of [MessageDecoder]. 
typedef MessageDecoder<T extends Message> = T Function(List<int> data); 

/// A callback to execute with a specific serialized Protobuf message.
typedef MessageHandler<T extends Message> = void Function(T);

/// A callback to handle any [WrappedMessage].
typedef WrappedMessageHandler = void Function(WrappedMessage);

/// A callback to execute with raw Protobuf data.
typedef RawDataHandler = void Function(List<int> data);

/// Gets the name of the command message for the given device.
String getCommandName(Device device) => switch (device) {
	Device.ARM => "ArmCommand",
	Device.GRIPPER => "GripperCommand",
	Device.SCIENCE => "ScienceCommand",
	Device.DRIVE => "DriveCommand",
	_ => "Unknown",
};

/// Gets the name of the data message for the given device.
String getDataName(Device device) => switch (device) {
	Device.ARM => "ArmData",
	Device.GRIPPER => "GripperData",
	Device.SCIENCE => "ScienceData",
	Device.DRIVE => "DriveData",
	_ => "Unknown",
};

/// Utilities for a list of Protobuf enums.
extension UndefinedFilter<T extends ProtobufEnum> on List<T> {
  /// Filters out `_UNDEFINED` values from the list.
  List<T> get filtered => [
    for (final value in this) 
      if (value.value != 0)
        value, 
  ];
}

/// Utilities for [Timestamp]s.
extension TimestampUtils on Timestamp {
	/// The [Timestamp] version of [DateTime.now].
	Timestamp now() => Timestamp.fromDateTime(DateTime.now());

	/// Adds a [Duration] to a [Timestamp].
	Timestamp operator +(Duration duration) => Timestamp.fromDateTime(toDateTime().add(duration));

  /// Subtracts the 
	double operator -(Timestamp other) => (seconds - other.seconds).toDouble();
}

/// Decodes a wrapped Protobuf message. 
extension Unwrapper on WrappedMessage {
	/// Decodes the wrapped message into a message of type [T]. 
	T decode<T extends Message>(MessageDecoder<T> decoder) => decoder(data);
}

/// Gets a user-friendly name for a [RoverStatus].
extension RoverStatusHumanName on RoverStatus {
	/// Gets a user-friendly name for a [RoverStatus].
	String get humanName {
		switch (this) {
			case RoverStatus.DISCONNECTED: return "Disconnected";
			case RoverStatus.IDLE: return "Idle";
			case RoverStatus.MANUAL: return "Manual";
			case RoverStatus.AUTONOMOUS: return "Autonomous";
			case RoverStatus.POWER_OFF: return "Off";
      case RoverStatus.RESTART: return "Restart";
		}
		// Do not use default or else you'll lose exhaustiveness checking.
		throw ArgumentError("Unrecognized rover status: $this");
	}
}

/// Extensions for [Coordinates] messages.
extension CoordinatesUtils on Coordinates {
	/// Adds two coordinates.
	Coordinates operator +(Coordinates other) => 
		Coordinates(x: x + other.x, y: y + other.y, z: z + other.z);

	/// Returns a user-friendly format of these coordinates.
	String get prettyPrint => "(${x.toStringAsFixed(2)}, ${y.toStringAsFixed(2)}, ${z.toStringAsFixed(2)})";
}

/// Extensions for [CameraName] values.
extension CameraNameUtils on CameraName {
	/// Gets a user-friendly name for a [CameraName].
	String get humanName {
		switch(this) {
			case CameraName.CAMERA_NAME_UNDEFINED: return "";
			case CameraName.ROVER_FRONT: return "Rover front";
			case CameraName.ROVER_REAR: return "Rover rear";
			case CameraName.AUTONOMY_DEPTH: return "Depth";
			case CameraName.SUBSYSTEM1: return "Subsystem 1";
			case CameraName.SUBSYSTEM2: return "Subsystem 2";
			case CameraName.SUBSYSTEM3: return "Subsystem 3";
		}
		// Do not use default or else you'll lose exhaustiveness checking.
		throw ArgumentError("Unrecognized camera name: $this");
	}
}

/// Extensions for [VideoData].
extension VideoDataUtils on VideoData {
	/// Whether this data has a frame to show.
	/// 
	/// A Protobuf `bytes` object is never null, only empty.
	bool get hasFrame => frame.isNotEmpty;
}

/// Extensions for [CameraStatus] values.
extension CameraStatusUtils on CameraStatus {
	/// Gets a user-friendly name for a [CameraStatus].
	String get humanName {
		switch(this) {
			case CameraStatus.CAMERA_STATUS_UNDEFINED: return "";
			case CameraStatus.CAMERA_DISCONNECTED: return "Disconnected";
			case CameraStatus.CAMERA_ENABLED: return "Enabled";
			case CameraStatus.CAMERA_DISABLED: return "Disabled";
			case CameraStatus.CAMERA_NOT_RESPONDING: return "Not responding";
			case CameraStatus.CAMERA_LOADING: return "Loading";
			case CameraStatus.FRAME_TOO_LARGE: return "Frame too large";
			case CameraStatus.CAMERA_HAS_NO_NAME: return "Camera has no name";
		}
		// Do not use default or else you'll lose exhaustiveness checking.
		throw ArgumentError("Unrecognized rover status: $this");
	}
}

/// Extensions for [Device] values.
extension DeviceUtils on Device {
	/// Gets a user-friendly name for a [Device].
	String get humanName {
		switch(this) {
			case Device.DEVICE_UNDEFINED: return "Unknown device";
			case Device.DASHBOARD: return "Dashboard";
			case Device.SUBSYSTEMS: return "Subsystems";
			case Device.VIDEO: return "Video";
			case Device.AUTONOMY: return "Autonomy";
			case Device.FIRMWARE: return "Firmware";
			case Device.ARM: return "Arm";
			case Device.GRIPPER: return "Gripper";
			case Device.SCIENCE: return "Science";
			case Device.DRIVE: return "Drive";
		}
		// Do not use default or else you'll lose exhaustiveness checking.
		throw ArgumentError("Unrecognized device: $this");
	}
}

/// Utilities for Gps Coordinates Data
extension GpsUtils on GpsCoordinates {
  /// Calculate Euclidean distance between current coordinates and another set of coordinates.
  /// 
  /// See https://en.wikipedia.org/wiki/Geographic_coordinate_system#Length_of_a_degree
  double distanceTo(GpsCoordinates other) {
  	// Convert to distance in meters and use Pythagorean theorem
  	final latitudeDistance = 111132.92 - 559.82*cos(2*latitude) + 1.175*cos(4*latitude) - 0.0023*cos(6*latitude);
  	final longitudeDistance = 111412.84*cos(latitude) - 93.5*cos(3*latitude) + 0.118*cos(5*latitude);
  	return pow(
	    pow((latitude - other.latitude)*latitudeDistance, 2)
		    + pow((longitude - other.longitude)*longitudeDistance, 2)
	      + pow(altitude - other.altitude, 2),
	    0.5,
	  ).toDouble();
  }
}

/// Utilities for [AutonomyState]s.
extension AutonomyStateUtils on AutonomyState {
	/// The human-readable name of the task.
	String get humanName {
		switch (this) {
			case AutonomyState.AUTONOMY_STATE_UNDEFINED: return "Disabled";
			case AutonomyState.PATHING: return "Calculating path";
			case AutonomyState.APPROACHING: return "Approaching destination";
			case AutonomyState.AT_DESTINATION: return "Arrived at destination";
			case AutonomyState.DRIVING: return "Driving";
			case AutonomyState.SEARCHING: return "Searching for ArUco";
			case AutonomyState.ABORTING: return "Aborting";
			case AutonomyState.NO_SOLUTION: return "No solution found";
		}
		// Do not use default or else you'll lose exhaustiveness checking.
		throw ArgumentError("Unrecognized status: $this");
	}
}

/// Utilities for [AutonomyTask]s.
extension AutonomyTaskUtils on AutonomyTask {
	/// The human-readable name of the task.
	String get humanName {
		switch (this) {
			case AutonomyTask.AUTONOMY_TASK_UNDEFINED: return "No task";
			case AutonomyTask.GPS_ONLY: return "GPS only";
			case AutonomyTask.VISUAL_MARKER: return "Visual marker";
			case AutonomyTask.BETWEEN_GATES: return "Between gates";
		}
		// Do not use default or else you'll lose exhaustiveness checking.
		throw ArgumentError("Unrecognized task: $this");
	}
}

/// Utilities for [ScienceState]s.
extension ScienceStateUtils on ScienceState {
	/// The human-readable name of the task.
	String get humanName {
		switch (this) {
			case ScienceState.SCIENCE_STATE_UNDEFINED: return "Unknown";
			case ScienceState.STOP_COLLECTING: return "Idle";
			case ScienceState.COLLECT_DATA: return "Collecting data";
		}
		// Do not use default or else you'll lose exhaustiveness checking.
		throw ArgumentError("Unrecognized task: $this");
	}
}

/// Utilities for [MotorDirection]s.
extension MotorDirectionUtils on MotorDirection {
	/// The human-readable name of the direction
	String get humanName {
		switch (this) {
			case MotorDirection.MOTOR_DIRECTION_UNDEFINED: return "Unknown";
			case MotorDirection.UP: return "Up";
			case MotorDirection.DOWN: return "Down";
			case MotorDirection.LEFT: return "Left";
			case MotorDirection.RIGHT: return "Right";
			case MotorDirection.CLOCKWISE: return "Clockwise";
			case MotorDirection.COUNTER_CLOCKWISE: return "Counter clockwise";
			case MotorDirection.OPENING: return "Opening";
			case MotorDirection.CLOSING: return "Closing";
			case MotorDirection.NOT_MOVING: return "Not moving";
		}
		// Do not use default or else you'll lose exhaustiveness checking.
		throw ArgumentError("Unrecognized MotorDirection: $this");
	}
}

/// More human-friendly fields for [BurtLogLevel]s.
extension LogLevelUtils on BurtLogLevel {
  /// The human-readable name of this level.
  String get humanName => switch(this) {
    BurtLogLevel.critical => "Critical",
    BurtLogLevel.error => "Error",
    BurtLogLevel.warning => "Warning",
    BurtLogLevel.info => "Info",
    BurtLogLevel.debug => "Debug",
    BurtLogLevel.trace => "Trace",
    _ => "Unknown",
  };

  /// The label to represent this log.
  String get label => switch(this) {
    BurtLogLevel.critical => "[C]",
    BurtLogLevel.error => "[E]",
    BurtLogLevel.warning => "[W]",
    BurtLogLevel.info => "[I]",
    BurtLogLevel.debug => "[D]",
    BurtLogLevel.trace => "[T]",
    _ => "?",
  };
}

/// Formats [BurtLog] messages in plain-text. For the UI, use widgets.
extension LogFormat on BurtLog {
  /// Formats [BurtLog] messages in plain-text. For the UI, use widgets.
  String format() {
    final result = StringBuffer()
      ..write(level.label)
      ..write(" ")
      ..write(title);
    if (body.isNotEmpty) {
      result..write("\n  ")..write(body);
    }
    return result.toString();
  }
}

/// Helpful methods on [Version]s.
extension VersionUtils on Version {
  /// Formats the version in a human-readable format.
  String format() => hasMajor() ? "$major.$minor" : "unknown";
  /// Whether another version is compatible with this one.
  bool isCompatible(Version other) => major == other.major;
}

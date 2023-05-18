import "dart:math";
import "dart:ui" show Color;

import "package:protobuf/protobuf.dart" as proto;
import "package:rover_dashboard/data.dart";

export "package:protobuf/protobuf.dart" show GeneratedMessageGenericExtensions;

/// A cleaner name for any message generated by Protobuf.
typedef Message = proto.GeneratedMessage;

/// A function that decodes a Protobuf messages serialized form.
/// 
/// The `.fromBuffer` constructor is a type of [MessageDecoder]. 
typedef MessageDecoder<T extends Message> = T Function(List<int> data); 

/// Utilities for [Timestamp]s.
extension TimestampUtils on Timestamp {
	/// The [Timestamp] version of [DateTime.now].
	Timestamp now() => Timestamp.fromDateTime(DateTime.now());

	/// Adds a [Duration] to a [Timestamp].
	Timestamp operator +(Duration duration) => Timestamp.fromDateTime(toDateTime().add(duration));
}

/// Defines a friendlier method for getting the name of a message.
extension MessageUtils on Message {
	/// The name of the message as declared in the .proto file. 
	String get messageName => info_.messageName;

	/// Returns a [WrappedMessage] representing this message with a timestamp
	WrappedMessage wrapWithTimestamp(Timestamp timestamp) => WrappedMessage(
		data: writeToBuffer(),
		timestamp: timestamp,
	);

	/// Returns a [WrappedMessage] representing this message with a name.
	WrappedMessage get wrapped => WrappedMessage(
		data: writeToBuffer(),
		name: messageName,
	);
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
}

/// Extensions for [CameraName] values.
extension CameraNameUtils on CameraName {
	/// Gets a user-friendly name for a [CameraName].
	String get humanName {
		switch(this) {
			case CameraName.CAMERA_NAME_UNDEFINED: return "";
			case CameraName.ROVER_FRONT: return "Rover front";
			case CameraName.ROVER_REAR: return "Rover rear";
			case CameraName.ARM_BASE: return "Arm";
			case CameraName.ARM_GRIPPER: return "Gripper";
			case CameraName.SCIENCE_CAROUSEL: return "Science";
			case CameraName.SCIENCE_MICROSCOPE: return "Microscope";
		}
		// Do not use default or else you'll lose exhaustiveness checking.
		throw ArgumentError("Unrecognized rover status: $this");
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
			case Device.DEVICE_UNDEFINED: return "";
			case Device.DASHBOARD: return "Dashboard";
			case Device.SUBSYSTEMS: return "Subsystems";
			case Device.VIDEO: return "Video";
			case Device.AUTONOMY: return "Autonomy";
			case Device.FIRMWARE: return "Firmware";
			case Device.ARM: return "Arm";
			case Device.GRIPPER: return "Gripper";
			case Device.SCIENCE: return "Science";
			case Device.ELECTRICAL: return "Electrical";
			case Device.DRIVE: return "Drive";
			case Device.MARS: return "MARS";
			case Device.MARS_SERVER: return "MARS Pi";
		}
		// Do not use default or else you'll lose exhaustiveness checking.
		throw ArgumentError("Unrecognized device: $this");
	}
}

/// Utilities for Gps Coordinates Data
extension GpsUtils on GpsCoordinates {
  /// Calculate Euclidean distance between current coordinates and another set of coordinates
  num distanceTo(GpsCoordinates other) => pow(
    pow(latitude - other.latitude, 2) 
      + pow(longitude - other.longitude, 2) 
      + pow(altitude - other.altitude, 2), 
    0.5,
  );
}

/// Utilities for color data.
extension ColorUtils on ProtoColor {
	/// Creates a new [ProtoColor] from a Flutter [Color].
	ProtoColor fromColor(Color other) => ProtoColor(
		red: other.red / 255,
		green: other.green / 255,
		blue: other.blue / 255,
	);

	/// Converts this message to a Flutter [Color].
	Color toColor() => Color.fromARGB(
		255, (red*255).toInt(), (green*255).toInt(), (blue*255).toInt(),
	);
}

extension AutonomyStateUtils on AutonomyState {
	String get humanName {
		switch (this) {
			case AutonomyState.AUTONOMY_STATE_UNDEFINED: return "";
			case AutonomyState.PATHING: return "Calculating path...";
			case AutonomyState.APPROACHING: return "Approaching destination";
			case AutonomyState.AT_DESTINATION: return "Arrived at destination";
			case AutonomyState.DRIVING: return "Driving";
			case AutonomyState.SEARCHING: return "Searching for visual marker";
		}
		// Do not use default or else you'll lose exhaustiveness checking.
		throw ArgumentError("Unrecognized status: $this");
	}
}

extension AutonomyTaskUtils on AutonomyTask {
	String get humanName {
		switch (this) {
			case AutonomyTask.AUTONOMY_TASK_UNDEFINED: return "";
			case AutonomyTask.GPS_ONLY: return "GPS only";
			case AutonomyTask.VISUAL_MARKER: return "Visual marker";
			case AutonomyTask.BETWEEN_GATES: return "Between gates";
		}
		// Do not use default or else you'll lose exhaustiveness checking.
		throw ArgumentError("Unrecognized task: $this");
	}
}

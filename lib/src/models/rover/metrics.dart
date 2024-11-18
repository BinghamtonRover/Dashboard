import "dart:async";
import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/src/data/metrics/antenna.dart";

/// A data model that listens for updated data and provides [Metrics] to the UI.
class RoverMetrics extends Model {
	/// Data from the science subsystem.
	final science = ScienceMetrics();

  /// Data from the GPS.
  final position = PositionMetrics();

  /// Data from the drive subsystem.
  final drive = DriveMetrics();

  /// Data from the HREI subsystem about the arm base.
  final arm = ArmMetrics();

  /// Data from the HREI subsystem about the gripper.
  final gripper = GripperMetrics();

  /// Vitals data from the rover.
  final vitals = VitalsMetrics();

  /// Data from the Base Station Antenna
  final antenna = AntennaMetrics();

	/// A list of all the metrics to iterate over.
	///
	/// NOTE: Keep this as a getter, NOT a field. If this is made a field, then it won't update
	/// when new data is received. As a getter, every time it is called it will use new data.
	List<Metrics> get allMetrics => [vitals, position, drive, science, arm, gripper, antenna];

  /// Whether the given command is supported by the rover.
  bool isSupportedVersion(Message command) {
    final model = metricsByCommandName[command.messageName];
    return model?.matchesVersion ?? true;
  }

  /// Maps command names to the metrics responsible for the device.
  Map<String, Metrics> get metricsByCommandName => {
    ScienceCommand().messageName: science,
    DriveCommand().messageName: drive,
    ArmCommand().messageName: arm,
    GripperCommand().messageName: gripper,
    AntennaCommand().messageName: antenna,
  };

	@override
	Future<void> init() async {
		models.messages.stream.onMessage(
			name: DriveData().messageName,
			constructor: DriveData.fromBuffer,
			callback: drive.update,
		);
		models.messages.stream.onMessage(
			name: ScienceData().messageName,
			constructor: ScienceData.fromBuffer,
			callback: science.update,
		);
    models.messages.stream.onMessage(
			name: RoverPosition().messageName,
			constructor: RoverPosition.fromBuffer,
			callback: position.update,
		);
		models.messages.stream.onMessage(
			name: ArmData().messageName,
			constructor: ArmData.fromBuffer,
			callback: arm.update,
		);
		models.messages.stream.onMessage(
			name: GripperData().messageName,
			constructor: GripperData.fromBuffer,
			callback: gripper.update,
		);
    models.messages.stream.onMessage(
      name: AntennaData().messageName,
      constructor: AntennaData.fromBuffer,
      callback: antenna.update,
    );
    drive.addListener(vitals.notify);
    // versionTimer = Timer.periodic(versionInterval, _sendVersions);
	}

  // /// A timer to broadcast the supported Protobuf version every [versionInterval] seconds.
  // Timer? versionTimer;
  // /// Broadcasts the supported Protobuf version every 5 seconds.
  // static const versionInterval = Duration(seconds: 5);
  // void _sendVersions(_) {
  //   for (final metric in allMetrics) {
  //     final message = metric.versionCommand;
  //     models.messages.sendMessage(message, checkVersion: false);
  //   }
  // }
}

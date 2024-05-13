import "dart:async";
import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

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

	/// A list of all the metrics to iterate over.
	///
	/// NOTE: Keep this as a getter, NOT a field. If this is made a field, then it won't update
	/// when new data is received. As a getter, every time it is called it will use new data.
	List<Metrics> get allMetrics => [position, drive, science, arm, gripper];

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
  };

	@override
	Future<void> init() async {
		models.messages.registerHandler<DriveData>(
			name: DriveData().messageName,
			decoder: DriveData.fromBuffer,
			handler: drive.update,
		);
		models.messages.registerHandler<ScienceData>(
			name: ScienceData().messageName,
			decoder: ScienceData.fromBuffer,
			handler: science.update,
		);
    models.messages.registerHandler<RoverPosition>(
			name: RoverPosition().messageName,
			decoder: RoverPosition.fromBuffer,
			handler: position.update,
		);
		models.messages.registerHandler<ArmData>(
			name: ArmData().messageName,
			decoder: ArmData.fromBuffer,
			handler: arm.update,
		);
		models.messages.registerHandler<GripperData>(
			name: GripperData().messageName,
			decoder: GripperData.fromBuffer,
			handler: gripper.update,
		);
    versionTimer = Timer.periodic(versionInterval, _sendVersions);
	}

  /// A timer to broadcast the supported Protobuf version every [versionInterval] seconds.
  Timer? versionTimer;
  /// Broadcasts the supported Protobuf version every 5 seconds.
  static const versionInterval = Duration(seconds: 5);
  void _sendVersions(_) {
    for (final metric in allMetrics) {
      final message = metric.versionCommand;
      models.messages.sendMessage(message);
    }
  }
}

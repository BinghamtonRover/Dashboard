import "dart:async";
import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// A data model that listens for updated data and provides [Metrics] to the UI.
class RoverMetrics extends Model {
	/// Data about the rover's core vitals.
	final electrical = ElectricalMetrics();

	/// Data from the science subsystem.
	final science = ScienceMetrics();

  /// Data from the GPS.
  final position = PositionMetrics();

  /// Data from the drive subsystem.
  final drive = DriveMetrics();

  /// Data from the MARS subsystem.
  final mars = MarsMetrics();

  /// Data from the HREI subsystem about the arm base.
  final arm = ArmMetrics();

  /// Data from the HREI subsystem about the gripper.
  final gripper = GripperMetrics();

	/// A list of all the metrics to iterate over.
	///
	/// NOTE: Keep this as a getter, NOT a field. If this is made a field, then it won't update
	/// when new data is received. As a getter, every time it is called it will use new data.
	List<Metrics> get allMetrics => [position, mars, electrical, drive, science, arm, gripper];

	@override
	Future<void> init() async {
		models.messages.registerHandler<ElectricalData>(
			name: ElectricalData().messageName,
			decoder: ElectricalData.fromBuffer,
			handler: electrical.update,
		);
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
		models.messages.registerHandler<MarsData>(
			name: MarsData().messageName,
			decoder: MarsData.fromBuffer,
			handler: mars.update,
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
	}
}

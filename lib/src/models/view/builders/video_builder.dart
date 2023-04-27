import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// A [ValueBuilder] view model to modify a [CameraDetails].
class CameraDetailsBuilder extends ValueBuilder<CameraDetails> {
	/// Statuses the user can set the camera to.
	static const okStatuses = [CameraStatus.CAMERA_ENABLED, CameraStatus.CAMERA_DISABLED];

	/// The camera resolution's height. See [CameraDetails.resolutionHeight].
	final NumberBuilder<int> resolutionHeight;

	/// The camera resolution's width. See [CameraDetails.resolutionWidth].
	final NumberBuilder<int> resolutionWidth;

	/// The quality of the camera, as a percentage. See [CameraDetails.quality].
	final NumberBuilder<int> quality;

	/// How many frames per second to capture. See [CameraDetails.fps].
	final NumberBuilder<int> fps;

	/// The name of this camera.
	/// 
	/// This should not be changed by the user as it will cause multiple cameras to stream
	/// data under the same name and confuse the dashboard.
	final CameraName name;

	/// The camera's status.
	/// 
	/// The user cannot change this to any status, like [CameraStatus.CAMERA_DISCONNECTED].
	CameraStatus status;

	/// Whether changes are loading.
	bool isLoading = false;

	/// The error that occurrec when changing these settings, if any.
	String? error;

	/// Creates a [ValueBuilder] view model to change a [CameraDetails].
	CameraDetailsBuilder(CameraDetails data) : 
		resolutionHeight = NumberBuilder(data.resolutionHeight),
		resolutionWidth = NumberBuilder(data.resolutionWidth),
		quality = NumberBuilder(data.quality),
		fps = NumberBuilder(data.fps),
		name = data.name,
		status = CameraStatus.CAMERA_ENABLED;

	@override
	bool get isValid => resolutionHeight.isValid
		&& resolutionWidth.isValid
		&& quality.isValid
		&& fps.isValid
		&& okStatuses.contains(status);

	@override
	CameraDetails get value => CameraDetails(
		resolutionHeight: resolutionHeight.value, 
		resolutionWidth: resolutionWidth.value, 
		quality: quality.value, 
		fps: fps.value, 
		name: name,
		status: status,
	);

	/// Updates the [status] field.
	void updateStatus(CameraStatus? input) {
		if (input == null) return;
		if (!okStatuses.contains(input)) {
			error = "You can't set that status";
			notifyListeners();
			return;
		} else {
			error = null;
		}
		status = input;
		notifyListeners();
	}

	/// Saves these settings to the rover and updates the UI.
	Future<bool> saveSettings(int id) async {
		isLoading = true;
		error = null;
		notifyListeners();
		try {
			await models.video.updateCamera(id, value);
		} on RequestNotAccepted {
			error = "Rover did not accept this request";
		}
		isLoading = false;
		notifyListeners();
		return error == null;
	}
}

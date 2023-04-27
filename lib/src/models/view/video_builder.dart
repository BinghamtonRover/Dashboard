import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// A [ValueBuilder] view model to modify a [CameraDetails].
class CameraDetailsBuilder extends ValueBuilder<CameraDetails> {
	/// The camera resolution's height. See [CameraDetails.resolutionHeight].
	final NumberBuilder<int> resolutionHeight;

	/// The camera resolution's width. See [CameraDetails.resolutionWidth].
	final NumberBuilder<int> resolutionWidth;

	/// The quality of the camera, as a percentage. See [CameraDetails.quality].
	final NumberBuilder<int> quality;

	/// How many frames per second to capture. See [CameraDetails.fps].
	final NumberBuilder<int> fps;

	/// The camera's status.
	/// 
	/// The user cannot change this to any status, like [CameraStatus.CAMERA_DISCONNECTED].
	CameraStatus status;

	/// The name of this camera. 
	/// 
	/// The dashboard will not work well if two cameras have the same name, but nothing
	/// stops the rover from doing so. TODO: Fix this.
	CameraName name;

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
		status = data.status,
		name = data.name;

	@override
	bool get isValid => resolutionHeight.isValid
		&& resolutionWidth.isValid
		&& quality.isValid
		&& fps.isValid
		&& status != CameraStatus.CAMERA_DISCONNECTED;

	@override
	CameraDetails get value => CameraDetails(
		name: name,
		resolutionHeight: resolutionHeight.value, 
		resolutionWidth: resolutionWidth.value, 
		quality: quality.value, 
		fps: fps.value, 
		status: status,
	);

	/// Updates the [name] field.
	void updateName(CameraName? input) {
		if (input == null) return;
		name = input;
		notifyListeners();
	}

	/// Updates the [status] field.
	void updateStatus(CameraStatus? input) {
		if (input == null) return;
		if (input != CameraStatus.CAMERA_ENABLED && input != CameraStatus.CAMERA_DISABLED) {
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

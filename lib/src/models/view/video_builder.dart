import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

class CameraDetailsBuilder extends ValueBuilder<CameraDetails> {
	final NumberBuilder<int> resolutionHeight;
	final NumberBuilder<int> resolutionWidth;
	final NumberBuilder<int> quality;
	final NumberBuilder<int> fps;

	CameraStatus status;
	CameraName name;

	bool isLoading = false;
	String? error;

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

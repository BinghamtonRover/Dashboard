import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// A [ValueBuilder] view model to modify a [CameraDetails].
class CameraDetailsBuilder extends ValueBuilder<CameraDetails> {
	/// Statuses the user can set the camera to.
	static const okStatuses = [CameraStatus.CAMERA_ENABLED, CameraStatus.CAMERA_DISABLED];

	/// The camera resolution's capture width. See [CameraDetails.resolutionWidth].
	final NumberBuilder<int> captureWidth;

	/// The camera resolution's capture height. See [CameraDetails.resolutionHeight].
	final NumberBuilder<int> captureHeight;

  /// The camera resolution's stream width. See [CameraDetails.streamWidth].
	final NumberBuilder<int> streamWidth;

  /// The camera resolution's stream height. See [CameraDetails.streamHeight].
	final NumberBuilder<int> streamHeight;

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

	/// The error that occurred when changing these settings, if any.
	String? error;

  /// Current status of the camera's autofocus
  bool autofocus = true;

	@override
  List<ValueBuilder<dynamic>> get otherBuilders => [
      captureWidth,
      captureHeight,
      streamWidth,
      streamHeight,
      quality,
      fps,
    ];

	/// Creates a [ValueBuilder] view model to change a [CameraDetails].
	CameraDetailsBuilder(CameraDetails data) :
  	captureWidth = NumberBuilder(data.resolutionWidth, min: 0, max: 1920),
		captureHeight = NumberBuilder(data.resolutionHeight, min: 0, max: 1080),
    streamWidth = NumberBuilder(data.streamWidth, min: 0, max: 800),
    streamHeight = NumberBuilder(data.streamHeight, min: 0, max: 600),
		quality = NumberBuilder(data.quality, min: 0, max: 100),
		fps = NumberBuilder(data.fps, min: 0, max: 60),
		name = data.name,
		status = CameraStatus.CAMERA_ENABLED,
    autofocus = data.autofocus;

  @override
  bool get isValid =>
      captureWidth.isValid &&
      captureHeight.isValid &&
      streamWidth.isValid &&
      streamHeight.isValid &&
      quality.isValid &&
      fps.isValid &&
      okStatuses.contains(status);


  @override
	CameraDetails get value => CameraDetails(
		resolutionWidth: captureWidth.value,
		resolutionHeight: captureHeight.value,
    streamWidth: streamWidth.value,
    streamHeight: streamHeight.value,
		quality: quality.value,
		fps: fps.value,
		name: name,
		status: status,
    focus: 0,
    zoom: 100,
    pan: 0,
    tilt: 0,
    autofocus: true,
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
	Future<bool> saveSettings(String id) async {
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

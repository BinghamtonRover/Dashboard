import "package:flutter/material.dart";
import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/widgets.dart";

/// A widget to edit camera settings.
class VideoSettingsWidget extends ReusableReactiveWidget<VideoFeedSettings> {
  /// The details being sent to the camera.
  final CameraDetails details;
  /// The ID of the camera being edited.
  final String id;

  /// Creates the video settings widget.
  const VideoSettingsWidget(super.model, {
    required this.details, 
    required this.id,
  });

	@override
	Widget build(BuildContext context, VideoFeedSettings model) => LayoutBuilder(
    builder: (context, constraints) => Visibility(
      visible: constraints.maxWidth >= 175,
      child: ListView(
        children: [
          SliderSettings(
            label: "Zoom",
            value: model.zoom,
            min: 100,
            max: 800,
            onChanged: (val) => model.zoom = val,
            onChangeEnd: (val) async {
              await models.video.updateCamera(
                verify: false,
                id,
                CameraDetails(name: details.name, zoom: val.round()),
              );
            },
          ),
          SliderSettings(
            label: "Pan",
            value: model.pan,
            min: -180,
            max: 180,
            onChanged: (val) => model.pan = val,
            onChangeEnd: (val) async {
              await models.video.updateCamera(
                verify: false,
                id,
                CameraDetails(name: details.name, pan: val.round()),
              );
            },
          ),
          SliderSettings(
            label: "Tilt",
            value: model.tilt,
            min: -180,
            max: 180,
            onChanged: (val) => model.tilt = val,
            onChangeEnd: (val) async {
              await models.video.updateCamera(
                verify: false,
                id,
                CameraDetails(name: details.name, tilt: val.round()),
              );
            },
          ),
          SliderSettings(
            label: "Focus",
            value: model.focus,
            max: 255,
            onChanged: (val) => model.focus = val,
            onChangeEnd: (val) async {
              await models.video.updateCamera(
                verify: false,
                id,
                CameraDetails(name: details.name, focus: val.round()),
              );
            },
          ),
          // Need to debug bool conversion to 1.0 and 2.0
          SwitchListTile(
            title: const Text("Autofocus"),
            value: model.autofocus,
            onChanged: (bool value) async {
              model.autofocus = value;
              await models.video.updateCamera(
                verify: false,
                id,
                CameraDetails(name: details.name, autofocus: value),
              );
            },
          ),
        ],
      ),
    ),
  );
}

/// Class that defines a slider for camera controls
class SliderSettings extends StatelessWidget {
  /// Name of the slider
  final String label;

  /// Value corresponding to the slider
  final double value;

  /// Value to change the position of the slider
  final ValueChanged<double> onChanged;

  /// Callback for when the slider is done being dragged
  final ValueChanged<double>? onChangeEnd;

  /// The min value on this slider.
  final double min;

  /// The max value on this slider.
  final double max;

  /// Constructor for SliderSettings
  const SliderSettings({
    required this.label,
    required this.value,
    required this.onChanged,
    this.onChangeEnd,
    this.min = 0,
    this.max = 100,
  });

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      Text("$label: ${value.floor()}"),
      Slider(
        value: value,
        onChanged: onChanged,
        onChangeEnd: onChangeEnd,
        max: max,
        min: min,
      ),
    ],
  );
}

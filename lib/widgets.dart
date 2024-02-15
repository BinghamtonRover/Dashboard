/// Contains complex or reusable widgets. 
/// 
/// If a widget is becoming too large or needs to be reused, separate it into its own file and put 
/// it here. Although "everything is a widget"™ in Flutter, this library is reserved for widgets
/// that are contained to a small, logical section of the general UI. Groups of widgets spanning
/// multiple loosely-related purposes should be considered "pages" and put in the pages library.
/// 
/// This library is broken out into several directories: 
/// - The `atomic` directory represent singular pieces of data, such as metric readouts.
/// - The `generic` directory contains random pieces of UI that are reused in many locations.
/// - The `navigation` directory is for global pieces of UI that handle navigation.
/// - The `utils` directory contains widgets or other frontend code used by other widgets.
/// - Other folders named after pages contain complex widgets used in that page.
/// 
/// This library may depend on the data, services, and models library.   
library widgets;

import "package:flutter/material.dart";

export "src/widgets/atomic/autonomy_command.dart";
export "src/widgets/atomic/camera_editor.dart";
export "src/widgets/atomic/editors.dart";
export "src/widgets/atomic/video_feed.dart";

export "src/widgets/generic/gamepad.dart";
export "src/widgets/generic/reactive_widget.dart";
export "src/widgets/generic/timer.dart";

export "src/widgets/navigation/footer.dart";
export "src/widgets/navigation/sidebar.dart";
export "src/widgets/navigation/views.dart";

/// Convenience functions on [BuildContext].
extension BuildContextUtils on BuildContext {
	/// Gets the text theme of the app.
	TextTheme get textTheme => Theme.of(this).textTheme;

	/// Gets the color scheme of the app.
	ColorScheme get colorScheme => Theme.of(this).colorScheme;
}

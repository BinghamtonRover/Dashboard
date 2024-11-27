import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// The global mapping of keyboard shortcuts.
///
/// Do not include rover controls in here. See [KeyboardController] instead
final shortcuts = <ShortcutActivator, Intent>{
  ...WidgetsApp.defaultShortcuts,
  const SingleActivator(LogicalKeyboardKey.space): const VoidCallbackIntent(stopEverything),
  const CharacterActivator("n"): VoidCallbackIntent(models.sockets.reset),
  const CharacterActivator("l"): VoidCallbackIntent(models.sockets.toggleRoverType),
};

/// Sends all available stop commands and puts the rover into idle mode.
void stopEverything() {
  for (final controller in models.rover.controllers) {
    for (final stopCommand in controller.controls.onDispose) {
      models.messages.sendMessage(stopCommand);
    }
  }
  models.rover.settings.setStatus(RoverStatus.IDLE);
  models.sockets.autonomy.sendMessage(AutonomyCommand(abort: true));
  models.home.setMessage(severity: Severity.error, text: "Stopped everything");
}

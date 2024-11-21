import "package:flutter/services.dart";
import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/src/services/service.dart";

/// Modifier keys for shortcuts (e.g. ctrl, alt, shift, etc)
class KeyModifier {
  /// Key modifier for the control key, this can be either left control or right control
  static final KeyModifier control =
      KeyModifier._(() => HardwareKeyboard.instance.isControlPressed);

  /// Key modifier for the alt key, this can be either left shift or right shift
  static final KeyModifier shift =
      KeyModifier._(() => HardwareKeyboard.instance.isShiftPressed);

  /// Key modifier for the alt key, this can be either left alt or right alt
  static final KeyModifier alt =
      KeyModifier._(() => HardwareKeyboard.instance.isAltPressed);

  const KeyModifier._(this.active);

  /// Function for whether or not the modifier is active
  final bool Function() active;
}

/// A class representing a shortcut key and its modifiers
class ShortcutKey {
  /// The keyboard key for the shortcut
  final List<LogicalKeyboardKey> logicalKeys;

  /// Key modifiers for the shortcut
  final List<KeyModifier>? modifiers;

  /// Unique identifier for this shortcut
  final String identifier;

  /// Constructor for a shortcut key
  ShortcutKey(this.logicalKeys, {required this.identifier, this.modifiers});
}

/// Callback for when a shortcut key is pressed
typedef ShortcutCallback = void Function();

/// A service for global shortcuts in the dashboard
///
/// Wraps the [HardwareKeyboard] listener methods to listen to global shortcuts
///
/// Any shortcuts that are defined are global to the application, regardless of which widgets are in focus
class ShortcutsService extends Service {
  final List<ShortcutKey> _shortcutList = [];
  final Map<String, ShortcutCallback> _callbackMap = {};

  int _getNumberModifiersPressed() {
    var count = 0;

    if (HardwareKeyboard.instance.isControlPressed) {
      count++;
    }

    if (HardwareKeyboard.instance.isAltPressed) {
      count++;
    }

    if (HardwareKeyboard.instance.isShiftPressed) {
      count++;
    }

    if (HardwareKeyboard.instance.isMetaPressed) {
      count++;
    }

    return count;
  }

  bool _handleRawKeyEvent(KeyEvent value) {
    if (value is! KeyDownEvent) {
      return false;
    }

    final modifierCount = _getNumberModifiersPressed();

    final shortcuts = _shortcutList.where((e) {
      if (!e.logicalKeys.contains(value.logicalKey)) {
        return false;
      }

      for (final key in e.logicalKeys) {
        if (!HardwareKeyboard.instance.isLogicalKeyPressed(key)) {
          return false;
        }
      }

      if (e.modifiers?.isEmpty ?? true) {
        return true;
      }

      if (e.modifiers!.length != modifierCount) {
        return false;
      }

      for (final modifier in e.modifiers!) {
        if (!modifier.active()) {
          return false;
        }
      }

      return true;
    });

    if (shortcuts.isEmpty) {
      return false;
    }

    for (final shortcut in shortcuts) {
      final callback = _callbackMap[shortcut.identifier];

      if (callback != null) {
        callback();
      }
    }

    return true;
  }

  /// Registers a [ShortcutKey] to the global shortcut listeners
  ///
  /// The shortcut will only get called once all the required keys are pressed, and will not be repeated
  void register(
    ShortcutKey shortcut, {
    required ShortcutCallback callback,
  }) {
    _callbackMap.update(
      shortcut.identifier,
      (_) => callback,
      ifAbsent: () => callback,
    );

    _shortcutList.add(shortcut);
  }

  @override
  Future<void> init() async {
    register(
      ShortcutKey([LogicalKeyboardKey.space], identifier: "safety e-stop"),
      callback: () {
        final statusNotifier = models.rover.status;

        if (statusNotifier.value == RoverStatus.MANUAL ||
            statusNotifier.value == RoverStatus.AUTONOMOUS) {
          models.home.setMessage(
            severity: Severity.info,
            text: "Setting rover status to idle",
          );
          statusNotifier.value = RoverStatus.IDLE;
        }
      },
    );

    register(
      ShortcutKey(
        [
          LogicalKeyboardKey.bracketLeft,
          LogicalKeyboardKey.bracketRight,
          LogicalKeyboardKey.backslash,
        ],
        identifier: "enable rover",
      ),
      callback: () {
        final statusNotifier = models.rover.status;

        if (statusNotifier.value == RoverStatus.IDLE) {
          statusNotifier.value = RoverStatus.MANUAL;
        }
      },
    );
    HardwareKeyboard.instance.addHandler(_handleRawKeyEvent);
  }

  @override
  Future<void> dispose() async {
    HardwareKeyboard.instance.removeHandler(_handleRawKeyEvent);
  }
}

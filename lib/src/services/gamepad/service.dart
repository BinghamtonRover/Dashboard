import "../service.dart";
import "gamepad.dart";
import "mock.dart";

/// A service to match operators to gamepads.
///
/// An operator is a human user who will be assigned a gamepad. This user will expect to operate
/// one part of the rover for the duration of the session, hence the name. Above all, it is
/// critical that, once assigned, an operator's controller never changes assignments. that means
/// managing differences between the order of the operators and the order of the gamepads.
///
/// For example, say there are three operators and three gamepads. It is very likely that they will
/// not grab the gamepads in the "correct" order -- operator 1 might end up with gamepad 2. Instead
/// of forcing the operators to think like machines, we keep the [gamepads] list in the order of the
/// operators. When an operator wishes to connect, they may call [connect] which will grab the first
/// gamepad available, which may have a mismatched gamepad index. [init] will simply try to connect
/// as many gamepads as possible, which is often desirable at the start of a session.
///
/// Note that some gamepads with wireless receivers will show up as connected when the *receiver* is
/// plugged in, even if the gamepad itself is turned off. This is a fundamental limitation.
class GamepadService extends Service {
  /// The maximum number of gamepads that will be connected.
  static const maxGamepads = 3;

  /// A list of gamepads that are currently connected.
  ///
  /// Note that the index in this list does **not** correspond to [Gamepad.controllerIndex]. The
  /// latter is the unique integer ID assigned to the physical gamepad by the operating system,
  /// while the former is a number 1-3 representing which operator is holding that gamepad.
  List<Gamepad> gamepads = [];

  /// A list of [Gamepad.controllerIndex]es for each currently connected controller.
  ///
  /// This set exists because the order of indexes that the operating system assigns may, and
  /// usually will, differ from the order that the operators are in. For example, if the OS assigns
  /// indexes 0 and 2, we'd still want the gamepads to appear in indexes 0 and 1 and save the
  /// disconnected gamepad for index 2.
  Set<int> get osIndexes => {
    for (final gamepad in gamepads)
      if (gamepad.isConnected)
        gamepad.controllerIndex,
  };

  @override
  Future<void> init() async {
    for (var i = 0; i < maxGamepads; i++) {
      connect(i);
    }
  }

  /// Connects the given operator to the first available gamepad.
  ///
  /// See the discussions at [gamepads] and [osIndexes] for context first. This function will
  /// loop through all available OS indexes to find the first available index, and then assign
  /// it to the operator at the given index.
  ///
  /// For example, assume the OS provides gamepads at indexes 0 and 2. There is already an operator
  /// connected to gamepad 0. If the next operator (at index 1) wants to connect, this function will
  /// assign them the gamepad at index 2.
  void connect(int operatorIndex) {
    gamepads[operatorIndex] = MockGamepad(0);
    for (var osIndex = 0; osIndex < maxGamepads; osIndex++) {
      if (osIndexes.contains(osIndex)) continue;
      final gamepad = Gamepad.forPlatform(osIndex);
      if (!gamepad.isConnected) continue;
      gamepads[operatorIndex] = gamepad;
      gamepad.pulse();
      return;
    }
  }

  @override
  Future<void> dispose() async { }
}

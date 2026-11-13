import "dart:math" as math;
import "package:burt_network/burt_network.dart";

/// Converts joystick increments to bounded absolute targets for the Teensy bench test.
class SwivelJog {
  double? _targetRadians;
  bool _holding = false;

  /// Build an absolute swivel target, or hold on release or invalid input.
  ArmCommand? update({
    required double joystick,
    required double incrementRadians,
    required double? measuredRadians,
    required double speedErpm,
    required double accelerationErpmPerSecond,
    bool stop = false,
  }) {
    if (stop) return hold();
    // Wider centre region and hysteresis reject spring-centre drift.
    final deadzone = _targetRadians == null ? 0.15 : 0.10;
    if (!joystick.isFinite || joystick.abs() <= deadzone) {
      return _targetRadians == null && !_holding ? null : hold();
    }
    if (measuredRadians == null ||
        !measuredRadians.isFinite ||
        !incrementRadians.isFinite ||
        !speedErpm.isFinite ||
        speedErpm < 0 ||
        speedErpm > 327670 ||
        !accelerationErpmPerSecond.isFinite ||
        accelerationErpmPerSecond < 0 ||
        accelerationErpmPerSecond > 327670) {
      return _targetRadians == null && !_holding ? null : hold();
    }
    // Avoid queuing a distant destination if feedback or the motor stops advancing.
    const maxLead = 5 * math.pi / 180;
    _targetRadians =
        ((_targetRadians ?? measuredRadians) +
                joystick.clamp(-1.0, 1.0) * incrementRadians)
            .clamp(measuredRadians - maxLead, measuredRadians + maxLead);
    _holding = false;
    return ArmCommand(
      usingIk: BoolState.OFF,
      swivel: MotorCommand(
        angle: _targetRadians,
        speedErpm: speedErpm,
        accelerationErpmPerSecond: accelerationErpmPerSecond,
      ),
    );
  }

  /// Forget the previous destination and request a measured-position hold.
  ArmCommand hold() {
    _targetRadians = null;
    _holding = true; // Repeat HOLD until the next deliberate movement command.
    return ArmCommand(stop: true);
  }
}

/// A class to limit the rate of change of a value. Useful for
/// limiting acceleration of motors preventing shaking or high
/// current draw.
///
/// The maximum rate of change of the input (the rate) affects how rapidly the input can be changed.
/// The [calculate] method returns the input clamped between (input - (previous * dt))
/// and (input + (previous * dt))
///
/// When this is not being frequently updated via [calculate], it is recommended to call [reset]
///
/// Implementation inspired from WPILib
/// https://github.com/wpilibsuite/allwpilib/blob/main/wpimath/src/main/native/include/frc/filter/SlewRateLimiter.h
class SlewRateLimiter {
  /// The rate of change for the slew rate limiter in input units per second
  double rate = 1;

  double _previousValue = 0;
  DateTime _previousTime = DateTime.now();

  /// Constructor a slew rate limiter with a [rate] representing the max change in input per second
  SlewRateLimiter({this.rate = 1});

  /// The previous value calculated by the rate limiter
  double get lastValue => _previousValue;

  /// Filters the input to the max rate of change
  double calculate(double input) {
    final currentTime = DateTime.now();

    // Extremely rare edge case where if the computer syncs its
    // time to an online server and suddenly the time is slightly
    // earlier than before, it will cause an error. I've only seen
    // this happen once but it was a weird one.
    if (currentTime.isBefore(_previousTime)) {
      _previousTime = currentTime;
      return _previousValue;
    }
    final elapsedSeconds =
        currentTime.difference(_previousTime).inMicroseconds / 1e6;
    _previousValue += (input - _previousValue).clamp(
      -rate * elapsedSeconds,
      rate * elapsedSeconds,
    );
    _previousTime = currentTime;
    return _previousValue;
  }

  /// Resets the slew rate limiter to [value]
  void reset([double value = 0]) {
    _previousValue = value;
    _previousTime = DateTime.now();
  }
}

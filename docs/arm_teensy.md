# All-motor Arm controls — protocol 1.6

Use the updated Dashboard executable together with the matching Teensy firmware.
Both commands and telemetry now have framed payloads after the existing Connect
handshake. Older raw-arm Dashboard builds are not compatible with this update.

Dashboard pins burt_network to published Rover-Code commit
`4ed0c83dd36c6b8040b48bd980072970b1db42bd` on `CubeMars-Arm-Dashboard`.
No local path override is required. The lockfile records that same Git revision.
Keep the full Windows application folder together when distributing a build.

## Manual Arm controls

- Right stick horizontal: swivel (2).
- Right stick vertical: shoulder, coordinating bar (3) and lever (4).
- Left stick vertical: elbow via lever (4), with shoulder held at its requested angle.
- Bumpers: separate forearm roll (7).
- D-pad up/down: wrist pitch (5+6).
- D-pad left/right: wrist roll (5+6).
- Triggers: gripper motor-angle jog (8).
- Release: hold that group. Select or leave Arm mode: hold all commanded motors.

Motor speed and acceleration in Arm settings are shared across all groups and use
electrical RPM and electrical RPM/s. Signed increments are radians per joystick
tick, not speed. Shoulder forward is positive at the joint, with bar negative and
lever positive. Elbow is relative to the bar, not an absolute lever angle.

Current firmware limits remain authoritative: swivel -160..160; shoulder 0..90;
the **lever motor minimum is 0 degrees**. Relative elbow-angle limits are
unconfigured and disabled. Negative relative elbow angles are valid while the
lever stays at or above zero and other motor/shoulder limits are satisfied. Gripper fully-open/closed actions remain unavailable until its
endpoints are measured; the triggers already provide direct motor-angle jogging.
Wrist mounting signs and external ratios use the test project's configurable defaults.

Each group starts from its calibrated feedback. A missing paired motor prevents
that group from starting, without stopping unrelated motors. Releasing one axis
of a coupled group captures its measured angle while the other axis continues.
All-neutral groups repeat selective HOLD. A 250 ms per-motor command timeout also
cancels and holds a group if its command stream disappears. No zero-current release
is used. Normal inertia and controller dynamics still require physical testing.

The old mouse IK action is disabled for this arm. Use manual Arm mode, not Arm IK.

## Packet format and schema

Arm serial frames are A5 5A, uint16 little-endian payload length, protobuf bytes,
with a 2048-byte maximum. Handshake and reset remain raw. USB fragments and multiple
frames per read are reassembled by both ends. Other serial device types retain
their original format.

All MotorCommand angles use radians. Speed/acceleration fields remain optional.
ArmCommand.hold_motor_mask is field 25: bit N selects CAN ID N. Either motor in
the four-bar or wrist pair selects its whole group. Other groups can receive
movement targets in that same message. Global stop remains supported.

Raw motor position is tenths of a degree; normalized joint_angles and virtual
wrist pitch/roll are radians, calculated by firmware using its zero/direction setup.

## Build and test

```powershell
$env:PATH = "$env:LOCALAPPDATA\Pub\Cache\bin;" + $env:PATH
Set-Location 'C:\Users\Kenneth Ou\Rover\Rover-code\burt_network'
dart pub global activate protoc_plugin 25.0.0
dart Protobuf/gen_dart.dart

Set-Location 'C:\Users\Kenneth Ou\Rover\Arm-Firmware'
python Protobuf/generate_arduino.py --sketch Arm --proto arm

Set-Location 'C:\Users\Kenneth Ou\Rover\Dashboard'
flutter pub get
flutter analyze --no-pub
flutter test --no-pub
flutter build windows --debug --no-pub
```

Generate with protoc_plugin 25.0.0 for compatibility with protobuf 6.0. The command
above activates that version explicitly. Keep shared schema copies synchronized
before generation; do not edit generated bindings manually.

The networking branch references published Protobuf commit
`18bd0f099a2f354108e33eb01ef3dcdd12af09e9` from `Arm-Data-Add`.
For local networking development, an optional ignored pubspec_overrides.yaml can
point burt_network at a sibling checkout. Remove that override before checking
that the committed Git dependency and lockfile build independently.

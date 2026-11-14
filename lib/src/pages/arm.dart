import "dart:math";

import "package:flutter/gestures.dart";
import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/src/models/view/arm.dart";
import "package:rover_dashboard/src/models/view/arm3d.dart";
import "package:rover_dashboard/widgets.dart";

/// Paints the arm as a 3D four-bar arm on an orbitable floor.
///
/// The pivoting lower-motor mount, the two bars, the rigid coupler they pin to,
/// the parallel forearm, and the gripper are drawn in world space and projected
/// through [camera], with every part sorted by depth so nearer links cover
/// farther ones. Hovering shows a translucent preview of the pose that would
/// reach the mouse, and the arm being controlled is painted from its reported
/// four-bar angles.
class ArmPainter3d extends CustomPainter {
  /// Where each joint of the arm is in 3D.
  final ArmPose3d pose;

  /// The length of each link of the arm, in meters.
  final ArmLengths lengths;

  /// The camera looking at the arm.
  final ArmCamera camera;

  /// The pose that would reach the mouse, if the mouse is over the view.
  final ArmPose3d? preview;

  /// The 3D point on the arm's plane under the mouse, if any.
  final ArmVector? hoverTarget;

  /// The color to draw the arm in.
  final Color color;

  /// The color to highlight joints and the target with.
  final Color accent;

  /// The color of the floor behind the arm.
  final Color background;

  /// Creates a painter for the 3D view.
  ArmPainter3d({
    required this.pose,
    required this.lengths,
    required this.camera,
    required this.color,
    required this.accent,
    required this.background,
    this.preview,
    this.hoverTarget,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _paintBackground(canvas, size);
    _paintFloor(canvas, size);

    final preview = this.preview;
    if (preview != null) {
      _paintArm(canvas, size, preview, opacity: 0.35);
    }
    _paintArm(canvas, size, pose, opacity: 1);

    final target = hoverTarget;
    if (target != null) {
      final projected = camera.project(target, size);
      if (projected != null) {
        _paintTarget(canvas, projected.screen, reached: preview != null);
      }
    }
  }

  /// Fills the view with a soft vertical gradient.
  void _paintBackground(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            background,
            Color.lerp(background, Colors.black, 0.3)!,
          ],
        ).createShader(rect),
    );
  }

  /// Draws the floor grid and the circle the fingertip can reach.
  void _paintFloor(Canvas canvas, Size size) {
    final reach = lengths.bar + lengths.forearm + lengths.gripper;
    final extent = reach * 1.35;
    final step = reach / 6;
    final grid = Paint()
      ..color = color.withValues(alpha: 0.1)
      ..strokeWidth = 1;

    for (var offset = -extent; offset <= extent + 1e-9; offset += step) {
      _drawSegment(
        canvas,
        size,
        ArmVector(offset, -extent, 0),
        ArmVector(offset, extent, 0),
        grid,
      );
      _drawSegment(
        canvas,
        size,
        ArmVector(-extent, offset, 0),
        ArmVector(extent, offset, 0),
        grid,
      );
    }

    // The fingertip can reach this circle when the arm is at floor height.
    final ring = Path();
    var started = false;
    for (var index = 0; index <= 72; index++) {
      final angle = 2 * pi * index / 72;
      final projected = camera.project(
        ArmVector(reach * cos(angle), reach * sin(angle), 0),
        size,
      );
      if (projected == null) {
        started = false;
        continue;
      }
      if (started) {
        ring.lineTo(projected.screen.dx, projected.screen.dy);
      } else {
        ring.moveTo(projected.screen.dx, projected.screen.dy);
        started = true;
      }
    }
    canvas.drawPath(
      ring,
      Paint()
        ..color = accent.withValues(alpha: 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  /// Draws a segment in world space, if both ends are in front of the camera.
  void _drawSegment(
    Canvas canvas,
    Size size,
    ArmVector start,
    ArmVector end,
    Paint paint,
  ) {
    final projectedStart = camera.project(start, size);
    final projectedEnd = camera.project(end, size);
    if (projectedStart == null || projectedEnd == null) return;
    canvas.drawLine(projectedStart.screen, projectedEnd.screen, paint);
  }

  /// Draws one pose of the arm, sorting the parts by depth.
  void _paintArm(
    Canvas canvas,
    Size size,
    ArmPose3d pose, {
    required double opacity,
  }) {
    final parts = <({double depth, void Function() draw})>[];

    void segment(ArmVector start, ArmVector end, Color tint, double radius) {
      final projectedStart = camera.project(start, size);
      final projectedEnd = camera.project(end, size);
      if (projectedStart == null || projectedEnd == null) return;
      final paint = Paint()
        ..color = tint.withValues(alpha: opacity)
        ..strokeWidth = max(
          3,
          radius * (projectedStart.pixelsPerMeter + projectedEnd.pixelsPerMeter),
        ).toDouble()
        ..strokeCap = StrokeCap.round;
      parts.add((
        depth: (projectedStart.depth + projectedEnd.depth) / 2,
        draw: () => canvas.drawLine(
          projectedStart.screen,
          projectedEnd.screen,
          paint,
        ),
      ));
    }

    void joint(ArmVector point, double radius, Color tint, {bool ring = false}) {
      final projected = camera.project(point, size);
      if (projected == null) return;
      final radiusOnScreen = max(4, radius * projected.pixelsPerMeter).toDouble();
      parts.add((
        depth: projected.depth,
        draw: () {
          if (ring) {
            canvas.drawCircle(
              projected.screen,
              radiusOnScreen,
              Paint()
                ..color = tint.withValues(alpha: opacity)
                ..style = PaintingStyle.stroke
                ..strokeWidth = 2,
            );
          } else {
            canvas.drawCircle(
              projected.screen,
              radiusOnScreen,
              Paint()..color = tint.withValues(alpha: opacity),
            );
          }
        },
      ));
    }

    // The base plate sits on the floor under the swivel.
    final basePlate = <Offset>[];
    for (final corner in [
      const ArmVector(-0.17, -0.17, 0),
      const ArmVector(0.17, -0.17, 0),
      const ArmVector(0.17, 0.17, 0),
      const ArmVector(-0.17, 0.17, 0),
    ]) {
      final projected = camera.project(corner, size);
      if (projected == null) {
        basePlate.clear();
        break;
      }
      basePlate.add(projected.screen);
    }
    if (basePlate.length == 4) {
      final outline = Path()..addPolygon(basePlate, true);
      canvas.drawPath(
        outline,
        Paint()..color = color.withValues(alpha: opacity * 0.2),
      );
      canvas.drawPath(
        outline,
        Paint()
          ..color = color.withValues(alpha: opacity * 0.35)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }

    // The pedestal carries the upper pivot and the lower motor's base pin.
    // The lower motor hangs on a link from that pin, so its bar can move
    // independently of the upper bar.
    segment(pose.base, pose.shoulder, color, 0.045);
    segment(pose.shoulder, pose.pivot, color, 0.032);
    segment(
      pose.pivot,
      pose.elbow,
      Color.lerp(color, accent, 0.45)!,
      0.04,
    );
    segment(pose.shoulder, pose.bracket, color, 0.034);
    segment(
      pose.elbow,
      pose.rear,
      Color.lerp(color, accent, 0.35)!,
      0.034,
    );

    // Both bars pin to the rigid coupler, which carries the next arm bar
    // parallel to it on the front pin.
    segment(pose.bracket, pose.rear, color, 0.032);

    // The forearm is parallel to the coupler and carries the gripper outward.
    segment(pose.output, pose.wrist, color, 0.028);
    segment(pose.wrist, pose.fingers, Colors.blue, 0.02);

    // Two prongs so the gripper reads as a gripper rather than a stick.
    final grip = (pose.fingers - pose.wrist).normalized;
    final normal = ArmVector.up.cross(grip).normalized;
    for (final spread in [0.35, -0.35]) {
      final prong =
          grip * cos(spread) + normal * sin(spread);
      segment(pose.fingers, pose.fingers + prong * 0.06, Colors.blue, 0.012);
    }

    // Joint housings.
    joint(pose.shoulder, 0.06, color);
    joint(pose.pivot, 0.04, color);
    joint(pose.elbow, 0.05, color);
    joint(pose.bracket, 0.05, accent, ring: true);
    joint(pose.rear, 0.032, accent, ring: true);
    joint(pose.wrist, 0.038, accent);

    parts.sort((a, b) => b.depth.compareTo(a.depth));
    for (final part in parts) {
      part.draw();
    }
  }

  /// Draws the crosshair where a click would put the fingertip.
  void _paintTarget(Canvas canvas, Offset center, {required bool reached}) {
    final tint = reached ? accent : Colors.red;
    canvas.drawCircle(
      center,
      10,
      Paint()..color = tint.withValues(alpha: 0.2),
    );
    final line = Paint()
      ..color = tint
      ..strokeWidth = 2;
    canvas.drawCircle(
      center,
      10,
      Paint()
        ..color = tint
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    canvas.drawLine(
      center - const Offset(15, 0),
      center + const Offset(15, 0),
      line,
    );
    canvas.drawLine(
      center - const Offset(0, 15),
      center + const Offset(0, 15),
      line,
    );
  }

  @override
  bool shouldRepaint(covariant ArmPainter3d oldDelegate) => true;
}

/// The arm page, showing the four-bar arm in 3D.
class ArmPage extends ReactiveWidget<ArmModel> {
  /// The index of this view.
  final int index;

  /// A const constructor.
  const ArmPage({required this.index});

  @override
  ArmModel createModel() => ArmModel();

  @override
  Widget build(BuildContext context, ArmModel model) {
    final swivel = model.pendingSwivel ?? model.angles.swivel;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(
          pageIndex: index,
          children: [
            const SizedBox(width: 8),
            Text("Arm", style: context.textTheme.headlineMedium),
            const SizedBox(width: 8),
            IconButton(
              tooltip: "Reset view",
              onPressed: model.resetCamera,
              icon: const Icon(Icons.center_focus_strong),
            ),
            const Spacer(),
            const Text("Laser Light"),
            const SizedBox(width: 5),
            Switch(
              activeThumbColor: Colors.red,
              value: model.desiredLaserState,
              onChanged: (value) => model.setLaser(laser: value),
            ),
            const SizedBox(width: 5),
            if (model.desiredLaserState == model.arm.laserState.toBool())
              const Tooltip(
                message: "The laser has been updated",
                child: Icon(Icons.check, color: Colors.green),
              )
            else
              const Tooltip(
                message: "Waiting for the laser to respond",
                child: Icon(Icons.sync),
              ),
            const SizedBox(width: 8),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          "3D View - drag to orbit, scroll to zoom, click to move the gripper; "
          "the base turns to reach beyond straight up",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.blue,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        Expanded(
          child: Card(
            margin: const EdgeInsets.all(16),
            elevation: 16,
            clipBehavior: Clip.antiAlias,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = constraints.biggest;
                return Listener(
                  onPointerSignal: (event) {
                    if (event is PointerScrollEvent) {
                      model.zoom(event.scrollDelta.dy);
                    }
                  },
                  child: MouseRegion(
                    onHover: (event) =>
                        model.onHover(event.localPosition, size),
                    onExit: (_) => model.cancelIK(),
                    cursor: SystemMouseCursors.grab,
                    child: GestureDetector(
                      onTapUp: (details) =>
                          model.sendIK(details.localPosition, size),
                      onPanUpdate: (details) => model.orbit(details.delta),
                      child: SizedBox.expand(
                        child: CustomPaint(
                          painter: ArmPainter3d(
                            pose: model.pose3d,
                            preview: model.previewPose,
                            lengths: model.lengths,
                            camera: model.camera,
                            hoverTarget: model.hoverTarget,
                            color: context.colorScheme.onSurface,
                            accent: context.colorScheme.primary,
                            background: context.colorScheme.surfaceContainer,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
          child: Row(
            children: [
              const Text("Swivel"),
              Expanded(
                child: Slider(
                  value: swivel.clamp(-pi, pi),
                  min: -pi,
                  max: pi,
                  onChanged: model.setSwivel,
                ),
              ),
              SizedBox(
                width: 56,
                child: Text(
                  "${(swivel * 180 / pi).round()}°",
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

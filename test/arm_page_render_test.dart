// Verification for the arm page's four-bar geometry, 3D view, IK, and painter.

import "dart:math";

import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/src/models/view/arm.dart";
import "package:rover_dashboard/src/models/view/arm3d.dart";
import "package:rover_dashboard/src/pages/arm.dart";

void main() {
  // The arm page takes its link lengths from the user's settings.
  setUpAll(() => models.settings.all = Settings.fromJson({}));

  const size = Size(800, 600);
  const lengths = (
    bar: 0.53,
    base: 0.13,
    bracket: 0.13,
    mount: 0.15,
    forearm: 0.10,
    gripper: 0.12,
  );

  /// Whether two line segments cross away from their shared ends.
  bool crosses(Offset a, Offset b, Offset c, Offset d) {
    double side(Offset start, Offset end, Offset point) =>
        (end.dx - start.dx) * (point.dy - start.dy) -
        (end.dy - start.dy) * (point.dx - start.dx);
    final first = side(a, b, c);
    final second = side(a, b, d);
    final third = side(c, d, a);
    final fourth = side(c, d, b);
    return first * second < 0 && third * fourth < 0;
  }

  /// Where the fingertip sits in the arm's side view, in meters.
  Offset planarFingertip(ArmSolution solution) => ArmModel.planarPose(
    solution.angles,
    lengths,
    nearMount: solution.mount,
  )!.fingers;

  test("the bars, coupler, and forearm stay rigid and parallel", () {
    final model = ArmModel();
    addTearDown(model.dispose);
    final solved = model.solveIK(const Offset(0.5, 0.3));
    expect(solved, isNotNull);

    for (final solution in [solved!]) {
      final pose = ArmModel.planarPose(
        solution.angles,
        lengths,
        nearMount: solution.mount,
      );
      expect(pose, isNotNull, reason: "the solved pose should close");

      expect(
        (pose!.pivot - pose.shoulder).distance,
        closeTo(lengths.base, 1e-9),
      );
      expect(
        (pose.elbow - pose.pivot).distance,
        closeTo(lengths.mount, 1e-9),
      );
      expect(
        (pose.bracket - pose.shoulder).distance,
        closeTo(lengths.bar, 1e-9),
      );
      expect(
        (pose.rear - pose.elbow).distance,
        closeTo(lengths.bar, 1e-9),
      );
      expect(
        (pose.rear - pose.bracket).distance,
        closeTo(lengths.bracket, 1e-9),
      );
      expect(
        (pose.wrist - pose.output).distance,
        closeTo(lengths.forearm, 1e-9),
      );
      expect(
        (pose.fingers - pose.wrist).distance,
        closeTo(lengths.gripper, 1e-9),
      );

      // The forearm is mounted on the front pin and runs parallel to the
      // coupler.
      expect((pose.output - pose.bracket).distance, lessThan(1e-9));
      final coupler = pose.rear - pose.bracket;
      final forearm = pose.wrist - pose.output;
      expect(
        (coupler.dx * forearm.dy - coupler.dy * forearm.dx).abs(),
        lessThan(1e-9),
      );

      // The lower motor hangs from its fixed base pin on a rigid link.
      expect(
        (pose.pivot - pose.shoulder).distance,
        closeTo(lengths.base, 1e-9),
      );
      expect(
        (pose.elbow - pose.pivot).distance,
        closeTo(lengths.mount, 1e-9),
      );
    }
  });

  test("the loop never stretches and the bars never cross", () {
    var closed = 0;
    for (var shoulder = 0.2; shoulder <= 1.7; shoulder += 0.1) {
      for (var elbow = 0.2; elbow <= 1.7; elbow += 0.1) {
        final pose = ArmModel.planarPose(
          (swivel: 0, shoulder: shoulder, elbow: elbow, pitch: 0.2),
          lengths,
        );
        // The coupler spans a limited distance, so some pairs of bar angles
        // cannot be assembled at all.
        if (pose == null) continue;
        closed++;

        expect(
          (pose.rear - pose.bracket).distance,
          closeTo(lengths.bracket, 1e-9),
        );
        expect(
          crosses(pose.shoulder, pose.bracket, pose.elbow, pose.rear),
          isFalse,
        );
      }
    }
    expect(closed, greaterThan(60));
  });

  test("IK puts the fingertip on the requested point", () {
    final model = ArmModel();
    addTearDown(model.dispose);

    var solvedCount = 0;
    for (var x = 0.1; x <= 0.9; x += 0.1) {
      for (var y = 0.0; y <= 0.8; y += 0.1) {
        final target = Offset(x, y);
        final solved = model.solveIK(target);
        // Points the four-bar's wrist curve cannot put the gripper on have no
        // solution.
        if (solved == null) continue;
        solvedCount++;

        final reached = planarFingertip(solved);
        expect(
          reached.dx,
          closeTo(target.dx, 1e-3),
          reason: "target $target should be reached on X",
        );
        expect(
          reached.dy,
          closeTo(target.dy, 1e-3),
          reason: "target $target should be reached on Y",
        );

        // Reaching a point in front of the base never turns the base.
        expect(solved.angles.swivel, closeTo(model.angles.swivel, 1e-12));

        // The solution is a pose the real linkage can assemble.
        final pose = ArmModel.planarPose(
          solved.angles,
          lengths,
          nearMount: solved.mount,
        )!;
        expect(
          crosses(pose.shoulder, pose.bracket, pose.elbow, pose.rear),
          isFalse,
        );
      }
    }
    expect(solvedCount, greaterThan(10));
  });

  test("IK never flips to the other assembly", () {
    final model = ArmModel();
    addTearDown(model.dispose);

    int side(Offset line, Offset point) {
      final cross = line.dx * point.dy - line.dy * point.dx;
      return cross > 1e-9 ? 1 : (cross < -1e-9 ? -1 : 0);
    }

    final current = ArmModel.planarPose(model.angles, lengths)!;
    final currentUpper = side(current.wrist, current.bracket);
    final currentMount = side(
      current.rear - current.pivot,
      current.elbow - current.pivot,
    );

    var checked = 0;
    for (var x = 0.2; x <= 0.7; x += 0.1) {
      for (var y = 0.1; y <= 0.6; y += 0.1) {
        final solved = model.solveIK(Offset(x, y));
        if (solved == null) continue;
        checked++;
        final pose = ArmModel.planarPose(
          solved.angles,
          lengths,
          nearMount: solved.mount,
        )!;
        expect(side(pose.wrist, pose.bracket), currentUpper);
        expect(
          side(
            pose.rear - pose.pivot,
            pose.elbow - pose.pivot,
          ),
          currentMount,
        );
      }
    }
    expect(checked, greaterThan(0));
  });

  test("points the arm cannot reach solve to null", () {
    final model = ArmModel();
    addTearDown(model.dispose);
    expect(model.solveIK(const Offset(3, 0)), isNull);
    expect(model.solveIK(const Offset(0.3, -2)), isNull);
    // The arm does not lean behind its base; it turns the base instead.
    expect(model.solveIK(const Offset(-0.4, 0.5)), isNull);
  });

  test("a point behind the base turns the swivel half a turn", () {
    final model = ArmModel();
    addTearDown(model.dispose);

    const point = ArmVector(-0.4, 0, 0.6);
    final projected = model.camera.project(point, size);
    expect(projected, isNotNull);

    model.onHover(projected!.screen, size);
    final preview = model.ikAngles;
    expect(preview, isNotNull);
    expect(
      ArmModel.planarPose(preview!, lengths, nearMount: model.ikMount),
      isNotNull,
    );
    expect(
      (preview.swivel - model.angles.swivel).abs(),
      closeTo(pi, 1e-6),
    );

    final reached = model.previewPose!.fingers;
    expect((reached - point).length, lessThan(0.01));
  });

  test("hovering solves a pose that reaches the picked point", () {
    final model = ArmModel();
    addTearDown(model.dispose);

    const point = ArmVector(0.5, 0, 0.4);
    final projected = model.camera.project(point, size)!;
    model.onHover(projected.screen, size);

    expect(model.hoverTarget, isNotNull);
    final preview = model.previewPose;
    expect(preview, isNotNull);
    expect((preview!.fingers - point).length, lessThan(0.01));
  });

  test("the old wide coupler setting moves to the close spacing", () {
    final old = ArmSettings.fromJson({"bracketLength": 0.26});
    expect(old.bracketLength, 0.13);

    final changed = ArmSettings.fromJson({"bracketLength": 0.16});
    expect(changed.bracketLength, 0.16);
  });

  test("link lengths come from the arm settings", () {
    final settings = ArmSettings.fromJson({
      "upperArmLength": 0.6,
      "baseOffset": 0.14,
      "bracketLength": 0.3,
      "motorMountLength": 0.2,
      "forearmLength": 0.12,
      "gripperLength": 0.15,
    });
    expect(
      settings.lengths,
      (
        bar: 0.6,
        base: 0.14,
        bracket: 0.3,
        mount: 0.2,
        forearm: 0.12,
        gripper: 0.15,
      ),
    );

    final json = settings.toJson();
    expect(json["upperArmLength"], 0.6);
    expect(json["baseOffset"], 0.14);
    expect(json["bracketLength"], 0.3);
    expect(json["motorMountLength"], 0.2);
    expect(json["forearmLength"], 0.12);
    expect(json["gripperLength"], 0.15);
  });

  test("the arm page draws the configured link lengths", () {
    const custom = (
      bar: 0.6,
      base: 0.14,
      bracket: 0.3,
      mount: 0.2,
      forearm: 0.12,
      gripper: 0.15,
    );
    final pose = ArmModel.getPose3d(
      (swivel: 0, shoulder: pi / 3, elbow: pi / 3, pitch: 0),
      custom,
    );
    expect(pose, isNotNull);
    expect(
      (pose!.bracket - pose.shoulder).length,
      closeTo(custom.bar, 1e-9),
    );
    expect((pose.pivot - pose.shoulder).length, closeTo(custom.base, 1e-9));
    expect((pose.elbow - pose.pivot).length, closeTo(custom.mount, 1e-9));
    expect((pose.rear - pose.bracket).length, closeTo(custom.bracket, 1e-9));
    expect((pose.wrist - pose.output).length, closeTo(custom.forearm, 1e-9));
    expect((pose.fingers - pose.wrist).length, closeTo(custom.gripper, 1e-9));
  });

  test("a projected point picks back onto the arm plane", () {
    final model = ArmModel();
    addTearDown(model.dispose);

    const point = ArmVector(0.6, 0, 0.4);
    final projected = model.camera.project(point, size);
    expect(projected, isNotNull);

    final picked = model.targetOnArmPlane(projected!.screen, size);
    expect(picked, isNotNull);
    expect((picked! - point).length, lessThan(1e-6));
  });

  testWidgets("the 3D painter draws without throwing", (tester) async {
    const painterLengths = (
      bar: 0.6,
      base: 0.14,
      bracket: 0.3,
      mount: 0.2,
      forearm: 0.12,
      gripper: 0.15,
    );
    final pose = ArmModel.getPose3d(
      (swivel: 0.3, shoulder: pi / 3, elbow: pi / 3, pitch: 0.2),
      painterLengths,
    )!;
    final preview = ArmModel.getPose3d(
      (swivel: 0.3 + pi, shoulder: pi / 3, elbow: pi / 3, pitch: 0.4),
      painterLengths,
    );

    for (final canvas in [const Size(800, 600), const Size(380, 260)]) {
      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: SizedBox(
              width: canvas.width,
              height: canvas.height,
              child: CustomPaint(
                size: canvas,
                painter: ArmPainter3d(
                  pose: pose,
                  preview: preview,
                  lengths: painterLengths,
                  camera: ArmCamera(),
                  hoverTarget: const ArmVector(0.5, 0.1, 0.4),
                  color: Colors.white,
                  accent: Colors.teal,
                  background: Colors.grey,
                ),
              ),
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
    }
  });
}

import "dart:math";

import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/src/models/view/arm.dart";
import "package:rover_dashboard/src/models/view/arm3d.dart";

/// Whether two segments touch or cross anywhere, including collinear overlap.
bool segmentsIntersect(Offset p1, Offset p2, Offset q1, Offset q2) {
  const eps = 1e-9;
  double cross(Offset a, Offset b, Offset c) =>
      (b.dx - a.dx) * (c.dy - a.dy) - (b.dy - a.dy) * (c.dx - a.dx);
  double dot(Offset a, Offset b) => a.dx * b.dx + a.dy * b.dy;
  bool within(Offset a, Offset b, Offset p) {
    final ab = b - a;
    final ap = p - a;
    final length = ab.distance;
    if (length < eps) return ap.distance < eps;
    final t = dot(ap, ab) / (length * length);
    if (t < -eps || t > 1 + eps) return false;
    final closest = a + ab * t;
    return (p - closest).distance < 1e-7;
  }

  final d1 = cross(q1, q2, p1);
  final d2 = cross(q1, q2, p2);
  final d3 = cross(p1, p2, q1);
  final d4 = cross(p1, p2, q2);
  if (((d1 > eps && d2 < -eps) || (d1 < -eps && d2 > eps)) &&
      ((d3 > eps && d4 < -eps) || (d3 < -eps && d4 > eps))) {
    return true;
  }
  if (d1.abs() <= eps && within(q1, q2, p1)) return true;
  if (d2.abs() <= eps && within(q1, q2, p2)) return true;
  if (d3.abs() <= eps && within(p1, p2, q1)) return true;
  if (d4.abs() <= eps && within(p1, p2, q2)) return true;
  return false;
}

void main() {
  setUpAll(() => models.settings.all = Settings.fromJson({}));

  const lengths = (
    bar: 0.53,
    base: 0.13,
    bracket: 0.13,
    mount: 0.15,
    forearm: 0.10,
    gripper: 0.12,
  );

  /// Whether the drawn links match the configured linkage.
  List<String> rigidFaults(ArmPlanarPose pose) {
    final faults = <String>[];
    if (((pose.pivot - pose.shoulder).distance - lengths.base).abs() > 1e-6) {
      faults.add("base pin spacing");
    }
    if (((pose.elbow - pose.pivot).distance - lengths.mount).abs() > 1e-6) {
      faults.add("motor mount length");
    }
    if (((pose.bracket - pose.shoulder).distance - lengths.bar).abs() > 1e-6) {
      faults.add("first bar length");
    }
    if (((pose.rear - pose.elbow).distance - lengths.bar).abs() > 1e-6) {
      faults.add("second bar length");
    }
    if (((pose.rear - pose.bracket).distance - lengths.bracket).abs() > 1e-6) {
      faults.add("coupler length");
    }
    if (((pose.wrist - pose.output).distance - lengths.forearm).abs() > 1e-6) {
      faults.add("forearm length");
    }
    if (((pose.fingers - pose.wrist).distance - lengths.gripper).abs() > 1e-6) {
      faults.add("gripper length");
    }
    if ((pose.output - pose.bracket).distance > 1e-9) {
      faults.add("forearm is not on the front pin");
    }
    final coupler = pose.rear - pose.bracket;
    final forearm = pose.wrist - pose.output;
    final cross = coupler.dx * forearm.dy - coupler.dy * forearm.dx;
    if (cross.abs() > coupler.distance * forearm.distance * 1e-9) {
      faults.add("forearm is not parallel to the coupler");
    }
    return faults;
  }

  test("every pair of bar angles closes with rigid links", () {
    const step = 2 * pi / 72;
    var assembled = 0;
    var rejected = 0;
    var crossings = 0;
    var faults = 0;
    for (var shoulder = -pi; shoulder < pi; shoulder += step) {
      for (var elbow = -pi; elbow < pi; elbow += step) {
        final angles = (
          swivel: 0.0,
          shoulder: shoulder,
          elbow: elbow,
          pitch: 0.3,
        );
        final pose = ArmModel.planarPose(angles, lengths);
        if (pose == null) {
          rejected++;
          continue;
        }
        assembled++;
        if (rigidFaults(pose).isNotEmpty) faults++;
        if (segmentsIntersect(
          pose.shoulder,
          pose.bracket,
          pose.elbow,
          pose.rear,
        )) {
          crossings++;
        }
      }
    }
    // ignore: avoid_print
    print(
      "bar-angle pairs: assembled=$assembled rejected=$rejected "
      "twoBarCrossings=$crossings faults=$faults",
    );

    expect(assembled, greaterThan(400));
    expect(crossings, 0);
    expect(faults, 0);
  });

  test("every reachable IK target is rigid and exact", () {
    final model = ArmModel();
    addTearDown(model.dispose);
    var solved = 0;
    var faults = 0;
    var missed = 0;
    var crossings = 0;
    for (var x = 0.0; x <= 0.9; x += 0.02) {
      for (var y = -0.03; y <= 0.9; y += 0.02) {
        final target = Offset(x, y);
        final solution = model.solveIK(target);
        if (solution == null) continue;
        solved++;
        final pose = ArmModel.planarPose(
          solution.angles,
          lengths,
          nearMount: solution.mount,
        )!;
        if ((pose.fingers - target).distance > 1e-4) missed++;
        if (segmentsIntersect(
          pose.shoulder,
          pose.bracket,
          pose.elbow,
          pose.rear,
        )) {
          crossings++;
        }
        if (rigidFaults(pose).isNotEmpty) faults++;
      }
    }
    // ignore: avoid_print
    print(
      "IK targets: solved=$solved twoBarCrossings=$crossings "
      "faults=$faults missed=$missed",
    );

    expect(solved, greaterThan(500));
    expect(crossings, 0);
    expect(faults, 0);
    expect(missed, 0);
  });

  test("every planned behind-the-base target stays rigid", () {
    final model = ArmModel();
    addTearDown(model.dispose);
    var checked = 0;
    var faults = 0;
    var missed = 0;
    var crossings = 0;
    for (var x = -0.9; x <= -0.02; x += 0.05) {
      for (var y = 0.0; y <= 0.9; y += 0.05) {
        final point = ArmVector(x, 0, y + ArmModel.baseHeight);
        final plan = model.planFor(point);
        if (plan == null) continue;
        checked++;
        final pose = ArmModel.planarPose(
          plan.angles,
          lengths,
          nearMount: plan.mount,
        )!;
        if (rigidFaults(pose).isNotEmpty) faults++;
        if (segmentsIntersect(
          pose.shoulder,
          pose.bracket,
          pose.elbow,
          pose.rear,
        )) {
          crossings++;
        }
        final reached = ArmModel.getPose3d(
          plan.angles,
          lengths,
          nearMount: plan.mount,
        )!.fingers;
        if ((reached - point).length > 0.01) missed++;
      }
    }
    // ignore: avoid_print
    print(
      "behind targets: checked=$checked twoBarCrossings=$crossings "
      "faults=$faults missed=$missed",
    );

    expect(checked, greaterThan(100));
    expect(crossings, 0);
    expect(faults, 0);
    expect(missed, 0);
  });
}

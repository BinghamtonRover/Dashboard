// Verification for the QuIK inverse kinematics solver.

import "dart:math";
import "dart:ui";

import "package:flutter_test/flutter_test.dart";
import "package:rover_dashboard/src/models/view/quik.dart";

void main() {
  /// A simple two-link planar arm with unit links.
  Offset? twoLinks(Joints joints) => Offset(
    cos(joints[0]) + cos(joints[0] + joints[1]),
    sin(joints[0]) + sin(joints[0] + joints[1]),
  );

  /// A redundant three-link planar arm: three joints for two coordinates.
  Offset? threeLinks(Joints joints) {
    final second = joints[0] + joints[1];
    final third = second + joints[2];
    return Offset(
      cos(joints[0]) + cos(second) + 0.6 * cos(third),
      sin(joints[0]) + sin(second) + 0.6 * sin(third),
    );
  }

  test("QuIK solves a two-link arm from a poor guess", () {
    final solver = QuikSolver(joints: 2, fingers: twoLinks, reach: 2);
    const target = Offset(1.2, 0.6);

    final solved = solver.solve(target, [0, 0]);
    expect(solved, isNotNull);
    final reached = twoLinks(solved!)!;
    expect((target - reached).distance, lessThan(1e-3));
  });

  test("QuIK solves a redundant chain with all its joints", () {
    final solver = QuikSolver(joints: 3, fingers: threeLinks, reach: 2.6);
    final target = threeLinks([0.5, 0.4, 0.3])!;

    final solved = solver.solve(target, [-0.2, 0.2, -0.2]);
    expect(solved, isNotNull);
    final reached = threeLinks(solved!)!;
    expect((target - reached).distance, lessThan(1e-3));

    // The redundant solve moves the chain from its guess rather than leaving
    // one of the joints at its starting angle.
    expect(solved.any((angle) => angle.abs() > 1e-3), isTrue);
  });

  test("QuIK gives up on a target it cannot reach", () {
    final solver = QuikSolver(joints: 2, fingers: twoLinks, reach: 2);
    expect(solver.solve(const Offset(3, 0), [0, 0]), isNull);
  });

  test("QuIK leaves an already-solved pose alone", () {
    final solver = QuikSolver(joints: 2, fingers: twoLinks, reach: 2);
    final target = twoLinks([0.4, 0.7]);
    expect(target, isNotNull);

    final solved = solver.solve(target!, [0.4, 0.7]);
    expect(solved, isNotNull);
    expect(solved![0], closeTo(0.4, 1e-9));
    expect(solved[1], closeTo(0.7, 1e-9));
  });
}

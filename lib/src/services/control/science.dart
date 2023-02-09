import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/services.dart";
import "../service.dart";

/// A service to send commands to the Rover when it is the [ScienceControl] mode
class ScienceControl extends Service {
  @override
  Future<void> init() async {}

  @override
  Future<void> dispose() async {}

  /// Command to tell the rover to dig
  void dig({required bool isDigging}){
    services.messageSender.sendMessage(ScienceCommand(dig: isDigging));
  }

  /// Command to spin the carousel tube
  void spinCarouselTube({required bool isSpinning}){
    services.messageSender.sendMessage(ScienceCommand(spinCarouselTube: isSpinning));
  }

  /// Command to spin the carousel section
  void spinCarouselSections({required bool isSpinning}){
    services.messageSender.sendMessage(ScienceCommand(spinCarouselSection: isSpinning));
  }

  /// Command to turn on Vacuum
  void vacuumOn({required bool isOn}){
    services.messageSender.sendMessage(ScienceCommand(vacuumSuck: isOn));
  }

  /// Command to change carousel angle
  void setCarouselAngle(double angle){
    services.messageSender.sendMessage(ScienceCommand(carouselAngle: angle));
  }

  /// Command to change carousel position
  void setCarouselLinearPosition(double pos){
    services.messageSender.sendMessage(ScienceCommand(carouselLinearPosition: pos));
  }

  /// Command to change test tube position
  void setTestLinearPosition(double pos){
    services.messageSender.sendMessage(ScienceCommand(testLinearPosition: pos));
  }

  /// Command to change vacuum tube position
  void setVacuumLinearPosition(double pos){
    services.messageSender.sendMessage(ScienceCommand(vacuumLinearPosition: pos));
  }

  /// Turn vacuum on/off.
  void vacuumPower({required bool status}) {}

  /// Turn pump 1 on/off.
  void pump1({required bool status}) {}

  /// Turn pump 1 on/off.
  void pump2({required bool status}) {}

  /// Turn pump 1 on/off.
  void pump3({required bool status}) {}

  /// Turn pump 1 on/off.
  void pump4({required bool status}) {}
}

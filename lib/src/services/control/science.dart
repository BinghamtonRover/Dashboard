import "package:rover_dashboard/services.dart";
import "../service.dart";

/// A service to send commands to the Rover when it is the [ScienceControl] mode
class ScienceControl extends Service {
  @override
  Future<void> init() async {}

  @override
  Future<void> dispose() async {}

  void moveCarouselHorizontally(double degree) {
    //final message = ScienceCommand(move_carousel_horizontally: degree);
    //services.messageSender.sendMessage(message);
  }

  void rotateCarousel(double degree) {
    //final message = ScienceCommand(rotate_carousel: degree);
    //services.messageSender.sendMessage(message);
  }

  void moveTestingSuite(double mm) {
    //final message = ScienceCommand(move_testing_suite: mm);
    //services.messageSender.sendMessage(message);
  }

  void moveDirtCollection(double mm) {
    //final message = ScienceCommand(move_dirt_collection: mm);
    //services.messageSender.sendMessage(message);
  }

  void vacuumPower({required bool b}) {}

  void pump1({required bool status}) {}

  void pump2({required bool status}) {}

  void pump3({required bool status}) {}

  void pump4({required bool status}) {}
}

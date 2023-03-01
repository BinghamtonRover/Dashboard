import "controller.dart";

/// A controller that does nothing.
class StubController extends Controller {
	@override
	List<Message> parseInputs(GamepadState state) => [];

	@override
	List<Message> get onDispose => [];

	@override
	Map<String, String> get controls => {};
}

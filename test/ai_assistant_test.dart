// Verification for the AI assistant's tool calls and dashboard view bindings.

import "package:flutter_test/flutter_test.dart";
import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/src/models/view/ai_assistant.dart";
import "package:rover_dashboard/src/services/ai/ollama.dart";

/// An Ollama service that returns scripted tool calls instead of calling a
/// model, so the binding path can be tested without a running server.
class FakeOllama extends OllamaService {
  /// Creates a fake that requests [calls] on the next message.
  FakeOllama(this.calls, {this.content = ""});

  /// The tool calls to return.
  final List<AiToolCall> calls;

  /// The text to return alongside the tool calls.
  final String content;

  /// The messages sent to the service.
  final List<List<AiMessage>> messages = [];

  /// The tools advertised to the service.
  final List<List<AiTool>> tools = [];

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<AiResponse> chat({
    required List<AiMessage> messages,
    List<AiTool> tools = const [],
    double temperature = 0.7,
  }) async {
    this.messages.add(messages);
    this.tools.add(tools);
    return AiResponse(
      message: AiMessage.assistant(content, toolCalls: calls),
    );
  }

  @override
  void dispose() {}
}

/// Builds a tool call for [name].
AiToolCall call(String name, [Map<String, dynamic> arguments = const {}]) =>
    AiToolCall(
      id: name,
      type: "function",
      function: AiToolFunction(name: name, arguments: arguments),
    );

void main() {
  setUpAll(() => models.settings.all = Settings.fromJson({}));

  setUp(() => models.views.views = [DashboardView.blank]);

  test("the prompt advertises the dashboard view bindings", () async {
    final ollama = FakeOllama([]);
    final model = AiAssistantModel(ollama: ollama);
    addTearDown(model.dispose);

    await model.sendMessage("what can you do?");

    final names = ollama.tools.single.map((tool) => tool.name).toSet();
    expect(
      names,
      containsAll(["view_show_page", "view_set_layout", "view_clear_pane"]),
    );
    final show = ollama.tools.single.firstWhere(
      (tool) => tool.name == "view_show_page",
    );
    expect(show.description, contains(Routes.arm));
    expect(show.description, contains("Rover front"));
  });

  test("view_show_page puts a page in the chosen pane", () async {
    models.views.views = [DashboardView.blank, DashboardView.blank];
    final ollama = FakeOllama([
      call("view_show_page", {"page": Routes.arm, "index": 1}),
    ]);
    final model = AiAssistantModel(ollama: ollama);
    addTearDown(model.dispose);

    await model.sendMessage("put the arm page on the right");

    expect(models.views.views[0].name, Routes.blank);
    expect(models.views.views[1].name, Routes.arm);
    expect(model.pendingActions, isEmpty);
  });

  test("tool calls written as JSON in the reply are still executed", () async {
    // phi4-mini returns calls in the message text rather than in `tool_calls`.
    final ollama = FakeOllama(
      [],
      content:
          '[{"name": "view_show_page", "arguments": {"page": "Arm"}}]',
    );
    final model = AiAssistantModel(ollama: ollama);
    addTearDown(model.dispose);

    await model.sendMessage("show the arm page");

    expect(models.views.views.single.name, Routes.arm);
    expect(model.messages.last.content, contains('Showing "Arm"'));
    expect(model.messages.last.content, isNot(contains('"name"')));
  });

  test("a short page name still finds the right view", () async {
    final ollama = FakeOllama([
      call("view_show_page", {"page": "Science"}),
    ]);
    final model = AiAssistantModel(ollama: ollama);
    addTearDown(model.dispose);

    await model.sendMessage("open a view with a science page");

    expect(models.views.views.single.name, Routes.science);
    expect(model.messages.last.content, contains("Science Analysis"));
  });

  test("view_add_page opens a page in a new pane when there is room", () async {
    final assistant = DashboardView.uiViews.firstWhere(
      (view) => view.name == Routes.aiAssistant,
    );
    models.views.views = [assistant];
    final ollama = FakeOllama([
      call("view_add_page", {"page": Routes.science}),
    ]);
    final model = AiAssistantModel(ollama: ollama);
    addTearDown(model.dispose);

    await model.sendMessage("open a new view with a science page");

    expect(models.views.views, hasLength(2));
    expect(models.views.views[0].name, Routes.aiAssistant);
    expect(models.views.views[1].name, Routes.science);
  });

  test("a page goes to a spare pane instead of replacing the assistant", () async {
    final assistant = DashboardView.uiViews.firstWhere(
      (view) => view.name == Routes.aiAssistant,
    );
    models.views.views = [assistant, DashboardView.blank];
    final ollama = FakeOllama([
      call("view_show_page", {"page": Routes.arm}),
    ]);
    final model = AiAssistantModel(ollama: ollama);
    addTearDown(model.dispose);

    await model.sendMessage("show the arm page");

    expect(models.views.views[0].name, Routes.aiAssistant);
    expect(models.views.views[1].name, Routes.arm);
  });

  test("view_show_page accepts a camera feed too", () async {
    final ollama = FakeOllama([
      call("view_show_page", {"page": "Rover front"}),
    ]);
    final model = AiAssistantModel(ollama: ollama);
    addTearDown(model.dispose);

    await model.sendMessage("show the front camera");

    expect(models.views.views.single.key, CameraName.ROVER_FRONT);
  });

  test("view_set_layout changes how many panes are shown", () async {
    final ollama = FakeOllama([
      call("view_set_layout", {"panes": 4}),
    ]);
    final model = AiAssistantModel(ollama: ollama);
    addTearDown(model.dispose);

    await model.sendMessage("split it into four");

    expect(models.views.views, hasLength(4));
    expect(models.views.views.every((view) => view.name == Routes.blank), isTrue);
  });

  test("view_set_layout refuses layouts the dashboard cannot draw", () async {
    final ollama = FakeOllama([
      call("view_set_layout", {"panes": 6}),
    ]);
    final model = AiAssistantModel(ollama: ollama);
    addTearDown(model.dispose);

    await model.sendMessage("give me six panes");

    expect(models.views.views, hasLength(1));
  });

  test("view_clear_pane empties a pane without changing the layout", () async {
    models.views.views = [DashboardView.uiViews.first, DashboardView.blank];
    final ollama = FakeOllama([
      call("view_clear_pane", {"index": 0}),
    ]);
    final model = AiAssistantModel(ollama: ollama);
    addTearDown(model.dispose);

    await model.sendMessage("clear the left pane");

    expect(models.views.views, hasLength(2));
    expect(models.views.views.first.name, Routes.blank);
  });

  test("a layout command in prose still splits the dashboard", () async {
    final ollama = FakeOllama(
      [],
      content: "I'm splitting the dashboard into four panes.",
    );
    final model = AiAssistantModel(ollama: ollama);
    addTearDown(model.dispose);

    await model.sendMessage("split the dashboard into four panes");

    expect(models.views.views, hasLength(4));
    expect(model.messages.last.content, contains("4 panes"));
  });

  test("a pane named in the message is the pane that changes", () async {
    final ollama = FakeOllama([], content: "Sure thing.");
    final model = AiAssistantModel(ollama: ollama);
    addTearDown(model.dispose);

    await model.sendMessage("make the first pane show a map");

    expect(models.views.views.single.name, Routes.autonomy);
  });

  test("a prose new-view request still adds a pane", () async {
    final assistant = DashboardView.uiViews.firstWhere(
      (view) => view.name == Routes.aiAssistant,
    );
    models.views.views = [assistant];
    final ollama = FakeOllama([], content: "Okay.");
    final model = AiAssistantModel(ollama: ollama);
    addTearDown(model.dispose);

    await model.sendMessage("open a new view with a science page");

    expect(models.views.views, hasLength(2));
    expect(models.views.views[1].name, Routes.science);
  });

  test("a question about a page does not change the dashboard", () async {
    final ollama = FakeOllama(
      [],
      content: "The arm is a four-bar linkage.",
    );
    final model = AiAssistantModel(ollama: ollama);
    addTearDown(model.dispose);

    await model.sendMessage("show me how the arm works");

    expect(models.views.views.single.name, Routes.blank);
    expect(model.messages.last.content, contains("four-bar"));
  });

  test("hardware actions wait for operator confirmation", () async {
    final ollama = FakeOllama([
      call("arm_swivel_set_angle", {"angle": 1.25}),
    ]);
    final model = AiAssistantModel(ollama: ollama);
    addTearDown(model.dispose);

    await model.sendMessage("turn the arm a bit");

    expect(model.pendingActions, hasLength(1));
    expect(
      model.pendingActions.single.description,
      contains("1.25 rad"),
    );
  });
}

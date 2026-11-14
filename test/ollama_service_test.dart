// Verification for the Ollama chat service used by the AI assistant.

import "dart:convert";

import "package:flutter_test/flutter_test.dart";
import "package:http/http.dart" as http;
import "package:http/testing.dart";
import "package:rover_dashboard/src/services/ai/ollama.dart";

void main() {
  test("isAvailable requires the configured model", () async {
    final up = OllamaService(
      client: MockClient((request) async {
        expect(request.url.path, "/api/tags");
        return http.Response(
          jsonEncode({
            "models": [
              {"name": "phi4-mini:latest"},
            ],
          }),
          200,
        );
      }),
    );
    expect(await up.isAvailable(), isTrue);

    final wrongModel = OllamaService(
      client: MockClient(
        (request) async => http.Response(
          jsonEncode({
            "models": [
              {"name": "llama3.2:latest"},
            ],
          }),
          200,
        ),
      ),
    );
    expect(await wrongModel.isAvailable(), isFalse);

    final down = OllamaService(
      client: MockClient((request) async => http.Response("nope", 503)),
    );
    expect(await down.isAvailable(), isFalse);
  });

  test("chat sends the conversation, tools, and temperature", () async {
    late Map<String, dynamic> body;
    final service = OllamaService(
      client: MockClient((request) async {
        expect(request.url.path, "/api/chat");
        body = jsonDecode(request.body) as Map<String, dynamic>;
        return http.Response(
          jsonEncode({
            "message": {
              "role": "assistant",
              "content": "",
              "tool_calls": [
                {
                  "function": {
                    "name": "view_show_page",
                    "arguments": {"page": "Arm", "index": 1},
                  },
                },
              ],
            },
          }),
          200,
        );
      }),
    );

    final response = await service.chat(
      messages: [AiMessage.user("show the arm")],
      tools: const [
        AiTool(
          name: "view_show_page",
          description: "Show a page.",
          parameters: {
            "type": "object",
            "properties": {
              "page": {"type": "string"},
            },
            "required": ["page"],
          },
        ),
      ],
      temperature: 0.2,
    );

    expect(body["model"], OllamaService.defaultModel);
    expect(body["stream"], isFalse);
    expect(body["options"], {"temperature": 0.2});
    expect(body["messages"], [
      {"role": "user", "content": "show the arm"},
    ]);
    expect(body["tools"], [
      {
        "type": "function",
        "function": {
          "name": "view_show_page",
          "description": "Show a page.",
          "parameters": {
            "type": "object",
            "properties": {
              "page": {"type": "string"},
            },
            "required": ["page"],
          },
        },
      },
    ]);

    final toolCall = response.message.toolCalls.single;
    expect(toolCall.function.name, "view_show_page");
    expect(toolCall.function.arguments["page"], "Arm");
    expect(toolCall.function.arguments["index"], 1);
  });

  test("chat parses arguments that a model stringifies", () async {
    final service = OllamaService(
      client: MockClient(
        (request) async => http.Response(
          jsonEncode({
            "message": {
              "role": "assistant",
              "content": "",
              "tool_calls": [
                {
                  "function": {
                    "name": "view_set_layout",
                    "arguments": "{\"panes\": 4}",
                  },
                },
              ],
            },
          }),
          200,
        ),
      ),
    );

    final response = await service.chat(messages: [AiMessage.user("split it")]);

    expect(
      response.message.toolCalls.single.function.arguments,
      {"panes": 4},
    );
  });

  test("chat reports an unreachable or unhappy server", () async {
    final service = OllamaService(
      client: MockClient((request) async => http.Response("model not found", 404)),
    );

    await expectLater(
      service.chat(messages: [AiMessage.user("hi")]),
      throwsA(isA<AiServiceException>()),
    );
  });
}

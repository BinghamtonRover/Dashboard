import "dart:async";
import "dart:convert";

import "package:http/http.dart" as http;

/// The model Ollama serves by default for the dashboard assistant.
const String defaultAiModel = "phi4-mini";

/// A single message in an AI conversation.
class AiMessage {
  /// A const constructor.
  const AiMessage({
    required this.role,
    this.content = "",
    this.toolCalls = const [],
  });

  /// Parses a message from an Ollama response.
  factory AiMessage.fromJson(Map<String, dynamic> json) {
    final rawCalls = json["tool_calls"];
    return AiMessage(
      role: json["role"] as String? ?? "assistant",
      content: json["content"] as String? ?? "",
      toolCalls: [
        if (rawCalls is List)
          for (final call in rawCalls)
            if (call is Map<String, dynamic>) AiToolCall.fromJson(call),
      ],
    );
  }

  /// Creates a user message.
  factory AiMessage.user(String content) =>
      AiMessage(role: "user", content: content);

  /// Creates an assistant message.
  factory AiMessage.assistant(
    String content, {
    List<AiToolCall> toolCalls = const [],
  }) => AiMessage(role: "assistant", content: content, toolCalls: toolCalls);

  /// Creates a system message.
  factory AiMessage.system(String content) =>
      AiMessage(role: "system", content: content);

  /// Who sent the message: `system`, `user`, `assistant`, or `tool`.
  final String role;

  /// The text of the message.
  final String content;

  /// Operations the model wants to run.
  final List<AiToolCall> toolCalls;
}

/// A tool call requested by the model.
class AiToolCall {
  /// A const constructor.
  const AiToolCall({
    required this.id,
    required this.type,
    required this.function,
  });

  /// Parses a tool call from an Ollama response.
  factory AiToolCall.fromJson(Map<String, dynamic> json) {
    final function = json["function"];
    return AiToolCall(
      id: json["id"] as String? ?? "",
      type: json["type"] as String? ?? "function",
      function: AiToolFunction.fromJson(
        function is Map<String, dynamic> ? function : const {},
      ),
    );
  }

  /// The ID of the call, if Ollama assigned one.
  final String id;

  /// The call type. Ollama only uses `function`.
  final String type;

  /// The function the model wants to run.
  final AiToolFunction function;
}

/// A function the model wants to run and its arguments.
class AiToolFunction {
  /// A const constructor.
  const AiToolFunction({required this.name, required this.arguments});

  /// Parses a function call from an Ollama response.
  ///
  /// Ollama returns arguments as a JSON object, but some models stringify them,
  /// so both forms are accepted.
  factory AiToolFunction.fromJson(Map<String, dynamic> json) {
    final raw = json["arguments"];
    var arguments = <String, dynamic>{};
    if (raw is Map) {
      arguments = {
        for (final entry in raw.entries) entry.key.toString(): entry.value,
      };
    } else if (raw is String) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map) {
          arguments = {
            for (final entry in decoded.entries)
              entry.key.toString(): entry.value,
          };
        }
      } on FormatException {
        // Leave the arguments empty; the binding will report what is missing.
      }
    }
    return AiToolFunction(
      name: json["name"] as String? ?? "",
      arguments: arguments,
    );
  }

  /// The name of the operation to run.
  final String name;

  /// The arguments to the operation.
  final Map<String, dynamic> arguments;
}

/// An operation the model is allowed to call.
class AiTool {
  /// A const constructor.
  const AiTool({
    required this.name,
    required this.description,
    required this.parameters,
  });

  /// The binding name, which is also the function name the model calls.
  final String name;

  /// What the operation does, in words the model can understand.
  final String description;

  /// A JSON schema describing the operation's arguments.
  final Map<String, dynamic> parameters;

  /// Converts this tool into the format Ollama expects.
  Map<String, dynamic> toJson() => {
    "type": "function",
    "function": {
      "name": name,
      "description": description,
      "parameters": parameters,
    },
  };
}

/// A response from the AI service.
class AiResponse {
  /// A const constructor.
  const AiResponse({required this.message});

  /// The assistant's reply.
  final AiMessage message;
}

/// An error raised while talking to the AI service.
class AiServiceException implements Exception {
  /// A const constructor.
  const AiServiceException(this.message);

  /// What went wrong.
  final String message;

  @override
  String toString() => message;
}

/// Talks to a local Ollama server.
///
/// The dashboard uses Ollama so the assistant runs on the operator's machine
/// without sending rover data to a third party.
class OllamaService {
  /// Creates a service. A custom [client] and [baseUrl] make it testable.
  OllamaService({http.Client? client, Uri? baseUrl})
    : _client = client ?? http.Client(),
      baseUrl =
          baseUrl ??
          Uri(scheme: "http", host: "127.0.0.1", port: 11434);

  /// The model used when the operator has not chosen one.
  static const String defaultModel = defaultAiModel;

  /// The HTTP client used to reach Ollama.
  final http.Client _client;

  /// Where Ollama is listening.
  final Uri baseUrl;

  /// The model to use for chat requests.
  String model = defaultModel;

  /// Whether Ollama is running and has the model installed.
  Future<bool> isAvailable() async {
    try {
      final response = await _client
          .get(baseUrl.resolve("/api/tags"))
          .timeout(const Duration(seconds: 3));
      if (response.statusCode != 200) return false;
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) return false;
      final models = decoded["models"];
      if (models is! List) return false;
      return models.any((entry) {
        if (entry is! Map) return false;
        final name = entry["name"];
        return name is String &&
            (name == model || name.startsWith("$model:"));
      });
    } on Exception {
      return false;
    }
  }

  /// Sends the conversation to Ollama and returns the assistant's reply.
  ///
  /// [tools] describes the operations the model may call. Ollama decides
  /// whether to answer in text or request one or more tool calls.
  Future<AiResponse> chat({
    required List<AiMessage> messages,
    List<AiTool> tools = const [],
    double temperature = 0.7,
  }) async {
    final body = <String, dynamic>{
      "model": model,
      "messages": [
        for (final message in messages)
          {"role": message.role, "content": message.content},
      ],
      "stream": false,
      "options": {"temperature": temperature},
      if (tools.isNotEmpty)
        "tools": [for (final tool in tools) tool.toJson()],
    };

    http.Response response;
    try {
      response = await _client
          .post(
            baseUrl.resolve("/api/chat"),
            headers: const {"content-type": "application/json"},
            body: jsonEncode(body),
          )
          .timeout(const Duration(minutes: 2));
    } on Exception catch (error) {
      throw AiServiceException("Could not reach Ollama: $error");
    }

    if (response.statusCode != 200) {
      throw AiServiceException(
        "Ollama returned ${response.statusCode}: ${response.body}",
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const AiServiceException("Ollama returned an invalid response");
    }
    final message = decoded["message"];
    if (message is! Map<String, dynamic>) {
      throw const AiServiceException("Ollama did not return a message");
    }
    return AiResponse(message: AiMessage.fromJson(message));
  }

  /// Releases the HTTP client.
  void dispose() => _client.close();
}

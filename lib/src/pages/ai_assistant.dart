import 'dart:async';

import 'package:flutter/material.dart';

import 'package:rover_dashboard/widgets.dart';
import 'package:rover_dashboard/src/models/view/ai_assistant.dart';
import 'package:rover_dashboard/src/services/ai/ollama.dart';

/// The AI assistant page.
///
/// This page provides a chat interface for interacting with an AI assistant
/// that can perform rover operations through bindings. The AI uses Ollama
/// to run phi4-mini-instruct locally.
class AiAssistantPage extends ReactiveWidget<AiAssistantModel> {
  /// A const constructor.
  const AiAssistantPage();

  @override
  AiAssistantModel createModel() {
    final model = AiAssistantModel();
    unawaited(model.init());
    return model;
  }

  @override
  Widget build(BuildContext context, AiAssistantModel model) {
    return Column(
      children: [
        _buildHeader(context, model),
        Expanded(
          child: Row(
            children: [
              // Main chat area
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: _buildMessageList(context, model),
                    ),
                    _buildInputArea(context, model),
                  ],
                ),
              ),
              // Pending actions sidebar
              if (model.pendingActions.isNotEmpty)
                Container(
                  width: 300,
                  decoration: BoxDecoration(
                    color: context.colorScheme.surface,
                    border: Border(
                      left: BorderSide(
                        color: context.colorScheme.outline,
                      ),
                    ),
                  ),
                  child: _buildPendingActionsPanel(context, model),
                ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds the header with controls.
  Widget _buildHeader(BuildContext context, AiAssistantModel model) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: context.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.chat_bubble_outline, size: 28),
          const SizedBox(width: 12),
          Text(
            'AI Assistant',
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          // Model status indicator
          _buildStatusIndicator(context, model),
          const SizedBox(width: 16),
          // Unrestricted mode toggle
          _buildUnrestrictedToggle(context, model),
          const SizedBox(width: 8),
          // Clear conversation button
          IconButton(
            icon: const Icon(Icons.clear_all),
            tooltip: 'Clear conversation',
            onPressed: model.clearConversation,
          ),
        ],
      ),
    );
  }

  /// Builds the status indicator for Ollama connection.
  Widget _buildStatusIndicator(BuildContext context, AiAssistantModel model) {
    final isChecking = model.isCheckingAvailability;
    final isConnected = model.ollamaAvailable;
    final color = isChecking
        ? Colors.orange
        : (isConnected ? Colors.green : Colors.red);
    final icon = isChecking
        ? Icons.hourglass_top
        : (isConnected ? Icons.cloud_queue : Icons.cloud_off);
    final label = isChecking
        ? 'Checking ${model.modelName}...'
        : (isConnected
              ? '${model.modelName} ready'
              : 'Ollama unavailable');

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.refresh, size: 16),
          tooltip: 'Refresh status',
          onPressed: model.refreshAvailability,
        ),
      ],
    );
  }

  /// Builds the unrestricted mode toggle.
  Widget _buildUnrestrictedToggle(BuildContext context, AiAssistantModel model) {
    return Tooltip(
      message: model.unrestrictedMode
          ? 'Unrestricted mode enabled - AI can perform actions without asking'
          : 'Restricted mode - AI will ask before performing actions',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            model.unrestrictedMode ? Icons.lock_open : Icons.lock,
            color: model.unrestrictedMode ? Colors.orange : Colors.grey,
          ),
          const SizedBox(width: 4),
          Text(
            model.unrestrictedMode ? 'Unrestricted' : 'Restricted',
            style: TextStyle(
              color: model.unrestrictedMode ? Colors.orange : Colors.grey,
              fontSize: 12,
              fontWeight: model.unrestrictedMode ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Switch(
            value: model.unrestrictedMode,
            onChanged: (value) => model.toggleUnrestrictedMode(),
            activeThumbColor: Colors.orange,
          ),
        ],
      ),
    );
  }

  /// Builds the message list.
  Widget _buildMessageList(BuildContext context, AiAssistantModel model) {
    if (model.isCheckingAvailability) {
      return const Center(child: CircularProgressIndicator());
    }
    if (!model.ollamaAvailable) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off,
              size: 64,
              color: context.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'Ollama is not available',
              style: context.textTheme.titleLarge?.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Make sure Ollama is running and the model "${model.modelName}" is installed.\n'
              'Install with: ollama pull phi4-mini',
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: model.scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: model.messages.length,
      itemBuilder: (context, index) {
        final message = model.messages[index];
        return _buildMessageBubble(context, message, model);
      },
    );
  }

  /// Builds a message bubble.
  Widget _buildMessageBubble(
      BuildContext context, AiMessage message, AiAssistantModel model) {
    final isUser = message.role == 'user';
    final isAssistant = message.role == 'assistant';
    final isSystem = message.role == 'system';
    final isTool = message.role == 'tool';

    Color bubbleColor;
    Color textColor;
    IconData? icon;

    if (isUser) {
      bubbleColor = context.colorScheme.primary;
      textColor = Colors.white;
      icon = Icons.person_outline;
    } else if (isAssistant) {
      bubbleColor = context.colorScheme.surfaceContainerHighest;
      textColor = context.colorScheme.onSurface;
      icon = Icons.smart_toy_outlined;
    } else if (isSystem) {
      bubbleColor = context.colorScheme.surfaceContainerHighest
          .withValues(alpha: 0.5);
      textColor = context.colorScheme.onSurface.withValues(alpha: 0.7);
      icon = Icons.info_outline;
    } else {
      // Tool response
      bubbleColor = Colors.blue.withValues(alpha: 0.1);
      textColor = Colors.blue;
      icon = Icons.build;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(icon, size: 24, color: textColor.withValues(alpha: 0.7)),
            ),
          if (isTool)
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
                  bottomRight: isUser ? const Radius.circular(16) : Radius.zero,
                ),
              ),
              child: Column(
                crossAxisAlignment:
                    isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (isSystem)
                    Text(
                      'System',
                      style: TextStyle(
                        color: textColor.withValues(alpha: 0.5),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  if (isAssistant && message.toolCalls.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: context.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.build,
                            size: 14,
                            color: context.colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${message.toolCalls.length} action(s)',
                            style: TextStyle(
                              color: context.colorScheme.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Text(
                    message.content,
                    style: TextStyle(
                      color: textColor,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Icon(icon, size: 24, color: textColor.withValues(alpha: 0.7)),
            ),
        ],
      ),
    );
  }

  /// Builds the input area.
  Widget _buildInputArea(BuildContext context, AiAssistantModel model) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: context.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: model.chatController,
                decoration: InputDecoration(
                  hintText: 'Ask the AI assistant...',
                  hintStyle: TextStyle(
                    color: context.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(
                      color: context.colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(
                      color: context.colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(
                      color: context.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: context.colorScheme.surfaceContainerHighest,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                style: context.textTheme.bodyLarge,
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (value) => model.sendMessage(value),
              ),
            ),
            const SizedBox(width: 12),
            FilledButton.icon(
              onPressed: model.isGenerating
                  ? null
                  : () => model.sendMessage(model.chatController.text),
              icon: model.isGenerating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.send),
              label: Text(model.isGenerating ? 'Thinking...' : 'Send'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the pending actions panel.
  Widget _buildPendingActionsPanel(
      BuildContext context, AiAssistantModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: context.colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.pending_actions, size: 20),
              const SizedBox(width: 8),
              Text(
                'Pending Actions',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${model.pendingActions.length}',
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: model.pendingActions.length,
            itemBuilder: (context, index) {
              final action = model.pendingActions[index];
              return _buildPendingActionCard(context, action, model);
            },
          ),
        ),
      ],
    );
  }

  /// Builds a pending action card.
  Widget _buildPendingActionCard(
      BuildContext context, PendingAction action, AiAssistantModel model) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.warning_amber,
                  color: Colors.orange,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Action Required',
                    style: context.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              action.description,
              style: context.textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'Operation: ${action.bindingName}',
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha: 0.5),
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => model.cancelAction(action.id),
                    icon: const Icon(Icons.close, size: 18),
                    label: const Text('Cancel'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => model.confirmAction(action.id),
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('Confirm'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

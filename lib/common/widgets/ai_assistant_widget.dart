import 'package:flutter/material.dart';
import 'package:go_mep_application/common/utils/ai_assistant_plugin.dart';
import 'package:go_mep_application/common/utils/app_feature.dart';
import 'package:go_mep_application/common/utils/feature_action_handler.dart';

/// Example widget demonstrating AI Assistant plugin usage
class AIAssistantWidget extends StatefulWidget {
  const AIAssistantWidget({Key? key}) : super(key: key);

  @override
  State<AIAssistantWidget> createState() => _AIAssistantWidgetState();
}

class _AIAssistantWidgetState extends State<AIAssistantWidget> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    // Add welcome message
    _messages.add(ChatMessage(
      text: 'Xin chào! Tôi có thể giúp gì cho bạn?\n\n'
          'Bạn có thể thử:\n'
          '• Báo tắc đường\n'
          '• Báo ngập nước\n'
          '• Tìm quán ăn\n'
          '• Mở thông báo\n'
          '• Mở profile',
      isUser: false,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      // Add user message
      _messages.add(ChatMessage(text: text, isUser: true));
      _isProcessing = true;
    });

    _controller.clear();

    // Process with AI Assistant
    Future.delayed(const Duration(milliseconds: 300), () {
      final result = AIAssistantPlugin.recognize(text);

      setState(() {
        _isProcessing = false;
      });

      // Handle the recognized feature
      final response = FeatureActionHandler.handleFeature(
        context,
        result,
        onAction: (feature, params) {
          debugPrint('Feature action: ${feature.displayName}');
          debugPrint('Parameters: $params');

          // Custom action handling here
          _handleCustomAction(feature, params);
        },
      );

      setState(() {
        _messages.add(ChatMessage(text: response, isUser: false));
      });
    });
  }

  void _handleCustomAction(AppFeature feature, Map<String, dynamic>? params) {
    // Implement custom navigation or action here
    switch (feature) {
      case AppFeature.reportTrafficJam:
        // Navigate to traffic jam report screen
        debugPrint('Navigate to traffic jam report');
        break;
      case AppFeature.reportWaterlogging:
        // Navigate to waterlogging report screen
        debugPrint('Navigate to waterlogging report');
        break;
      case AppFeature.reportAccident:
        // Navigate to accident report screen
        debugPrint('Navigate to accident report');
        break;
      case AppFeature.findRestaurants:
        // Navigate to restaurant search
        debugPrint('Navigate to restaurant search');
        break;
      case AppFeature.openRestaurantList:
        // Navigate to restaurant list
        debugPrint('Navigate to restaurant list');
        break;
      case AppFeature.openNotifications:
        // Navigate to notifications
        debugPrint('Navigate to notifications');
        break;
      case AppFeature.openProfile:
        // Navigate to profile
        debugPrint('Navigate to profile');
        break;
      case AppFeature.unknown:
        debugPrint('Unknown feature');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Assistant'),
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return ChatBubble(message: message);
              },
            ),
          ),

          // Processing indicator
          if (_isProcessing)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(width: 16),
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text('Đang xử lý...'),
                ],
              ),
            ),

          // Input field
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Nhập yêu cầu của bạn...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _handleSubmit(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _handleSubmit,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Chat message model
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
  }) : timestamp = DateTime.now();
}

/// Chat bubble widget
class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.smart_toy, color: Colors.white),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser
                    ? Theme.of(context).primaryColor
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person, color: Colors.black54),
            ),
          ],
        ],
      ),
    );
  }
}

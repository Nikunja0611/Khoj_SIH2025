import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/ai_saathi_provider.dart';

class AISaathiChatPage extends StatefulWidget {
  @override
  _AISaathiChatPageState createState() => _AISaathiChatPageState();
}

class _AISaathiChatPageState extends State<AISaathiChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadConversationHistory();
  }

  void _loadConversationHistory() {
    try {
      final provider = Provider.of<AISaathiProvider>(context, listen: false);
      
      if (provider.conversationHistory.isEmpty) {
        _addWelcomeMessage();
      } else {
        // Load existing conversation history
        setState(() {
          _messages.clear();
          _messages.addAll(provider.conversationHistory.map((msg) => ChatMessage(
            text: msg.text,
            isUser: msg.isUser,
            timestamp: msg.timestamp,
          )));
        });
      }
    } catch (e) {
      print('Chat: Error loading conversation history: $e');
      _addWelcomeMessage();
    }
  }

  void _addWelcomeMessage() {
    _messages.add(ChatMessage(
      text: "Namaste! I'm AI Saathi, your ultimate Jharkhand companion! 🌟\n\nI know everything about Jharkhand - from the tribal cultures of Santhal and Munda communities to the hidden gems like Netarhat and Betla National Park. I can help you with:\n\n• Travel planning and itineraries\n• Cultural insights and traditions\n• Local cuisine and festivals\n• Historical knowledge\n• Practical travel tips\n\nWhat would you like to know about Jharkhand?",
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.psychology, color: Theme.of(context).primaryColor),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("AI Saathi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("Jharkhand Expert", style: TextStyle(fontSize: 12, color: Colors.white70)),
              ],
            ),
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _clearConversation,
            tooltip: 'Clear Chat',
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          
          // Loading indicator
          Consumer<AISaathiProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 12),
                      Text("AI Saathi is thinking...", style: TextStyle(fontStyle: FontStyle.italic)),
                    ],
                  ),
                );
              }
              return SizedBox.shrink();
            },
          ),
          
          // Message input
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Ask AI Saathi about Jharkhand...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    onSubmitted: (value) => _sendMessage(),
                  ),
                ),
                SizedBox(width: 8),
                Consumer<AISaathiProvider>(
                  builder: (context, provider, child) {
                    return FloatingActionButton(
                      onPressed: provider.isLoading ? null : _sendMessage,
                      mini: true,
                      child: Icon(Icons.send),
                      backgroundColor: Theme.of(context).primaryColor,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(Icons.psychology, size: 16, color: Colors.white),
            ),
            SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.isUser ? Theme.of(context).primaryColor : Colors.grey[200],
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: message.isUser ? Colors.white : Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      color: message.isUser ? Colors.white70 : Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.isUser) ...[
            SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[400],
              child: Icon(Icons.person, size: 16, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();
    _scrollToBottom();

    // Get AI response using provider (which now handles conversation history)
    final provider = Provider.of<AISaathiProvider>(context, listen: false);
    await provider.generateItinerary(text);

    // Update UI with the latest conversation history
    setState(() {
      _messages.clear();
      _messages.addAll(provider.conversationHistory.map((msg) => ChatMessage(
        text: msg.text,
        isUser: msg.isUser,
        timestamp: msg.timestamp,
      )));
    });

    _scrollToBottom();
  }


  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _clearConversation() {
    final provider = Provider.of<AISaathiProvider>(context, listen: false);
    provider.clearConversation();
    
    setState(() {
      _messages.clear();
      _addWelcomeMessage();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

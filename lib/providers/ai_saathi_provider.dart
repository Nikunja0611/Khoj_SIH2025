import 'package:flutter/material.dart';
import '../services/ai_saathi_service.dart';
import '../models/ai_saathi_models.dart' as models;

class ConversationMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? context;

  ConversationMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.context,
  });
}

class AISaathiProvider extends ChangeNotifier {
  final AISaathiService _aiService = AISaathiService();
  
  models.AISaathiResponse? _currentItinerary;
  bool _isLoading = false;
  String? _error;
  List<ConversationMessage> _conversationHistory = [];
  
  models.AISaathiResponse? get currentItinerary => _currentItinerary;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<ConversationMessage> get conversationHistory => _conversationHistory;
  
  Future<void> generateItinerary(String userInput) async {
    _isLoading = true;
    _error = null;
    
    // Add user message to conversation history
    _conversationHistory.add(ConversationMessage(
      text: userInput,
      isUser: true,
      timestamp: DateTime.now(),
    ));
    
    notifyListeners();
    
    try {
      print('Provider: Starting itinerary generation with context...');
      _currentItinerary = await _aiService.generateItinerary(userInput, _conversationHistory);
      print('Provider: Itinerary generated successfully');
      
      // Add AI response to conversation history
      if (_currentItinerary != null) {
        String aiResponse = _formatAIResponse(_currentItinerary!);
        _conversationHistory.add(ConversationMessage(
          text: aiResponse,
          isUser: false,
          timestamp: DateTime.now(),
          context: 'ai_response',
        ));
      }
    } catch (e) {
      print('Provider: Error generating itinerary: $e');
      _error = e.toString();
      
      // Add error message to conversation history
      _conversationHistory.add(ConversationMessage(
        text: "Sorry, I encountered an error. Please try again.",
        isUser: false,
        timestamp: DateTime.now(),
        context: 'error',
      ));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  void clearItinerary() {
    _currentItinerary = null;
    _error = null;
    notifyListeners();
  }
  
  void clearConversation() {
    _conversationHistory.clear();
    _currentItinerary = null;
    _error = null;
    notifyListeners();
  }
  
  String _formatAIResponse(models.AISaathiResponse response) {
    if (response.itinerary.isNotEmpty) {
      return "Here's your personalized Jharkhand experience! Check the Itinerary tab for full details.";
    } else if (response.metadata.containsKey('raw_response')) {
      return response.metadata['raw_response'] as String;
    } else {
      return "I'd be happy to help you with that! Could you please provide more details?";
    }
  }
  
  List<ConversationMessage> getRecentContext({int limit = 5}) {
    // Get last few messages for context
    int startIndex = _conversationHistory.length > limit 
        ? _conversationHistory.length - limit 
        : 0;
    return _conversationHistory.sublist(startIndex);
  }
}

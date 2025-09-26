import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:convert';
import '../models/ai_saathi_models.dart' as models;

class AISaathiService {
  static const String _apiKey =
      'AIzaSyDKpanhJQbg7mK2LmErhXz77pzKM6bTwmg'; // Replace with your actual key
  late GenerativeModel _model;

  AISaathiService() {
    _model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: _apiKey);
  }

  Future<models.AISaathiResponse> generateItinerary(String userInput, [List<dynamic>? conversationHistory]) async {
    try {
      print('AI Saathi: Generating itinerary for: $userInput');
      print('AI Saathi: Using API Key: ${_apiKey.substring(0, 10)}...');
      print('AI Saathi: Using model: gemini-1.5-flash');

      // Test with a simple prompt first
      final simplePrompt =
          "Hello, can you respond with 'AI Saathi is working'?";
      print('AI Saathi: Testing with simple prompt...');

      final content = [Content.text(simplePrompt)];
      final response = await _model.generateContent(content);

      print('AI Saathi: Simple test response: ${response.text}');

      // If simple test works, try the full prompt
      final prompt = _buildPrompt(userInput, conversationHistory);
      print('AI Saathi: Prompt built with context, calling Gemini API...');

      final fullContent = [Content.text(prompt)];
      final fullResponse = await _model.generateContent(fullContent);

      print(
        'AI Saathi: Gemini response received: ${fullResponse.text?.substring(0, 100)}...',
      );
      return _parseResponse(fullResponse.text ?? '');
    } catch (e) {
      print('AI Saathi: Error occurred: $e');
      print('AI Saathi: Error type: ${e.runtimeType}');
      print('AI Saathi: Full error details: ${e.toString()}');
      
      // Handle specific error cases
      String errorMessage = 'Sorry, I encountered an error. Please try again.';
      if (e.toString().contains('overloaded')) {
        errorMessage = 'AI Saathi is currently busy. Please try again in a few moments. (tip: Try asking a simpler question)';
      } else if (e.toString().contains('quota')) {
        errorMessage = 'AI Saathi has reached its limit. Please try again later.';
      } else if (e.toString().contains('network')) {
        errorMessage = 'Network error. Please check your internet connection.';
      } else if (e.toString().contains('timeout')) {
        errorMessage = 'Request timed out. Please try again.';
      }
      
      // Provide a helpful fallback response for common questions
      String fallbackResponse = errorMessage;
      if (userInput.toLowerCase().contains('munda')) {
        fallbackResponse = 'I\'m currently experiencing high traffic, but I can tell you that the Munda tribe is one of the largest tribal communities in Jharkhand, known for their rich cultural heritage and traditional practices. Please try asking me again in a moment for more detailed information!';
      } else if (userInput.toLowerCase().contains('jharkhand')) {
        fallbackResponse = 'I\'m temporarily busy, but Jharkhand is a beautiful state with rich tribal culture, stunning natural beauty, and amazing places like Netarhat, Betla National Park, and Hundru Falls. Please try again in a moment!';
      }
      
      return models.AISaathiResponse(
        itinerary: [],
        confidence: 0.0,
        suggestions: [fallbackResponse],
        alternatives: [],
        metadata: {
          'error': e.toString(),
          'conversational': true,
          'raw_response': fallbackResponse,
        },
      );
    }
  }

  String _buildPrompt(String userInput, [List<dynamic>? conversationHistory]) {
    return """
    You are AI Saathi, the ultimate Jharkhand expert and travel companion. 
    You are a 10/10 chatbot with deep knowledge of Jharkhand's culture, history, geography, tourism, cuisine, festivals, and everything about this beautiful state.

    JHARKHAND EXPERTISE:
    - Complete knowledge of all 24 districts
    - Deep understanding of tribal culture (Santhal, Munda, Oraon, Ho, Kharia, etc.)
    - Rich history from ancient times to modern Jharkhand
    - All tourist destinations, hidden gems, and authentic local experiences
    - Traditional cuisine, festivals, and cultural practices
    - Local languages, customs, and traditions
    - Best times to visit, weather patterns, and seasonal highlights
    - Transportation, accommodation, and practical travel tips
    - Economic aspects, industries, and development
    - Environmental conservation, forests, and wildlife

    RESPONSE STYLE:
    - Be warm, friendly, and enthusiastic about Jharkhand
    - Use local expressions and terms when appropriate (with simple explanations in brackets)
    - Provide detailed, accurate, and helpful information
    - Be conversational and engaging, like a real travel companion
    - Always include practical travel tips, local insights, and safety notes
    - Show genuine love for Jharkhand's diversity and beauty
    - IMPORTANT: Do not use Markdown, bold, italics, or symbols like *, _, or #.
      Respond only in plain text. Use markers like (tip), (important), (local insight) for emphasis.

    ${_buildConversationContext(conversationHistory)}
    
    USER QUERY: $userInput

    RESPOND AS AI SAATHI:
    If the user is asking for travel/itinerary help, provide a structured JSON response in plain text with this format:
    {
      "itinerary": [
        {
          "day": 1,
          "date": "2024-01-01",
          "theme": "Nature & Wildlife",
          "activities": [
            {
              "id": "1",
              "name": "Activity Name",
              "description": "Detailed description",
              "location": "Place Name",
              "time": "Morning | Afternoon | Evening | Full Day",
              "duration": 2,
              "cost": 500,
              "type": "Sightseeing | Adventure | Food | Cultural | Shopping"
            }
          ],
          "summary": "Day summary",
          "estimatedCost": 1500,
          "estimatedDuration": 8,
          "safetyTips": ["Tip 1", "Tip 2"],
          "accessibility": "Wheelchair-friendly / Not recommended for elderly travelers"
        }
      ],
      "confidence": 0.9,
      "suggestions": ["Suggestion 1", "Suggestion 2"],
      "alternatives": ["Alternative 1", "Alternative 2"]
    }

    If the user is asking general questions about Jharkhand, respond conversationally in plain text with detailed, accurate information about:
    - Culture, traditions, and festivals
    - History and heritage
    - Geography and climate
    - Cuisine and local delicacies
    - Tourist attractions and hidden gems
    - Local customs and practices
    - Economic and social aspects
    - Wildlife, forests, and nature
    - Transportation and practical travel tips
    - Local languages and dialects
    - Traditional arts, crafts, music, and dance
    - Religious and spiritual sites
    - Adventure activities and sports
    - Shopping and local markets
    - Accommodation and hospitality
    - Local transportation
    - Safety and health tips
    - Seasonal attractions
    - Local events and celebrations
    - Traditional medicine and wellness
    - Environmental conservation
    - Tribal communities and their way of life
    - Modern development and progress
    - Education and institutions
    - Healthcare and facilities
    - Communication and connectivity
    - Local businesses and entrepreneurship
    - Government initiatives and policies
    - Future prospects and opportunities

    Always be helpful, accurate, practical, and passionate about Jharkhand!
    """;
  }

  String _buildConversationContext(List<dynamic>? conversationHistory) {
    if (conversationHistory == null || conversationHistory.isEmpty) {
      return "";
    }
    
    String context = "\nCONVERSATION CONTEXT:\n";
    context += "Here's our recent conversation to help you understand the context:\n\n";
    
    // Get last 3-4 conversation turns for context
    int startIndex = conversationHistory.length > 6 ? conversationHistory.length - 6 : 0;
    List<dynamic> recentHistory = conversationHistory.sublist(startIndex);
    
    for (var message in recentHistory) {
      if (message.isUser) {
        context += "User: ${message.text}\n";
      } else {
        context += "AI Saathi: ${message.text}\n";
      }
    }
    
    context += "\nPlease respond to the current question while considering this conversation context. ";
    context += "If the user asks follow-up questions, build upon our previous discussion.\n";
    
    return context;
  }

  models.AISaathiResponse _parseResponse(String response) {
    try {
      print('AI Saathi: Parsing response: ${response.substring(0, 200)}...');
      
      // Check if response contains JSON structure
      if (response.contains('"itinerary"') && response.contains('{')) {
        // Extract JSON from response - handle markdown code blocks
        String jsonString = response;
        
        // Remove markdown code blocks if present
        if (response.contains('```json')) {
          final jsonStart = response.indexOf('```json') + 7;
          final jsonEnd = response.indexOf('```', jsonStart);
          jsonString = response.substring(jsonStart, jsonEnd).trim();
        } else if (response.contains('```')) {
          final jsonStart = response.indexOf('```') + 3;
          final jsonEnd = response.indexOf('```', jsonStart);
          jsonString = response.substring(jsonStart, jsonEnd).trim();
        } else {
          // Look for JSON object
          final jsonStart = response.indexOf('{');
          final jsonEnd = response.lastIndexOf('}') + 1;
          jsonString = response.substring(jsonStart, jsonEnd);
        }
        
        print('AI Saathi: Extracted JSON: ${jsonString.substring(0, 100)}...');
        final jsonData = json.decode(jsonString);
        print('AI Saathi: JSON parsed successfully');

        return models.AISaathiResponse.fromJson(jsonData);
      } else {
        // It's a conversational response, not JSON
        print('AI Saathi: Conversational response detected');
        return models.AISaathiResponse(
          itinerary: [],
          confidence: 0.9,
          suggestions: [],
          alternatives: [],
          metadata: {
            'conversational': true,
            'raw_response': response,
            'parsed': true,
          },
        );
      }
    } catch (e) {
      print('AI Saathi: JSON parsing error: $e');
      print('AI Saathi: Raw response: $response');
      
      // Return conversational response with raw text
      return models.AISaathiResponse(
        itinerary: [],
        confidence: 0.8,
        suggestions: [],
        alternatives: [],
        metadata: {
          'conversational': true,
          'raw_response': response,
          'parsed': false,
          'error': e.toString(),
        },
      );
    }
  }

  models.DayPlan _createFallbackItinerary() {
    return models.DayPlan(
      dayNumber: 1,
      date: DateTime.now(),
      theme: 'Jharkhand Exploration',
      activities: [
        models.Activity(
          id: '1',
          name: 'Netarhat Visit',
          description: 'Explore the Queen of Chotanagpur',
          location: 'Netarhat',
          timeSlot: 'Morning',
          cost: 500.0,
          duration: 4,
          type: 'Sightseeing',
        ),
      ],
      summary: 'Explore the beautiful hill station of Netarhat',
      estimatedCost: 1000.0,
      estimatedDuration: 6,
    );
  }
}

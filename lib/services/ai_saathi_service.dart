import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AISaathiService {
  static const String _apiKey =
      'AIzaSyDKpanhJQbg7mK2LmErhXz77pzKM6bTwmg'; // Replace with your actual key
  late GenerativeModel _model;

  AISaathiService() {
    _model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: _apiKey);
  }

  Future<AISaathiResponse> generateItinerary(String userInput) async {
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
      final prompt = _buildPrompt(userInput);
      print('AI Saathi: Prompt built, calling Gemini API...');

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
      return AISaathiResponse(
        itinerary: [_createFallbackItinerary()],
        confidence: 0.0,
        suggestions: ['Error generating itinerary. Please try again.'],
        alternatives: [],
        metadata: {'error': e.toString()},
      );
    }
  }

  String _buildPrompt(String userInput) {
    return """
    You are AI Saathi, the ultimate Jharkhand expert and travel companion. You are a 10/10 chatbot with deep knowledge of Jharkhand's culture, history, geography, tourism, cuisine, festivals, and everything about this beautiful state.

    JHARKHAND EXPERTISE:
    - Complete knowledge of all 24 districts
    - Deep understanding of tribal culture (Santhal, Munda, Oraon, Ho, Kharia, etc.)
    - Rich history from ancient times to modern Jharkhand
    - All tourist destinations, hidden gems, and local experiences
    - Traditional cuisine, festivals, and cultural practices
    - Local languages, customs, and traditions
    - Best times to visit, weather patterns, and seasonal attractions
    - Transportation, accommodation, and practical travel tips
    - Economic aspects, industries, and development
    - Environmental conservation and wildlife

    RESPONSE STYLE:
    - Be warm, friendly, and enthusiastic about Jharkhand
    - Use local terms and expressions when appropriate
    - Provide detailed, accurate, and helpful information
    - Be conversational and engaging
    - Always include practical tips and local insights
    - Show genuine love for Jharkhand's diversity and beauty

    USER QUERY: $userInput

    RESPOND AS AI SAATHI:
    If the user is asking for travel/itinerary help, provide a detailed JSON response with this structure:
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
              "time": "Morning",
              "duration": 2,
              "cost": 500,
              "type": "Sightseeing"
            }
          ],
          "summary": "Day summary",
          "estimatedCost": 1500,
          "estimatedDuration": 8
        }
      ],
      "confidence": 0.85,
      "suggestions": ["Suggestion 1", "Suggestion 2"],
      "alternatives": ["Alternative 1", "Alternative 2"]
    }

    If the user is asking general questions about Jharkhand, respond conversationally with detailed, accurate information about:
    - Culture, traditions, and festivals
    - History and heritage
    - Geography and climate
    - Cuisine and local delicacies
    - Tourist attractions and hidden gems
    - Local customs and practices
    - Economic and social aspects
    - Wildlife and nature
    - Transportation and practical tips
    - Local languages and dialects
    - Traditional arts and crafts
    - Religious and spiritual sites
    - Adventure activities and sports
    - Shopping and local markets
    - Accommodation and hospitality
    - Local transportation
    - Safety and travel tips
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

    Always be helpful, accurate, and passionate about Jharkhand!
    """;
  }

  AISaathiResponse _parseResponse(String response) {
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

        return AISaathiResponse.fromJson(jsonData);
      } else {
        // It's a conversational response, not JSON
        print('AI Saathi: Conversational response detected');
        return AISaathiResponse(
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
      return AISaathiResponse(
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

  DayPlan _createFallbackItinerary() {
    return DayPlan(
      dayNumber: 1,
      date: DateTime.now(),
      theme: 'Jharkhand Exploration',
      activities: [
        Activity(
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

// Data models
class AISaathiResponse {
  final List<DayPlan> itinerary;
  final double confidence;
  final List<String> suggestions;
  final List<String> alternatives;
  final Map<String, dynamic> metadata;

  AISaathiResponse({
    required this.itinerary,
    required this.confidence,
    required this.suggestions,
    required this.alternatives,
    required this.metadata,
  });

  factory AISaathiResponse.fromJson(Map<String, dynamic> json) {
    return AISaathiResponse(
      itinerary: (json['itinerary'] as List)
          .map((day) => DayPlan.fromJson(day))
          .toList(),
      confidence: json['confidence']?.toDouble() ?? 0.0,
      suggestions: List<String>.from(json['suggestions'] ?? []),
      alternatives: List<String>.from(json['alternatives'] ?? []),
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }
}

class DayPlan {
  final int dayNumber;
  final DateTime date;
  final String theme;
  final List<Activity> activities;
  final String summary;
  final double estimatedCost;
  final int estimatedDuration;

  DayPlan({
    required this.dayNumber,
    required this.date,
    required this.theme,
    required this.activities,
    required this.summary,
    required this.estimatedCost,
    required this.estimatedDuration,
  });

  factory DayPlan.fromJson(Map<String, dynamic> json) {
    return DayPlan(
      dayNumber: json['day'] ?? 1,
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      theme: json['theme'] ?? 'Jharkhand Exploration',
      activities: (json['activities'] as List)
          .map((activity) => Activity.fromJson(activity))
          .toList(),
      summary: json['summary'] ?? '',
      estimatedCost: (json['estimatedCost'] ?? 0).toDouble(),
      estimatedDuration: json['estimatedDuration'] ?? 8,
    );
  }
}

class Activity {
  final String id;
  final String name;
  final String description;
  final String location;
  final String timeSlot;
  final double cost;
  final int duration;
  final String type;

  Activity({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.timeSlot,
    required this.cost,
    required this.duration,
    required this.type,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      timeSlot: json['time'] ?? 'Morning',
      cost: (json['cost'] ?? 0).toDouble(),
      duration: json['duration'] ?? 2,
      type: json['type'] ?? 'Sightseeing',
    );
  }
}

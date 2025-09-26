import 'package:flutter/material.dart';
import '../services/ai_saathi_service.dart';

class AISaathiProvider extends ChangeNotifier {
  final AISaathiService _aiService = AISaathiService();
  
  AISaathiResponse? _currentItinerary;
  bool _isLoading = false;
  String? _error;
  
  AISaathiResponse? get currentItinerary => _currentItinerary;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  Future<void> generateItinerary(String userInput) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      print('Provider: Starting itinerary generation...');
      _currentItinerary = await _aiService.generateItinerary(userInput);
      print('Provider: Itinerary generated successfully');
    } catch (e) {
      print('Provider: Error generating itinerary: $e');
      _error = e.toString();
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
}

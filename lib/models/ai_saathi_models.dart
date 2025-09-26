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

  Map<String, dynamic> toJson() {
    return {
      'itinerary': itinerary.map((day) => day.toJson()).toList(),
      'confidence': confidence,
      'suggestions': suggestions,
      'alternatives': alternatives,
      'metadata': metadata,
    };
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
  final List<String> safetyTips;
  final String accessibility;

  DayPlan({
    required this.dayNumber,
    required this.date,
    required this.theme,
    required this.activities,
    required this.summary,
    required this.estimatedCost,
    required this.estimatedDuration,
    this.safetyTips = const [],
    this.accessibility = '',
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
      safetyTips: List<String>.from(json['safetyTips'] ?? []),
      accessibility: json['accessibility'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': dayNumber,
      'date': date.toIso8601String(),
      'theme': theme,
      'activities': activities.map((activity) => activity.toJson()).toList(),
      'summary': summary,
      'estimatedCost': estimatedCost,
      'estimatedDuration': estimatedDuration,
      'safetyTips': safetyTips,
      'accessibility': accessibility,
    };
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'location': location,
      'time': timeSlot,
      'duration': duration,
      'cost': cost,
      'type': type,
    };
  }
}

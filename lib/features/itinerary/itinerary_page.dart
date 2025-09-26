import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/ai_saathi_service.dart';
import '../../providers/ai_saathi_provider.dart';
import '../ai_saathi/ai_saathi_chat_page.dart';

class ItineraryPage extends StatefulWidget {
  @override
  _ItineraryPageState createState() => _ItineraryPageState();
}

class _ItineraryPageState extends State<ItineraryPage> {
  final TextEditingController _inputController = TextEditingController();
  final AISaathiService _aiService = AISaathiService();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AI Saathi – Itinerary"),
        actions: [
          IconButton(
            icon: Icon(Icons.chat),
            onPressed: _openChat,
            tooltip: 'Chat with AI Saathi',
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _clearItinerary,
          ),
        ],
      ),
      body: Consumer<AISaathiProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return _buildLoadingState();
          }
          
          if (provider.currentItinerary == null) {
            return _buildWelcomeState();
          }
          
          return _buildItineraryView(provider.currentItinerary!);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showInputDialog,
        child: Icon(Icons.auto_awesome),
        tooltip: 'Generate Itinerary',
      ),
    );
  }
  
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'AI Saathi is planning your perfect trip...',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 8),
          Text(
            'This may take a few moments',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
  
  Widget _buildWelcomeState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.travel_explore,
              size: 80,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 24),
            Text(
              'Welcome to AI Saathi!',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'Your intelligent travel companion for Jharkhand',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
                  SizedBox(height: 24),
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _showInputDialog,
                          icon: Icon(Icons.auto_awesome),
                          label: Text('Generate Itinerary'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _openChat,
                          icon: Icon(Icons.chat),
                          label: Text('Chat with AI Saathi'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            backgroundColor: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Generate personalized itineraries or chat with AI Saathi about anything Jharkhand!',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildItineraryView(AISaathiResponse itinerary) {
    return Column(
      children: [
        // Confidence and suggestions header
        Container(
          padding: EdgeInsets.all(16),
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.psychology, color: Theme.of(context).primaryColor),
                  SizedBox(width: 8),
                  Text(
                    'AI Confidence: ${(itinerary.confidence * 100).toInt()}%',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              if (itinerary.suggestions.isNotEmpty) ...[
                SizedBox(height: 8),
                Text(
                  'Suggestions: ${itinerary.suggestions.join(', ')}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ],
          ),
        ),
        
        // Itinerary content
        Expanded(
          child: ListView.builder(
            itemCount: itinerary.itinerary.length,
            itemBuilder: (context, index) {
              final day = itinerary.itinerary[index];
              return _buildDayCard(day);
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildDayCard(DayPlan day) {
    return Card(
      margin: EdgeInsets.all(8),
      child: ExpansionTile(
        title: Text('Day ${day.dayNumber}: ${day.theme}'),
        subtitle: Text(day.summary),
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Day info
                Row(
                  children: [
                    Icon(Icons.schedule, size: 16),
                    SizedBox(width: 8),
                    Text('Duration: ${day.estimatedDuration} hours'),
                    Spacer(),
                    Icon(Icons.attach_money, size: 16),
                    SizedBox(width: 8),
                    Text('Cost: ₹${day.estimatedCost.toInt()}'),
                  ],
                ),
                SizedBox(height: 16),
                
                // Activities
                Text(
                  'Activities:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 8),
                ...day.activities.map((activity) => _buildActivityCard(activity)),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildActivityCard(Activity activity) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.place, color: Colors.white, size: 16),
        ),
        title: Text(activity.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(activity.description),
            SizedBox(height: 4),
            Wrap(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.access_time, size: 12),
                    SizedBox(width: 4),
                    Text('${activity.timeSlot} (${activity.duration}h)'),
                  ],
                ),
                SizedBox(width: 16),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.attach_money, size: 12),
                    SizedBox(width: 4),
                    Text('₹${activity.cost.toInt()}'),
                  ],
                ),
              ],
            ),
          ],
        ),
        trailing: Chip(
          label: Text(activity.type),
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
        ),
      ),
    );
  }
  
  void _showInputDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Tell AI Saathi about your trip'),
        content: TextField(
          controller: _inputController,
          decoration: InputDecoration(
            hintText: 'e.g., "I want to visit Jharkhand for 3 days, love nature and wildlife"',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _generateItinerary,
            child: Text('Generate'),
          ),
        ],
      ),
    );
  }
  
  void _generateItinerary() async {
    if (_inputController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your travel preferences')),
      );
      return;
    }
    
    Navigator.pop(context);
    
    final provider = Provider.of<AISaathiProvider>(context, listen: false);
    await provider.generateItinerary(_inputController.text);
    
    _inputController.clear();
  }
  
  void _clearItinerary() {
    final provider = Provider.of<AISaathiProvider>(context, listen: false);
    provider.clearItinerary();
  }

  void _openChat() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AISaathiChatPage()),
    );
  }
}

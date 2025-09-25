import 'package:flutter/material.dart';

class ItineraryPage extends StatefulWidget {
  @override
  _ItineraryPageState createState() => _ItineraryPageState();
}

class _ItineraryPageState extends State<ItineraryPage> {
  List<ChatMessage> messages = [];
  TextEditingController _textController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  
  // Chat state
  int step = 0; // 0: initial, 1: ask days, 2: ask for whom, 3: show itinerary
  int? selectedDays;
  String? tripType;

  @override
  void initState() {
    super.initState();
    _addBotMessage("🏞 Welcome to Jharkhand Tourism Itinerary Planner!\n\nHow many days are you planning to stay in Jharkhand?\n\n• Type '3' for 3 days\n• Type '5' for 5 days\n• Type '7' for 7 days");
    step = 1;
  }

  void _addBotMessage(String message) {
    setState(() {
      messages.add(ChatMessage(
        text: message,
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });
    _scrollToBottom();
  }

  void _addUserMessage(String message) {
    setState(() {
      messages.add(ChatMessage(
        text: message,
        isUser: true,
        timestamp: DateTime.now(),
      ));
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

  void _handleUserInput(String input) {
    _addUserMessage(input);
    
    switch (step) {
      case 1: // Days selection
        if (input == '3' || input == '5' || input == '7') {
          selectedDays = int.parse(input);
          step = 2;
          _addBotMessage("Great! $selectedDays days it is.\n\nNow, are you planning this trip for yourself or for your parents?\n\n• Type 'myself' for yourself\n• Type 'parents' for your parents");
        } else {
          _addBotMessage("Please enter a valid number: 3, 5, or 7 days only.");
        }
        break;
        
      case 2: // Trip type selection
        if (input.toLowerCase() == 'myself' || input.toLowerCase() == 'parents') {
          tripType = input.toLowerCase();
          step = 3;
          _generateItinerary();
        } else {
          _addBotMessage("Please type either 'myself' or 'parents'.");
        }
        break;
        
      case 3: // After itinerary is shown
        _addBotMessage("Would you like to plan another trip? If yes, type 'restart' to begin again!");
        if (input.toLowerCase() == 'restart') {
          _restartChat();
        }
        break;
    }
  }

  void _generateItinerary() {
    String itinerary = "";
    
    if (selectedDays == 3 && tripType == 'myself') {
      itinerary = """✅ 3 Days Itinerary - For Yourself

Day 1 (Ranchi):
• Rock Garden - Perfect for photography
• Tagore Hill - Beautiful city views
• Ranchi Lake - Peaceful boating
• Evening street food exploration

Day 2 (Patratu Valley):
• Scenic drive through hills
• Boating at Patratu Dam
• Paragliding adventure
• Photography at sunset point

Day 3 (Netarhat):
• Sunrise at Magnolia Point
• Trekking to Upper Ghaghri Falls
• Return journey with memories

Have a wonderful adventure! 🌟""";
    }
    else if (selectedDays == 3 && tripType == 'parents') {
      itinerary = """✅ 3 Days Itinerary - For Parents
🎯 Special Feature:Prepaid guide fund (guide manages cash with vendors)

Day 1 (Ranchi):
• Rock Garden (easy access spots)
• Ranchi Lake boating (comfortable)
• Calm evening at Tagore Hill

Day 2 (Netarhat):
• Drive to Magnolia Point for sunrise
• Upper Ghaghri waterfall (gentle walk path)
• Local craft shopping with guide assistance

Day 3 (Patratu Valley):
• Scenic drive and dam visit
• Relaxation with guide assistance
• Comfortable return journey

Your parents will have a stress-free trip! 👨‍👩‍👧‍👦""";
    }
    else if (selectedDays == 5 && tripType == 'myself') {
      itinerary = """✅ 5 Days Itinerary - For Yourself

Day 1: Ranchi sightseeing
• Rock Garden, Hundru Falls, Tagore Hill

Day 2: Patratu Valley Adventure
• Paragliding, kayaking, sunset view

Day 3: Netarhat
• Magnolia Point sunrise, trek to waterfalls, overnight stay

Day 4: Betla National Park
• Wildlife safari, Palamu Fort visit

Day 5: Deoghar
• Baidyanath Temple, Tapovan caves

Get ready for an amazing adventure! 🎒""";
    }
    else if (selectedDays == 5 && tripType == 'parents') {
      itinerary = """✅ **5 Days Itinerary - For Parents**
🎯 Special Feature: Prepaid guide fund for hassle-free cash handling

Day 1: Ranchi sightseeing
• Rock Garden, Ranchi Lake, easy evening walk

Day 2: Patratu Valley
• Scenic drive, dam view, light boating

Day 3: Netarhat
• Magnolia Point (drive accessible), relaxed market shopping

Day 4: Betla National Park
• Easy safari ride with guide

Day 5: Deoghar
• Baidyanath Temple & Tapovan caves (guide handles offerings, tickets)

Perfect comfortable trip for your parents! 🏡""";
    }
    else if (selectedDays == 7 && tripType == 'myself') {
      itinerary = """✅ 7 Days Itinerary - For Yourself

Day 1: Ranchi sightseeing (Rock Garden, Tagore Hill, Hundru Falls)
Day 2: Patratu Valley adventure (paragliding, kayaking, dam view)
Day 3: Netarhat – sunrise + trekking trails, overnight stay
Day 4: Netarhat waterfalls (Upper & Lower Ghaghri), tribal village visit
Day 5: Betla National Park safari, Palamu Fort exploration
Day 6: Deoghar pilgrimage, shopping, Tapovan caves
Day 7: Relaxed day at Ranchi markets + local food tasting

Ultimate Jharkhand experience awaits! 🌄""";
    }
    else if (selectedDays == 7 && tripType == 'parents') {
      itinerary = """✅ 7 Days Itinerary - For Parents
🎯 Special Feature: Prepaid guide fund + comfortable stay options

Day 1: Ranchi sightseeing (Rock Garden, Lake boating, evening walk)
Day 2: Patratu Valley scenic drive, dam view, photography spots
Day 3: Netarhat – Magnolia Point, Upper Ghaghri (light trekking path)
Day 4: Netarhat relaxation, local craft markets, sunset point
Day 5: Betla National Park – Safari in a jeep (easy ride)
Day 6: Deoghar Baidyanath Temple (guide manages queues & offerings)
Day 7: Local handicrafts shopping, cultural evening dance show

A perfect blend of comfort and culture for your parents! 🎭""";
    }
    
    _addBotMessage(itinerary);
    _addBotMessage("That's your perfect Jharkhand itinerary! Need to plan another trip? Type 'restart' to begin again. 😊");
  }

  void _restartChat() {
    setState(() {
      messages.clear();
      step = 0;
      selectedDays = null;
      tripType = null;
    });
    _addBotMessage("🏞 Welcome back to Jharkhand Tourism Itinerary Planner!\n\nHow many days are you planning to stay in Jharkhand?\n\n• Type '3' for 3 days\n• Type '5' for 5 days\n• Type '7' for 7 days");
    step = 1;
  }

  void _sendMessage() {
    String text = _textController.text.trim();
    if (text.isNotEmpty) {
      _handleUserInput(text);
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ChatBubble(message: messages[index]);
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 5,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    onSubmitted: (text) => _sendMessage(),
                  ),
                ),
                SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _sendMessage,
                  child: Icon(Icons.send),
                  backgroundColor: const Color.fromARGB(255, 142, 109, 56),
                  foregroundColor: Colors.white,
                  mini: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
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

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color.fromARGB(255, 210, 151, 87),
              child: Icon(Icons.support_agent, size: 18, color: Colors.white),
            ),
            SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.isUser ? const Color.fromARGB(255, 243, 170, 33) : Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : Colors.black87,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
            SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color.fromARGB(255, 243, 180, 33),
              child: Icon(Icons.person, size: 18, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }
}
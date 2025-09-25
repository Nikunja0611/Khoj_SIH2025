import 'package:flutter/material.dart';
import 'core/app_theme.dart';

// Import pages
import 'features/explore/explore_page.dart';
import 'features/itinerary/itinerary_page.dart';
import 'features/marketplace/marketplace_page.dart';
import 'features/ar/ar_page.dart';
import 'features/community/community_page.dart';
import 'features/rewards/rewards_page.dart';
import 'features/sos/sos_page.dart';
import 'features/profile/profile_page.dart';

void main() {
  runApp(JharkhandTourismApp());
}

class JharkhandTourismApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jharkhand Tourism',
      theme: AppTheme.lightTheme,
      home: MainNavigation(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainNavigation extends StatefulWidget {
  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  Widget _selectedScreen = ExplorePage();
  String _title = "Explore Jharkhand";
  bool _isLoggedIn = false;


  void _onSelect(String title, Widget page) {
    setState(() {
      _title = title;
      _selectedScreen = page; 
    });
    Navigator.pop(context); // close drawer after selection
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Theme.of(context).primaryColor),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Welcome, Traveller!",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const Text(
                    "Explore Jharkhand",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.explore),
              title: Text("Explore"),
              onTap: () => _onSelect("Explore Jharkhand", ExplorePage()),
            ),
            ListTile(
              leading: Icon(Icons.schedule),
              title: Text("Itinerary (AI Saathi)"),
              onTap: () => _onSelect("AI Saathi – Itinerary", ItineraryPage()),
            ),
            ListTile(
              leading: Icon(Icons.store),
              title: Text("Marketplace"),
              onTap: () => _onSelect("Marketplace", MarketplacePage()),
            ),
            ListTile(
              leading: Icon(Icons.view_in_ar),
              title: Text("AR / Immersive"),
              onTap: () => _onSelect("Immersive AR Experience", ARPage()),
            ),
            ListTile(
              leading: Icon(Icons.group),
              title: Text("Community"),
              onTap: () => _onSelect("Community", CommunityPage()),
            ),
            ListTile(
              leading: Icon(Icons.star),
              title: Text("Rewards"),
              onTap: () => _onSelect("Rewards", RewardsPage()),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.warning, color: Colors.red),
              title: Text("Emergency SOS"),
              onTap: () => _onSelect("Emergency SOS", SOSPage()),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Profile"),
              onTap: () => _onSelect("My Profile", ProfilePage()),
            ),
          ],
        ),
      ),
      body: _selectedScreen,
    );
  }
}

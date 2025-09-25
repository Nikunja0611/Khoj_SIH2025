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
      theme: AppTheme.theme,
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
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    ExplorePage(),
    ItineraryPage(),
    MarketplacePage(),
    ARPage(),
    CommunityPage(),
    RewardsPage(),
    SOSPage(),
    ProfilePage(),
  ];

  final List<String> _titles = [
    "Explore Jharkhand",
    "AI Saathi – Itinerary",
    "Marketplace",
    "Immersive AR Experience",
    "Community",
    "Rewards",
    "Emergency SOS",
    "My Profile",
  ];

  void _onSelect(int index) {
    setState(() {
      _selectedIndex = index;
      Navigator.pop(context); // close drawer after selection
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_selectedIndex])),
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
              onTap: () => _onSelect(0),
            ),
            ListTile(
              leading: Icon(Icons.schedule),
              title: Text("Itinerary (AI Saathi)"),
              onTap: () => _onSelect(1),
            ),
            ListTile(
              leading: Icon(Icons.store),
              title: Text("Marketplace"),
              onTap: () => _onSelect(2),
            ),
            ListTile(
              leading: Icon(Icons.view_in_ar),
              title: Text("AR / Immersive"),
              onTap: () => _onSelect(3),
            ),
            ListTile(
              leading: Icon(Icons.group),
              title: Text("Community"),
              onTap: () => _onSelect(4),
            ),
            ListTile(
              leading: Icon(Icons.star),
              title: Text("Rewards"),
              onTap: () => _onSelect(5),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.warning, color: Colors.red),
              title: Text("Emergency SOS"),
              onTap: () => _onSelect(6),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Profile"),
              onTap: () => _onSelect(7),
            ),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
    );
  }
}

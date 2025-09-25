import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch logged-in user details dynamically
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tourist Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pop(context); // simple logout flow
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: const [
            CircleAvatar(
              radius: 50,
              backgroundImage:
                  NetworkImage("https://i.pravatar.cc/150?img=3"), // dummy
            ),
            SizedBox(height: 20),
            Text("Tourist Username",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text("tourist@email.com",
                style: TextStyle(fontSize: 16, color: Colors.grey)),
            Divider(height: 40),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text("Saved Locations"),
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text("Favorite Destinations"),
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text("Booking History"),
            ),
          ],
        ),
      ),
    );
  }
}

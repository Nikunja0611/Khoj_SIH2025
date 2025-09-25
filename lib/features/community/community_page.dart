import 'package:flutter/material.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  // Hardcoded posts
  final List<Map<String, dynamic>> _posts = const [
    {
      "user": "Rohit",
      "experience": "Netarhat sunrise was breathtaking! The hills and fresh air made it unforgettable.",
      "rating": 5,
      "date": "12/09/2025",
    },
    {
      "user": "Anita",
      "experience": "Betla National Park safari was amazing. Spotted elephants and deer up close.",
      "rating": 4,
      "date": "10/09/2025",
    },
    {
      "user": "Sanjay",
      "experience": "Patratu Valley drive was scenic, but roads are a bit steep. Loved the dam view.",
      "rating": 4,
      "date": "08/09/2025",
    },
    {
      "user": "Priya",
      "experience": "Deoghar temple visit was spiritually uplifting. Managed queues with guide help.",
      "rating": 5,
      "date": "05/09/2025",
    },
  ];

  Widget _buildPostCard(Map<String, dynamic> post) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post["user"],
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(post["experience"],
                style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 8),
            Row(
              children: List.generate(
                5,
                (index) => Icon(
                  Icons.star,
                  size: 20,
                  color: index < post["rating"] ? Colors.orange : Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Posted on ${post["date"]}",
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _posts.isEmpty
          ? const Center(child: Text("No posts yet."))
          : ListView.builder(
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                return _buildPostCard(_posts[index]);
              },
            ),
    );
  }
}
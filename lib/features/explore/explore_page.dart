import 'package:flutter/material.dart';

class ExplorePage extends StatelessWidget {
  final List<Map<String, String>> places = [
    {
      "name": "Netarhat",
      "desc": "Queen of Chotanagpur",
      "img": "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800"
    },
    {
      "name": "Betla National Park",
      "desc": "Wildlife safari & nature trails",
      "img": "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800"
    },
    {
      "name": "Hundru Falls",
      "desc": "Iconic scenic waterfall",
      "img": "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (context, index) {
        final place = places[index];
        return Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                place["img"]!, 
                fit: BoxFit.cover, 
                height: 180, 
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 180,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: Icon(Icons.image, size: 50, color: Colors.grey[600]),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 180,
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(place["name"]!, style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 4),
                    Text(place["desc"]!, style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text("Add to Itinerary"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

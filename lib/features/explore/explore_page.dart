import 'package:flutter/material.dart';

class ExplorePage extends StatelessWidget {
  final List<Map<String, String>> places = [
    {
      "name": "Netarhat",
      "desc": "Queen of Chotanagpur",
      "img": "https://upload.wikimedia.org/wikipedia/commons/2/28/Netarhat_sunrise.jpg"
    },
    {
      "name": "Betla National Park",
      "desc": "Wildlife safari & nature trails",
      "img": "https://upload.wikimedia.org/wikipedia/commons/3/3e/Betla.jpg"
    },
    {
      "name": "Hundru Falls",
      "desc": "Iconic scenic waterfall",
      "img": "https://upload.wikimedia.org/wikipedia/commons/0/0d/Hundru_falls.jpg"
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
              Image.network(place["img"]!, fit: BoxFit.cover, height: 180, width: double.infinity),
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

import 'package:flutter/material.dart';

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedDistrict = "All";

  final List<String> districts = [
    "All",
    "Ranchi",
    "Jamshedpur",
    "Dhanbad",
    "Hazaribagh",
    "Deoghar",
    "Netarhat"
  ];

  final List<Map<String, dynamic>> items = [
    {
      "title": "Tribal Handwoven Baskets",
      "subtitle": "Santhal Community Shop",
      "location": "Ranchi",
      "desc":
          "Handwoven bamboo baskets crafted by the Santhal tribe using centuries-old techniques.",
      "price": "₹450",
      "rating": 4.8,
      "district": "Ranchi",
      "category": "Handicrafts",
      "images": [
        "https://images.unsplash.com/photo-1621507466137-ef8f90d9bd5e?w=600",
        "https://images.unsplash.com/photo-1602526219038-871ad60a3c1e?w=600",
      ]
    },
    {
      "title": "Tussar Silk Sarees",
      "subtitle": "Jharkhand Silk Cooperative",
      "location": "Hazaribagh",
      "desc":
          "Authentic tussar silk sarees woven by women self-help groups with intricate tribal motifs.",
      "price": "₹2,800",
      "rating": 4.7,
      "district": "Hazaribagh",
      "category": "Handicrafts",
      "images": [
        "https://images.unsplash.com/photo-1604933762543-3f5f2dbb6c65?w=600",
        "https://images.unsplash.com/photo-1584036561566-baf8f5f1b144?w=600",
      ]
    },
    {
      "title": "Village Heritage Stay",
      "subtitle": "Tribal Homestay Group",
      "location": "Netarhat",
      "desc":
          "Stay with tribal families, enjoy organic food, cultural evenings, and nature treks.",
      "price": "₹1,500/night",
      "rating": 4.6,
      "district": "Netarhat",
      "category": "Homestays",
      "images": [
        "https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=600",
        "https://images.unsplash.com/photo-1505691938895-1758d7feb511?w=600",
      ]
    },
    {
      "title": "Betla National Park Safari",
      "subtitle": "EcoTour Adventure Club",
      "location": "Daltonganj",
      "desc":
          "Jeep safari in Betla National Park. Spot elephants, deer, tigers, and rare birds.",
      "price": "₹1,200/person",
      "rating": 4.9,
      "district": "Dhanbad",
      "category": "Eco-Tourism",
      "images": [
        "https://images.unsplash.com/photo-1610018556012-65e52d79cba0?w=600",
        "https://images.unsplash.com/photo-1606925797300-4a1af9da6af7?w=600",
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          // Filter by District
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: DropdownButtonFormField<String>(
              value: selectedDistrict,
              decoration: const InputDecoration(
                labelText: "Select District",
                border: OutlineInputBorder(),
              ),
              items: districts
                  .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  selectedDistrict = val!;
                });
              },
            ),
          ),

          // Tabs
          TabBar(
            controller: _tabController,
            labelColor: Colors.brown.shade700,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.brown,
            tabs: const [
              Tab(text: 'Handicrafts'),
              Tab(text: 'Homestays'),
              Tab(text: 'Eco-Tourism'),
            ],
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTab("Handicrafts"),
                _buildTab("Homestays"),
                _buildTab("Eco-Tourism"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String category) {
    final filtered = items.where((item) {
      final districtMatch =
          selectedDistrict == "All" || item["district"] == selectedDistrict;
      final categoryMatch = item["category"] == category;
      return districtMatch && categoryMatch;
    }).toList();

    if (filtered.isEmpty) {
      return const Center(
        child: Text("No items found",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final f = filtered[index];
        return _buildMarketplaceCard(f, index % 2 == 0, context);
      },
    );
  }

  Widget _buildMarketplaceCard(
      Map<String, dynamic> item, bool isLeftAligned, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            if (isLeftAligned) _buildImagePreview(item["images"]),
            _buildCardContent(item, context, isLeftAligned),
            if (!isLeftAligned) _buildImagePreview(item["images"]),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview(List<String> images) {
    return Expanded(
      flex: 2,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          images.first,
          height: 160,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildCardContent(
      Map<String, dynamic> item, BuildContext context, bool isLeftAligned) {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment:
              isLeftAligned ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Text(item["title"],
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(item["subtitle"],
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.green.shade800,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            Text(
              item["desc"],
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: isLeftAligned
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.end,
              children: [
                _buildPriceWidget(item["price"]),
                const SizedBox(width: 8),
                _buildRatingWidget(item["rating"]),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment:
                  isLeftAligned ? Alignment.centerLeft : Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => DetailPage(item: item)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown.shade600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text("View Details", style: TextStyle(fontSize: 12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceWidget(String price) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
            color: Colors.amber.shade100,
            border: Border.all(color: Colors.amber.shade400),
            borderRadius: BorderRadius.circular(6)),
        child: Text(price,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.amber.shade800)),
      );

  Widget _buildRatingWidget(double rating) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, size: 14, color: Colors.orange.shade600),
          Text(rating.toString(),
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800)),
        ],
      );
}

/// Detail Page
class DetailPage extends StatefulWidget {
  final Map<String, dynamic> item;
  const DetailPage({super.key, required this.item});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final TextEditingController reviewController = TextEditingController();
  int selectedStars = 0;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown.shade700,
        title: Text(item["title"]),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              child: PageView(
                children: List.generate(
                  item["images"].length,
                  (i) => ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(item["images"][i], fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(item["subtitle"],
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            Text("📍 Location: ${item["location"]} (${item["district"]})",
                style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
            const SizedBox(height: 12),
            Text(item["desc"],
                style: const TextStyle(fontSize: 14, height: 1.5)),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildTag(item["price"], Colors.amber.shade700),
                const SizedBox(width: 8),
                _buildTag("⭐ ${item["rating"]}", Colors.green.shade700),
              ],
            ),
            const SizedBox(height: 20),

            // ⭐ Rating
            const Text("Rate this Shop",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Row(
              children: List.generate(5, (index) {
                final starIndex = index + 1;
                return IconButton(
                  onPressed: () {
                    setState(() {
                      selectedStars = starIndex;
                    });
                  },
                  icon: Icon(Icons.star,
                      color: starIndex <= selectedStars
                          ? Colors.amber
                          : Colors.grey.shade400,
                      size: 32),
                );
              }),
            ),
            if (selectedStars > 0)
              Text("You rated: $selectedStars/5",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w500)),

            const SizedBox(height: 20),

            // 📝 Review
            const Text("Write a Review",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: reviewController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Share your experience...",
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                if (selectedStars == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Please give a star rating first!")));
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        "Review submitted with $selectedStars stars!")));
                reviewController.clear();
                setState(() {
                  selectedStars = 0;
                });
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown.shade600),
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(6)),
        child: Text(text,
            style: TextStyle(
                color: color, fontSize: 12, fontWeight: FontWeight.bold)),
      );
}
